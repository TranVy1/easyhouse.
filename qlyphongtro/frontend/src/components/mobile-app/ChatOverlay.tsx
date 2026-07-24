'use client';
import { useState, useRef, useEffect } from "react";
import { X, Send, Mic, Bot, User, Loader2 } from "lucide-react";

interface Message {
  id: number;
  role: "bot" | "user";
  text: string;
}

const quickReplies = [
  "Tìm phòng",
  "giá phòng"
];

interface ChatOverlayProps {
  onClose: () => void;
}

export function ChatOverlay({ onClose }: ChatOverlayProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: 0,
      role: "bot",
      text: "Xin chào! Tôi là trợ lý của EasyHouse 🤖\nMình có thể giúp bạn tìm trọ hoặc giải đáp các thắc mắc về đồ án. Bạn cần hỗ trợ gì nào?",
    },
  ]);
  const [input, setInput] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const sendMessage = async (text: string) => {
    if (!text.trim() || isLoading) return;

    const userMsg: Message = { id: Date.now(), role: "user", text };
    const newMessages = [...messages, userMsg];

    setMessages(newMessages);
    setInput("");
    setIsLoading(true);

    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ messages: newMessages }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'API Error');
      }

      setMessages((prev) => [
        ...prev,
        { id: Date.now() + 1, role: "bot", text: data.response }
      ]);
    } catch (error: any) {
      console.error(error);
      setMessages((prev) => [
        ...prev,
        {
          id: Date.now() + 1,
          role: "bot",
          text: error.message === 'Chưa cấu hình GEMINI_API_KEY trong file .env.local'
            ? "⚠️ Hệ thống chưa được cấu hình GEMINI_API_KEY. Vui lòng thêm vào file .env.local để sử dụng tính năng này."
            : "Xin lỗi, hiện tại tôi đang gặp sự cố kết nối. Vui lòng thử lại sau nhé! 😅"
        }
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="fixed bottom-0 left-0 right-0 sm:bottom-24 sm:left-auto sm:right-6 md:bottom-6 md:right-8 z-50 flex flex-col justify-end sm:justify-start w-full sm:w-[380px] pointer-events-none">
      <div
        className="bg-white sm:rounded-2xl rounded-t-3xl flex flex-col overflow-hidden font-sans shadow-[0_8px_30px_rgb(0,0,0,0.12)] border-0 sm:border border-slate-200 pointer-events-auto"
        style={{ height: "80vh", maxHeight: "600px", minHeight: "400px" }}
      >
        {/* Header */}
        <div className="flex items-center gap-3 px-4 py-4 border-b border-[#E8DED2]">
          <div className="w-10 h-10 bg-[#243B5A] rounded-full flex items-center justify-center">
            <Bot size={20} className="text-white" />
          </div>
          <div className="flex-1">
            <p className="font-bold text-[#243B5A] text-[15px] tracking-tight">EasyHouse Assistant</p>
            <div className="flex items-center gap-1.5 mt-0.5">
              <span className={`w-2 h-2 rounded-full ${isLoading ? 'bg-amber-500 animate-pulse' : 'bg-green-500'}`} />
              <p className="text-[13px] font-medium text-[#6B7A8C]">
                {isLoading ? 'Đang suy nghĩ...' : 'Trợ lý Tìm Trọ AI'}
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 bg-slate-100 rounded-full flex items-center justify-center active:bg-slate-200 transition-colors"
          >
            <X size={16} className="text-[#6B7A8C]" />
          </button>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto px-4 py-4 space-y-4">
          {messages.map((msg) => (
            <div
              key={msg.id}
              className={`flex gap-2.5 ${msg.role === "user" ? "flex-row-reverse" : "flex-row"}`}
            >
              {msg.role === "bot" ? (
                <div className="w-8 h-8 bg-[#4FA7A0]/15 rounded-full flex items-center justify-center shrink-0">
                  <Bot size={14} className="text-[#243B5A]" />
                </div>
              ) : (
                <div className="w-8 h-8 bg-slate-200 rounded-full flex items-center justify-center shrink-0">
                  <User size={14} className="text-[#6B7A8C]" />
                </div>
              )}
              <div
                className={`max-w-[75%] px-4 py-3 text-[14.5px] leading-[1.5] whitespace-pre-line shadow-sm ${msg.role === "bot"
                  ? "bg-[#F8FAFC] text-[#1E293B] rounded-2xl rounded-tl-sm border border-slate-100 font-medium"
                  : "bg-[#243B5A] text-white rounded-2xl rounded-tr-sm font-normal"
                  }`}
              >
                {msg.text.split(/(!?\[.*?\]\(.*?\))/).map((segment, idx) => {
                  if (segment.startsWith('![') && segment.includes('](')) {
                    const imgMatch = segment.match(/!\[(.*?)\]\((.*?)\)/);
                    if (imgMatch) {
                      return (
                        <img key={idx} src={imgMatch[2]} alt={imgMatch[1]} className="w-full max-h-48 object-cover rounded-xl mt-2 mb-1 shadow-sm border border-slate-100" />
                      );
                    }
                  } else if (segment.startsWith('[') && segment.includes('](')) {
                    const linkMatch = segment.match(/\[(.*?)\]\((.*?)\)/);
                    if (linkMatch) {
                      return (
                        <a key={idx} href={linkMatch[2]} target="_blank" rel="noopener noreferrer" className={`underline underline-offset-2 font-bold transition-colors ${msg.role === "bot" ? "text-amber-600 hover:text-amber-700" : "text-amber-300 hover:text-amber-200"}`}>
                          {linkMatch[1]}
                        </a>
                      );
                    }
                  }
                  return (
                    <span key={idx}>
                      {segment.split('**').map((part, i) => (
                        i % 2 === 1 ? <strong key={i} className={msg.role === "bot" ? "text-[#4FA7A0]" : "text-white"}>{part}</strong> : part
                      ))}
                    </span>
                  );
                })}
              </div>
            </div>
          ))}

          {isLoading && (
            <div className="flex gap-2.5 flex-row">
              <div className="w-8 h-8 bg-[#4FA7A0]/15 rounded-full flex items-center justify-center shrink-0">
                <Bot size={14} className="text-[#243B5A]" />
              </div>
              <div className="px-4 py-4 bg-[#F8FAFC] rounded-2xl rounded-tl-sm border border-slate-100 flex items-center gap-1">
                <div className="w-1.5 h-1.5 bg-[#4FA7A0]/60 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
                <div className="w-1.5 h-1.5 bg-[#4FA7A0]/60 rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
                <div className="w-1.5 h-1.5 bg-[#4FA7A0]/60 rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
              </div>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>

        {/* Quick replies */}
        <div className="px-4 py-3 flex gap-2 overflow-x-auto scrollbar-none border-t border-[#E8DED2]">
          {quickReplies.map((q) => (
            <button
              key={q}
              onClick={() => sendMessage(q)}
              disabled={isLoading}
              className="shrink-0 text-[13px] font-medium bg-[#4FA7A0]/10 text-[#1E293B] border border-[#4FA7A0]/30 px-3.5 py-2 rounded-full active:bg-[#4FA7A0]/20 transition-all hover:bg-[#4FA7A0]/15 disabled:opacity-50"
            >
              {q}
            </button>
          ))}
        </div>

        {/* Input */}
        <div className="px-4 py-3 pb-8 flex items-center gap-2 border-t border-[#E8DED2] bg-white">
          <div className="flex-1 flex items-center gap-2 bg-[#F1F5F9] rounded-2xl px-4 py-3 shadow-inner">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && sendMessage(input)}
              disabled={isLoading}
              placeholder="Nhập câu hỏi..."
              className="flex-1 bg-transparent outline-none text-[15px] font-medium text-[#243B5A] placeholder:text-[#94A3B8] disabled:bg-transparent"
            />
            <button className="text-[#6B7A8C] active:text-[#4FA7A0] transition-colors disabled:opacity-50" disabled={isLoading}>
              <Mic size={18} />
            </button>
          </div>
          <button
            onClick={() => sendMessage(input)}
            disabled={isLoading || !input.trim()}
            className="w-12 h-12 bg-[#243B5A] rounded-full flex items-center justify-center shadow-md active:scale-95 transition-transform hover:bg-[#1E293B] disabled:opacity-70 disabled:active:scale-100"
          >
            {isLoading ? <Loader2 size={18} className="text-white animate-spin" /> : <Send size={18} className="text-white ml-1" />}
          </button>
        </div>
      </div>
    </div>
  );
}
