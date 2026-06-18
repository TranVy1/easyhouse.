const fs = require('fs');
const lines = fs.readFileSync('f:/qlyphongtro/frontend/src/app/(dashboard)/dashboard/phong/page.tsx', 'utf-8').split('\n');
const code = lines.slice(871, 1246).join('\n');
const imports = `'use client';

import { useState, useEffect } from 'react';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { DialogFooter } from '@/components/ui/dialog';
import { Info, Image as ImageIcon } from 'lucide-react';
import { toast } from 'sonner';
import { PhongImageUpload } from '@/components/ui/phong-image-upload';
import type { Phong, ToaNha } from '@/types';
import Image from 'next/image';

`;
fs.writeFileSync('f:/qlyphongtro/frontend/src/components/ui/phong-form.tsx', imports + code, 'utf-8');
console.log('Done!');
