package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class DashboardAnalyticsService {

    private final EntityManager entityManager;
    private final com.example.quanlyphongtro.repository.MeterAnomalyAlertRepository meterAnomalyAlertRepository;

    public DashboardAnalyticsOverviewResponse getOverview(UUID nhaTroId) {
        String filterSql = nhaTroId != null ? " AND p.nha_tro_id = :nhaTroId " : "";
        String filterSqlNoPrefix = nhaTroId != null ? " AND nha_tro_id = :nhaTroId " : "";

        // Rooms count
        String roomQuerySql = "SELECT " +
                "COUNT(p.id) AS total_rooms, " +
                "SUM(CASE WHEN p.trang_thai = 'RENTED' THEN 1 ELSE 0 END) AS occupied_rooms, " +
                "SUM(CASE WHEN p.trang_thai = 'AVAILABLE' THEN 1 ELSE 0 END) AS available_rooms " +
                "FROM phong p WHERE p.xoa_luc IS NULL " + filterSql;

        Query roomQuery = entityManager.createNativeQuery(roomQuerySql);
        if (nhaTroId != null) roomQuery.setParameter("nhaTroId", nhaTroId);
        Object[] roomResult = (Object[]) roomQuery.getSingleResult();
        long totalRooms = ((Number) roomResult[0]).longValue();
        long occupiedRooms = roomResult[1] != null ? ((Number) roomResult[1]).longValue() : 0;
        long availableRooms = roomResult[2] != null ? ((Number) roomResult[2]).longValue() : 0;
        double occupancyRate = totalRooms > 0 ? (double) occupiedRooms / totalRooms * 100 : 0;

        // Revenue this month
        String revQuerySql = "SELECT " +
                "SUM(hd.tong_tien) AS expected_revenue, " +
                "SUM(hd.da_tra) AS collected_revenue, " +
                "SUM(GREATEST(hd.tong_tien - hd.da_tra, 0)) AS outstanding " +
                "FROM hoa_don hd " +
                "JOIN phong p ON hd.phong_id = p.id " +
                "WHERE hd.xoa_luc IS NULL AND hd.trang_thai != 'CANCELLED' " +
                "AND hd.ky_thang = EXTRACT(MONTH FROM CURRENT_DATE) " +
                "AND hd.ky_nam = EXTRACT(YEAR FROM CURRENT_DATE) " + filterSql;

        Query revQuery = entityManager.createNativeQuery(revQuerySql);
        if (nhaTroId != null) revQuery.setParameter("nhaTroId", nhaTroId);
        Object[] revResult = (Object[]) revQuery.getSingleResult();
        BigDecimal expectedRevenue = revResult[0] != null ? (BigDecimal) revResult[0] : BigDecimal.ZERO;
        BigDecimal collectedRevenue = revResult[1] != null ? (BigDecimal) revResult[1] : BigDecimal.ZERO;
        BigDecimal outstanding = revResult[2] != null ? (BigDecimal) revResult[2] : BigDecimal.ZERO;
        double collectionRate = expectedRevenue.compareTo(BigDecimal.ZERO) > 0 
                ? collectedRevenue.doubleValue() / expectedRevenue.doubleValue() * 100 
                : 0;

        // Incident count
        String incidentQuerySql = "SELECT COUNT(sc.id) FROM su_co sc " +
                "JOIN phong p ON sc.phong_id = p.id " +
                "WHERE sc.trang_thai NOT IN ('RESOLVED', 'CANCELLED') " + filterSql;
        Query incidentQuery = entityManager.createNativeQuery(incidentQuerySql);
        if (nhaTroId != null) incidentQuery.setParameter("nhaTroId", nhaTroId);
        long openIncidentCount = ((Number) incidentQuery.getSingleResult()).longValue();

        // Expiring contracts
        String contractQuerySql = "SELECT COUNT(hd.id) FROM hop_dong hd " +
                "JOIN phong p ON hd.phong_id = p.id " +
                "WHERE hd.xoa_luc IS NULL AND hd.trang_thai = 'ACTIVE' " +
                "AND hd.ngay_ket_thuc <= CURRENT_DATE + INTERVAL '30 days' " + filterSql;
        Query contractQuery = entityManager.createNativeQuery(contractQuerySql);
        if (nhaTroId != null) contractQuery.setParameter("nhaTroId", nhaTroId);
        long expiringContractCount = ((Number) contractQuery.getSingleResult()).longValue();
        
        // Overdue invoices
        String overdueInvoiceSql = "SELECT COUNT(hd.id) FROM hoa_don hd " +
                "JOIN phong p ON hd.phong_id = p.id " +
                "WHERE hd.xoa_luc IS NULL AND hd.trang_thai IN ('UNPAID', 'PARTIAL', 'OVERDUE') " +
                "AND hd.han_tra < CURRENT_DATE " + filterSql;
        Query overdueQuery = entityManager.createNativeQuery(overdueInvoiceSql);
        if (nhaTroId != null) overdueQuery.setParameter("nhaTroId", nhaTroId);
        long overdueInvoiceCount = ((Number) overdueQuery.getSingleResult()).longValue();

        return DashboardAnalyticsOverviewResponse.builder()
                .totalRooms(totalRooms)
                .occupiedRooms(occupiedRooms)
                .availableRooms(availableRooms)
                .occupancyRate(occupancyRate)
                .expectedRevenueThisMonth(expectedRevenue)
                .collectedThisMonth(collectedRevenue)
                .outstandingThisMonth(outstanding)
                .collectionRate(collectionRate)
                .openIncidentCount(openIncidentCount)
                .expiringContractCount(expiringContractCount)
                .overdueInvoiceCount(overdueInvoiceCount)
                .build();
    }

    public List<RevenueChartItemResponse> getRevenueChart(int months, UUID nhaTroId) {
        String filterSql = nhaTroId != null ? " AND p.nha_tro_id = :nhaTroId " : "";
        String sql = "WITH RECURSIVE months_cte AS (" +
                "  SELECT date_trunc('month', CURRENT_DATE) - INTERVAL '" + (months - 1) + " months' AS m_date " +
                "  UNION ALL " +
                "  SELECT m_date + INTERVAL '1 month' " +
                "  FROM months_cte " +
                "  WHERE m_date < date_trunc('month', CURRENT_DATE) " +
                ") " +
                "SELECT " +
                "  EXTRACT(MONTH FROM m.m_date) AS month, " +
                "  EXTRACT(YEAR FROM m.m_date) AS year, " +
                "  COALESCE(SUM(hd.tong_tien), 0) AS expected_revenue, " +
                "  COALESCE(SUM(hd.da_tra), 0) AS collected_revenue, " +
                "  COALESCE(SUM(GREATEST(hd.tong_tien - hd.da_tra, 0)), 0) AS outstanding " +
                "FROM months_cte m " +
                "LEFT JOIN hoa_don hd ON EXTRACT(MONTH FROM hd.ngay_lap_hoa_don) = EXTRACT(MONTH FROM m.m_date) " +
                "  AND EXTRACT(YEAR FROM hd.ngay_lap_hoa_don) = EXTRACT(YEAR FROM m.m_date) " +
                "  AND hd.xoa_luc IS NULL AND hd.trang_thai != 'CANCELLED' " +
                "LEFT JOIN phong p ON hd.phong_id = p.id " +
                "WHERE (p.id IS NULL OR 1=1) " + filterSql +
                "GROUP BY m.m_date " +
                "ORDER BY m.m_date";

        Query query = entityManager.createNativeQuery(sql);
        if (nhaTroId != null) query.setParameter("nhaTroId", nhaTroId);
        
        List<Object[]> results = query.getResultList();
        List<RevenueChartItemResponse> response = new ArrayList<>();
        
        for (Object[] row : results) {
            int month = ((Number) row[0]).intValue();
            int year = ((Number) row[1]).intValue();
            BigDecimal expected = (BigDecimal) row[2];
            BigDecimal collected = (BigDecimal) row[3];
            BigDecimal outstanding = (BigDecimal) row[4];
            
            response.add(RevenueChartItemResponse.builder()
                    .month(month)
                    .year(year)
                    .label("T" + month + "/" + year)
                    .expectedRevenue(expected)
                    .collectedRevenue(collected)
                    .outstanding(outstanding)
                    .build());
        }
        
        return response;
    }

    public DebtAgingResponse getDebtAging(UUID nhaTroId) {
        String filterSql = nhaTroId != null ? " AND p.nha_tro_id = :nhaTroId " : "";
        String sql = "SELECT " +
                "SUM(CASE WHEN hd.han_tra >= CURRENT_DATE THEN GREATEST(hd.tong_tien - hd.da_tra, 0) ELSE 0 END) AS not_due, " +
                "SUM(CASE WHEN CURRENT_DATE - hd.han_tra BETWEEN 1 AND 7 THEN GREATEST(hd.tong_tien - hd.da_tra, 0) ELSE 0 END) AS overdue_1_7, " +
                "SUM(CASE WHEN CURRENT_DATE - hd.han_tra BETWEEN 8 AND 15 THEN GREATEST(hd.tong_tien - hd.da_tra, 0) ELSE 0 END) AS overdue_8_15, " +
                "SUM(CASE WHEN CURRENT_DATE - hd.han_tra BETWEEN 16 AND 30 THEN GREATEST(hd.tong_tien - hd.da_tra, 0) ELSE 0 END) AS overdue_16_30, " +
                "SUM(CASE WHEN CURRENT_DATE - hd.han_tra > 30 THEN GREATEST(hd.tong_tien - hd.da_tra, 0) ELSE 0 END) AS overdue_over_30 " +
                "FROM hoa_don hd " +
                "JOIN phong p ON hd.phong_id = p.id " +
                "WHERE hd.xoa_luc IS NULL AND hd.trang_thai IN ('UNPAID', 'PARTIAL', 'OVERDUE') " + filterSql;

        Query query = entityManager.createNativeQuery(sql);
        if (nhaTroId != null) query.setParameter("nhaTroId", nhaTroId);
        Object[] result = (Object[]) query.getSingleResult();
        
        BigDecimal notDue = result[0] != null ? (BigDecimal) result[0] : BigDecimal.ZERO;
        BigDecimal o1_7 = result[1] != null ? (BigDecimal) result[1] : BigDecimal.ZERO;
        BigDecimal o8_15 = result[2] != null ? (BigDecimal) result[2] : BigDecimal.ZERO;
        BigDecimal o16_30 = result[3] != null ? (BigDecimal) result[3] : BigDecimal.ZERO;
        BigDecimal o30 = result[4] != null ? (BigDecimal) result[4] : BigDecimal.ZERO;
        
        BigDecimal total = notDue.add(o1_7).add(o8_15).add(o16_30).add(o30);
        
        return DebtAgingResponse.builder()
                .notDue(notDue)
                .overdue1To7(o1_7)
                .overdue8To15(o8_15)
                .overdue16To30(o16_30)
                .overdueOver30(o30)
                .totalOutstanding(total)
                .build();
    }

    public List<TopDebtorResponse> getTopDebtors(UUID nhaTroId, int limit) {
        String filterSql = nhaTroId != null ? " AND p.nha_tro_id = :nhaTroId " : "";
        String sql = "SELECT " +
                "p.id AS phong_id, " +
                "p.ten, " +
                "kt.id AS khach_thue_id, " +
                "kt.ho_ten AS ten_khach_thue, " +
                "kt.so_dien_thoai, " +
                "SUM(GREATEST(hd.tong_tien - hd.da_tra, 0)) AS tong_no, " +
                "SUM(CASE WHEN hd.han_tra < CURRENT_DATE THEN GREATEST(hd.tong_tien - hd.da_tra, 0) ELSE 0 END) AS no_qua_han, " +
                "MIN(hd.han_tra) AS oldest_due_date, " +
                "COUNT(hd.id) AS invoice_count " +
                "FROM hoa_don hd " +
                "JOIN phong p ON hd.phong_id = p.id " +
                "LEFT JOIN hop_dong hg ON hd.hop_dong_id = hg.id " +
                "LEFT JOIN khach_thue kt ON hg.khach_thue_id = kt.id " +
                "WHERE hd.xoa_luc IS NULL AND hd.trang_thai IN ('UNPAID', 'PARTIAL', 'OVERDUE') " + filterSql +
                "GROUP BY p.id, p.ten, kt.id, kt.ho_ten, kt.so_dien_thoai " +
                "HAVING SUM(GREATEST(hd.tong_tien - hd.da_tra, 0)) > 0 " +
                "ORDER BY tong_no DESC LIMIT :limit";
        
        Query query = entityManager.createNativeQuery(sql);
        if (nhaTroId != null) query.setParameter("nhaTroId", nhaTroId);
        query.setParameter("limit", limit);
        
        List<Object[]> results = query.getResultList();
        List<TopDebtorResponse> response = new ArrayList<>();
        
        for (Object[] row : results) {
            response.add(TopDebtorResponse.builder()
                    .phongId(row[0] != null ? UUID.fromString(row[0].toString()) : null)
                    .maPhong((String) row[1])
                    .khachThueId(row[2] != null ? UUID.fromString(row[2].toString()) : null)
                    .tenKhachThue((String) row[3])
                    .soDienThoai((String) row[4])
                    .tongNo((BigDecimal) row[5])
                    .noQuaHan((BigDecimal) row[6])
                    .oldestDueDate(row[7] != null ? ZonedDateTime.parse(row[7].toString() + "T00:00:00Z") : null) // approximate ZonedDateTime parsing from date
                    .invoiceCount(((Number) row[8]).longValue())
                    .build());
        }
        
        return response;
    }

    public List<ActionItemResponse> getActionItems(UUID nhaTroId, int limit) {
        List<ActionItemResponse> items = new ArrayList<>();
        
        List<UUID> nhaTroIds = nhaTroId != null ? List.of(nhaTroId) : List.of(); // Assuming we handle permission before calling this or we fetch all if null
        // However, we just use JPA or native queries. Here we only focus on Meter Anomaly Alerts first, 
        // as other items (Overdue invoices, Open Incidents) can be added later.
        
        // Add Meter Anomaly Alerts
        String filterSql = nhaTroId != null ? " AND p.nha_tro_id = :nhaTroId " : "";
        String alertSql = "SELECT a.id, p.ten, a.muc_do, a.loai, a.ly_do " +
                "FROM meter_anomaly_alert a " +
                "JOIN phong p ON a.phong_id = p.id " +
                "WHERE a.trang_thai = 'OPEN' " + filterSql +
                "ORDER BY a.tao_luc DESC LIMIT :limit";
                
        try {
            Query query = entityManager.createNativeQuery(alertSql);
            if (nhaTroId != null) query.setParameter("nhaTroId", nhaTroId);
            query.setParameter("limit", limit);
            
            List<Object[]> alertResults = query.getResultList();
            for (Object[] row : alertResults) {
                String mucDo = (String) row[2];
                String loai = (String) row[3];
                items.add(ActionItemResponse.builder()
                        .type("METER_ANOMALY")
                        .priority(mucDo)
                        .title("Bất thường chỉ số " + loai + " - Phòng " + row[1])
                        .description((String) row[4])
                        .entityId(UUID.fromString(row[0].toString()))
                        .href("/chiso")
                        .build());
            }
        } catch (Exception e) {
            log.warn("Failed to fetch meter anomalies (table might not exist): {}", e.getMessage());
        }
        
        // Add Overdue Invoices > 7 days
        String overdueSql = "SELECT hd.id, p.ten, hd.ma_hoa_don, (CURRENT_DATE - hd.han_tra) as days_overdue " +
                "FROM hoa_don hd " +
                "JOIN phong p ON hd.phong_id = p.id " +
                "WHERE hd.xoa_luc IS NULL AND hd.trang_thai IN ('UNPAID', 'PARTIAL', 'OVERDUE') " +
                "AND hd.han_tra < CURRENT_DATE - 7 " + filterSql +
                "ORDER BY days_overdue DESC LIMIT :limit";
                
        Query overdueQuery = entityManager.createNativeQuery(overdueSql);
        if (nhaTroId != null) overdueQuery.setParameter("nhaTroId", nhaTroId);
        overdueQuery.setParameter("limit", limit);
        
        List<Object[]> overdueResults = overdueQuery.getResultList();
        for (Object[] row : overdueResults) {
            int days = ((Number) row[3]).intValue();
            String priority = days >= 30 ? "HIGH" : (days >= 15 ? "MEDIUM" : "LOW");
            items.add(ActionItemResponse.builder()
                    .type("OVERDUE_INVOICE")
                    .priority(priority)
                    .title("Nợ quá hạn " + days + " ngày - Phòng " + row[1])
                    .description("Hóa đơn " + row[2] + " đã quá hạn " + days + " ngày.")
                    .entityId(UUID.fromString(row[0].toString()))
                    .href("/dashboard/cong-no")
                    .build());
        }
        
        return items;
    }
}
