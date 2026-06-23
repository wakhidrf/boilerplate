# Global Software Engineering Workflow (SENSITIVE FILE)

> **PENTING:** Dokumen ini adalah standar operasional prosedur (SOP) utama dan "Single Source of Truth" untuk seluruh arsitektur proyek. File ini bersifat **SENSITIF** dan **KRITIKAL**.
>
> **Prosedur Perubahan Dokumen (Maintenance):**
> 1. **Analisis**: Identifikasi bagian spesifik yang perlu diperbarui atau ditambah.
> 2. **Konsultasi**: WAJIB menjelaskan alasan perubahan dan memberikan draf perbandingan kepada User.
> 3. **Persetujuan**: Perubahan hanya boleh diterapkan setelah User memberikan persetujuan eksplisit ("OK").
> 4. **Metode Merge**: Dilarang melakukan *full overwrite* (replace total). Gunakan penggabungan (merge) untuk menjaga integritas pondasi.

---

## 1. Arsitektur & Pola Pengembangan

### 1.1 Standar Alur Kerja MVC (Model-View-Controller)
Gunakan pola MVC yang ketat untuk menjaga keteraturan kode:
- **Models** (`src/models`): Definisi skema data (Drizzle/ORM) dan validasi skema (**Valibot**). Satu file per entitas.
- **Controllers** (`src/controllers`): Logika bisnis, Server Actions (`next-safe-action`), Hooks kustom, dan State Management (**nuqs** untuk URL state, **Zustand** untuk UI state lokal).
- **Views** (`src/views`): Komponen UI Reusable. Dilarang melakukan akses database langsung.
- **Routing** (`src/app`): Folder routing yang merakit views dan memanggil controllers/data.

### 1.2 Prinsip Client vs Server Components
Secara default, seluruh komponen harus berupa **Server Components**.
- **Server**: Pengambilan data (fetching), akses database/kredensial, keamanan tinggi.
- **Client**: Interaktivitas, manajemen state lokal menggunakan `zustand`, hooks.
- **Strategi**: Minimalisir penggunaan client components dengan memindahkan interaktivitas ke komponen terkecil (*leaf components*).
- **Pembagian State Management**:
  - **`nuqs`** → state yang perlu shareable, bookmarkable, atau survive page refresh (filter, pagination, sort, search query). Wajib digunakan untuk semua URL Search Params di Next.js App Router.
  - **`zustand`** → state UI lokal yang tidak perlu di-share (modal buka/tutup, sidebar collapse, toast/notifikasi, form draft sementara, auth session).
  - **Aturan**: Jangan simpan UI state di URL, dan jangan simpan shareable state di Zustand.

### 1.3 Aturan Penamaan & Struktur (Naming Convention)
- **Files & Folders**: Wajib menggunakan `kebab-case` untuk seluruh nama file dan folder tanpa pengecualian (contoh: `hero-section.tsx`, `use-mortgage.ts`, `api-keys.ts`).
- **Tujuan**: Menghindari masalah *case-sensitivity* antar sistem operasi dan mengikuti standar profesional Google.
- **Larangan Index Files**: Dilarang keras menggunakan nama file `index.ts` atau `index.tsx`. Setiap file wajib memiliki nama yang deskriptif mencerminkan isinya (misal: `database.ts` bukan `index.ts`). Penggunaan *barrel files* juga dilarang untuk menghindari masalah performa dan kejelasan impor.
- **Section-Based**: UI dipecah menjadi bagian mandiri di `src/views/sections` yang bersifat *data-driven* (menerima data via props).

### 1.4 Path Aliases & Imports
- **Path Aliases**: Selalu gunakan alias `@/` untuk mengacu ke direktori `src/`.
- **Dilarang**: Menggunakan relatif path yang kompleks (seperti `../../../../controllers/...`).
- **Tujuan**: Menjaga kebersihan kode dan menghindari error *Module not found* saat terjadi perpindahan file antar folder.

### 1.5 Strategi Migrasi & Refaktorisasi Bertahap
1. **Inventarisasi**: Petakan logika bisnis, skema database, dan alur kerja dari sistem lama.
2. **Migrasi Data**: Bangun fondasi data dan sinkronisasi skema antar lingkungan.
3. **Implementasi Logika**: Pindahkan logika bisnis ke lapisan kontroler yang terisolasi.
4. **Pengembangan UI**: Bangun pustaka komponen UI yang dapat digunakan kembali.
5. **Perakitan**: Hubungkan semua lapisan melalui sistem routing aplikasi.

### 1.6 Architectural Clarification: Routing vs Controller
- **Routing Layer (`src/app/api`)**: Merupakan titik masuk untuk *request* API. Bertanggung jawab murni untuk *routing* dan memanggil *controller* yang relevan.
- **Controller Layer (`src/controllers/api`)**: Menyimpan logika bisnis inti, yang dipicu oleh *routing layer*.

---

## 2. Standar Pengembangan & Kode

### 2.1 Kualitas Kode & Prinsip Modularitas
- **Prinsip Single Responsibility (SRP)**: Setiap file harus memiliki **satu tanggung jawab yang jelas**. Gunakan 200 baris sebagai *soft limit* — jika sebuah file mendekati atau melebihi batas ini, evaluasi apakah file tersebut melanggar SRP. Jika ya, dekomposisi menjadi sub-komponen atau utility functions. Jika tidak (misalnya schema Valibot kompleks atau enum besar), pertahankan dalam satu file demi kohesi.
- **Type Safety**: Gunakan tipe data eksplisit dan hindari penggunaan tipe data dinamis yang tidak terdefinisi.
- **Pembersihan Kode**: Gunakan alat linter (**Biome**) dan format otomatis secara konsisten.

### 2.2 Form & Validasi (Stack: `valibot`)
- **Validasi Ganda**: Terapkan validasi di sisi klien untuk pengalaman pengguna dan di sisi server untuk integritas data menggunakan **Valibot**.
- **Feedback**: Berikan indikator status proses (loading) dan notifikasi setelah aksi selesai.

### 2.3 Penanganan Error & Loading
- **Skeleton Screens**: Gunakan placeholder visual (`Skeleton` dari `@fluentui/react-components`) yang mencerminkan struktur konten selama pemuatan. Dilarang menggunakan `shadcn/ui` karena berbasis Tailwind CSS.
- **Error Boundaries**: Terapkan penanganan kesalahan pada level routing (`error.tsx`) untuk isolasi error.
- **404 Handling**: Gunakan `not-found.tsx` untuk respon tepat jika data tidak ditemukan.
- **UI pada Error Pages**: Komponen di `error.tsx` dan `not-found.tsx` wajib menggunakan komponen dari `@fluentui/react-components`. Dilarang menggunakan library UI lain atau elemen HTML mentah tanpa styling Fluent UI.

### 2.4 Performa & Caching
- **Deduplikasi Permintaan**: Gunakan mekanisme cache untuk menghindari pemanggilan data yang berulang.
- **Optimasi Kueri**: Pilih kolom data secara eksplisit dan pastikan kolom pencarian terindeks dengan benar.
- **Pemuatan Dinamis**: Gunakan teknik lazy loading untuk komponen berat yang tidak diperlukan segera.

---

## 3. Manajemen Data & API (Stack: `swr`, `axios`, `drizzle`)

### 3.1 Strategi "Drizzle Ready"
Meskipun saat ini bersifat statis, arsitektur harus dirancang agar migrasi ke database dapat dilakukan minimal:
- Simpan mock data di `src/models/*.ts` sebagai konstanta.
- Tipe data statis harus mencerminkan struktur kolom di skema database masa depan.
- **Koneksi Database**: Gunakan **Aiven PostgreSQL** sebagai satu-satunya database produksi. Wajib menggunakan connection string via **PgBouncer** (bukan direct connection) untuk efisiensi koneksi. SSL wajib diaktifkan dengan CA Certificate dari Aiven.
  - Gunakan: `DATABASE_URL=postgres://user:pass@host:5432/db?pgbouncer=true`
  - Dilarang: `DATABASE_URL=postgres://user:pass@host:5432/db` (direct connection)

### 3.2 Integrasi Layanan Eksternal
- **Keamanan Kredensial**: Kelola kunci akses melalui variabel lingkungan; jangan pernah memaparkannya di sisi klien.
- **Lapisan Layanan (Service Layer)**: Buat abstraksi khusus untuk setiap integrasi layanan pihak ketiga.
- **Layanan Eksternal yang Digunakan**:
  - **Xendit** — payment gateway; semua transaksi finansial wajib write langsung ke database (tidak boleh di-cache)
  - **Google OAuth** — autentikasi pengguna; token disimpan di server session
  - **Google Drive** — manajemen file dokumen
  - **Cloudinary** — manajemen aset gambar
- **Aturan Environment Variables**: Semua kredensial layanan di atas **hanya boleh ada di Netlify environment variables** — tidak pernah di-expose ke Tauri atau sisi klien. Variabel yang diawali `NEXT_PUBLIC_` adalah satu-satunya yang boleh dikonsumsi Tauri.
- **Standar `.env.example`**: Wajib menjaga file `.env.example` di root project selalu sinkron setiap kali ada penambahan atau perubahan variabel lingkungan. File ini tidak boleh mengandung nilai asli — hanya key dan keterangan singkat:
  ```bash
  # Database
  DATABASE_URL=                       # Aiven PostgreSQL via PgBouncer
  AIVEN_CA_PATH=                      # Path ke CA certificate Aiven

  # Auth
  NEXT_PUBLIC_GOOGLE_CLIENT_ID=       # Google OAuth Client ID
  GOOGLE_CLIENT_SECRET=               # Google OAuth Client Secret

  # Payment
  XENDIT_SECRET_KEY=                  # Xendit secret key (server only)

  # Storage
  GOOGLE_DRIVE_SERVICE_KEY=           # Google Drive service account JSON
  NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=
  CLOUDINARY_API_SECRET=

  # App
  NEXT_PUBLIC_API_URL=                # URL Netlify untuk dikonsumsi Tauri
  ```

### 3.3 Integritas Data & Audit
- **Metadata Standar**: Setiap tabel wajib memiliki informasi waktu pembuatan, pembaruan, serta identitas pengubah.
- **Soft Delete**: Gunakan penghapusan logis untuk data transaksi penting agar tidak hilang dari sistem.

### 3.4 Navigasi & State
- **URL State (`nuqs`)**: Gunakan `nuqs` sebagai state utama untuk filter, pagination, sort, dan search query. State ini bersifat shareable, bookmarkable, dan SSR-compatible.
- **UI State (`zustand`)**: Gunakan Zustand untuk state lokal yang tidak perlu persist di URL — modal, sidebar, toast, form draft, dan auth session.
- **Aturan Pemilihan**:
  - Perlu di-share / di-bookmark / survive refresh? → `nuqs` (URL)
  - Hanya urusan UI lokal? → `zustand`

### 3.5 Next.js Bundling & Safety (Crucial)
Untuk mencegah error *build* pada Client Components akibat dependensi modul Node.js (seperti `pg`):
- **Pemisahan Model**: Wajib memisahkan `db/` (schema & types) dari `client/` (instance & connection).
- **Client Components**: HANYA boleh mengimpor dari `@/models/db`.
- **Server Components/API Routes**: HANYA boleh mengimpor `db` (instance) dari `@/models/client`.
- **Kepatuhan**: Setiap modul baru yang berinteraksi dengan database WAJIB mematuhi pemisahan ini.

---

## 4. UI, UX, Asset & Aksesibilitas

### 4.1 Design & Asset Stack
- **Styling**: **Fluent UI** (`@fluentui/react-components`) sebagai satu-satunya design system. Tailwind CSS **tidak digunakan** untuk menghindari CSS specificity conflict dengan Fluent UI.
- **Icons**: Wajib menggunakan **Fluent Icons** (`@fluentui/react-icons`) untuk konsistensi visual.
- **Responsivitas**: UI wajib responsif lintas platform — browser (Netlify), desktop, dan mobile via **Tauri**. Gunakan Fluent UI's responsive tokens dan layout primitives sebagai fondasi adaptasi tampilan antar platform.
- **Next.js + Fluent UI**: Komponen Fluent UI yang membutuhkan runtime browser wajib dibungkus dalam Client Components (`"use client"`), karena Fluent UI tidak mendukung SSR secara penuh.
- **Fonts**: Wajib menggunakan font dari [CDNFonts](https://www.cdnfonts.com/).
- **Asset Standar**: Wajib format `.webp`, ukuran < 500KB (Hero) / < 100KB (Thumb), dan menggunakan `next/image`.
- **Placeholder**: Gunakan gambar dari [Unsplash](https://unsplash.com/id) untuk preview/mockup.

### 4.2 Standar Aksesibilitas (A11y)
- **Struktur Semantik**: Gunakan elemen HTML sesuai fungsi (misal: `<button>` bukan `<div>`).
- **ARIA & Keyboard**: Gunakan atribut ARIA yang tepat dan pastikan navigasi keyboard berfungsi penuh dengan indikator fokus yang jelas.
- **Kontras**: Pastikan rasio kontras warna memenuhi standar WCAG.

### 4.3 SEO & Metadata
- **Manajemen Metadata**: Konfigurasi judul, deskripsi, dan ikon secara dinamis via Metadata API di setiap halaman.
- **Hierarki Heading**: Gunakan hanya **satu H1** per halaman.

---

## 5. Keamanan & Sanitasi

### 5.1 Integritas Aksi Server
- Semua mutasi data WAJIB dibungkus dengan **next-safe-action** untuk validasi input dan perlindungan eksekusi.
- **Xendit Webhook**: Setiap request yang masuk ke `/api/webhooks/xendit` wajib melalui verifikasi signature sebelum memproses payload apapun:
  1. Verifikasi header `x-callback-token` (wajib pertama)
  2. Jika tidak valid → tolak dengan `401`, jangan proses payload
  3. Jika valid → proses payload → update database
  - Token verifikasi disimpan di env sebagai `XENDIT_WEBHOOK_TOKEN` (server only)
  - Dilarang memproses payload sebelum verifikasi selesai

### 5.2 Sanitasi Konten
- **Client Side (Render)**: Wajib mensanitasi konten dinamis menggunakan **DOMPurify** sebelum dirender ke DOM untuk mencegah XSS.
- **Server Side (Input)**: Validasi dan sanitasi input wajib menggunakan **Valibot schema** di semua Server Actions via `next-safe-action`. Input yang tidak lolos schema langsung ditolak — tidak perlu library sanitasi tambahan karena Drizzle sudah menggunakan parameterized query.

### 5.3 Peran & Izin Akses (RBAC)
- **Matriks Akses**: Definisikan peran pengguna dan tingkat akses yang diizinkan.
- **Keamanan Antarmuka**: Sembunyikan elemen aksi atau navigasi yang tidak sesuai dengan izin akses pengguna.

### 5.4 Rate Limiting
Wajib menerapkan rate limiting pada endpoint yang rawan abuse menggunakan **`@upstash/ratelimit`**:

| Endpoint | Limit | Window |
|---|---|---|
| `/api/auth/*` | 10 request | per menit |
| `/api/webhooks/*` | 50 request | per menit |
| `/api/*` (global) | 100 request | per menit |

- Jika limit terlampaui → tolak dengan response `429 Too Many Requests`
- Konfigurasi limit disimpan di env, bukan hardcoded

### 5.5 Security Headers
Wajib mengkonfigurasi HTTP security headers di `next.config.js`:
- `X-Frame-Options: DENY` — mencegah clickjacking
- `X-Content-Type-Options: nosniff` — mencegah MIME sniffing
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy: camera=(), microphone=(), geolocation=()`
- `Content-Security-Policy: default-src 'self'` — mencegah injeksi konten dari sumber tidak dikenal

### 5.6 CSRF Protection
- Semua mutasi data via form wajib memverifikasi bahwa request berasal dari origin yang sah.
- Gunakan origin check di Server Actions: cocokkan header `Origin` / `Referer` dengan `NEXT_PUBLIC_API_URL`. Jika tidak cocok → tolak dengan `403`.
- `next-safe-action` wajib dikombinasikan dengan pengecekan origin ini untuk semua aksi yang bersifat mutasi.

### 5.7 Audit Log
Setiap aksi penting wajib dicatat di tabel `audit_logs` via Drizzle:

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | uuid | Primary key |
| `user_id` | uuid | Pelaku aksi |
| `action` | string | Nama aksi (CREATE, UPDATE, DELETE, PAYMENT) |
| `entity` | string | Entitas yang diubah (user, invoice, file) |
| `entity_id` | uuid | ID entitas yang diubah |
| `payload` | jsonb | Snapshot data sebelum/sesudah perubahan |
| `ip_address` | string | IP pelaku |
| `created_at` | timestamp | Waktu kejadian |

**Aksi yang wajib diaudit**: login, logout, pembayaran Xendit, perubahan RBAC, upload/delete file Google Drive, perubahan data kritis.

---

## 6. Alur Kerja Git & Testing

### 6.1 Conventional Commits
Format pesan commit: `<type>(<scope>): <description>`
- `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

### 6.2 Strategi Testing (Playwright)
- **E2E Testing**: Fokus pada alur kritis pengguna (User Journeys).
- **Component Testing**: Simpan file spec di folder komponen terkait (`*.spec.tsx`).

---

### 6.3 Dokumentasi Progres & Tracking (Memory Logs)
- **Memory Logs**: Setiap langkah signifikan atau penyelesaian tahap refaktorisasi WAJIB dicatat dalam file baru di `guides/memory/<YYYY-MM-DD-HH-mm-ss>.md`.
- **Konteks Eksekutor**: Log ini dirancang sebagai **memori persisten untuk AI Coding Agents** (seperti Google Jules, OpenCode, Antigravity CLI, dan agen sejenis). Setiap agen yang mengerjakan task WAJIB membaca log terakhir sebelum memulai dan menulis log baru setelah selesai, untuk menjaga kontinuitas konteks antar sesi.
- **Isi Log Wajib**:
  - Tanggal & timestamp eksekusi
  - Nama agen/eksekutor yang mengerjakan
  - Daftar perubahan file yang dilakukan (path lengkap)
  - Temuan teknis & keputusan arsitektur yang diambil
  - Catatan blocker atau hal yang perlu ditindaklanjuti sesi berikutnya
- **Marking Plan**: Jika proyek memiliki `guides/Plan.md`, setiap langkah yang telah selesai harus ditandai dengan centang `[x]` pada judul atau butir rencana tersebut.
- **Tujuan**: Mencegah pekerjaan tumpang tindih atau terulang antar sesi agen, memastikan transparansi progres bagi User, dan memberikan riwayat teknis yang jelas untuk audit masa depan.

## 7. Pelaporan, Deployment & QA

### 7.1 Sistem Pelaporan
- Gunakan alat pembuatan dokumen yang presisi untuk laporan resmi dan ekspor spreadsheet dengan tipe data terjaga.

### 7.2 Quality Gates (Checklist Merge)
Sebelum merge ke `main`, wajib lolos:
1. Linting & Formatting (Biome).
2. Type Checking (TSC).
3. Automated Tests (Playwright).
4. Build Check (`npm run build`).

### 7.3 Keberlanjutan Sistem (Operasi)
- Pencadangan berkala, audit dependensi secara rutin, dan monitoring performa real-time di produksi.

### 7.4 Deployment Architecture
Aplikasi ini memiliki **dua build target** yang berbeda namun berbagi sumber UI yang sama:

**Web (Netlify)**
- Build command: `next build`
- Next.js berjalan sebagai SSR/Static di Netlify
- Memegang semua `.env` dan kredensial layanan eksternal (Xendit, Google, Cloudinary, Aiven)
- Satu-satunya layer yang boleh berinteraksi langsung dengan Aiven PostgreSQL via PgBouncer

**Desktop/Mobile (Tauri)**
- Build command: `tauri build`
- Tauri membungkus UI React yang sama via WebView
- **Tidak memegang `.env` apapun**
- Semua API call diarahkan ke Netlify via HTTPS
- Deteksi environment via `window.__TAURI__` di `src/lib/api-client.ts`

**Google OAuth Flow per Platform**:
Semua platform menggunakan **satu callback URL** di Netlify. Tampilan tombol login seragam via Fluent UI Button — tidak menggunakan komponen bawaan Google (`<GoogleLogin />`) agar tetap konsisten dengan design system.

```
User klik Fluent UI Button
      ↓
Trigger @react-oauth/google
      ↓
https://yourdomain.netlify.app/api/auth/callback
      ↓
Netlify proses token
      ↓
      ├── Desktop  → redirect myapp://auth?token=xxx (deep link)
      ├── Android  → App Links via assetlinks.json → OS buka Tauri
      └── iOS      → Universal Links via apple-app-site-association → OS buka Tauri
```

Implementasi tombol login wajib menggunakan Fluent UI:
```tsx
import { Button } from "@fluentui/react-components";
import { useGoogleLogin } from "@react-oauth/google";

const login = useGoogleLogin({ onSuccess: handleSuccess });

<Button appearance="outline" icon={<GoogleIcon />} onClick={() => login()}>
  Masuk dengan Google
</Button>
```

**Konfigurasi per Platform**:
- **Web (Netlify)**: `@react-oauth/google` langsung, redirect ke `/api/auth/callback`
- **Desktop (Tauri)**: Browser eksternal → deep link `myapp://auth?token=xxx` via `tauri-plugin-deep-link`, token disimpan via `tauri-plugin-store`
- **Android (Tauri)**: Chrome Custom Tabs → App Links via `assetlinks.json` di `/.well-known/`
- **iOS (Tauri)**: SFSafariViewController → Universal Links via `apple-app-site-association`

**Aturan Kritis**:
- Semua secret (Xendit, Google, Cloudinary, DATABASE_URL, Aiven CA Cert) **hanya di Netlify**
- Tauri hanya boleh hit endpoint `NEXT_PUBLIC_API_URL`
- Data transaksi finansial wajib **write-through** langsung ke Aiven, tidak boleh di-cache
- Dilarang menggunakan komponen `<GoogleLogin />` bawaan — wajib Fluent UI Button
- Token yang diterima Tauri wajib disimpan via `tauri-plugin-store`, bukan `localStorage`
- Semua redirect URI wajib didaftarkan di Google OAuth Console

---

## Lampiran: Glosarium Umum
- **Unit/Organisasi**: Struktur pengelompokan pengguna atau data.
- **Hierarki Kriteria**: Tingkatan data yang berjenjang.
- **Siklus Proses**: Tahapan rutin dalam manajemen tugas atau mutu.
- **Autentikasi Hybrid**: Sistem masuk yang mendukung berbagai sumber identitas.