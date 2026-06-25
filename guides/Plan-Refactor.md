# Plan: Refaktor [Nama Proyek]

> **Dokumen ini adalah rencana kerja spesifik proyek.**
> Mengacu pada `SOP.md` dan `Design.md` sebagai Single Source of Truth.
> Setiap langkah yang selesai ditandai `[x]`. Setiap konflik dengan SOP → update Plan, bukan SOP.
>
> **Dibuat**: YYYY-MM-DD
> **Terakhir diperbarui**: YYYY-MM-DD
> **Eksekutor**: [Nama Developer / Nama Agen AI]

---

## 0. Konteks Proyek

### 0.1 Deskripsi Singkat
> Jelaskan proyek ini dalam 2-3 kalimat. Apa yang dilakukan, siapa penggunanya, dan mengapa perlu direfaktor.

### 0.2 Tech Stack Saat Ini (Sebelum Refaktor)
```
Framework  :
Database   :
Auth       :
UI Library :
Deployment :
Lainnya    :
```

### 0.3 Tech Stack Target (Setelah Refaktor)
```
Framework  : Next.js (App Router)
Database   : Aiven PostgreSQL + Drizzle ORM
Auth       : Google OAuth
UI Library : Fluent UI (@fluentui/react-components)
Deployment : Netlify (web) + Tauri (desktop/mobile) — hapus jika tidak relevan
Lainnya    :
```

### 0.4 Alasan Refaktor
- [ ] Performance buruk
- [ ] Tech debt menumpuk
- [ ] Migrasi framework/library
- [ ] Keamanan tidak memadai
- [ ] Skalabilitas terbatas
- [ ] Lainnya: ___

### 0.5 Batasan & Constraint
> Tuliskan hal-hal yang TIDAK boleh berubah selama refaktor:
- Contoh: URL struktur tidak boleh berubah (SEO)
- Contoh: Data existing harus dimigrasikan, tidak boleh hilang
- Contoh: Fitur X harus tetap berjalan selama proses refaktor

---

## 1. Inventarisasi Sistem Lama

### 1.1 Pemetaan Fitur Existing
| Fitur | Status | Akan Dipertahankan? | Catatan |
|---|---|---|---|
| [Nama Fitur] | ✅ Berfungsi | Ya / Tidak / Dimodifikasi | |
| | | | |

### 1.2 Pemetaan Database Existing
| Tabel | Kolom Penting | Akan Dimigrasikan? | Catatan |
|---|---|---|---|
| [Nama Tabel] | | Ya / Tidak / Diubah | |
| | | | |

### 1.3 Pemetaan API / Integrasi Existing
| Layanan | Endpoint | Status | Akan Dipertahankan? |
|---|---|---|---|
| [Nama Layanan] | | Aktif / Mati | Ya / Tidak |
| | | | |

### 1.4 Pemetaan Komponen UI Existing
| Komponen | Lokasi | Akan Di-refaktor? | Catatan |
|---|---|---|---|
| [Nama Komponen] | | Ya / Tidak | |
| | | | |

### 1.5 Temuan Teknis Awal
> Catat temuan penting dari audit kode existing:
- [ ] ...
- [ ] ...

---

## 2. Penyesuaian SOP & Design untuk Proyek Ini

### 2.1 Layanan Eksternal yang Digunakan
> Centang yang relevan untuk proyek ini:
- [ ] Xendit (payment)
- [ ] Google OAuth (auth)
- [ ] Google Drive (file)
- [ ] Cloudinary (gambar)
- [ ] Lainnya: ___

### 2.2 Deployment Target
- [ ] Web (Netlify)
- [ ] Desktop (Tauri)
- [ ] Mobile (Tauri)

### 2.3 Nuansa Default Proyek Ini
```
Nuansa  :
Tema    :
Bahasa  :
```

### 2.4 Penyimpangan dari SOP (jika ada)
> Jika ada keputusan yang berbeda dari SOP, dokumentasikan di sini beserta alasannya:
| Section SOP | Keputusan Berbeda | Alasan |
|---|---|---|
| | | |

---

## 3. Rencana Migrasi Data

### 3.1 Strategi Migrasi
- [ ] Big bang (semua sekaligus, downtime singkat)
- [ ] Incremental (bertahap, zero downtime)
- [ ] Shadow mode (jalankan paralel, bandingkan output)

### 3.2 Langkah Migrasi Data
- [ ] Backup database existing sebelum mulai
- [ ] Buat schema baru di Drizzle (`src/models/`)
- [ ] Tulis migration script
- [ ] Test migrasi di environment staging
- [ ] Jalankan migrasi di produksi
- [ ] Verifikasi integritas data

### 3.3 Rollback Plan
> Jika migrasi gagal, apa yang dilakukan:
```
1.
2.
3.
```

---

## 4. Tahapan Refaktor

### Fase 1 — Fondasi
> Target: Arsitektur baru berjalan tanpa fitur

- [ ] Setup Next.js App Router
- [ ] Setup Drizzle ORM + koneksi Aiven
- [ ] Setup Fluent UI + FluentProvider
- [ ] Setup `next-intl` (i18n)
- [ ] Setup `nuqs` + `zustand`
- [ ] Setup `next-safe-action` + `valibot`
- [ ] Setup security headers di `next.config.js`
- [ ] Setup `.env.example` lengkap
- [ ] Setup struktur folder MVC (`src/models`, `src/controllers`, `src/views`)
- [ ] Setup Memory Logs (`guides/memory/active/`)

**Log Memory**: `guides/memory/active/[timestamp]-fase-1.md`

---

### Fase 2 — Migrasi Data & Model
> Target: Data existing tersedia di schema baru

- [ ] Definisi schema Drizzle semua tabel
- [ ] Jalankan migrasi data
- [ ] Verifikasi data integrity
- [ ] Setup `audit_logs` table
- [ ] Test koneksi PgBouncer

**Log Memory**: `guides/memory/active/[timestamp]-fase-2.md`

---

### Fase 3 — Migrasi Auth & Keamanan
> Target: Login berfungsi di stack baru

- [ ] Setup Google OAuth flow
- [ ] Setup RBAC (roles & permissions)
- [ ] Setup rate limiting (`@upstash/ratelimit`)
- [ ] Setup CSRF protection
- [ ] Setup DOMPurify (client)
- [ ] Test auth flow di web
- [ ] Test auth flow di Tauri (jika relevan)

**Log Memory**: `guides/memory/active/[timestamp]-fase-3.md`

---

### Fase 4 — Migrasi Logika Bisnis
> Target: Semua Server Actions & API Routes berfungsi

- [ ] Pindahkan logika bisnis ke `src/controllers/`
- [ ] Implementasi Server Actions dengan `next-safe-action`
- [ ] Migrasi integrasi layanan eksternal
- [ ] Setup Xendit webhook + signature verification (jika relevan)
- [ ] Setup `audit_logs` untuk aksi kritis
- [ ] Test semua API endpoints

**Log Memory**: `guides/memory/active/[timestamp]-fase-4.md`

---

### Fase 5 — Migrasi UI
> Target: Semua halaman tampil dengan Fluent UI

- [ ] Setup token nuansa di `src/styles/tokens/vibes/`
- [ ] Setup onboarding flow (bahasa → nuansa → tema)
- [ ] Setup nuansa switcher di settings
- [ ] Setup command palette (`cmdk`)
- [ ] Migrasi komponen halaman per halaman:
  - [ ] Landing Page
  - [ ] Auth Page
  - [ ] Dashboard
  - [ ] [Halaman lainnya]
- [ ] Implementasi skeleton & empty states semua halaman
- [ ] Implementasi error.tsx & not-found.tsx dengan Fluent UI

**Log Memory**: `guides/memory/active/[timestamp]-fase-5.md`

---

### Fase 6 — Animasi & Experience
> Target: Animasi & WebGL berfungsi sesuai Design.md

- [ ] Setup Lenis smooth scroll
- [ ] Implementasi landing page WebGL scene
- [ ] Implementasi scroll-driven narrative landing
- [ ] Implementasi cinematic text reveal
- [ ] Implementasi micro-interaction per komponen
- [ ] Setup GPU detection + CSS fallback
- [ ] Test reduced-motion compliance
- [ ] Test animasi di Tauri (jika relevan)

**Log Memory**: `guides/memory/active/[timestamp]-fase-6.md`

---

### Fase 7 — QA & Launch
> Target: Semua quality gates lolos

- [ ] Linting & Formatting (Biome) — bersih
- [ ] Type Checking (TSC) — zero error
- [ ] Automated Tests (Playwright) — semua pass
- [ ] Build Check (`npm run build`) — sukses
- [ ] Tauri build check (`tauri build`) — sukses (jika relevan)
- [ ] WCAG AA contrast check — lolos semua nuansa
- [ ] Performance audit (Lighthouse) — score > 90
- [ ] Security audit — semua layer terverifikasi
- [ ] Checklist Design.md section 22 — semua centang

**Log Memory**: `guides/memory/active/[timestamp]-fase-7.md`

---

## 5. Tracking Progress

### 5.1 Status Keseluruhan
```
Fase 1 — Fondasi          : ⬜ Belum / 🟡 Sedang / ✅ Selesai
Fase 2 — Data & Model     : ⬜
Fase 3 — Auth & Security  : ⬜
Fase 4 — Logika Bisnis    : ⬜
Fase 5 — UI               : ⬜
Fase 6 — Animasi          : ⬜
Fase 7 — QA & Launch      : ⬜
```

### 5.2 Blocker Aktif
> Catat blocker yang sedang menghambat progress:
| Blocker | Fase | Ditemukan | Status |
|---|---|---|---|
| | | | |

### 5.3 Keputusan Arsitektur yang Diambil
> Catat setiap keputusan penting yang dibuat selama refaktor:
| Keputusan | Alasan | Tanggal |
|---|---|---|
| | | |

---

## 6. Catatan Agen

> Section ini diisi oleh AI Agent setiap sesi kerja.
> Format mengikuti standar Memory Logs (SOP 6.3).

### Sesi Terakhir
```
Tanggal    :
Agen       :
Fase aktif :
Yang dikerjakan:
-
Blocker:
-
Selanjutnya:
-
```
