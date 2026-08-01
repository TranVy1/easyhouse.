-- The application issues signed refresh tokens that can exceed 255 characters.
-- Keep the restored schema aligned with RefreshToken.token (length = 1024).
ALTER TABLE public.refresh_token
    ALTER COLUMN token TYPE varchar(1024);
