'use client';

import { useState, useEffect } from 'react';
import { Sun, Moon, Monitor } from 'lucide-react';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';

export function ThemeToggle() {
  const [, setTheme] = useState<string>('light');

  useEffect(() => {
    // Initial load
    const savedUiSettings = localStorage.getItem('uiSettings');
    if (savedUiSettings) {
      const parsed = JSON.parse(savedUiSettings);
      setTheme(parsed.theme || 'light');
      applyTheme(parsed.theme || 'light');
    }
  }, []);

  const applyTheme = (newTheme: string) => {
    if (newTheme === 'dark') {
      document.documentElement.classList.add('dark');
    } else if (newTheme === 'light') {
      document.documentElement.classList.remove('dark');
    } else {
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      if (prefersDark) {
        document.documentElement.classList.add('dark');
      } else {
        document.documentElement.classList.remove('dark');
      }
    }
  };

  const handleThemeChange = (newTheme: string) => {
    setTheme(newTheme);
    applyTheme(newTheme);
    
    // Save to localStorage so it syncs with CaiDat page
    const savedUiSettings = localStorage.getItem('uiSettings');
    const parsed = savedUiSettings ? JSON.parse(savedUiSettings) : {};
    localStorage.setItem('uiSettings', JSON.stringify({ ...parsed, theme: newTheme }));
  };

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="icon" className="h-9 w-9 rounded-full">
          <Sun className="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
          <Moon className="absolute h-[1.2rem] w-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
          <span className="sr-only">Chuyển đổi giao diện</span>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={() => handleThemeChange('light')} className="gap-2">
          <Sun className="h-4 w-4" />
          <span>Sáng</span>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => handleThemeChange('dark')} className="gap-2">
          <Moon className="h-4 w-4" />
          <span>Tối</span>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => handleThemeChange('auto')} className="gap-2">
          <Monitor className="h-4 w-4" />
          <span>Hệ thống</span>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
