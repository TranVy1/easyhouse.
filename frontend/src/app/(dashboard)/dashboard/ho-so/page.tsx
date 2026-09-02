'use client'

import { useEffect, useState } from 'react'
import { useSession } from 'next-auth/react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import { toast } from 'sonner'

type Profile = { name: string; email: string; phone?: string; address?: string; avatar?: string; role?: string }

export default function HoSoPage() {
  const { data: session } = useSession()
  const token = session?.accessToken
  const [profile, setProfile] = useState<Profile | null>(null)
  const [password, setPassword] = useState({ matKhauCu: '', matKhauMoi: '' })
  const [saving, setSaving] = useState(false)

  useEffect(() => {
    if (!token) return
    fetch('/api/user/profile', { headers: { Authorization: `Bearer ${token}` } })
      .then(r => r.json()).then(j => { if (j.success) setProfile(j.data) })
      .catch(() => toast.error('Không thể tải hồ sơ'))
  }, [token])

  const saveProfile = async () => {
    if (!profile || !token) return
    setSaving(true)
    try {
      const res = await fetch('/api/user/profile', { method: 'PUT', headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` }, body: JSON.stringify(profile) })
      const json = await res.json()
      if (!res.ok || !json.success) throw new Error(json.message)
      setProfile(json.data); toast.success('Đã cập nhật hồ sơ')
    } catch (e: unknown) { toast.error(e instanceof Error ? e.message : 'Cập nhật hồ sơ thất bại') } finally { setSaving(false) }
  }

  const changePassword = async () => {
    if (!token || !password.matKhauCu || !password.matKhauMoi) return
    const payload = { oldPassword: password.matKhauCu, newPassword: password.matKhauMoi }
    const res = await fetch('/api/user/change-password', { method: 'POST', headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` }, body: JSON.stringify(payload) })
    const json = await res.json()
    if (res.ok && json.success) { setPassword({ matKhauCu: '', matKhauMoi: '' }); toast.success('Đã đổi mật khẩu') } else toast.error(json.message || 'Đổi mật khẩu thất bại')
  }

  if (!profile) return <div className="p-6 text-muted-foreground">Đang tải hồ sơ...</div>
  return <div className="mx-auto grid max-w-3xl gap-6 p-4 md:p-6">
    <Card><CardHeader><CardTitle>Hồ sơ cá nhân</CardTitle></CardHeader><CardContent className="grid gap-4 sm:grid-cols-2">
      <div className="grid gap-2"><Label>Họ và tên</Label><Input value={profile.name || ''} onChange={e => setProfile({ ...profile, name: e.target.value })} /></div>
      <div className="grid gap-2"><Label>Email</Label><Input value={profile.email || ''} disabled /></div>
      <div className="grid gap-2"><Label>Số điện thoại</Label><Input value={profile.phone || ''} onChange={e => setProfile({ ...profile, phone: e.target.value })} /></div>
      <div className="grid gap-2"><Label>Địa chỉ</Label><Input value={profile.address || ''} onChange={e => setProfile({ ...profile, address: e.target.value })} /></div>
      <Button className="sm:col-span-2" onClick={saveProfile} disabled={saving}>{saving ? 'Đang lưu...' : 'Lưu thay đổi'}</Button>
    </CardContent></Card>
    <Card><CardHeader><CardTitle>Đổi mật khẩu</CardTitle></CardHeader><CardContent className="grid gap-4 sm:grid-cols-2">
      <Input type="password" placeholder="Mật khẩu hiện tại" value={password.matKhauCu} onChange={e => setPassword({ ...password, matKhauCu: e.target.value })} />
      <Input type="password" placeholder="Mật khẩu mới" value={password.matKhauMoi} onChange={e => setPassword({ ...password, matKhauMoi: e.target.value })} />
      <Button variant="outline" className="sm:col-span-2" onClick={changePassword}>Đổi mật khẩu</Button>
    </CardContent></Card>
  </div>
}
