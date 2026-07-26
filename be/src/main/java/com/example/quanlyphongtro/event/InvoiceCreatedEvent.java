package com.example.quanlyphongtro.event;

import com.example.quanlyphongtro.entity.HoaDon;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

@Getter
public class InvoiceCreatedEvent extends ApplicationEvent {
    private final HoaDon invoice;

    public InvoiceCreatedEvent(Object source, HoaDon invoice) {
        super(source);
        this.invoice = invoice;
    }
}
