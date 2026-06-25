# Design System Documentation

> **PENTING:** Dokumen ini adalah panduan desain utama yang selaras dengan `SOP.md`. Seluruh keputusan visual, tema, bahasa, dan animasi mengacu pada dokumen ini sebagai **Single Source of Truth** untuk UI/UX.
>
> **Prosedur Perubahan**: Ikuti prosedur yang sama dengan `SOP.md` — analisis, konsultasi, persetujuan eksplisit, lalu merge.

---

## 1. Filosofi Desain

### 1.1 Prinsip Utama
- **Konsisten**: Setiap elemen visual mengikuti token yang telah didefinisikan — tidak ada nilai warna, font, atau spacing yang hardcoded di luar sistem token.
- **Modular**: Tema, nuansa, bahasa, dan animasi bersifat independen dan dapat dikombinasikan bebas.
- **Accessible**: Seluruh pilihan visual wajib memenuhi standar WCAG AA (kontras minimum 4.5:1 untuk teks normal, 3:1 untuk teks besar).
- **Purposeful**: Animasi dan dekorasi harus memiliki tujuan — bukan sekadar estetika.
- **Fluent-First**: Seluruh komponen dibangun di atas `@fluentui/react-components`. Token Fluent UI di-override untuk mengekspresikan nuansa yang dipilih, bukan digantikan.

### 1.2 Hierarki Sistem Visual
```
Nuansa (Vibe)         ← lapisan paling luar, mengatur kepribadian visual
      ↓
Tema (Light/Dark)     ← mengatur nilai terang/gelap dalam nuansa
      ↓
Bahasa (i18n)         ← mengatur teks, arah baca, dan tipografi regional
      ↓
Token Design          ← warna, font, spacing, radius, shadow, animasi
      ↓
Komponen Fluent UI    ← implementasi aktual di React
```

---

## 2. Sistem Tema

### 2.1 Pilihan Tema
Aplikasi mendukung tiga mode tema yang bisa dipilih pengguna:

| Mode | Token | Keterangan |
|---|---|---|
| `light` | `webLightTheme` | Latar terang, teks gelap |
| `dark` | `webDarkTheme` | Latar gelap, teks terang |
| `system` | Auto-detect | Mengikuti preferensi OS |

### 2.2 Implementasi Tema di Fluent UI
```tsx
// src/controllers/use-theme.ts
import { useQueryState } from "nuqs";
import { parseAsStringEnum } from "nuqs";

type Theme = "light" | "dark" | "system";

export const useTheme = () => {
  const [theme, setTheme] = useQueryState(
    "theme",
    parseAsStringEnum(["light", "dark", "system"]).withDefault("system")
  );
  return { theme, setTheme };
};
```

```tsx
// src/app/layout.tsx
import { FluentProvider, webLightTheme, webDarkTheme } from "@fluentui/react-components";
import { mergeThemes } from "./lib/merge-themes";

<FluentProvider theme={mergeThemes(selectedVibe, selectedTheme)}>
  {children}
</FluentProvider>
```

### 2.3 Penyimpanan Preferensi Tema
- Tema disimpan di `zustand` store dengan `persist` middleware ke `localStorage` via `tauri-plugin-store` di Tauri.
- Default saat pertama install: ditentukan oleh konfigurasi aplikasi (`app.config.ts`), bukan hardcoded.

---

## 3. Sistem Bahasa (i18n)

### 3.1 Bahasa yang Didukung
| Kode | Bahasa | Arah Baca |
|---|---|---|
| `id` | Bahasa Indonesia | LTR |
| `en` | English | LTR |

### 3.2 Stack i18n
- Library: **`next-intl`** — native support Next.js App Router, SSR-compatible.
- File terjemahan: `src/locales/id.json` dan `src/locales/en.json`.
- Routing: prefix URL `/id/...` dan `/en/...`.

### 3.3 Tipografi per Bahasa
Font dipilih berdasarkan kombinasi bahasa **dan** nuansa aktif:

| Bahasa | Display Font | Body Font | Catatan |
|---|---|---|---|
| `id` | Mengikuti nuansa | Plus Jakarta Sans | Optimal untuk huruf Latin + diakritik Indonesia |
| `en` | Mengikuti nuansa | Inter | Standar internasional, sangat readable |

### 3.4 Penyimpanan Preferensi Bahasa
- Bahasa disimpan via `nuqs` di URL (`?lang=id`) untuk SSR-compatibility.
- Fallback: deteksi bahasa browser via `navigator.language`.

---

## 4. Sistem Nuansa (Vibe System)

### 4.1 Filosofi Nuansa
Setiap nuansa adalah **kepribadian visual lengkap** yang mencakup:
- Palet warna (primer, sekunder, aksen, surface, border)
- Tipografi display (font judul yang merepresentasikan karakter nuansa)
- Radius komponen (sharp, rounded, pill)
- Shadow & depth
- Animasi & easing
- Tekstur & pattern (opsional)

### 4.2 Daftar Nuansa yang Tersedia

#### 🔷 Modern
```
Karakter  : Bersih, presisi, profesional, minimalis
Warna     : #0F172A (base), #3B82F6 (aksen), #F8FAFC (surface)
Display   : "Geist" atau "Space Grotesk"
Body      : "Inter"
Radius    : 8px (medium-rounded)
Shadow    : Subtle, difuse, monochromatic
Animasi   : Ease-out cepat (200ms), spring ringan
Tekstur   : Tidak ada — kejelasan adalah dekorasi
```

#### ⚡ Cyberpunk
```
Karakter  : Futuristik, neon, high-contrast, edgy
Warna     : #0A0A0F (base), #00FF9C (aksen neon), #FF2D78 (aksen sekunder)
Display   : "Orbitron" atau "Rajdhani"
Body      : "Share Tech Mono" atau "JetBrains Mono"
Radius    : 2px (sharp, angular)
Shadow    : Neon glow (box-shadow dengan warna aksen)
Animasi   : Glitch effect, scanline, flicker (150ms, cubic-bezier tajam)
Tekstur   : Grid lines, scanlines, noise overlay
```

#### ⚙️ Steampunk
```
Karakter  : Viktorian, tembaga, mekanis, antik-futuristik
Warna     : #2C1810 (base coklat tua), #B87333 (tembaga), #D4AF37 (emas)
Display   : "Cinzel Decorative" atau "IM Fell English"
Body      : "Crimson Text" atau "Libre Baskerville"
Radius    : 4px (sedikit rounded, terkesan dikerjain tangan)
Shadow    : Warm sepia tone, inner shadow untuk efek emboss
Animasi   : Gear rotation, slow reveal (400ms, ease-in-out)
Tekstur   : Gear pattern, worn leather, rivets
```

#### 🌿 Nature
```
Karakter  : Organik, tenang, earthy, breathable
Warna     : #1A2E1A (hijau tua), #4CAF50 (hijau), #F5F0E8 (krem)
Display   : "Playfair Display" atau "Cormorant Garamond"
Body      : "Lato" atau "Source Sans Pro"
Radius    : 16px (soft, organik)
Shadow    : Green-tinted, soft difuse
Animasi   : Slow fade, gentle float (300ms, ease-in-out)
Tekstur   : Leaf pattern, grain, watercolor wash
```

#### 📜 Oldstyle
```
Karakter  : Klasik, elegan, editorial, timeless
Warna     : #F5F0DC (perkamen), #2C2416 (tinta), #8B6914 (emas tua)
Display   : "Playfair Display SC" atau "Cormorant SC"
Body      : "EB Garamond" atau "Crimson Pro"
Radius    : 0px (sharp, klasik)
Shadow    : Tidak ada — flat seperti media cetak
Animasi   : Page turn, fade (500ms, linear)
Tekstur   : Paper grain, aged texture
```

#### 🤠 Cowboy
```
Karakter  : Wild west, rugged, warm, dusty
Warna     : #3D2B1F (coklat gelap), #C17F24 (emas barat), #D4956A (pasir)
Display   : "Rye" atau "Wanted" atau "Boogaloo"
Body      : "Noticia Text" atau "Zilla Slab"
Radius    : 4px (handcrafted feel)
Shadow    : Warm amber tone, pressed effect
Animasi   : Slide-in dari sisi (300ms, ease-out), dust particle
Tekstur   : Wood grain, worn leather, rope pattern
```

#### 🌸 Minimalist Japanese
```
Karakter  : Ma (negative space), zen, ink, seasonal
Warna     : #FAFAF8 (washi), #1C1C1E (sumi ink), #E8A0A0 (sakura)
Display   : "Noto Serif JP" atau "Shippori Mincho"
Body      : "Noto Sans JP" atau "M PLUS 1p"
Radius    : 0px atau 2px (presisi)
Shadow    : Tidak ada — white space adalah hirarki
Animasi   : Ink brush reveal, slow wipe (600ms, ease)
Tekstur   : Washi paper grain, subtle ink wash
```

#### 🚀 Retro Futurism
```
Karakter  : 70s sci-fi, optimistic, geometric, bold
Warna     : #1A0533 (deep purple), #FF6B35 (oranye retro), #FFD700 (kuning)
Display   : "Audiowide" atau "Nasalization"
Body      : "Exo 2" atau "Titillium Web"
Radius    : 0px dan 50% (mix sharp + pill, no in-between)
Shadow    : Hard offset shadow (no blur), duotone
Animasi   : Bounce, overshoot (400ms, spring cubic-bezier)
Tekstur   : Halftone dots, geometric grid
```

---

## 5. Token Design System

### 5.1 Struktur Token
```
src/styles/
├── tokens/
│   ├── base.ts          ← spacing, breakpoint, z-index (tidak berubah)
│   ├── vibes/
│   │   ├── modern.ts
│   │   ├── cyberpunk.ts
│   │   ├── steampunk.ts
│   │   ├── nature.ts
│   │   ├── oldstyle.ts
│   │   ├── cowboy.ts
│   │   ├── japanese.ts
│   │   └── retro.ts
│   └── index.ts         ← export semua vibe tokens
├── fonts/
│   └── index.ts         ← mapping font per vibe + bahasa
└── animations/
    └── index.ts         ← keyframes & easing per vibe
```

### 5.2 Struktur Token per Nuansa
Setiap file vibe wajib mengekspor token berikut:
```typescript
export interface VibeToken {
  // Warna
  colorPrimary: string;
  colorSecondary: string;
  colorAccent: string;
  colorSurface: string;
  colorSurfaceAlt: string;
  colorBorder: string;
  colorText: string;
  colorTextMuted: string;

  // Tipografi
  fontDisplay: string;
  fontBody: string;
  fontMono: string;
  fontScaleBase: number;      // px, biasanya 16

  // Shape
  radiusSmall: string;
  radiusMedium: string;
  radiusLarge: string;
  radiusFull: string;

  // Shadow
  shadowSmall: string;
  shadowMedium: string;
  shadowLarge: string;

  // Animasi
  durationFast: string;       // ms
  durationNormal: string;
  durationSlow: string;
  easingDefault: string;      // cubic-bezier
  easingSpring: string;

  // Tekstur (opsional)
  textureOverlay?: string;    // CSS background atau URL
}
```

### 5.3 Spacing Scale (Universal, tidak berubah per nuansa)
```
2px   → space-1  (micro gap)
4px   → space-2  (tight)
8px   → space-3  (compact)
12px  → space-4
16px  → space-5  (base)
24px  → space-6
32px  → space-7
48px  → space-8
64px  → space-9
96px  → space-10 (section gap)
```

### 5.4 Breakpoint (Universal)
```
sm  → 480px   (mobile)
md  → 768px   (tablet)
lg  → 1024px  (desktop)
xl  → 1280px  (wide)
2xl → 1536px  (ultrawide)
```

---

## 6. Sistem Tipografi

### 6.1 Skala Tipografi
| Role | Size | Weight | Line Height | Keterangan |
|---|---|---|---|---|
| Display XL | 64px | 700-900 | 1.1 | Hero headline |
| Display L | 48px | 700 | 1.15 | Section title |
| Display M | 36px | 600-700 | 1.2 | Card title besar |
| Heading L | 28px | 600 | 1.3 | H2 |
| Heading M | 22px | 600 | 1.35 | H3 |
| Heading S | 18px | 600 | 1.4 | H4 |
| Body L | 18px | 400 | 1.6 | Artikel panjang |
| Body M | 16px | 400 | 1.6 | Default body |
| Body S | 14px | 400 | 1.5 | Secondary text |
| Caption | 12px | 400 | 1.4 | Label, metadata |
| Mono | 14px | 400 | 1.6 | Kode, data |

### 6.2 Aturan Tipografi
- Wajib menggunakan font dari **CDNFonts** sesuai yang didefinisikan per nuansa.
- Display font digunakan **hanya** untuk judul (H1-H3) — tidak untuk body atau UI label.
- Mono font digunakan untuk kode, data tabel numerik, dan timestamp.
- Satu halaman hanya boleh menggunakan **maksimal 2 font family** (display + body).

---

## 7. Sistem Animasi

### 7.1 Prinsip Animasi
- **Purposeful**: Setiap animasi harus memiliki tujuan fungsional (feedback, orientasi, transisi).
- **Reduced Motion**: Wajib menghormati `prefers-reduced-motion` — semua animasi harus bisa dinonaktifkan.
- **Performance**: Gunakan hanya properti `transform` dan `opacity` untuk animasi — hindari animasi `width`, `height`, `top`, `left`.
- **Konsisten per Nuansa**: Karakter animasi mengikuti kepribadian nuansa aktif.

### 7.2 Kategori Animasi per Nuansa

| Nuansa | Karakter Animasi | Durasi Tipikal | Easing |
|---|---|---|---|
| Modern | Slide + fade, precise | 200ms | ease-out |
| Cyberpunk | Glitch, flicker, scanline | 150ms | steps(4) |
| Steampunk | Gear spin, slow reveal | 400ms | ease-in-out |
| Nature | Float, breathe, grow | 300ms | ease-in-out |
| Oldstyle | Page turn, ink fade | 500ms | linear |
| Cowboy | Slide dari sisi, dust | 300ms | ease-out |
| Japanese | Ink brush, slow wipe | 600ms | ease |
| Retro | Bounce, overshoot | 400ms | spring |

### 7.3 Animasi Standar (Tersedia di Semua Nuansa)
```typescript
// src/styles/animations/index.ts
export const animations = {
  fadeIn: "fadeIn 200ms ease-out",
  slideUp: "slideUp 200ms ease-out",
  slideDown: "slideDown 200ms ease-out",
  scaleIn: "scaleIn 150ms ease-out",
  // Override per nuansa untuk durasi & easing
};
```

---

## 8. Responsivitas & Multiplatform

### 8.1 Breakpoint Strategy
Karena aplikasi berjalan di web (Netlify) dan desktop/mobile (Tauri), layout wajib responsif di semua ukuran:

| Platform | Ukuran Target | Breakpoint |
|---|---|---|
| Mobile (Tauri) | 375px - 428px | `sm` |
| Tablet | 768px - 1024px | `md` - `lg` |
| Desktop (Tauri) | 1024px - 1920px | `lg` - `2xl` |
| Web Browser | Semua ukuran | Semua breakpoint |

### 8.2 Fluent UI Responsive Tokens
Gunakan Fluent UI responsive utilities untuk layout adaptif:
```tsx
// Jangan gunakan Tailwind — gunakan Fluent UI Stack/Grid
import { makeStyles } from "@fluentui/react-components";

const useStyles = makeStyles({
  grid: {
    display: "grid",
    gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))",
    gap: tokens.spacingHorizontalL,
  },
});
```

---

## 9. Aksesibilitas Visual

### 9.1 Kontras Warna (WCAG AA)
- Teks normal (< 18px): rasio kontras minimum **4.5:1**
- Teks besar (≥ 18px bold atau ≥ 24px): minimum **3:1**
- Komponen UI & ikon: minimum **3:1**
- Setiap token warna wajib diverifikasi kontrasnya sebelum masuk ke sistem.

### 9.2 Motion Accessibility
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```
Wajib diimplementasikan di `src/styles/global.css`.

### 9.3 Focus Indicator
- Semua komponen interaktif wajib memiliki focus ring yang visible.
- Warna focus ring mengikuti token aksen nuansa aktif dengan kontras minimum 3:1.

---

## 10. Panduan Implementasi untuk Agen

### 10.1 Urutan Implementasi Nuansa Baru
1. Buat file token di `src/styles/tokens/vibes/<nama-nuansa>.ts`
2. Daftarkan font di `src/styles/fonts/index.ts`
3. Tambahkan keyframes animasi di `src/styles/animations/index.ts`
4. Override Fluent UI theme tokens di `src/lib/merge-themes.ts`
5. Tambahkan nuansa ke selector di `src/controllers/use-vibe.ts`
6. Test kontras warna semua token sebelum commit

### 10.2 Aturan yang Tidak Boleh Dilanggar
- **Dilarang** hardcode warna, font, atau radius di komponen — wajib dari token.
- **Dilarang** menggunakan Tailwind CSS — semua styling via Fluent UI `makeStyles`.
- **Dilarang** animasi properti selain `transform` dan `opacity`.
- **Dilarang** menambah font baru yang tidak ada di CDNFonts.
- **Dilarang** bypass `prefers-reduced-motion`.

### 10.3 Checklist Sebelum Merge
- [ ] Semua token nuansa baru terdefinisi lengkap (tidak ada nilai undefined)
- [ ] Kontras warna WCAG AA lolos untuk semua kombinasi teks/background
- [ ] Font terdaftar di CDNFonts dan diload dengan benar
- [ ] Animasi mengikuti karakter nuansa
- [ ] Responsif di semua breakpoint (sm hingga 2xl)
- [ ] `prefers-reduced-motion` dihormati
- [ ] Tidak ada hardcoded value di komponen

---

## Lampiran: Referensi Font per Nuansa (CDNFonts)

| Nuansa | Display Font | Body Font | Mono Font |
|---|---|---|---|
| Modern | Space Grotesk | Inter | JetBrains Mono |
| Cyberpunk | Orbitron | Share Tech Mono | JetBrains Mono |
| Steampunk | Cinzel Decorative | Crimson Text | Courier Prime |
| Nature | Playfair Display | Lato | Source Code Pro |
| Oldstyle | Cormorant SC | EB Garamond | Courier Prime |
| Cowboy | Rye | Zilla Slab | Courier Prime |
| Japanese | Shippori Mincho | Noto Sans JP | Noto Sans Mono |
| Retro | Audiowide | Exo 2 | Share Tech Mono |

---

## 11. Grid System & Layout Primitives

### 11.1 Column Grid per Breakpoint
```
sm  (480px)  → 4 kolom,  gutter 16px, margin 16px
md  (768px)  → 8 kolom,  gutter 24px, margin 24px
lg  (1024px) → 12 kolom, gutter 24px, margin 32px
xl  (1280px) → 12 kolom, gutter 32px, margin 48px
2xl (1536px) → 12 kolom, gutter 32px, margin auto (max-width centered)
```

### 11.2 Container Max-Width
```
content    → max-width: 720px  (artikel, form)
default    → max-width: 1024px (halaman standar)
wide       → max-width: 1280px (dashboard, tabel)
full       → max-width: 100%   (hero, background section)
```

### 11.3 Layout Patterns Standar
| Pattern | Kolom | Digunakan untuk |
|---|---|---|
| Centered | 6/12 offset 3 | Form, artikel, auth page |
| Split 50/50 | 6 + 6 | Landing, login with illustration |
| Split 40/60 | 5 + 7 | Detail page dengan sidebar |
| Sidebar | 3 + 9 | Dashboard, admin panel |
| Full Width | 12 | Hero, banner, table penuh |
| Card Grid | auto-fit 300px | List produk, daftar item |

### 11.4 Implementasi dengan Fluent UI
```tsx
// src/views/layouts/container.tsx
import { makeStyles, tokens } from "@fluentui/react-components";

const useStyles = makeStyles({
  container: {
    width: "100%",
    maxWidth: "1024px",
    marginLeft: "auto",
    marginRight: "auto",
    paddingLeft: tokens.spacingHorizontalXL,
    paddingRight: tokens.spacingHorizontalXL,
  },
});
```

---

## 12. Color Semantic Tokens

### 12.1 Status Colors (Universal, berlaku di semua nuansa)
Warna semantik tidak berubah per nuansa — hanya intensitasnya yang disesuaikan:

| Token | Light Mode | Dark Mode | Penggunaan |
|---|---|---|---|
| `colorSuccess` | #16A34A | #4ADE80 | Pembayaran berhasil, data tersimpan |
| `colorSuccessBg` | #F0FDF4 | #052E16 | Background badge/alert success |
| `colorWarning` | #D97706 | #FCD34D | Pending, perlu perhatian |
| `colorWarningBg` | #FFFBEB | #1C1500 | Background badge/alert warning |
| `colorDanger` | #DC2626 | #F87171 | Error, gagal, destruktif |
| `colorDangerBg` | #FEF2F2 | #1C0000 | Background badge/alert danger |
| `colorInfo` | #2563EB | #60A5FA | Informasi netral |
| `colorInfoBg` | #EFF6FF | #0C1A3D | Background badge/alert info |
| `colorDisabled` | #9CA3AF | #4B5563 | Komponen nonaktif |
| `colorDisabledBg` | #F3F4F6 | #1F2937 | Background disabled |

### 12.2 State Tokens (Universal)
```typescript
// Diterapkan via Fluent UI token override
colorNeutralForeground1Hover    // teks saat hover
colorNeutralBackground1Hover    // background saat hover
colorNeutralForeground1Pressed  // teks saat pressed
colorBrandBackground2Pressed    // background saat pressed
colorNeutralStroke1             // border default
colorNeutralStroke1Hover        // border saat hover
colorCompoundBrandStroke        // border saat focused
```

### 12.3 Transaction Status Colors (Khusus Xendit)
| Status | Warna | Token |
|---|---|---|
| `PENDING` | Warning kuning | `colorWarning` |
| `PAID` | Success hijau | `colorSuccess` |
| `FAILED` | Danger merah | `colorDanger` |
| `EXPIRED` | Disabled abu | `colorDisabled` |
| `REFUNDED` | Info biru | `colorInfo` |
| `PARTIAL` | #7C3AED (ungu) | `colorPartial` |

---

## 13. Component State Documentation

### 13.1 Button States
| State | Visual | Behavior |
|---|---|---|
| Default | Warna primer nuansa | Siap diklik |
| Hover | +10% lightness, subtle shadow | Cursor pointer |
| Pressed | -10% lightness, scale 0.98 | Active feedback |
| Focused | Outline 2px warna aksen, offset 2px | Keyboard navigation |
| Disabled | colorDisabled, opacity 0.5 | Cursor not-allowed |
| Loading | Spinner kiri, teks berubah, disabled | Mencegah double submit |
| Success | colorSuccess, ikon centang sementara | 1.5 detik lalu kembali normal |

### 13.2 Input / Form Field States
| State | Border | Label | Helper Text |
|---|---|---|---|
| Default | colorNeutralStroke1 | Di atas field | Hint abu |
| Focused | colorCompoundBrandStroke (2px) | Naik + warna aksen | Hint abu |
| Filled | colorNeutralStroke1 | Di atas (tetap) | — |
| Error | colorDanger (2px) | Warna danger | Pesan error merah |
| Success | colorSuccess (2px) | Warna success | Pesan konfirmasi |
| Disabled | Dashed, colorDisabled | Warna disabled | — |
| Readonly | Background colorDisabledBg | Normal | — |

### 13.3 Card States
| State | Visual |
|---|---|
| Default | Shadow small, radius sesuai nuansa |
| Hover | Shadow medium, translateY(-2px), transisi 200ms |
| Selected | Border 2px colorBrandStroke, background colorBrandBackground2 |
| Loading | Skeleton shimmer menggantikan konten |
| Error | Border colorDanger, ikon error di pojok |

### 13.4 Table States
| State | Visual |
|---|---|
| Default | Row alternating: surface + surfaceAlt |
| Row Hover | Background colorNeutralBackground1Hover |
| Row Selected | Background colorBrandBackground2, border kiri 3px aksen |
| Loading | Skeleton rows (5 rows placeholder) |
| Empty | Ilustrasi empty state + CTA |
| Error | Alert banner di atas tabel + retry button |

### 13.5 Empty State Pattern
Setiap empty state wajib mengandung:
1. **Ilustrasi** — sesuai gaya nuansa aktif
2. **Judul** — menjelaskan kondisi (bukan "No Data")
3. **Deskripsi** — konteks mengapa kosong
4. **CTA** — aksi yang bisa dilakukan pengguna

```
❌ "No data found"
✅ "Belum ada transaksi"
   "Transaksi Anda akan muncul di sini setelah pembayaran pertama."
   [Mulai Transaksi]
```

---

## 14. Dark Mode Color Mapping per Nuansa

### 14.1 Filosofi Dark Mode Senior UI/UX
Dark mode bukan inversi warna — ini adalah **palet alternatif** yang dirancang khusus:
- Surface tidak boleh pure black (`#000000`) — gunakan dark gray
- Elevation di dark mode menggunakan **lightness bertingkat** (bukan shadow)
- Saturasi warna aksen dikurangi 10-15% di dark mode agar tidak terlalu mencolok

### 14.2 Elevation Model Dark Mode
```
Elevation 0 (base)    → #0F0F0F - #1A1A1A  (background halaman)
Elevation 1 (card)    → #1E1E1E - #242424  (card, panel)
Elevation 2 (overlay) → #2A2A2A - #303030  (dropdown, popover)
Elevation 3 (modal)   → #333333 - #3A3A3A  (modal, dialog)
```
Setiap nuansa mengadaptasi skema elevation ini dengan tint warna primernya.

### 14.3 Dark Mode per Nuansa

| Nuansa | Dark Base | Dark Surface | Dark Aksen | Catatan |
|---|---|---|---|---|
| Modern | #0F172A | #1E293B | #60A5FA | Biru lebih soft |
| Cyberpunk | #050508 | #0D0D14 | #00FF9C | Neon tetap intens |
| Steampunk | #1A0F08 | #2C1A10 | #D4923A | Tembaga lebih redup |
| Nature | #0D1F0D | #1A2E1A | #6BCB77 | Hijau lebih terang |
| Oldstyle | #1A1408 | #241C0C | #C9A84C | Perkamen gelap, tinta emas |
| Cowboy | #1F1208 | #2E1C10 | #D4923A | Amber lebih redup |
| Japanese | #0F0F0D | #1A1A18 | #F0A0A0 | Sakura lebih soft |
| Retro | #0D0520 | #180A35 | #FF8C5A | Oranye lebih redup |

### 14.4 Catatan Khusus Oldstyle & Japanese di Dark Mode
Kedua nuansa ini tidak menggunakan dark mode konvensional — melainkan **"night edition"**:
- **Oldstyle Dark** → seperti membaca buku dengan lampu meja malam: background coklat tua hangat, teks krem, bukan putih
- **Japanese Dark** → seperti taman zen malam hari: background hitam arang sangat gelap, teks putih gading, aksen sakura redup

---

## 15. Iconography Rules (Fluent Icons)

### 15.1 Ukuran Ikon yang Diizinkan
| Ukuran | Penggunaan |
|---|---|
| 16px | Inline teks, badge, label kecil |
| 20px | Default UI (tombol, input, list item) |
| 24px | Navigasi, heading section |
| 28px | Card header, feature highlight |
| 32px | Empty state, onboarding |
| 48px | Hero section, splash screen |

### 15.2 Variant Fluent Icons
| Variant | Kapan Digunakan |
|---|---|
| `Regular` | Default untuk semua UI |
| `Filled` | State aktif/selected, primary action |
| `Light` | Decorative, background element |

```tsx
// ✅ Benar - Regular default, Filled untuk aktif
import { Home24Regular, Home24Filled } from "@fluentui/react-icons";

const NavItem = ({ isActive }) => (
  isActive ? <Home24Filled /> : <Home24Regular />
);
```

### 15.3 Ikon + Teks
```
Gap antara ikon dan teks: tokens.spacingHorizontalXS (4px)
Alignment: center vertical
Posisi ikon di tombol: kiri untuk aksi, kanan untuk navigasi/arrow

✅ [→ Lanjut]    (ikon kanan = navigasi)
✅ [💾 Simpan]   (ikon kiri = aksi)
❌ [Simpan 💾]   (ikon kanan untuk aksi = salah)
```

### 15.4 Ikon Standalone
Ikon tanpa teks **wajib** memiliki salah satu:
- `aria-label` untuk screen reader
- `Tooltip` dari `@fluentui/react-components` yang muncul saat hover

---

## 16. Motion Design (Detail)

### 16.1 Page Transition
```typescript
// Semua page transition menggunakan pola yang sama:
// Exit: fade out + slide up 8px (100ms)
// Enter: fade in + slide up dari 8px (200ms)
// Total: 300ms, tidak overlap

const pageVariants = {
  exit:  { opacity: 0, y: -8,  transition: { duration: 0.1 } },
  enter: { opacity: 0, y:  8 },
  animate:{ opacity: 1, y:  0,  transition: { duration: 0.2, delay: 0.1 } },
};
```

### 16.2 Staggered Children Animation
Untuk list, card grid, atau menu item — animasi masuk berurutan:
```typescript
// Parent: stagger 50ms per anak
// Anak: fade in + slide up 12px
// Maksimal 8 item yang di-stagger — sisanya muncul sekaligus

const staggerParent = { animate: { transition: { staggerChildren: 0.05 } } };
const staggerChild  = {
  enter:   { opacity: 0, y: 12 },
  animate: { opacity: 1, y:  0, transition: { duration: 0.2 } },
};
```

### 16.3 Skeleton → Content Transition
```
1. Skeleton tampil langsung (no delay)
2. Konten masuk: crossfade 150ms
3. Tidak ada layout shift — skeleton harus sama dimensinya dengan konten
```

### 16.4 Micro-interaction Standar
| Interaksi | Animasi | Durasi |
|---|---|---|
| Button press | scale(0.97) | 100ms ease-out |
| Toggle on/off | slide thumb + color transition | 200ms ease |
| Checkbox check | scale bounce 1→1.2→1 + fade ikon | 200ms spring |
| Modal masuk | scale(0.95)→1 + fade | 200ms ease-out |
| Modal keluar | scale(1)→0.95 + fade | 150ms ease-in |
| Toast masuk | slide dari bawah + fade | 300ms spring |
| Toast keluar | fade + scale(0.9) | 200ms ease-in |
| Dropdown buka | clip-path reveal dari atas | 150ms ease-out |
| Accordion buka | height expand (tidak pakai height:auto langsung) | 250ms ease |

### 16.5 Nuansa-Specific Signature Animations
| Nuansa | Signature Animation | Trigger |
|---|---|---|
| Cyberpunk | Glitch flicker pada judul | Page load, hover |
| Steampunk | Gear rotation pada loading | Loading state |
| Nature | Leaf float ambient | Background idle |
| Oldstyle | Ink spread reveal | Page transition |
| Cowboy | Dust particle slide | Page transition |
| Japanese | Ink brush horizontal wipe | Page transition |
| Retro | Bounce overshoot pada modal | Modal open |

---

## 17. Voice & Tone per Nuansa

### 17.1 Prinsip Umum
- Selalu gunakan bahasa aktif
- Nama tombol = apa yang terjadi saat diklik ("Simpan", bukan "Submit")
- Error = jelaskan masalah + cara fix, tidak minta maaf
- Empty state = undangan bertindak, bukan pernyataan kosong

### 17.2 Tone per Nuansa

| Nuansa | Tone | Contoh Tombol Hapus | Contoh Error |
|---|---|---|---|
| Modern | Profesional, ringkas | "Hapus" | "Data tidak ditemukan. Coba filter lain." |
| Cyberpunk | Tech slang, singkat | "DELETE" | "ERR_404: Data not in system." |
| Steampunk | Formal, teatrikal | "Musnahkan Berkas" | "Sungguh malang, berkas tak ditemukan." |
| Nature | Hangat, gentle | "Lepaskan" | "Hmm, kami tidak menemukan itu. Coba kata lain?" |
| Oldstyle | Elegan, formal | "Hapuskan" | "Mohon maaf, dokumen yang dicari tidak tersedia." |
| Cowboy | Kasual, humor | "Buang!" | "Wah, nggak ketemu pardner. Coba lagi?" |
| Japanese | Sopan, minimalis | "削除" / "Hapus" | "データが見つかりません。" |
| Retro | Energetik | "ZAP IT!" | "WHOOPS! Can't find that. Try again!" |

---

## 18. Z-Index Scale

### 18.1 Standar Z-Index (Universal, semua nuansa)
```typescript
// src/styles/tokens/base.ts
export const zIndex = {
  base:      0,    // konten normal
  raised:    10,   // card hover, floating element
  dropdown:  100,  // dropdown menu, select, autocomplete
  sticky:    200,  // sticky header, sticky sidebar
  overlay:   300,  // modal backdrop, drawer backdrop
  modal:     400,  // modal dialog, drawer panel
  toast:     500,  // notifikasi toast
  tooltip:   600,  // tooltip (selalu di atas segalanya)
} as const;
```

### 18.2 Aturan Z-Index
- **Dilarang** menggunakan angka z-index di luar skala di atas (tidak boleh `z-index: 9999`)
- Selalu gunakan token `zIndex.modal` bukan nilai literal
- Fluent UI components sudah menggunakan z-index internal — pastikan tidak konflik dengan menggunakan `FluentProvider` sebagai boundary

---

## 19. Data Visualization

### 19.1 Chart Library
Gunakan **Recharts** — sudah tersedia di stack React dan ringan:
```tsx
import { LineChart, BarChart, PieChart } from "recharts";
```

### 19.2 Color Palette per Nuansa untuk Chart
Setiap nuansa memiliki 8 warna chart yang harmonis (tidak menggunakan warna semantik):

| Nuansa | Chart Colors (urutan prioritas) |
|---|---|
| Modern | #3B82F6, #10B981, #F59E0B, #EF4444, #8B5CF6, #06B6D4, #F97316, #84CC16 |
| Cyberpunk | #00FF9C, #FF2D78, #00D4FF, #FFE600, #B44FFF, #FF6B00, #00FFD1, #FF00AA |
| Steampunk | #B87333, #D4AF37, #8B4513, #CD853F, #A0522D, #DEB887, #8B7355, #C19A6B |
| Nature | #4CAF50, #8BC34A, #009688, #CDDC39, #795548, #FF9800, #2196F3, #9E9D24 |
| Oldstyle | #8B6914, #A0522D, #6B4226, #C19A6B, #8B7355, #D4A017, #7B6B47, #B8860B |
| Cowboy | #C17F24, #8B4513, #D2691E, #CD853F, #A0522D, #DEB887, #B8860B, #6B4226 |
| Japanese | #E8A0A0, #A8D8A8, #AEC6CF, #F7CAC9, #B5B9FF, #FFDFD3, #D4A5A5, #C4DFE6 |
| Retro | #FF6B35, #FFD700, #7B2FBE, #00CED1, #FF1493, #32CD32, #FF8C00, #4169E1 |

### 19.3 Aturan Chart
- Selalu sertakan **legend** jika lebih dari 1 data series
- Selalu sertakan **tooltip** saat hover
- Warna chart **tidak boleh** menggunakan warna semantik (success/danger) kecuali untuk status chart
- Untuk status transaksi Xendit → gunakan warna semantik section 12.3
- Axis label menggunakan `fontMono` dari token nuansa aktif
- Responsive: chart wajib menggunakan `ResponsiveContainer` dari Recharts

### 19.4 Chart Types per Use Case
| Data | Chart Type |
|---|---|
| Tren waktu (transaksi harian) | Line Chart |
| Perbandingan kategori | Bar Chart |
| Proporsi/komposisi | Pie / Donut Chart |
| Distribusi | Area Chart |
| Korelasi dua variabel | Scatter Plot |
| Progress target | Radial Bar Chart |

---

## 20. Imagery & Illustration Guidelines

### 20.1 Gaya Ilustrasi per Nuansa
| Nuansa | Gaya Ilustrasi |
|---|---|
| Modern | Flat geometric, minimal detail, bold shapes |
| Cyberpunk | Neon line art, isometric, glitch aesthetic |
| Steampunk | Detailed engraving style, sepia tone, mechanical |
| Nature | Watercolor wash, organic shapes, hand-drawn feel |
| Oldstyle | Woodcut/etching style, high contrast, vintage |
| Cowboy | Retro poster art, hand-lettered, dusty palette |
| Japanese | Ink wash (sumi-e), minimal, seasonal motifs |
| Retro | Bold pop art, halftone, geometric retro |

### 20.2 Aturan Foto
- Format wajib `.webp`, max 500KB (hero), max 100KB (thumbnail) — sesuai SOP 4.1
- Overlay teks pada foto wajib memiliki backdrop: `rgba(0,0,0,0.4)` minimum
- Kontras teks di atas foto minimum 4.5:1 (WCAG AA)
- Placeholder dari Unsplash — sesuai SOP 4.1
- Aspect ratio standar: `16:9` (hero), `4:3` (card), `1:1` (avatar)

### 20.3 Avatar & User Image
```
Ukuran    : 24px, 32px, 40px, 48px, 64px, 96px
Shape     : Circle (border-radius: 50%)
Fallback  : Inisial nama (1-2 huruf) dengan background warna aksen nuansa
Stack     : Maksimal 5 avatar bertumpuk, sisanya "+N"
```

---

## 21. WebGL, Three.js & Animation Experience

### 21.1 Filosofi
Animasi dan WebGL bukan dekorasi — mereka adalah **kepribadian yang bergerak**. Setiap nuansa memiliki "jiwa visual" yang diekspresikan melalui motion. Standar yang diacu adalah experience-first design seperti animejs.com — setiap animasi harus memiliki tujuan naratif, bukan sekadar keren.

### 21.2 Animation Stack Lengkap
```
Core Animation:
├── motion (Framer Motion v11)      → scroll-driven, layout, page transition
├── animejs                         → timeline kompleks, SVG path, presisi tinggi
└── @studio-freight/lenis           → smooth scroll premium di semua halaman

3D & WebGL:
├── @react-three/fiber              → React + Three.js
├── @react-three/drei               → helpers (Text, Environment, dll)
├── @react-three/postprocessing     → bloom, glitch, chromatic aberration
└── detect-gpu                      → deteksi kapabilitas GPU

Utility:
└── tsparticles                     → particle 2D ringan (fallback Three.js)
```

### 21.3 Strategi per Layer Halaman

```
Landing Page          → Full WebGL experience
                         Scroll-driven narrative
                         Cinematic text reveal
                         Particle / shader hero
                         Lenis: smooth, lerp 0.08 (sangat smooth)
                              ↓
Auth Page             → Signature animation nuansa
                         Subtle WebGL background (jika nuansa mendukung)
                         No scroll complexity
                         Lenis: smooth, lerp 0.1
                              ↓
Dashboard / App       → Micro-interaction + nuansa personality
                         WebGL hanya sebagai subtle background
                         Stagger list, layout animation
                         Lenis: lerp 0.12 (sedikit lebih responsif)
                              ↓
Form / Transaksi      → Zero WebGL
                         Hanya transition & loading state
                         Lenis: lerp 0.15 (paling responsif, feels native)
```

### 21.4 Lenis Configuration per Konteks
```typescript
// src/lib/lenis.ts
export const lenisConfig = {
  landing: {
    lerp: 0.08,        // sangat smooth, cinematic
    smoothWheel: true,
    wheelMultiplier: 0.8,
  },
  auth: {
    lerp: 0.1,
    smoothWheel: true,
    wheelMultiplier: 0.9,
  },
  dashboard: {
    lerp: 0.12,
    smoothWheel: true,
    wheelMultiplier: 1.0,
  },
  form: {
    lerp: 0.15,        // paling responsif, terasa native
    smoothWheel: true,
    wheelMultiplier: 1.1,
  },
} as const;
```

### 21.5 Landing Page: Scroll-Driven Narrative Pattern
Struktur landing page wajib mengikuti pola naratif ini:

```
Section 1 → Hero
            WebGL full-screen scene / particle
            Cinematic text reveal
            CTA muncul setelah animasi selesai

Section 2 → Feature Demo (Pinned)
            Satu section "terpaku" selama 3-4x scroll height
            Setiap scroll unit = reveal fitur baru
            Animasi mendemonstrasikan fungsi, bukan sekadar visual

Section 3 → Social Proof
            Stagger card masuk saat scroll
            Number counter animasi (0 → nilai aktual)

Section 4 → How It Works
            SVG path draw-on saat scroll
            Step masuk berurutan dengan connector line

Section 5 → CTA Final
            Parallax background
            Signature animation nuansa paling dramatis
            Full-width, immersive
```

### 21.6 Teknik Implementasi

#### Scroll-Driven dengan motion + lenis
```tsx
// src/views/sections/hero-section.tsx
"use client";
import { useScroll, useTransform, motion } from "motion/react";
import { useRef } from "react";

export const HeroSection = () => {
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start start", "end start"],
  });

  const opacity  = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  const scale    = useTransform(scrollYProgress, [0, 0.5], [1, 0.8]);
  const y        = useTransform(scrollYProgress, [0, 1], ["0%", "30%"]);

  return (
    <motion.section ref={ref} style={{ opacity, scale, y }}>
      {/* konten hero */}
    </motion.section>
  );
};
```

#### Cinematic Text Reveal
```tsx
// src/views/components/cinematic-text.tsx
"use client";
import { motion } from "motion/react";

const wordVariants = {
  hidden: { opacity: 0, y: 24, filter: "blur(8px)" },
  visible: (i: number) => ({
    opacity: 1, y: 0, filter: "blur(0px)",
    transition: { delay: i * 0.08, duration: 0.6, ease: [0.22, 1, 0.36, 1] },
  }),
};

export const CinematicText = ({ text }: { text: string }) => (
  <motion.h1 initial="hidden" animate="visible">
    {text.split(" ").map((word, i) => (
      <motion.span key={i} custom={i} variants={wordVariants}
        style={{ display: "inline-block", marginRight: "0.25em" }}>
        {word}
      </motion.span>
    ))}
  </motion.h1>
);
```

#### Three.js Canvas Background
```tsx
// src/views/sections/canvas-background.tsx
"use client";
import { Canvas } from "@react-three/fiber";
import { Suspense, lazy } from "react";
import { useGPUTier } from "detect-gpu";

const Scene = lazy(() => import("./scene"));

export const CanvasBackground = () => {
  const { tier } = useGPUTier();

  // Fallback CSS jika GPU tier rendah
  if (tier < 2) return <CSSFallbackBackground />;

  return (
    <Canvas
      style={{ position: "fixed", inset: 0, pointerEvents: "none", zIndex: 0 }}
      frameloop="demand"         // render hanya saat ada perubahan
      dpr={[1, 1.5]}             // max 1.5x pixel ratio
      camera={{ fov: 75, position: [0, 0, 5] }}
    >
      <Suspense fallback={null}>
        <Scene />
      </Suspense>
    </Canvas>
  );
};
```

#### Pinned Scroll Section
```tsx
// src/views/sections/feature-pin-section.tsx
"use client";
import { useScroll, useTransform, motion } from "motion/react";
import { useRef } from "react";

export const FeaturePinSection = ({ features }) => {
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({ target: ref });

  return (
    // height = 100vh * (jumlah fitur + 1) untuk scroll space
    <section ref={ref} style={{ height: `${(features.length + 1) * 100}vh` }}>
      <div style={{ position: "sticky", top: 0, height: "100vh" }}>
        {features.map((feature, i) => {
          const start = i / features.length;
          const end   = (i + 1) / features.length;
          const opacity = useTransform(scrollYProgress, [start, end], [0, 1]);
          return (
            <motion.div key={i} style={{ opacity, position: "absolute" }}>
              {feature.content}
            </motion.div>
          );
        })}
      </div>
    </section>
  );
};
```

### 21.7 WebGL per Nuansa di Landing Page

| Nuansa | Hero WebGL | Teknik | Post-processing |
|---|---|---|---|
| Modern | Gradient mesh halus | Custom GLSL shader | Subtle bloom |
| Cyberpunk | Particle grid neon + digital rain | Instanced mesh | Bloom + chromatic aberration + scanline |
| Steampunk | Gear 3D berputar + steam particle | Three.js mesh + particle | Sepia tone shader |
| Nature | Fluid wave simulation + daun gugur | Shader + particle | Soft bloom |
| Oldstyle | Ink spread simulation | Canvas 2D + shader | Grain overlay |
| Cowboy | Dust particle + parallax landscape | tsparticles + CSS parallax | Warm vignette |
| Japanese | Ink brush reveal + cherry blossom | SVG animation + particle | Film grain subtle |
| Retro | Rotating geometric 3D + halftone | Three.js + shader | Halftone + chromatic |

### 21.8 GPU Tier Strategy
```typescript
// detect-gpu → 3 tier
Tier 0-1 → Low end  : CSS animation only, no WebGL
Tier 2   → Mid      : tsparticles, simple Three.js, no postprocessing
Tier 3   → High end : Full WebGL + postprocessing
```

```tsx
// src/lib/use-animation-tier.ts
import { useGPUTier } from "detect-gpu";
import { useEffect, useState } from "react";

export type AnimationTier = "css" | "simple" | "full";

export const useAnimationTier = (): AnimationTier => {
  const { tier, isMobile } = useGPUTier();
  if (tier <= 1 || isMobile) return "css";
  if (tier === 2) return "simple";
  return "full";
};
```

### 21.9 Performance Rules (Wajib)
- **Lazy load** semua Three.js scene — dynamic import, tidak masuk main bundle
- **frameloop="demand"** — render hanya saat ada perubahan state/scroll
- **dpr max 1.5** — tidak perlu 2x pixel ratio untuk canvas background
- **dispose() wajib** — geometry, material, texture di-dispose saat unmount
- **Pause saat hidden** — gunakan `visibilitychange` event untuk pause render
- **Reduced motion** — jika `prefers-reduced-motion: reduce`, skip semua WebGL & animasi kompleks, ganti dengan fade sederhana
- **Canvas pointer-events: none** — canvas background tidak boleh memblokir klik UI

### 21.10 Bundle Strategy
```
main bundle      → zero Three.js, zero animejs
                   hanya motion (tree-shakeable)

landing chunk    → Three.js + animejs + lenis + postprocessing
                   lazy loaded saat landing page dibuka

dashboard chunk  → hanya motion + lenis
                   ringan, fungsional

// next.config.js
const config = {
  experimental: {
    optimizePackageImports: ["@react-three/fiber", "@react-three/drei"],
  },
};
```

### 21.11 Checklist WebGL sebelum Merge
- [ ] GPU tier detection aktif — fallback CSS tersedia
- [ ] `prefers-reduced-motion` dihormati — animasi dinonaktifkan
- [ ] `dispose()` dipanggil di cleanup useEffect
- [ ] `frameloop="demand"` aktif di semua Canvas
- [ ] `dpr` dibatasi maksimal `[1, 1.5]`
- [ ] Canvas menggunakan `pointerEvents: "none"`
- [ ] Lazy import untuk semua Three.js scene
- [ ] Test di mobile Tauri — minimum 30fps
- [ ] Bundle landing page terpisah dari main bundle
- [ ] Lenis dikonfigurasi sesuai konteks halaman

---

## 21. WebGL, Three.js & Animation Experience

### 21.1 Filosofi
Animasi dan WebGL adalah **bahasa visual aplikasi ini** — bukan dekorasi. Setiap efek harus:
- Memperkuat kepribadian nuansa yang aktif
- Memiliki tujuan naratif atau fungsional
- Berjalan mulus tanpa mengorbankan first load

Prinsip utama: **"Wow di landing, purposeful di dalam app."**

### 21.2 Strategi per Layer Halaman

| Layer | WebGL | Scroll | Animation Level |
|---|---|---|---|
| Landing Page | ✅ Full | Lenis + scroll-driven | Cinematic, wow factor |
| Auth Page | ⚠️ Subtle | Lenis | Signature nuansa |
| Dashboard | ⚠️ Background only | Lenis | Micro-interaction |
| Form & Transaksi | ❌ Tidak ada | Native scroll | Transition & feedback only |
| Error / 404 | ⚠️ Opsional | Native scroll | Playful, nuansa-appropriate |

### 21.3 Landing Page — Full Experience Stack

#### Scroll Engine
```typescript
// Lenis sebagai smooth scroll global di landing
// src/app/(landing)/layout.tsx
import Lenis from "@studio-freight/lenis";
import { useEffect } from "react";

useEffect(() => {
  const lenis = new Lenis({ lerp: 0.08, smoothWheel: true });
  const raf = (time: number) => { lenis.raf(time); requestAnimationFrame(raf); };
  requestAnimationFrame(raf);
  return () => lenis.destroy();
}, []);
```

#### Scroll-Driven Narrative Pattern
```
Section 1 — Hero         : WebGL canvas full viewport, text cinematic reveal
Section 2 — Pinned Demo  : Sticky 300vh, fitur terungkap satu per satu saat scroll
Section 3 — Feature Grid : Staggered card masuk dari bawah
Section 4 — Social Proof : Counter angka animate saat masuk viewport
Section 5 — CTA          : Subtle particle, strong typography
```

#### Cinematic Text Reveal
```typescript
// Split text per kata, stagger masuk dari bawah
// Library: motion
import { motion } from "motion/react";

const words = title.split(" ");
<motion.h1>
  {words.map((word, i) => (
    <motion.span
      key={i}
      initial={{ opacity: 0, y: 40 }}
      whileInView={{ opacity: 1, y: 0 }}
      transition={{ delay: i * 0.08, duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
      viewport={{ once: true }}
    >
      {word}{" "}
    </motion.span>
  ))}
</motion.h1>
```

#### Scroll-Pinned Feature Demo
```typescript
// Section terpaku selama 300vh scroll
// Setiap 100vh = satu fitur terungkap
import { useScroll, useTransform } from "motion/react";

const { scrollYProgress } = useScroll({ target: sectionRef });
const feature1Opacity = useTransform(scrollYProgress, [0, 0.33], [1, 0]);
const feature2Opacity = useTransform(scrollYProgress, [0.33, 0.66], [0, 1]);
const feature3Opacity = useTransform(scrollYProgress, [0.66, 1], [0, 1]);
```

### 21.4 WebGL Canvas — Hero Background

#### Setup Standar
```typescript
// src/views/sections/hero-canvas.tsx
// "use client" — wajib
import { Canvas } from "@react-three/fiber";
import { Suspense, lazy } from "react";

const Scene = lazy(() => import("./scene"));

<Canvas
  style={{ position: "absolute", inset: 0, pointerEvents: "none" }}
  camera={{ position: [0, 0, 5], fov: 75 }}
  frameloop="demand"        // render hanya saat ada perubahan
  dpr={[1, 1.5]}           // max pixel ratio 1.5 untuk performa
  gl={{ antialias: false }} // matikan antialiasing untuk performa
>
  <Suspense fallback={null}>
    <Scene />
  </Suspense>
</Canvas>
```

#### Scene per Nuansa
```
Modern     → Floating geometric planes, monochromatic, subtle
Cyberpunk  → Particle grid 3D, neon lines, reaktif terhadap cursor
Steampunk  → Gear mesh 3D berputar lambat, sepia tone
Nature     → Fluid wave simulation, hijau organik
Oldstyle   → Tidak ada WebGL — ink particle 2D via CSS
Cowboy     → Dust particle sistem, warm tone
Japanese   → Tidak ada WebGL — sakura petal via CSS (filosofi ma)
Retro      → Rotating geometric shapes, bold color, halftone shader
```

#### Cursor Reactive Particle (Cyberpunk)
```typescript
// Particle bereaksi terhadap posisi mouse
import { useFrame, useThree } from "@react-three/fiber";

useFrame(({ mouse, clock }) => {
  // particle bergerak menuju posisi mouse dengan lerp
  meshRef.current.position.x += (mouse.x * 2 - meshRef.current.position.x) * 0.05;
  meshRef.current.position.y += (mouse.y * 2 - meshRef.current.position.y) * 0.05;
});
```

### 21.5 Post-Processing Effects per Nuansa

```typescript
import { EffectComposer, Bloom, ChromaticAberration, Glitch, Noise } from "@react-three/postprocessing";

// Cyberpunk
<EffectComposer>
  <Bloom luminanceThreshold={0.2} intensity={1.5} />
  <ChromaticAberration offset={[0.002, 0.002]} />
  <Glitch delay={[5, 10]} strength={[0.1, 0.2]} /> {/* occasional */}
</EffectComposer>

// Nature
<EffectComposer>
  <Bloom luminanceThreshold={0.4} intensity={0.8} />
  <Noise opacity={0.02} />
</EffectComposer>

// Modern
<EffectComposer>
  <Bloom luminanceThreshold={0.8} intensity={0.3} /> {/* sangat subtle */}
</EffectComposer>
```

### 21.6 SVG Path Animation (Logo & Ilustrasi)

```typescript
// Draw-on effect untuk logo atau ilustrasi SVG
import { motion } from "motion/react";

<motion.path
  d={pathData}
  initial={{ pathLength: 0, opacity: 0 }}
  animate={{ pathLength: 1, opacity: 1 }}
  transition={{ duration: 1.5, ease: "easeInOut" }}
  stroke={colorAccent}
  strokeWidth={2}
  fill="none"
/>
```

### 21.7 Smooth Scroll Strategy

```
Landing Page    → Lenis (lerp: 0.08, smoothWheel: true)
Auth Page       → Lenis (lerp: 0.1)
Dashboard       → Lenis (lerp: 0.12, lebih responsif)
Form/Transaksi  → Native scroll (tidak ada Lenis)
                  Alasan: form membutuhkan scroll yang presisi
                  dan predictable untuk accessibility
```

```typescript
// src/lib/lenis-provider.tsx
// Deteksi otomatis halaman form → skip Lenis
const isFormPage = pathname.includes("/checkout") ||
                   pathname.includes("/payment") ||
                   pathname.includes("/form");

if (isFormPage) return children; // native scroll
// else: init Lenis
```

### 21.8 Performance Rules (Wajib)

```
1. Lazy load semua scene Three.js
   → dynamic import, tidak masuk bundle utama
   → pisahkan chunk: next.config.js splitChunks

2. Detect GPU tier sebelum render WebGL
   → import { getGPUTier } from "detect-gpu"
   → tier 0-1 → skip WebGL, gunakan CSS fallback
   → tier 2+ → render WebGL

3. Pause rendering saat tab tidak aktif
   → document.addEventListener("visibilitychange")
   → frameloop="demand" + invalidate() manual

4. Dispose semua resource saat unmount
   → geometry.dispose(), material.dispose(), texture.dispose()
   → useEffect cleanup wajib

5. Limit draw calls
   → Gunakan InstancedMesh untuk objek berulang
   → Merge geometri statis

6. Texture compression
   → Format .ktx2 dengan Basis compression
   → Gunakan useKTX2 dari @react-three/drei

7. Mobile fallback
   → Deteksi via navigator.hardwareConcurrency < 4
   → atau screen.width < 768
   → Render CSS animation sebagai pengganti WebGL
```

### 21.9 Animation Timeline untuk Landing Page

```
0ms      → Lenis init, canvas mount
0-300ms  → Hero canvas fade in (WebGL scene)
300ms    → Cinematic text reveal mulai (word by word)
800ms    → CTA button muncul (scale + fade)
1000ms   → Scroll indicator muncul (bounce)

--- User mulai scroll ---

scroll 0-33%   → Pinned section: fitur 1 terungkap
scroll 33-66%  → Pinned section: fitur 2 terungkap
scroll 66-100% → Pinned section: fitur 3 terungkap

--- Unpin, scroll lanjut ---

viewport enter → Card grid stagger (50ms per card)
viewport enter → Counter angka animate (0 → nilai aktual, 1.5 detik)
viewport enter → Social proof slide in dari kiri
viewport enter → CTA final: particle burst + strong typography
```

### 21.10 Accessibility & Reduced Motion

```typescript
// Wajib di semua komponen animasi
import { useReducedMotion } from "motion/react";

const prefersReducedMotion = useReducedMotion();

// Jika reduced motion aktif:
// → Skip semua WebGL
// → Skip scroll-driven animation
// → Hanya tampilkan static version dengan fade sederhana
// → Lenis diganti native scroll

const transition = prefersReducedMotion
  ? { duration: 0 }
  : { duration: 0.5, ease: [0.22, 1, 0.36, 1] };
```

### 21.11 Bundle Strategy untuk Animation Stack

```javascript
// next.config.js
module.exports = {
  experimental: {
    optimizePackageImports: [
      "@react-three/fiber",
      "@react-three/drei",
      "motion",
      "animejs",
    ],
  },
};

// Lazy import per halaman:
// Landing  → load semua (three, lenis, motion, animejs)
// Auth     → load motion saja
// App      → load motion saja
// Form     → tidak load library animasi berat
```

---

## 22. Checklist Final Design System

### 22.1 Sebelum Launch
- [ ] Semua 8 nuansa diimplementasikan dengan token lengkap
- [ ] Light & dark mode berfungsi di semua nuansa
- [ ] i18n ID & EN berfungsi di semua halaman
- [ ] WebGL fallback tersedia untuk GPU tier rendah & mobile
- [ ] `prefers-reduced-motion` dihormati di semua animasi
- [ ] WCAG AA lolos di semua kombinasi nuansa + tema
- [ ] Bundle Three.js tidak masuk halaman selain landing
- [ ] Lenis dinonaktifkan di halaman form & transaksi
- [ ] Semua ikon menggunakan Fluent Icons
- [ ] Semua font dari CDNFonts
- [ ] Tidak ada hardcoded warna/font/spacing di komponen
- [ ] Z-index hanya menggunakan nilai dari token `zIndex`
- [ ] Chart menggunakan palet warna yang sesuai nuansa
- [ ] Empty state tersedia di semua list & tabel
- [ ] Semua komponen interaktif punya visible focus indicator
- [ ] Onboarding flow berfungsi di web (Netlify) & desktop/mobile (Tauri)
- [ ] Onboarding preferensi sync ke DB setelah user login
- [ ] Nuansa switcher accessible via keyboard (Tab + Enter)
- [ ] Command palette (Ctrl+K) terdaftar semua nuansa & perintah
- [ ] Transisi ganti nuansa 300ms berfungsi & di-skip jika `prefers-reduced-motion` aktif
- [ ] Preferensi nuansa persist di localStorage (web) & tauri-plugin-store (Tauri)

### 22.2 Per Nuansa Baru
- [ ] Token lengkap (warna, font, radius, shadow, animasi)
- [ ] Dark mode palet (bukan inversi — palet baru)
- [ ] Signature animation terdefinisi
- [ ] Voice & tone terdokumentasi
- [ ] Chart color palette (8 warna)
- [ ] Illustration style terdefinisi
- [ ] WebGL scene atau CSS fallback tersedia
- [ ] Kontras WCAG AA lolos

---

## 23. Onboarding Flow

### 23.1 Filosofi
Gunakan prinsip **progressive disclosure** — tanya hanya yang paling berdampak visual terlebih dahulu. Sisanya dapat diubah kapan saja di Settings. Jangan overwhelm pengguna baru dengan terlalu banyak pilihan sekaligus.

### 23.2 Urutan Onboarding
```
Step 1 → Pilih Bahasa
         (fundamental — mempengaruhi semua teks di step berikutnya)
              ↓
Step 2 → Pilih Nuansa
         (paling "wow" — kesan pertama terkuat)
              ↓
Step 3 → Pilih Tema Light / Dark / System
         (refinement kenyamanan, bukan identitas)
              ↓
         Selesai → Masuk aplikasi
```

### 23.3 Skip Policy
| Step | Bisa Di-skip? | Default jika Skip |
|---|---|---|
| Bahasa | ❌ Tidak | — (wajib dipilih) |
| Nuansa | ✅ Ya | Modern |
| Tema | ✅ Ya | System |

### 23.4 Penyimpanan Preferensi
```
Sebelum login:
→ Zustand store + persist middleware
→ Web: localStorage
→ Tauri: tauri-plugin-store

Setelah login:
→ Sync ke database (kolom `preferences` jsonb di tabel `users`)
→ Format: { lang: "id", vibe: "cyberpunk", theme: "dark" }

Logout:
→ Preferensi tetap ada di device (tidak dihapus)
→ Saat login ulang: preferences DB menang atas preferences lokal
```

### 23.5 Desain Tiap Step

**Step 1 — Bahasa:**
```
Layout    : Centered, minimal, full viewport
Konten    : 2 pilihan besar (ID & EN), tidak ada teks lain
Animation : Fade in, pilihan slide up stagger
UX note   : Pilihan langsung apply — teks step itu sendiri
            langsung berubah bahasa saat dipilih
```

**Step 2 — Nuansa:**
```
Layout    : Grid 4x2, card preview live
Konten    : 8 card nuansa dengan preview warna + font aktual
Animation : Card stagger masuk, selected card scale up
UX note   : Background halaman onboarding langsung
            berubah ke nuansa yang di-hover (preview real-time)
            Confirmed saat diklik
```

**Step 3 — Tema:**
```
Layout    : 3 pilihan horizontal (Light / Dark / System)
Konten    : Ilustrasi sederhana per pilihan
Animation : Crossfade background saat pilihan berubah
UX note   : System = ikon monitor dengan separuh light/dark
```

### 23.6 Progress Indicator
```
○ ● ○   (3 dots, bukan angka, bukan progress bar)
Posisi   : Bottom center, tidak mengganggu konten utama
```

### 23.7 Implementasi
```typescript
// src/controllers/use-onboarding.ts
import { create } from "zustand";
import { persist } from "zustand/middleware";

interface OnboardingStore {
  completed: boolean;
  step: 1 | 2 | 3;
  preferences: {
    lang: "id" | "en" | null;
    vibe: VibeKey | null;
    theme: "light" | "dark" | "system" | null;
  };
  setStep: (step: 1 | 2 | 3) => void;
  setPreference: (key: string, value: string) => void;
  complete: () => void;
}
```

---

## 24. Nuansa Switcher UI

### 24.1 Filosofi
Nuansa switcher harus **discoverable tapi tidak mengganggu**. Dua titik akses: Settings Page untuk semua pengguna, Command Palette untuk power user.

### 24.2 Titik Akses

| Akses | Cara | Target Pengguna |
|---|---|---|
| Settings Page | `/settings/appearance` | Semua pengguna |
| Command Palette | `Ctrl+K` → ketik nuansa | Power user |

```
❌ Floating button   → mengganggu konten
❌ Dropdown navbar   → terlalu ramai di navbar
❌ Hanya di settings → tidak discoverable
✅ Settings + Cmd+K  → balance antara akses & kebersihan UI
```

### 24.3 Layout Settings Appearance
```
┌─────────────────────────────────────────────┐
│  Tampilan / Appearance                      │
│                                             │
│  Nuansa                                     │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌──────┐ │
│  │preview │ │preview │ │preview │ │ ...  │ │
│  │ Modern │ │ Cyber  │ │ Steam  │ │      │ │
│  └────────┘ └────────┘ └────────┘ └──────┘ │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌──────┐ │
│  │preview │ │preview │ │preview │ │ ...  │ │
│  │ Nature │ │Oldstyle│ │ Cowboy │ │      │ │
│  └────────┘ └────────┘ └────────┘ └──────┘ │
│                                             │
│  Tema                   Bahasa              │
│  ◉ Light    ○ Dark      ◉ Indonesia         │
│  ○ System               ○ English           │
│                                             │
└─────────────────────────────────────────────┘
```

### 24.4 Card Nuansa — Live Preview
Setiap card adalah **live preview aktual** — bukan sekadar label atau warna solid:

```
Card size    : 120x80px
Konten card  :
  - Background: colorSurface nuansa tersebut
  - Strip atas: colorPrimary nuansa
  - Teks nama : fontDisplay nuansa (ukuran 10px)
  - Dot aksen : colorAccent nuansa
  - Border    : 2px solid jika selected, 1px neutral jika tidak
  - Hover     : scale(1.04), shadow medium, 150ms ease
  - Selected  : border colorAccent, checkmark overlay
```

### 24.5 Transisi Ganti Nuansa
```
Bukan: hard switch (jarring)
Bukan: full page reload

Tapi: crossfade 300ms via CSS custom properties
```

```typescript
// src/lib/apply-vibe.ts
export const applyVibe = (vibe: VibeKey, theme: ThemeKey) => {
  const tokens = mergeVibeTheme(vibe, theme);

  // Enable transition
  document.documentElement.style.transition = [
    "background-color 300ms ease",
    "color 300ms ease",
    "border-color 300ms ease",
  ].join(", ");

  // Apply semua token
  Object.entries(tokens).forEach(([key, value]) => {
    document.documentElement.style.setProperty(`--${key}`, String(value));
  });

  // Hapus transition setelah selesai
  setTimeout(() => {
    document.documentElement.style.transition = "";
  }, 300);
};
```

### 24.6 Command Palette
Library: **`cmdk`** — ringan, accessible, keyboard-first.

```
Trigger   : Ctrl+K (Windows/Linux), ⌘+K (macOS)
Posisi    : Center modal, backdrop blur
Contoh perintah yang didukung:

> cyberpunk          → ganti nuansa ke Cyberpunk
> dark mode          → ganti tema ke Dark
> bahasa inggris     → ganti bahasa ke English
> modern light       → ganti nuansa Modern + tema Light sekaligus
> appearance         → buka /settings/appearance
```

```typescript
// src/controllers/use-command-palette.ts
// Daftarkan semua vibe sebagai command
const vibeCommands = Object.keys(vibes).map((vibe) => ({
  id: `vibe-${vibe}`,
  label: `Nuansa: ${vibe}`,
  keywords: [vibe, "nuansa", "tema", "vibe", "appearance"],
  perform: () => applyVibe(vibe as VibeKey, currentTheme),
}));
```

### 24.7 Persistensi setelah Ganti Nuansa
```
1. applyVibe() → CSS custom properties berubah (instant visual)
2. useVibeStore.setState({ vibe }) → Zustand update
3. Zustand persist → localStorage / tauri-plugin-store
4. Jika user sudah login → debounce 1 detik → sync ke DB
```

### 24.8 Aksesibilitas Switcher
- Semua card nuansa navigable via keyboard (Tab + Enter)
- Command palette fully keyboard-driven
- Screen reader: setiap card punya `aria-label="Nuansa Modern, saat ini dipilih"`
- Transisi 300ms dihormati `prefers-reduced-motion` → skip transition jika aktif
