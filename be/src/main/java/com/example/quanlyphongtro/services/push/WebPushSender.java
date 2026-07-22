package com.example.quanlyphongtro.services.push;

import com.example.quanlyphongtro.entity.DangKyPush;
import com.example.quanlyphongtro.entity.NenTangPush;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import nl.martijndwars.webpush.Notification;
import nl.martijndwars.webpush.PushService;
import nl.martijndwars.webpush.Subscription;
import org.apache.http.HttpResponse;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.security.Security;
import java.util.Map;

/**
 * Gui thong bao day toi trinh duyet theo chuan Web Push (RFC 8291).
 *
 * Chi duoc tao bean khi CO cau hinh khoa VAPID (@ConditionalOnProperty). Thieu
 * khoa thi bean khong ton tai, PushService thay danh sach kenh rong va bo qua —
 * ung dung van chay binh thuong, khong nem loi lung tung.
 *
 * Sinh cap khoa VAPID:
 *   npx web-push generate-vapid-keys
 * roi dat vao application-secrets.properties:
 *   push.vapid.public-key=...
 *   push.vapid.private-key=...
 *   push.vapid.subject=mailto:admin@easyhouse.vn
 */
@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "push.vapid", name = {"public-key", "private-key"})
public class WebPushSender implements KenhGuiPush {

    private final ObjectMapper objectMapper;

    @Value("${push.vapid.public-key}")
    private String khoaCong;

    @Value("${push.vapid.private-key}")
    private String khoaRieng;

    @Value("${push.vapid.subject:mailto:admin@easyhouse.vn}")
    private String chuThe;

    private PushService pushService;

    @PostConstruct
    void khoiTao() throws Exception {
        if (khoaCong == null || khoaCong.isBlank() || khoaRieng == null || khoaRieng.isBlank()) {
            log.warn("Web Push bị tắt do thiếu VAPID keys");
            return;
        }
        // Thu vien web-push dung mat ma duong cong elliptic, can BouncyCastle.
        if (Security.getProvider(BouncyCastleProvider.PROVIDER_NAME) == null) {
            Security.addProvider(new BouncyCastleProvider());
        }
        pushService = new PushService(khoaCong, khoaRieng, chuThe);
        log.info("Web Push da san sang");
    }

    @Override
    public boolean hoTro(NenTangPush nenTang) {
        return nenTang == NenTangPush.WEB;
    }

    @Override
    public boolean gui(DangKyPush dangKy, NoiDungPush noiDung) {
        if (pushService == null) {
            log.warn("Bỏ qua gửi push vì Web Push chưa được cấu hình VAPID keys");
            return false;
        }
        try {
            String payload = objectMapper.writeValueAsString(Map.of(
                    "tieuDe", noiDung.tieuDe(),
                    "noiDung", noiDung.noiDung(),
                    "duongDan", noiDung.duongDan(),
                    "hoiThoaiId", noiDung.hoiThoaiId() != null ? noiDung.hoiThoaiId().toString() : ""));

            Subscription subscription = new Subscription(
                    dangKy.getEndpoint(),
                    new Subscription.Keys(dangKy.getKhoaP256dh(), dangKy.getKhoaAuth()));

            HttpResponse response = pushService.send(new Notification(subscription, payload));
            int maTrangThai = response.getStatusLine().getStatusCode();

            // 404/410 = endpoint da chet (go app, thu hoi quyen, doi trinh duyet).
            // Bao cho PushService biet de ngung gui, thay vi thu lai mai.
            if (maTrangThai == 404 || maTrangThai == 410) {
                log.info("Endpoint push da het hieu luc ({}), se ngung gui", maTrangThai);
                return false;
            }
            if (maTrangThai >= 400) {
                log.warn("Nha cung cap push tra ve {}", maTrangThai);
            }
            return true;

        } catch (Exception ex) {
            // Loi mang/tam thoi: KHONG danh dau endpoint la chet, de con thu lai lan sau.
            log.warn("Gui Web Push that bai: {}", ex.getMessage());
            return true;
        }
    }
}
