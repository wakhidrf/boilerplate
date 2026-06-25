# Plan: [Nama Proyek Baru]

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
> Jelaskan proyek ini dalam 2-3 kalimat. Apa yang dilakukan, siapa penggunanya, dan apa nilai utamanya.

### 0.2 Jenis Proyek
- [ ] Landing Page Perusahaan
- [ ] Online Marketplace
- [ ] SaaS Application
- [ ] Dashboard / Admin Panel
- [ ] E-Commerce
- [ ] Lainnya: ___

### 0.3 Target Pengguna
```
Segmen utama  :
Keahlian tech :
Platform      : Web / Desktop / Mobile / Semua
Bahasa        : Indonesia / English / Keduanya
```

### 0.4 Tech Stack
```
Framework  : Next.js (App Router)
Database   : Aiven PostgreSQL + Drizzle ORM
Auth       :
UI Library : Fluent UI (@fluentui/react-components)
Deployment : Netlify (web) + Tauri (jika multiplatform)
Lainnya    :
```

### 0.5 Scope MVP
> Fitur minimal yang harus ada sebelum launch pertama:
- [ ] ...
- [ ] ...

### 0.6 Out of Scope (MVP)
> Fitur yang sengaja ditunda untuk versi berikutnya:
- [ ] ...
- [ ] ...

---

## 1. Penyesuaian SOP & Design untuk Proyek Ini

### 1.1 Layanan Eksternal yang Digunakan
- [ ] Xendit (payment)
- [ ] Google OAuth (auth)
- [ ] Google Drive (file)
- [ ] Cloudinary (gambar)
- [ ] Lainnya: ___

### 1.2 Deployment Target
- [ ] Web (Netlify)
- [ ] Desktop (Tauri)
- [ ] Mobile (Tauri)

### 1.3 Identitas Visual
```
Nuansa default  :
Tema default    :
Bahasa default  :
Nuansa tersedia : (centang dari 8 pilihan atau semua)
  [ ] Modern  [ ] Cyberpunk  [ ] Steampunk  [ ] Nature
  [ ] Oldstyle  [ ] Cowboy  [ ] Japanese  [ ] Retro
```

### 1.4 Penyimpangan dari SOP (jika ada)
| Section SOP | Keputusan Berbeda | Alasan |
|---|---|---|
| | | |

---

## 2. Arsitektur & Schema

### 2.1 Struktur Halaman
| Halaman | Route | Auth Required | Keterangan |
|---|---|---|---|
| Landing | `/` | Tidak | |
| Login | `/login` | Tidak | |
| Dashboard | `/dashboard` | Ya | |
| [Lainnya] | | | |

### 2.2 Schema Database
| Tabel | Kolom Utama | Relasi | Catatan |
|---|---|---|---|
| `users` | id, email, preferences | | |
| `audit_logs` | id, user_id, action, entity | users | Wajib per SOP |
| [Lainnya] | | | |

### 2.3 RBAC — Peran & Izin
| Peran | Akses | Keterangan |
|---|---|---|
| `admin` | Semua | |
| `user` | | |
| [Lainnya] | | |

### 2.4 API Routes yang Dibutuhkan
| Route | Method | Auth | Keterangan |
|---|---|---|---|
| `/api/auth/callback` | GET | Tidak | Google OAuth |
| `/api/webhooks/xendit` | POST | Tidak (signature) | Payment callback |
| [Lainnya] | | | |

---

## 3. Tahapan Pembangunan

### Fase 1 — Setup & Fondasi
> Target: Proyek berjalan dengan struktur yang benar

- [ ] Init Next.js App Router
- [ ] Setup Drizzle ORM + koneksi Aiven PostgreSQL
- [ ] Setup Fluent UI + FluentProvider + token nuansa
- [ ] Setup `next-intl` (i18n ID + EN)
- [ ] Setup `nuqs` + `zustand`
- [ ] Setup `next-safe-action` + `valibot`
- [ ] Setup security headers (`next.config.js`)
- [ ] Setup rate limiting (`@upstash/ratelimit`)
- [ ] Setup `.env.example` lengkap
- [ ] Setup struktur folder MVC
- [ ] Setup Biome (linting & formatting)
- [ ] Setup Memory Logs (`guides/memory/active/`)
- [ ] Init repository + conventional commits

**Log Memory**: `guides/memory/active/[timestamp]-fase-1.md`

---

### Fase 2 — Data & Model
> Target: Schema database siap, seed data tersedia

- [ ] Definisi semua schema Drizzle di `src/models/`
- [ ] Setup tabel `audit_logs`
- [ ] Jalankan migration pertama
- [ ] Buat seed data untuk development
- [ ] Verifikasi koneksi PgBouncer + SSL Aiven
- [ ] Test semua query dasar

**Log Memory**: `guides/memory/active/[timestamp]-fase-2.md`

---

### Fase 3 — Auth & Keamanan
> Target: Login berfungsi, RBAC aktif

- [ ] Setup Google OAuth flow (web)
- [ ] Setup OAuth deep link untuk Tauri (jika relevan)
- [ ] Implementasi RBAC
- [ ] Setup CSRF protection
- [ ] Setup DOMPurify (client)
- [ ] Setup `audit_logs` untuk login/logout
- [ ] Test auth flow end-to-end

**Log Memory**: `guides/memory/active/[timestamp]-fase-3.md`

---

### Fase 4 — Logika Bisnis & API
> Target: Semua fitur core berfungsi

- [ ] Implementasi semua Server Actions di `src/controllers/`
- [ ] Implementasi semua API Routes di `src/app/api/`
- [ ] Setup integrasi layanan eksternal:
  - [ ] Xendit (jika relevan)
  - [ ] Google Drive (jika relevan)
  - [ ] Cloudinary (jika relevan)
- [ ] Setup Xendit webhook + signature verification (jika relevan)
- [ ] Implementasi `audit_logs` untuk aksi kritis
- [ ] Test semua API dengan berbagai skenario

**Log Memory**: `guides/memory/active/[timestamp]-fase-4.md`

---

### Fase 5 — UI & Komponen
> Target: Semua halaman tampil dengan Fluent UI

- [ ] Setup token nuansa lengkap di `src/styles/`
- [ ] Setup onboarding flow (bahasa → nuansa → tema)
- [ ] Setup nuansa switcher di settings
- [ ] Setup command palette (`cmdk`)
- [ ] Bangun komponen reusable di `src/views/`:
  - [ ] Layout (header, sidebar, footer)
  - [ ] [Komponen spesifik proyek]
- [ ] Bangun semua halaman:
  - [ ] Landing Page
  - [ ] Auth Page
  - [ ] [Halaman lainnya]
- [ ] Implementasi skeleton & empty states
- [ ] Implementasi `error.tsx` & `not-found.tsx`
- [ ] Test responsivitas semua breakpoint

**Log Memory**: `guides/memory/active/[timestamp]-fase-5.md`

---

### Fase 6 — Animasi & Experience
> Target: Experience sesuai Design.md

- [ ] Setup Lenis smooth scroll
- [ ] Implementasi landing page WebGL scene (jika relevan)
- [ ] Implementasi scroll-driven narrative (jika relevan)
- [ ] Implementasi micro-interaction semua komponen
- [ ] Setup GPU detection + CSS fallback
- [ ] Test `prefers-reduced-motion` compliance
- [ ] Test performa animasi di mobile

**Log Memory**: `guides/memory/active/[timestamp]-fase-6.md`

---

### Fase 7 — Testing & QA
> Target: Semua quality gates lolos

- [ ] Linting & Formatting (Biome) — bersih
- [ ] Type Checking (TSC) — zero error
- [ ] E2E Tests (Playwright) — semua user journey pass
- [ ] Build Check (`npm run build`) — sukses
- [ ] Tauri build check (jika relevan)
- [ ] WCAG AA contrast — lolos semua nuansa aktif
- [ ] Lighthouse score > 90 (Performance, A11y, Best Practices)
- [ ] Security audit — semua layer SOP 5 terverifikasi
- [ ] Checklist Design.md section 22 — semua centang

**Log Memory**: `guides/memory/active/[timestamp]-fase-7.md`

---

### Fase 8 — Launch & Monitoring
> Target: Aplikasi live di produksi

- [ ] Setup Netlify production environment
- [ ] Setup semua environment variables di Netlify
- [ ] Setup Aiven production database
- [ ] DNS & domain configuration
- [ ] Test end-to-end di production
- [ ] Setup error monitoring (Sentry atau sejenis)
- [ ] Setup uptime monitoring
- [ ] Dokumentasikan architecture decision di Memory Logs

**Log Memory**: `guides/memory/active/[timestamp]-fase-8.md`

---

## 4. Tracking Progress

### 4.1 Status Keseluruhan
```
Fase 1 — Setup & Fondasi   : ⬜ Belum / 🟡 Sedang / ✅ Selesai
Fase 2 — Data & Model      : ⬜
Fase 3 — Auth & Keamanan   : ⬜
Fase 4 — Logika Bisnis     : ⬜
Fase 5 — UI & Komponen     : ⬜
Fase 6 — Animasi           : ⬜
Fase 7 — Testing & QA      : ⬜
Fase 8 — Launch            : ⬜
```

### 4.2 Milestone & Deadline
| Milestone | Target Tanggal | Status |
|---|---|---|
| Fase 1 selesai | | ⬜ |
| MVP siap demo | | ⬜ |
| Beta launch | | ⬜ |
| Production launch | | ⬜ |

### 4.3 Blocker Aktif
| Blocker | Fase | Ditemukan | Status |
|---|---|---|---|
| | | | |

### 4.4 Keputusan Arsitektur yang Diambil
| Keputusan | Alasan | Tanggal |
|---|---|---|
| | | |

---

## 5. Catatan Agen

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
