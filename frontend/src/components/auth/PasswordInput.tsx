import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { useState, forwardRef } from 'react';
import { Eye, EyeOff, Lock } from 'lucide-react';
import { cn } from '@/lib/utils';

interface PasswordInputProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'type'> {
  label?: string;
  error?: string;
  /** Show compact 3-segment password-strength bar — register page only */
  showStrength?: boolean;
}

function getStrength(pwd: string): 0 | 1 | 2 | 3 {
  if (!pwd) return 0;
  let score = 1;
  if (pwd.length >= 8) score++;
  if (/[A-Z]/.test(pwd) && /[0-9]/.test(pwd)) score++;
  return score as 0 | 1 | 2 | 3;
}

const STRENGTH_LABEL: Record<1 | 2 | 3, string> = { 1: 'Yếu', 2: 'Trung bình', 3: 'Mạnh' };
const STRENGTH_COLOR: Record<1 | 2 | 3, string> = {
  1: 'bg-red-400',
  2: 'bg-amber-400',
  3: 'bg-emerald-500',
};

export const PasswordInput = forwardRef<HTMLInputElement, PasswordInputProps>(
  ({ label = 'Mật khẩu', error, showStrength = false, className, id, value, onChange, onFocus, onBlur, ...props }, ref) => {
    const [visible, setVisible] = useState(false);
    const [eyeActive, setEyeActive] = useState(false);
    const [focused, setFocused] = useState(false);
    const inputId = id || props.name || 'password';
    const strVal = typeof value === 'string' ? value : '';
    const strength = showStrength && strVal ? getStrength(strVal) : 0;

    const handleToggle = () => {
      setEyeActive(true);
      setVisible((v) => !v);
      setTimeout(() => setEyeActive(false), 180);
    };

    return (
      <div className="w-full">
        <Label
          htmlFor={inputId}
          className="block text-[13px] font-semibold text-slate-700 mb-1.5"
        >
          {label}
        </Label>
        <div className="relative">
          {/* Lock icon — follows focus color */}
          <span
            className={cn(
              'pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 transition-colors duration-150',
              focused && !error ? 'text-[#0D9488]' : 'text-slate-400'
            )}
            aria-hidden="true"
          >
            <Lock size={16} />
          </span>

          <Input
            id={inputId}
            ref={ref}
            type={visible ? 'text' : 'password'}
            value={value}
            onChange={onChange}
            onFocus={(e) => { setFocused(true); onFocus?.(e); }}
            onBlur={(e)  => { setFocused(false); onBlur?.(e); }}
            className={cn(
              'h-12 rounded-[12px] pl-10 pr-11',
              'bg-[#F4F4F4] border-transparent',
              'text-[15px] text-slate-900 placeholder:text-slate-400',
              'focus:bg-white focus:border-[#0D9488] focus:ring-2 focus:ring-[#0D9488]/15',
              'transition-all duration-150',
              error && 'bg-red-50 border-red-400 focus:border-red-500 focus:ring-red-500/15',
              className
            )}
            aria-invalid={!!error}
            aria-describedby={error ? `${inputId}-error` : undefined}
            {...props}
          />

          {/* Eye toggle with scale micro-animation */}
          <button
            type="button"
            onClick={handleToggle}
            style={{ transform: eyeActive ? 'scale(0.88)' : 'scale(1)', transition: 'transform 160ms ease' }}
            className="
              absolute right-3.5 top-1/2 -translate-y-1/2
              text-slate-400 hover:text-slate-700
              transition-colors duration-150
              rounded focus:outline-none focus-visible:ring-2 focus-visible:ring-[#0D9488]
              p-0.5
            "
            aria-label={visible ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
          >
            {visible ? <EyeOff size={18} /> : <Eye size={18} />}
          </button>
        </div>

        {/* Password strength bar */}
        {showStrength && strVal && strength > 0 && (
          <div className="flex items-center gap-1.5 mt-1.5">
            <div className="flex gap-1 flex-1">
              {([1, 2, 3] as const).map((lvl) => (
                <div
                  key={lvl}
                  className={cn(
                    'h-[3px] flex-1 rounded-full transition-colors duration-300',
                    strength >= lvl ? STRENGTH_COLOR[strength] : 'bg-slate-200'
                  )}
                />
              ))}
            </div>
            <span className="text-[11px] font-semibold text-slate-500 shrink-0 w-[60px] text-right">
              {STRENGTH_LABEL[strength]}
            </span>
          </div>
        )}

        {/* Error zone — fixed height to prevent layout shift */}
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

PasswordInput.displayName = 'PasswordInput';
