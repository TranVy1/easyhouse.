package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.ChiSoDienNuocRepository;
import com.example.quanlyphongtro.repository.MeterAnomalyAlertRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.time.ZonedDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class MeterAnomalyService {

    private final MeterAnomalyAlertRepository alertRepository;
    private final ChiSoDienNuocRepository chiSoDienNuocRepository;

    @Transactional
    public void analyzeReading(ChiSoDienNuoc reading) {
        if (reading == null || reading.getChiSoMoi() == null || reading.getChiSoCu() == null) {
            return;
        }

        // Avoid creating duplicate open alerts for the same reading
        Optional<MeterAnomalyAlert> existingAlert = alertRepository.findByChiSoDienNuocId(reading.getId());
        if (existingAlert.isPresent() && existingAlert.get().getTrangThai() != TrangThaiAlert.OPEN) {
            return; // Already resolved/ignored, skip analysis
        }

        int tieuThuHienTai = reading.getChiSoMoi() - reading.getChiSoCu();

        // 1. Basic check: chiSoMoi < chiSoCu
        if (tieuThuHienTai < 0) {
            createOrUpdateAlert(existingAlert.orElse(null), reading, tieuThuHienTai, BigDecimal.ZERO, null, MucDoAlert.HIGH, "Chỉ số mới nhỏ hơn chỉ số cũ.");
            return;
        }

        // Fetch history
        List<ChiSoDienNuoc> history = chiSoDienNuocRepository.findByPhongIdAndLoaiOrderByKyNamDescKyThangDesc(
                reading.getPhong().getId(), reading.getLoai()
        );

        // Filter out the current reading from history, take max 3 older readings
        List<ChiSoDienNuoc> pastReadings = history.stream()
                .filter(h -> !h.getId().equals(reading.getId()))
                .limit(3)
                .toList();

        if (pastReadings.isEmpty()) {
            if (existingAlert.isPresent()) {
                alertRepository.delete(existingAlert.get());
            }
            return;
        }

        int totalPastTieuThu = 0;
        int validMonths = 0;
        int lastMonthTieuThu = -1;

        for (int i = 0; i < pastReadings.size(); i++) {
            ChiSoDienNuoc past = pastReadings.get(i);
            if (past.getChiSoMoi() != null && past.getChiSoCu() != null) {
                int tt = past.getChiSoMoi() - past.getChiSoCu();
                if (tt >= 0) {
                    totalPastTieuThu += tt;
                    validMonths++;
                    if (i == 0) {
                        lastMonthTieuThu = tt;
                    }
                }
            }
        }

        if (validMonths == 0) {
            if (existingAlert.isPresent()) alertRepository.delete(existingAlert.get());
            return;
        }

        BigDecimal average = BigDecimal.valueOf(totalPastTieuThu).divide(BigDecimal.valueOf(validMonths), 2, RoundingMode.HALF_UP);

        // 2. TieuThu = 0 while historically > 0
        if (tieuThuHienTai == 0 && average.compareTo(BigDecimal.valueOf(5)) > 0) {
            createOrUpdateAlert(existingAlert.orElse(null), reading, tieuThuHienTai, average, BigDecimal.valueOf(-100), MucDoAlert.MEDIUM, "Không có tiêu thụ nhưng lịch sử phòng có sử dụng.");
            return;
        }

        if (average.compareTo(BigDecimal.ZERO) == 0) {
            if (tieuThuHienTai > 50) {
                createOrUpdateAlert(existingAlert.orElse(null), reading, tieuThuHienTai, average, null, MucDoAlert.LOW, "Bắt đầu tiêu thụ lớn sau nhiều tháng bằng 0.");
            } else {
                if (existingAlert.isPresent()) alertRepository.delete(existingAlert.get());
            }
            return;
        }

        BigDecimal tyLeTang = BigDecimal.valueOf(tieuThuHienTai).subtract(average)
                .divide(average, 4, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100));

        // 3. High thresholds
        MucDoAlert mucDo = null;
        String lyDo = "";

        // Tăng vọt so với tháng trước một lượng tuyệt đối
        boolean absoluteIncrease = false;
        if (lastMonthTieuThu >= 0) {
            int diff = tieuThuHienTai - lastMonthTieuThu;
            if (reading.getLoai() == LoaiChiSo.ELECTRICITY && diff > 100) {
                absoluteIncrease = true;
                lyDo = "Tiêu thụ tăng hơn 100 kWh so với tháng trước.";
            } else if (reading.getLoai() == LoaiChiSo.WATER && diff > 30) {
                absoluteIncrease = true;
                lyDo = "Tiêu thụ tăng hơn 30 khối so với tháng trước.";
            }
        }

        if (tyLeTang.compareTo(BigDecimal.valueOf(250)) >= 0) {
            mucDo = MucDoAlert.HIGH;
            lyDo = "Tiêu thụ tăng " + tyLeTang.setScale(0, RoundingMode.HALF_UP) + "% (hơn 2.5 lần) so với trung bình " + validMonths + " tháng.";
        } else if (absoluteIncrease) {
             mucDo = MucDoAlert.HIGH;
        } else if (tyLeTang.compareTo(BigDecimal.valueOf(150)) >= 0) {
            mucDo = MucDoAlert.MEDIUM;
            lyDo = "Tiêu thụ tăng " + tyLeTang.setScale(0, RoundingMode.HALF_UP) + "% so với trung bình " + validMonths + " tháng.";
        } else if (tyLeTang.compareTo(BigDecimal.valueOf(100)) >= 0) {
            mucDo = MucDoAlert.LOW;
            lyDo = "Tiêu thụ tăng " + tyLeTang.setScale(0, RoundingMode.HALF_UP) + "% so với trung bình " + validMonths + " tháng.";
        }

        if (mucDo != null) {
            createOrUpdateAlert(existingAlert.orElse(null), reading, tieuThuHienTai, average, tyLeTang, mucDo, lyDo);
        } else {
            // Normal
            if (existingAlert.isPresent()) {
                alertRepository.delete(existingAlert.get());
            }
        }
    }

    private void createOrUpdateAlert(MeterAnomalyAlert alert, ChiSoDienNuoc reading, int currentUsage, BigDecimal avgUsage, BigDecimal tyLe, MucDoAlert mucDo, String lyDo) {
        if (alert == null) {
            alert = new MeterAnomalyAlert();
            alert.setChiSoDienNuoc(reading);
            alert.setPhong(reading.getPhong());
            alert.setHopDong(reading.getHopDong());
            alert.setLoai(reading.getLoai());
            alert.setKyThang(reading.getKyThang());
            alert.setKyNam(reading.getKyNam());
            alert.setTrangThai(TrangThaiAlert.OPEN);
        }
        alert.setTieuThuHienTai(currentUsage);
        alert.setTieuThuTrungBinh(avgUsage);
        alert.setTyLeTang(tyLe);
        alert.setMucDo(mucDo);
        alert.setLyDo(lyDo);
        alertRepository.save(alert);
    }

    @Transactional
    public MeterAnomalyAlert resolveAlert(UUID alertId, TrangThaiAlert status, NguoiDung currentUser) {
        MeterAnomalyAlert alert = alertRepository.findById(alertId)
                .orElseThrow(() -> new RuntimeException("Alert not found"));
        alert.setTrangThai(status);
        alert.setResolvedAt(ZonedDateTime.now());
        alert.setResolvedBy(currentUser);
        return alertRepository.save(alert);
    }
}
