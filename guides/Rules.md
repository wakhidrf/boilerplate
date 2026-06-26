# Sistem Skoring Kepatuhan AI (Compliance Scoring)

Sistem ini digunakan untuk mengevaluasi apakah sebuah **Plan** (sebelum eksekusi) atau **Kode** (sesudah eksekusi) memenuhi standar SOP dan Design yang telah ditetapkan.

### Mode Skoring:
1.  **Pre-execution (Plan Evaluation)**: Mengevaluasi niat, pemilihan library, dan struktur yang direncanakan. Fokus pada arsitektur.
2.  **Post-execution (Code Evaluation)**: Mengevaluasi implementasi nyata, kebersihan kode, dan detail fungsional.

# Rules.md — AI Planning Compliance & Scoring System

> **Tujuan Dokumen**: Mencegah AI menghasilkan plan atau output yang menyimpang dari `SOP.md` dan `Design.md`. Sebelum mengeksekusi atau menyetujui plan apapun, AI **wajib** menjalankan skoring ini dan melaporkan hasilnya kepada User.
>
> **Berlaku untuk**: Proyek baru, refaktor sebagian, dan refaktor total.
>
> **Status dokumen ini**: Turunan dari `SOP.md` dan `Design.md`. Jika keduanya diperbarui, Rules.md ikut diperbarui.

---

## Cara Kerja Sistem Skoring

Sebelum menyusun plan implementasi, AI **wajib**:

1. Membaca `SOP.md` dan `Design.md` secara penuh (atau ringkasan terakhir di `guides/memory/summary/`).
2. Menjalankan **5 Kategori Evaluasi** di bawah ini terhadap plan yang akan disusun.
3. Menghitung skor total dan menentukan **Verdict**.
4. Melaporkan hasil skoring kepada User **sebelum** menulis kode apapun.

AI **dilarang** melewati tahap ini dengan alasan apapun, termasuk "sudah jelas", "sederhana", atau "hanya perubahan kecil".

---

## Kategori Evaluasi & Bobot

| # | Kategori | Bobot Maksimal |
|---|---|---|
| A | Struktur MVC & Layer Separation | 20 poin |
| B | Naming Convention & File Structure | 15 poin |
| C | UI/UX Stack & Design System | 30 poin |
| D | State Management & Routing | 10 poin |
| E | Security, Performance & Code Quality | 25 poin |
| | **Total** | **100 poin** |

---

## A — Struktur MVC & Layer Separation (20 poin)

Evaluasi apakah plan menempatkan logika di layer yang benar sesuai SOP 1.1 dan 1.6.

### A1. Model Layer (7 poin)

| Skor | Kondisi |
|---|---|
| **7** | Skema data (`drizzle`) dan validasi (`valibot`) ada di `src/models/`. Satu file per entitas. Tidak ada logika bisnis di sini. |
| **7** | Model ada tapi satu file berisi lebih dari satu entitas, atau ada sedikit logika bisnis yang seharusnya di controller. |
| **4** | Model dan controller tercampur, atau validasi dilakukan di luar `src/models/`. |
| **0** | Tidak ada pemisahan model. Logika bisnis dan skema data ada di satu tempat (misalnya langsung di route handler). |

**Larangan keras (langsung 0 untuk A1)**:
- Akses database dari komponen View
- Koneksi DB (`db` instance) diimpor dari `@/models/db` di Client Components — wajib dari `@/models/client` di server
- Validasi input tanpa `valibot` schema

### A2. Controller Layer (7 poin)

| Skor | Kondisi |
|---|---|
| **7** | Server Actions menggunakan `next-safe-action`. Hooks kustom ada di `src/controllers/`. State management (`nuqs`, `zustand`) dipanggil dari controller, bukan langsung di View. |
| **7** | Sebagian besar benar, tapi ada 1-2 kasus logika bisnis yang bocor ke View atau Route handler. |
| **4** | Controller ada tapi tidak menggunakan `next-safe-action` untuk mutasi, atau animasi logic (`motion`, `animejs`) ada di View. |
| **0** | Tidak ada controller layer. Semua logika ada di View atau Route handler. |

**Larangan keras (langsung 0 untuk A2)**:
- Mutasi data tanpa `next-safe-action`
- Hook kustom ditempatkan di `src/views/`
- Animation logic (`motion`, `animejs`) ada di file yang sama dengan komponen presentational

### A3. View Layer (6 poin)

| Skor | Kondisi |
|---|---|
| **6** | `src/views/` hanya berisi komponen UI. Menerima data via props. Tidak ada `fetch()`, tidak ada akses DB, tidak ada logika bisnis. Section-based di `src/views/sections/`. |
| **7** | View sebagian besar bersih, tapi ada 1-2 `fetch()` langsung atau sedikit logika kondisional bisnis. |
| **4** | View melakukan pengambilan data langsung tapi tidak akses DB. Logika bisnis ringan ada di komponen. |
| **0** | View mengakses database, atau terdapat logika bisnis kompleks di dalam komponen presentational. |

**Larangan keras (langsung 0 untuk A3)**:
- `import { db } from "@/models/client"` di file dalam `src/views/`
- Server Action definition di dalam file View
- Data fetching dengan raw SQL di komponen

---

## B — Naming Convention & File Structure (15 poin)

Evaluasi apakah plan mengikuti standar penamaan SOP 1.3 dan 1.4.

### B1. Kebab-case Konsistensi (10 poin)

| Skor | Kondisi |
|---|---|
| **10** | Semua file dan folder menggunakan `kebab-case` tanpa pengecualian. Termasuk: komponen, hooks, utils, lib, types, constants. |
| **7** | 90%+ menggunakan kebab-case. Ada 1-2 file yang masih PascalCase atau camelCase (misalnya komponen React). |
| **3** | Campur aduk: sebagian kebab-case, sebagian PascalCase atau camelCase. |
| **0** | Menggunakan PascalCase atau camelCase secara dominan. |

**Contoh benar**: `hero-section.tsx`, `use-mortgage.ts`, `api-keys.ts`, `auth-callback.ts`  
**Contoh salah**: `HeroSection.tsx`, `useMortgage.ts`, `ApiKeys.ts`, `authCallback.ts`

### B2. Larangan Index Files & Barrel Exports (8 poin)

| Skor | Kondisi |
|---|---|
| **8** | Tidak ada satupun file bernama `index.ts` atau `index.tsx`. Tidak ada barrel file. Setiap file punya nama deskriptif. |
| **4** | Ada 1-2 `index.ts` yang dipakai untuk re-export (barrel file), tapi bukan entry point utama. |
| **0** | Menggunakan `index.ts`/`index.tsx` sebagai konvensi utama, atau barrel file tersebar di banyak folder. |

**Contoh benar**: `database.ts`, `auth-service.ts`, `format-currency.ts`  
**Contoh salah**: `index.ts` (sebagai barrel), `index.tsx` (sebagai komponen entry)

### B3. Path Aliases (5 poin)

| Skor | Kondisi |
|---|---|
| **5** | Semua import menggunakan alias `@/` yang mengarah ke `src/`. Tidak ada relative path yang kompleks (lebih dari 1 level `../`). |
| **4** | Sebagian besar menggunakan `@/`, tapi ada beberapa `../` yang masih tersisa. |
| **0** | Menggunakan relative path kompleks seperti `../../../../controllers/` atau tidak menggunakan alias sama sekali. |

---

## C — UI/UX Stack & Design System (30 poin)

Evaluasi apakah plan menggunakan stack UI/UX yang benar sesuai SOP dan seluruh `Design.md`.

### C1. Fluent UI sebagai Satu-satunya Design System (10 poin)

| Skor | Kondisi |
|---|---|
| **10** | Semua komponen UI menggunakan `@fluentui/react-components`. Semua ikon dari `@fluentui/react-icons`. Tidak ada Tailwind CSS, tidak ada `shadcn/ui`, tidak ada komponen HTML mentah tanpa Fluent UI styling. |
| **7** | Mayoritas Fluent UI, tapi ada komponen kecil yang menggunakan HTML mentah dengan inline style (bukan Tailwind). |
| **3** | Mencampur Fluent UI dengan library lain (misalnya shadcn/ui atau Radix UI langsung). |
| **0** | Menggunakan Tailwind CSS, `shadcn/ui`, atau library UI non-Fluent sebagai fondasi. |

**Larangan keras (langsung 0 untuk C1)**:
- `import { Button } from "shadcn/ui"` atau package shadcn apapun
- Menggunakan class Tailwind (`className="flex items-center"`)
- `<GoogleLogin />` dari library Google — wajib Fluent UI Button + `useGoogleLogin()`
- Komponen di `error.tsx` dan `not-found.tsx` yang tidak menggunakan Fluent UI

### C2. Token System & Design Tokens (5 poin)

| Skor | Kondisi |
|---|---|
| **5** | Semua nilai warna, font, spacing, radius, shadow menggunakan token dari `src/styles/tokens/`. Tidak ada hardcoded value di komponen. Styling menggunakan `makeStyles` dari Fluent UI. |
| **5** | Sebagian besar dari token, tapi ada 1-3 hardcoded value (misalnya `color: "#3B82F6"` langsung di komponen). |
| **2** | Banyak hardcoded value. Token system ada tapi tidak dipakai konsisten. |
| **0** | Tidak ada token system. Semua value hardcoded langsung di komponen. |

**Larangan keras (langsung 0 untuk C2)**:
- Warna hardcoded di komponen: `style={{ color: "#FF0000" }}`
- Font hardcoded: `fontFamily: "Inter, sans-serif"` di luar token
- Z-index diluar skala token (tidak boleh `zIndex: 9999`)

### C3. Animation & WebGL Compliance (5 poin)

| Skor | Kondisi |
|---|---|
| **5** | Library animasi sesuai stack yang diizinkan (`motion/react`, `animejs`, `lenis`). Import dari `motion/react` bukan `framer-motion`. Three.js di-lazy load. `prefers-reduced-motion` dihormati. GPU detection aktif sebelum WebGL. |
| **5** | Stack animasi benar, tapi ada 1 pelanggaran minor (misal: lupa `frameloop="demand"` pada Canvas, atau lupa dispose geometry). |
| **2** | Menggunakan library animasi yang tidak diizinkan, atau Three.js masuk main bundle tanpa lazy load. |
| **0** | Menggunakan `framer-motion` (bukan `motion/react`), atau WebGL tanpa GPU detection, atau animasi `width`/`height`/`top`/`left` (bukan `transform`/`opacity`). |

**Larangan keras (langsung 0 untuk C3)**:
- `import { motion } from "framer-motion"` — wajib dari `motion/react`
- Three.js, `animejs` masuk main bundle (bukan lazy import)
- WebGL tanpa fallback CSS untuk GPU tier rendah
- Lenis aktif di halaman form/checkout/payment
- Animasi properti selain `transform` dan `opacity`
- Tidak ada `useReducedMotion()` di komponen animasi

### C4. Design Quality & Accessibility (10 poin)

| Skor | Kondisi |
|---|---|
| **10** | Memenuhi WCAG AA (kontras, focus indicator). Ada desain *empty state*. Voice & Tone sesuai nuansa. |
| **5** | Visual bagus tapi aksesibilitas kurang (misal: kontras rendah atau tidak ada focus indicator). |
| **0** | Tidak ada empty state, melanggar standar aksesibilitas dasar, atau tone bahasa asal-asalan. |

---

## D — State Management & Routing (10 poin)

Evaluasi apakah plan menggunakan state management yang tepat sesuai SOP 1.2 dan 3.4.

### D1. Pemilihan State Manager (6 poin)

| Skor | Kondisi |
|---|---|
| **6** | `nuqs` digunakan untuk filter, pagination, sort, search query (shareable/URL state). `zustand` digunakan untuk modal, sidebar, toast, form draft, auth session (local UI state). Tidak ada percampuran. |
| **3** | Sebagian besar benar, tapi ada 1-2 kasus state yang salah penempatan (misal: filter disimpan di zustand, atau modal state di URL). |
| **0** | `nuqs` dan `zustand` digunakan secara acak tanpa aturan, atau menggunakan `useState` global yang tidak perlu, atau filter/pagination tidak menggunakan `nuqs`. |

### D2. Routing Layer vs Controller Layer (4 poin)

| Skor | Kondisi |
|---|---|
| **4** | `src/app/api/` hanya berisi routing dan pemanggilan controller. Logika bisnis inti ada di `src/controllers/api/`. |
| **2** | Ada logika bisnis ringan di route handler tapi tidak kritis. |
| **0** | Seluruh logika bisnis ada di route handler (`src/app/api/`), tidak ada pemisahan ke controller. |

---

## E — Security, Performance & Code Quality (25 poin)

### E1. Security Essentials (20 poin) — [BLOCKING CATEGORY]

| Skor | Kondisi |
|---|---|
| **20** | `next-safe-action` di semua mutasi + CSRF middleware. DOMPurify di client. Rate limiting aktif. Xendit webhook signature verified. |
| **10** | Keamanan dasar ada, tapi ada celah minor (misal: rate limiting kurang ketat). |
| **0** | **CRITICAL FAILURE**: Tidak ada validasi server-side, mutasi tanpa `next-safe-action`, atau webhook tanpa verifikasi. |

*Catatan: Skor 0 di E1 otomatis membuahkan verdict REJECT meskipun total skor tinggi.*

### E2. Performance & Code Quality (5 poin)

| Skor | Kondisi |
|---|---|
| **5** | Skeleton screen menggunakan `@fluentui/react-components`. Error boundary di `error.tsx`. `not-found.tsx` ada. Soft limit 200 baris per file dipatuhi (atau ada alasan valid). Koneksi DB via PgBouncer. |
| **3** | Sebagian besar ada, tapi ada 1-2 file yang jelas melebihi 200 baris tanpa alasan valid, atau skeleton tidak dari Fluent UI. |
| **0** | Tidak ada skeleton screen, atau menggunakan `shadcn/ui Skeleton`, atau koneksi DB langsung tanpa PgBouncer, atau file `error.tsx` tidak menggunakan Fluent UI. |

---

## Verdict & Tindakan

| Total Skor | Verdict | Tindakan AI |
|---|---|---|
| **90–100** | ✅ **APPROVED** | Lanjutkan eksekusi plan. Catat skor di memory log. |
| **75–89** | ⚠️ **CONDITIONAL** | Lanjutkan dengan catatan. Sebutkan poin yang kurang dan komitmen perbaikan. Catat di log. |
| **50–74** | 🔄 **REVISE** | Hentikan. Revisi plan dulu sebelum eksekusi. Buat draf revisi dan minta persetujuan User. |
| **< 50** | 🚫 **REJECT** | Tolak plan. Jelaskan bagian yang melanggar SOP/Design dan susun ulang plan dari awal. |

**Kondisi Khusus**: Jika Skor E1 (Security) adalah **0**, verdict otomatis menjadi **REJECT**.

---

## Format Laporan Skoring

Setiap kali AI menyusun plan, wajib menyertakan laporan ini **sebelum** menulis kode:

```markdown
## 📊 Compliance Score — [Nama Fitur/Refaktor]

| Kategori | Skor | Maks | Catatan |
|---|---|---|---|
| A1. Model Layer | X | 7 | ... |
| A2. Controller Layer | X | 7 | ... |
| A3. View Layer | X | 6 | ... |
| B1. Kebab-case | X | 5 | ... |
| B2. No Index Files | X | 5 | ... |
| B3. Path Aliases | X | 5 | ... |
| C1. Fluent UI Only | X | 10 | ... |
| C2. Token System | X | 5 | ... |
| C3. Animation Compliance | X | 5 | ... |
| C4. Design Quality | X | 10 | ... |
| D1. State Manager | X | 6 | ... |
| D2. Routing vs Controller | X | 4 | ... |
| E1. Security | X | 20 | ... |
| E2. Performance & Quality | X | 5 | ... |
| **TOTAL** | **XX** | **100** | |

**Verdict**: [APPROVED / CONDITIONAL / REVISE / REJECT]

**Pelanggaran Kritis** (jika ada):
- ...

**Catatan untuk User**:
- ...
```

---

## Trigger Otomatis

Sistem skoring ini **wajib dijalankan** pada kondisi berikut:

1. User meminta plan untuk fitur baru (proyek baru maupun tambahan fitur).
2. User meminta refaktor file, folder, atau arsitektur.
3. AI hendak membuat komponen UI baru.
4. AI hendak membuat route, controller, atau model baru.
5. AI hendak menggunakan library apapun (pastikan ada di stack yang diizinkan).
6. AI diminta membuat `Plan.md` baru atau memperbarui plan yang ada.

---

## Referensi Cepat: Stack yang Diizinkan

### ✅ Library yang Diizinkan

| Kategori | Library |
|---|---|
| UI / Design System | `@fluentui/react-components`, `@fluentui/react-icons` |
| Styling | Fluent UI `makeStyles` — **bukan Tailwind, bukan shadcn** |
| Form Validation | `valibot` |
| Server Actions | `next-safe-action` |
| URL State | `nuqs` |
| UI State | `zustand` |
| Data Fetching | `swr`, `axios` |
| ORM / DB | `drizzle-orm`, Aiven PostgreSQL via PgBouncer |
| Animation (core) | `motion/react` (v12+) — **bukan `framer-motion`** |
| Animation (timeline) | `animejs` |
| Smooth Scroll | `lenis` |
| 3D / WebGL | `@react-three/fiber`, `@react-three/drei`, `@react-three/postprocessing` |
| GPU Detection | `detect-gpu` |
| Particles (2D) | `tsparticles` |
| Command Palette | `cmdk` |
| Auth | `@react-oauth/google` + Fluent UI Button |
| Payment | Xendit (server-only) |
| Rate Limiting | `@upstash/ratelimit` |
| Sanitasi Client | `DOMPurify` |
| i18n | `next-intl` |
| Charts | `recharts` |
| Testing | `playwright` |
| Linting | `biome` |
| Desktop/Mobile | Tauri (`tauri-plugin-deep-link`, `tauri-plugin-store`) |

### 🚫 Library yang Dilarang

| Library | Alasan |
|---|---|
| `tailwindcss` | CSS specificity conflict dengan Fluent UI |
| `shadcn/ui` | Berbasis Tailwind, tidak compatible |
| `framer-motion` | Wajib gunakan `motion/react` |
| `<GoogleLogin />` | Wajib Fluent UI Button + `useGoogleLogin()` |
| `index.ts` / `index.tsx` | Barrel file dilarang keras |
| Relative path `../../..` | Wajib gunakan alias `@/` |
| Koneksi DB direct (tanpa PgBouncer) | Wajib via PgBouncer |
| `localStorage` untuk token (Tauri) | Wajib `tauri-plugin-store` |

---

## Aturan Tambahan untuk Plan Refaktor

Saat merefaktor proyek yang **sudah ada**, AI wajib:

1. **Inventarisasi Dulu**: Petakan file yang ada sebelum menulis plan. Identifikasi pelanggaran SOP/Design yang sudah terjadi.
2. **Migrasi Bertahap** (SOP 1.5): Ikuti urutan: Model → Controller → View → Routing. Jangan refaktor semuanya sekaligus.
3. **Tidak Overwrite SOP**: Jika `Plan.md` lama bertentangan dengan SOP.md, `Plan.md` yang diperbarui (SOP adalah Single Source of Truth).
4. **Memory Log Wajib**: Setiap sesi refaktor wajib menghasilkan log di `guides/memory/active/`.
5. **Skor di Setiap PR**: Setiap batch perubahan yang signifikan wajib ada laporan skor sebelum dieksekusi.

---

## Mekanisme "Override dengan Alasan"

Jika AI merasa perlu melanggar aturan (misal: file > 200 baris demi kohesi schema), AI wajib mencantumkan alasan di kolom "Catatan" pada Laporan Skoring. Jika User menyetujui, skor untuk poin tersebut dianggap penuh (Override Approved).

---

## Fast Path Reporting (Minor Changes)

Untuk perubahan kecil (perbaikan typo, update teks, perubahan warna minor), AI tidak perlu tabel lengkap. Gunakan format singkat:
`[FAST PATH] Compliance: PASSED (Security & SOP Checked)`

---

## Catatan Maintenance Rules.md

Dokumen ini adalah **turunan langsung** dari `SOP.md` dan `Design.md`. Prosedur perubahan mengikuti ketentuan yang sama:

1. Identifikasi bagian yang perlu diperbarui.
2. Konsultasikan alasan perubahan dan buat draf perbandingan.
3. Tunggu persetujuan eksplisit User ("OK" atau sejenisnya).
4. Merge — jangan overwrite total.
