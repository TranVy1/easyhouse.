package com.example.quanlyphongtro.entity;

/**
 * UNPAID, PARTIAL and OVERPAID are retained only to read historical records.
 * New invoices follow DRAFT -> ISSUED -> OVERDUE -> PAID/CANCELLED.
 */
public enum TrangThaiHoaDon { DRAFT, ISSUED, UNPAID, PARTIAL, PAID, OVERPAID, OVERDUE, CANCELLED }
