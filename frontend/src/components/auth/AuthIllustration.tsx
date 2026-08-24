/**
 * AuthIllustration
 *
 * Line-art SVG illustrations for auth pages.
 * Animation classes (auth-float, auth-float-sm, etc.) are defined in globals.css.
 * All animations respect `prefers-reduced-motion` via CSS.
 */

export function IllustrationLeft() {
  return (
    <svg
      viewBox="0 0 220 300"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="w-full h-full"
      aria-hidden="true"
      style={{ overflow: 'visible' }}
    >
      {/* ── Block / desk ── */}
      <rect x="40" y="210" width="80" height="50" rx="4" stroke="#1e293b" strokeWidth="2" fill="#f0fdf4" />

      {/* ── Small step block ── */}
      <rect x="10" y="230" width="40" height="30" rx="3" stroke="#1e293b" strokeWidth="1.5" fill="#f8fafc" />

      {/* Arrow on step — floats independently */}
      <g className="auth-arrow auth-delay-200">
        <polyline points="30,252 30,238 24,244" stroke="#1e293b" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
        <line x1="30" y1="238" x2="36" y2="244" stroke="#1e293b" strokeWidth="1.5" strokeLinecap="round" />
      </g>

      {/* ── Person body — the whole person floats gently ── */}
      <g className="auth-float">
        {/* Torso */}
        <path
          d="M75 175 Q70 195 65 205 Q75 208 90 205 Q92 195 85 175 Z"
          stroke="#1e293b" strokeWidth="1.8" fill="#e2e8f0"
        />
        {/* Left arm + laptop */}
        <path d="M72 183 Q58 190 52 195" stroke="#1e293b" strokeWidth="1.8" strokeLinecap="round" />
        <path d="M52 195 Q60 193 72 192" stroke="#1e293b" strokeWidth="1.8" strokeLinecap="round" />
        {/* Laptop lid */}
        <path d="M52 195 L68 175 L85 180 L72 195 Z" stroke="#1e293b" strokeWidth="1.5" fill="#bfdbfe" />
        {/* Screen glow line */}
        <line x1="62" y1="180" x2="78" y2="183" stroke="#0D9488" strokeWidth="1.2" strokeLinecap="round" />
        {/* Right arm */}
        <path d="M88 183 Q100 188 105 196" stroke="#1e293b" strokeWidth="1.8" strokeLinecap="round" />
        {/* Legs */}
        <path d="M70 205 Q68 220 60 235" stroke="#1e293b" strokeWidth="1.8" strokeLinecap="round" />
        <path d="M85 205 Q88 220 95 235" stroke="#1e293b" strokeWidth="1.8" strokeLinecap="round" />
        {/* Shoes */}
        <ellipse cx="57" cy="237" rx="8" ry="4" stroke="#1e293b" strokeWidth="1.5" fill="#1e293b" />
        <ellipse cx="98" cy="237" rx="8" ry="4" stroke="#1e293b" strokeWidth="1.5" fill="#1e293b" />

        {/* Head + hair */}
        <circle cx="80" cy="162" r="14" stroke="#1e293b" strokeWidth="1.8" fill="#fef3c7" />
        <path d="M74 152 Q80 144 86 152" stroke="#1e293b" strokeWidth="2" strokeLinecap="round" />
        <circle cx="80" cy="150" r="5" stroke="#1e293b" strokeWidth="1.5" fill="#1e293b" />

        {/* Energy lines — lightbulb moment */}
        <line x1="100" y1="148" x2="108" y2="140" stroke="#1e293b" strokeWidth="1.5" strokeLinecap="round" />
        <line x1="103" y1="155" x2="113" y2="152" stroke="#1e293b" strokeWidth="1.5" strokeLinecap="round" />
        <line x1="98" y1="143" x2="102" y2="133" stroke="#1e293b" strokeWidth="1.5" strokeLinecap="round" />
      </g>

      {/* ── Key — floats with rotation ── */}
      <g className="auth-float-key auth-delay-400">
        <circle cx="158" cy="100" r="10" stroke="#0D9488" strokeWidth="1.5" fill="none" />
        <line x1="168" y1="100" x2="182" y2="100" stroke="#0D9488" strokeWidth="1.5" strokeLinecap="round" />
        <line x1="177" y1="100" x2="177" y2="106" stroke="#0D9488" strokeWidth="1.5" strokeLinecap="round" />
        <line x1="182" y1="100" x2="182" y2="107" stroke="#0D9488" strokeWidth="1.5" strokeLinecap="round" />
      </g>

      {/* ── Sparkle top-right ── */}
      <g className="auth-sparkle auth-delay-600" style={{ opacity: 0.35 }}>
        <path
          d="M185 72 L186.2 68 L187.4 72 L191.4 73.2 L187.4 74.4 L186.2 78.4 L185 74.4 L181 73.2 Z"
          stroke="#0D9488" strokeWidth="1" fill="#ccfbf1"
        />
      </g>

      {/* ── Sparkle bottom-right of key ── */}
      <g className="auth-sparkle auth-delay-200" style={{ opacity: 0.3 }}>
        <path
          d="M196 88 L196.8 85 L197.6 88 L200.6 88.8 L197.6 89.6 L196.8 92.6 L196 89.6 L193 88.8 Z"
          stroke="#94a3b8" strokeWidth="0.8" fill="none"
        />
      </g>

      {/* ── Ground line ── */}
      <line x1="0" y1="260" x2="220" y2="260" stroke="#cbd5e1" strokeWidth="1.5" />
    </svg>
  );
}

export function IllustrationRight() {
  return (
    <svg
      viewBox="0 0 220 300"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="w-full h-full"
      aria-hidden="true"
      style={{ overflow: 'visible' }}
    >
      {/* ── Bar chart columns — static, gives visual weight ── */}
      {/* Col 1 short */}
      <rect x="20" y="210" width="42" height="50" rx="4" stroke="#1e293b" strokeWidth="1.8" fill="#f1f5f9" />
      {/* Col 2 medium with teal accent */}
      <rect x="76" y="170" width="42" height="90" rx="4" stroke="#1e293b" strokeWidth="1.8" fill="#ccfbf1" />
      <rect x="76" y="170" width="42" height="28" rx="4" stroke="none" fill="#0D9488" opacity="0.15" />
      {/* Col 3 tallest */}
      <rect x="132" y="140" width="42" height="120" rx="4" stroke="#1e293b" strokeWidth="1.8" fill="#f1f5f9" />

      {/* ── Cloud — floats gently ── */}
      <g className="auth-float-sm auth-delay-100">
        <path
          d="M145 125 Q148 115 158 118 Q160 108 172 112 Q182 108 182 120 Q190 120 188 130 Q188 135 180 134 L148 134 Q140 134 140 127 Q140 120 145 125 Z"
          stroke="#1e293b" strokeWidth="1.5" fill="#f8fafc"
        />
      </g>

      {/* ── Document on col 1 — floats independently ── */}
      <g className="auth-float-doc auth-delay-600">
        <rect x="28" y="182" width="26" height="22" rx="3" stroke="#0D9488" strokeWidth="1.4" fill="white" />
        <line x1="32" y1="188" x2="50" y2="188" stroke="#0D9488" strokeWidth="1" strokeLinecap="round" />
        <line x1="32" y1="192" x2="50" y2="192" stroke="#0D9488" strokeWidth="1" strokeLinecap="round" />
        <line x1="32" y1="196" x2="44" y2="196" stroke="#0D9488" strokeWidth="1" strokeLinecap="round" />
      </g>

      {/* ── Sparkle star on top of col3 ── */}
      <g className="auth-sparkle auth-delay-400">
        <path
          d="M153 138 L154.5 133 L156 138 L161 139.5 L156 141 L154.5 146 L153 141 L148 139.5 Z"
          stroke="#1e293b" strokeWidth="1.2" fill="#fef9c3"
        />
      </g>

      {/* ── Small sparkle upper-left ── */}
      <g className="auth-sparkle auth-delay-800" style={{ opacity: 0.3 }}>
        <path
          d="M35 160 L36 157 L37 160 L40 161 L37 162 L36 165 L35 162 L32 161 Z"
          stroke="#94a3b8" strokeWidth="0.8" fill="none"
        />
      </g>

      {/* ── House top-right — static, acts as visual anchor ── */}
      <polygon points="170,60 200,60 200,85 170,85" stroke="#1e293b" strokeWidth="1.5" fill="white" />
      {/* Roof */}
      <polyline points="167,62 185,45 203,62" stroke="#1e293b" strokeWidth="1.8" strokeLinejoin="round" fill="none" />
      {/* Door */}
      <rect x="180" y="72" width="10" height="13" rx="2" stroke="#1e293b" strokeWidth="1.2" fill="none" />
      {/* Window */}
      <rect x="170" y="67" width="8" height="7" rx="1" stroke="#1e293b" strokeWidth="1" fill="#bfdbfe" />

      {/* ── Ground line ── */}
      <line x1="0" y1="260" x2="220" y2="260" stroke="#cbd5e1" strokeWidth="1.5" />
    </svg>
  );
}
