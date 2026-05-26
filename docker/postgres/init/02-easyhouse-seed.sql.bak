INSERT INTO vai_tro (id, ten, tao_luc)
VALUES
  (gen_random_uuid(), 'ADMIN', now()),
  (gen_random_uuid(), 'LANDLORD', now()),
  (gen_random_uuid(), 'TENANT', now())
ON CONFLICT (ten) DO NOTHING;

WITH admin_role AS (
  SELECT id
  FROM vai_tro
  WHERE ten = 'ADMIN'
),
dev_user AS (
  INSERT INTO nguoi_dung (
    id,
    email,
    mat_khau,
    ho_ten,
    so_dien_thoai,
    trang_thai,
    tao_luc,
    cap_nhat_luc
  )
  VALUES (
    gen_random_uuid(),
    'admin@easyhouse.local',
    '$2a$10$9HgmP3LHXFShX6LXoCjinOy0E51QCxzfVmywozLxD/qSnD0u0bY1G',
    'EasyHouse Admin',
    '0900000000',
    'ACTIVE',
    now(),
    now()
  )
  ON CONFLICT (email) DO UPDATE
  SET
    mat_khau = EXCLUDED.mat_khau,
    ho_ten = EXCLUDED.ho_ten,
    trang_thai = EXCLUDED.trang_thai,
    cap_nhat_luc = now()
  RETURNING id
)
INSERT INTO nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id)
SELECT dev_user.id, admin_role.id
FROM dev_user
CROSS JOIN admin_role
ON CONFLICT DO NOTHING;
