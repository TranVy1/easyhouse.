import { AlertTriangle } from 'lucide-react';
import { Alert, AlertDescription } from '@/components/ui/alert';

interface FormErrorProps {
  message?: string;
}

export function FormError({ message }: FormErrorProps) {
  if (!message) return null;

  return (
    <Alert className="mb-6 bg-red-50/50 border-red-200 text-red-600 rounded-xl shadow-sm animate-in fade-in slide-in-from-top-2 duration-300">
      <AlertTriangle className="h-4 w-4 stroke-[2.5px] mr-2" />
      <AlertDescription className="text-sm font-semibold mt-0.5">
        {message}
      </AlertDescription>
    </Alert>
  );
}
