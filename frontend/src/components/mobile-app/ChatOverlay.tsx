'use client';
import { useState, useRef, useEffect } from "react";
import { X, Send, Mic, Bot, User } from "lucide-react";

interface Message {
  id: number;
  role: "bot" | "user";
  text: string;
}

const quickReplies = [
  "Máº­t kháº©u Wifi lÃ  gÃ¬?",
  "CÃ¡ch Ä‘á»c Ä‘á»“ng há»“ Ä‘iá»‡n?",
  "HÃ³a Ä‘Æ¡n thÃ¡ng nÃ y lÃ  bao nhiÃªu?",
  "LiÃªn há»‡ chá»§ nhÃ ",
];

const botResponses: Record<string, string> = {
  "Máº­t kháº©u Wifi lÃ  gÃ¬?": "Máº­t kháº©u Wifi tÃ²a nhÃ  lÃ : **EasyHouse@2026**\nSSID: EasyHouse_3F_5G ðŸ“¶",
  "CÃ¡ch Ä‘á»c Ä‘á»“ng há»“ Ä‘iá»‡n?": "Äá»ƒ Ä‘á»c Ä‘á»“ng há»“ Ä‘iá»‡n:\n1. Ghi sá»‘ 5 chá»¯ sá»‘ trÃªn mÃ n hÃ¬nh\n2. Trá»« sá»‘ thÃ¡ng trÆ°á»›c\n3. NhÃ¢n vá»›i 3.500Ä‘/kWh âš¡",
  "HÃ³a Ä‘Æ¡n thÃ¡ng nÃ y lÃ  bao nhiÃªu?": "HÃ³a Ä‘Æ¡n thÃ¡ng 5/2026 cá»§a báº¡n lÃ  **7.200.000Ä‘**\nHáº¡n thanh toÃ¡n: 15/05/2026 ðŸ“‹",
  "LiÃªn há»‡ chá»§ nhÃ ": "ThÃ´ng tin chá»§ nhÃ :\nðŸ“ž Ã”ng Tráº§n Minh Khoa\n0908 123 456\nZalo: 0908123456 ðŸ ",
};

interface ChatOverlayProps {
  onClose: () => void;
}

export function ChatOverlay({ onClose }: ChatOverlayProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: 0,
      role: "bot",
      text: "Xin chÃ o! TÃ´i lÃ  EasyHouse AI ðŸ¤–\nTÃ´i cÃ³ thá»ƒ giÃºp báº¡n vá» hÃ³a Ä‘Æ¡n, tiá»‡n Ã­ch, hay thÃ´ng tin phÃ²ng. Báº¡n cáº§n há»— trá»£ gÃ¬?",
    },
  ]);
  const [input, setInput] = useState("");
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const sendMessage = (text: string) => {
    if (!text.trim()) return;
    const userMsg: Message = { id: Date.now(), role: "user", text };
    setMessages((prev) => [...prev, userMsg]);
    setInput("");

    setTimeout(() => {
      const response = botResponses[text] || "Xin lá»—i, tÃ´i chÆ°a hiá»ƒu cÃ¢u há»i cá»§a báº¡n. Báº¡n cÃ³ thá»ƒ thá»­ há»i láº¡i khÃ´ng? ðŸ˜Š";
      setMessages((prev) => [...prev, { id: Date.now() + 1, role: "bot", text: response }]);
    }, 700);
  };

  return (
    <div className="absolute inset-0 z-50 flex flex-col justify-end" style={{ background: "rgba(15,23,42,0.4)" }}>
      <div
        className="bg-white rounded-t-3xl flex flex-col overflow-hidden"
        style={{ height: "85%" }}
      >
        {/* Header */}
        <div className="flex items-center gap-3 px-4 py-4 border-b border-[#E8DED2]">
          <div className="w-10 h-10 bg-[#243B5A] rounded-full flex items-center justify-center">
            <Bot size={20} className="text-white" />
          </div>
          <div className="flex-1">
            <p className="font-semibold text-[#243B5A] text-sm">EasyHouse AI</p>
            <div className="flex items-center gap-1">
              <span className="w-1.5 h-1.5 bg-green-500 rounded-full" />
              <p className="text-xs text-[#6B7A8C]">LuÃ´n sáºµn sÃ ng há»— trá»£</p>
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
        <div className="flex-1 overflow-y-auto px-4 py-4 space-y-3">
          {messages.map((msg) => (
            <div
              key={msg.id}
              className={`flex gap-2 ${msg.role === "user" ? "flex-row-reverse" : "flex-row"}`}
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
                className={`max-w-[75%] px-4 py-3 rounded-2xl text-sm leading-relaxed whitespace-pre-line ${
                  msg.role === "bot"
                    ? "bg-[#F1F5F9] text-[#243B5A] rounded-tl-sm"
                    : "bg-[#243B5A] text-white rounded-tr-sm"
                }`}
              >
                {msg.text}
              </div>
            </div>
          ))}
          <div ref={messagesEndRef} />
        </div>

        {/* Quick replies */}
        <div className="px-4 py-2 flex gap-2 overflow-x-auto scrollbar-none border-t border-[#E8DED2]">
          {quickReplies.map((q) => (
            <button
              key={q}
              onClick={() => sendMessage(q)}
              className="shrink-0 text-xs bg-[#4FA7A0]/10 text-[#243B5A] border border-[#4FA7A0]/30 px-3 py-2 rounded-full active:bg-[#4FA7A0]/15 transition-colors"
            >
              {q}
            </button>
          ))}
        </div>

        {/* Input */}
        <div className="px-4 py-3 pb-8 flex items-center gap-2 border-t border-[#E8DED2] bg-white">
          <div className="flex-1 flex items-center gap-2 bg-[#F1F5F9] rounded-2xl px-4 py-3">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && sendMessage(input)}
              placeholder="Nháº­p cÃ¢u há»i..."
              className="flex-1 bg-transparent outline-none text-sm text-[#243B5A] placeholder:text-[#6B7A8C]"
            />
            <button className="text-[#6B7A8C] active:text-[#4FA7A0] transition-colors">
              <Mic size={18} />
            </button>
          </div>
          <button
            onClick={() => sendMessage(input)}
            className="w-11 h-11 bg-[#243B5A] rounded-full flex items-center justify-center shadow-sm active:scale-95 transition-transform"
          >
            <Send size={16} className="text-white" />
          </button>
        </div>
      </div>
    </div>
  );
}
