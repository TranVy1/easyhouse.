'use client';

import { Component, ReactNode } from 'react';
import { RefreshCw, AlertOctagon } from 'lucide-react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, info: { componentStack: string }) {
    console.error('[ErrorBoundary]', error, info.componentStack);
  }

  handleReset = () => {
    this.setState({ hasError: false, error: undefined });
  };

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) return this.props.fallback;
      return (
        <div className="flex min-h-screen flex-col items-center justify-center gap-5 p-8 text-center bg-[#F8F3EC]">
          <div className="w-16 h-16 rounded-2xl bg-red-50 border border-red-100 flex items-center justify-center">
            <AlertOctagon size={32} className="text-red-500" />
          </div>
          <div className="max-w-sm">
            <h2 className="text-lg font-black text-[#243B5A]">Đã xảy ra lỗi không mong muốn</h2>
            <p className="text-sm text-[#6B7A8C] mt-2 leading-relaxed">
              {this.state.error?.message || 'Ứng dụng gặp sự cố. Vui lòng thử tải lại trang.'}
            </p>
          </div>
          <button
            onClick={this.handleReset}
            className="flex items-center gap-2 px-5 py-2.5 bg-indigo-600 text-white text-sm font-bold rounded-xl hover:bg-indigo-700 transition-colors"
          >
            <RefreshCw size={15} />
            Thử lại
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}
