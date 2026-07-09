-- Add DEPOSIT to phuong_thuc_thanh_toan ENUM
ALTER TYPE "public"."phuong_thuc_thanh_toan" ADD VALUE IF NOT EXISTS 'DEPOSIT';
