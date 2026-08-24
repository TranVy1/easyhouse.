import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { forwardRef, useState } from 'react';
import { cn } from '@/lib/utils';

interface AuthInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string;
  error?: string;
  icon?: React.ReactNode;
}

export const AuthInput = forwardRef<HTMLInputElement, AuthInputProps>(
  ({ label, error, icon, className, id, onFocus, onBlur, ...props }, ref) => {
    const [focused, setFocused] = useState(false);
    const inputId = id || props.name;

    return (
      <div className="w-full">
        <Label
          htmlFor={inputId}
          className="block text-[13px] font-semibold text-slate-700 mb-1.5"
        >
          {label}
        </Label>
        <div className="relative">
          {icon && (
            <span
              className={cn(
                'pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 transition-colors duration-150',
                focused && !error ? 'text-[#0D9488]' : 'text-slate-400'
              )}
              aria-hidden="true"
            >
              {icon}
            </span>
          )}
          <Input
            id={inputId}
            ref={ref}
            onFocus={(e) => { setFocused(true); onFocus?.(e); }}
            onBlur={(e)  => { setFocused(false); onBlur?.(e); }}
            className={cn(
              'h-12 rounded-[12px]',
              'bg-[#F4F4F4] border-transparent',
              'text-[15px] text-slate-900 placeholder:text-slate-400',
              'focus:bg-white focus:border-[#0D9488] focus:ring-2 focus:ring-[#0D9488]/15',
              'transition-all duration-150',
              icon && 'pl-10',
              error && 'bg-red-50 border-red-400 focus:border-red-500 focus:ring-red-500/15',
              className
            )}
            aria-invalid={!!error}
            aria-describedby={error ? `${inputId}-error` : undefined}
            {...props}
          />
        </div>
        {/* Fixed height — prevents layout shift */}
        <div className="min-h-[20px] mt-1 overflow-hidden">
          {error && (
            <p
              id={`${inputId}-error`}
              role="alert"
              className="text-[12px] text-red-500 font-medium animate-in fade-in slide-in-from-top-1 duration-200"
            >
              {error}
            </p>
          )}
        </div>
      </div>
    );
  }
);

AuthInput.displayName = 'AuthInput';
