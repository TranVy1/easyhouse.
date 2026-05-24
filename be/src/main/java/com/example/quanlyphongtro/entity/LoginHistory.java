package com.example.quanlyphongtro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.ZonedDateTime;
import java.util.UUID;

@Entity
@EntityListeners(com.example.quanlyphongtro.entity.listener.TimestampEntityListener.class)
@Table(name = "login_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nguoi_dung_id")
    private NguoiDung nguoiDung;

    private String email;

    @Column(nullable = false)
    private Boolean thanhCong;

    @JdbcTypeCode(SqlTypes.OTHER)
    @Column(columnDefinition = "inet")
    private String ipAddress;

    private String userAgent;
    private String lyDoThatBai;

    @Column(updatable = false)
    private ZonedDateTime taoLuc;
}
