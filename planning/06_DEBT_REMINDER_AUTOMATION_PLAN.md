# P1 - Nhắc nợ tự động nhiều cấp

## 1. Mục tiêu

Tự động nhắc khách thuê trước hạn và sau hạn thanh toán theo cấp độ, thay vì chỉ hiển thị công nợ.

Giá trị:
- Hoàn thiện flow thu tiền.
- Tận dụng `SchedulerService`, `ThongBaoService`, `EmailService` đã có.
- Dashboard có action rõ ràng.

## 2. Rule nhắc nợ đề xuất

Trước hạn:
- Trước 3 ngày: nhắc nhẹ.
- Trước 1 ngày: nhắc thanh toán.

Sau hạn:
- Quá hạn 1 ngày: cảnh báo lần 1.
- Quá hạn 7 ngày: cảnh báo lần 2 cho khách và chủ trọ.
- Quá hạn 15 ngày: cảnh báo vi phạm hợp đồng.
- Quá hạn 30 ngày: đánh dấu cần xử lý đặc biệt.

Không gửi lặp cùng loại nhắc cho cùng hóa đơn.

## 3. Database cần thêm

```sql
CREATE TABLE IF NOT EXISTS public.debt_reminder_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hoa_don_id uuid NOT NULL REFERENCES public.hoa_don(id) ON DELETE CASCADE,
    reminder_type varchar(50) NOT NULL,
    channel varchar(30) NOT NULL,
    recipient_id uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    recipient_contact varchar(255),
    status varchar(30) NOT NULL DEFAULT 'SENT',
    error_message text,
    sent_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (hoa_don_id, reminder_type, channel, recipient_contact)
);
```

Reminder type:
- `DUE_IN_3_DAYS`
- `DUE_TOMORROW`
- `OVERDUE_1_DAY`
- `OVERDUE_7_DAYS`
- `OVERDUE_15_DAYS`
- `OVERDUE_30_DAYS`

## 4. Backend cần thêm

Service:
- `DebtReminderService`

Method:
- `runDailyDebtReminders()`
- `sendReminder(HoaDon hoaDon, ReminderType type)`
- `alreadySent(HoaDon hoaDon, ReminderType type, Channel channel)`
- `previewReminders(LocalDate date)`

Controller admin/test:
- `POST /api/admin/debt-reminders/run`
- `GET /api/admin/debt-reminders/preview`

Scheduler:
- Gọi trong `SchedulerService.runDailyChecks`.

## 5. Frontend cần thêm

Trong công nợ:
- Button "Gửi nhắc nợ" cho từng phòng/khách.
- Hiển thị lịch sử nhắc nợ gần nhất.

Trong dashboard:
- Action item "Nợ quá hạn > 7 ngày".
- Card "Đã gửi nhắc nợ hôm nay".

Trong thông báo:
- Loại thông báo `DEBT`.

## 6. Test cần viết

- Đúng ngày trước hạn thì gửi reminder.
- Quá hạn 7 ngày gửi đúng type.
- Không gửi lặp nếu log đã tồn tại.
- Hóa đơn đã paid thì không gửi.
- Email lỗi không rollback toàn bộ job.

## 7. Checklist triển khai

- [ ] Tạo migration log.
- [ ] Tạo enum reminder type/channel.
- [ ] Tạo entity/repository.
- [ ] Tạo `DebtReminderService`.
- [ ] Tích hợp scheduler.
- [ ] Thêm endpoint preview/run.
- [ ] Thêm UI lịch sử nhắc nợ.
- [ ] Viết test.

## 8. Demo bảo vệ

1. Seed hóa đơn quá hạn 7 ngày.
2. Chạy job nhắc nợ.
3. Hệ thống tạo notification/email log.
4. Dashboard hiển thị đã xử lý.
5. Chạy lại job, chứng minh không gửi lặp.
