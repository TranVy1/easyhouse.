package com.example.quanlyphongtro.event;

import com.example.quanlyphongtro.services.ChatRealtimeService;
import com.example.quanlyphongtro.services.push.PushService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

/**
 * Day tin nhan xuong client, CHI SAU KHI transaction da commit.
 *
 * Vi sao la @TransactionalEventListener(AFTER_COMMIT) chu khong phai @EventListener:
 * InvoiceEventListener san co trong du an dung @EventListener + @Async, tuc la ban
 * su kien NGAY khi publish, truoc luc commit. Voi email thi hau qua nhe, nhung voi
 * chat thi sai ro rang:
 *   - client nhan duoc tin, goi REST doc lai thi chua thay (transaction chua commit)
 *   - neu transaction rollback, tin da hien tren man hinh nhung khong ton tai trong DB
 *
 * Khong dat @Async: convertAndSendToUser chi day message vao outbound channel cua
 * broker (da co executor rieng), khong block thread goi. Them @Async chi lam tin
 * nhan phai xep hang chung pool voi viec gui email.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ChatEventListener {

    private final ChatRealtimeService chatRealtimeService;
    private final PushService pushService;

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void khiCoTinNhanMoi(TinNhanCreatedEvent event) {
        chatRealtimeService.guiToiNhieuNguoi(
                event.nguoiNhanIds(),
                ChatRealtimeService.KENH_TIN_NHAN,
                event.tinNhan());

        // Thong bao day chi danh cho nguoi KHONG dang mo app — PushService tu loc.
        // Bao ve bang try/catch: push hong khong duoc lam anh huong viec day realtime
        // vua chay o tren, va cang khong duoc nem nguoc vao luong nghiep vu.
        try {
            pushService.guiChoTinNhan(event.tinNhan(), event.nguoiNhanIds());
        } catch (RuntimeException ex) {
            log.warn("Gui thong bao day that bai: {}", ex.getMessage());
        }
    }
}
