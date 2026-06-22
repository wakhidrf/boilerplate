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
- **Controllers** (`src/controllers`): Logika bisnis, Server Actions (`next-safe-action`), Hooks kustom, dan State Management (**Zustand**).
- **Views** (`src/views`): Komponen UI Reusable. Dilarang melakukan akses database langsung.
- **Routing** (`src/app`): Folder routing yang merakit views dan memanggil controllers/data.

### 1.2 Prinsip Client vs Server Components
Secara default, seluruh komponen harus berupa **Server Components**.
- **Server**: Pengambilan data (fetching), akses database/kredensial, keamanan tinggi.
- **Client**: Interaktivitas, manajemen state lokal menggunakan `zustand`, hooks.
- **Strategi**: Minimalisir penggunaan client components dengan memindahkan interaktivitas ke komponen terkecil (*leaf components*).

### 1.3 Aturan Penamaan & Struktur (Naming Convention)
- **Files & Folders**: Wajib menggunakan `kebab-case` untuk seluruh nama file dan folder tanpa pengecualian (contoh: `hero-section.tsx`, `use-mortgage.ts`, `api-keys.ts`).
- **Tujuan**: Menghindari masalah *case-sensitivity* antar sistem operasi dan mengikuti standar profesional Google.
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
- **Aturan 50 Baris**: Setiap file **tidak boleh melebihi 50 baris kode**. Jika mendekati batas, wajib dilakukan dekomposisi menjadi sub-komponen atau utility functions.
- **Type Safety**: Gunakan tipe data eksplisit dan hindari penggunaan tipe data dinamis yang tidak terdefinisi.
- **Pembersihan Kode**: Gunakan alat linter (**Biome**) dan format otomatis secara konsisten.

### 2.2 Form & Validasi (Stack: `valibot`)
- **Validasi Ganda**: Terapkan validasi di sisi klien untuk pengalaman pengguna dan di sisi server untuk integritas data menggunakan **Valibot**.
- **Feedback**: Berikan indikator status proses (loading) dan notifikasi setelah aksi selesai.

### 2.3 Penanganan Error & Loading
- **Skeleton Screens**: Gunakan placeholder visual (shadcn/ui `Skeleton`) yang mencerminkan struktur konten selama pemuatan.
- **Error Boundaries**: Terapkan penanganan kesalahan pada level routing (`error.tsx`) untuk isolasi error.
- **404 Handling**: Gunakan `not-found.tsx` untuk respon tepat jika data tidak ditemukan.

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

### 3.2 Integrasi Layanan Eksternal
- **Keamanan Kredensial**: Kelola kunci akses melalui variabel lingkungan; jangan pernah memaparkannya di sisi klien.
- **Lapisan Layanan (Service Layer)**: Buat abstraksi khusus untuk setiap integrasi layanan pihak ketiga.

### 3.3 Integritas Data & Audit
- **Metadata Standar**: Setiap tabel wajib memiliki informasi waktu pembuatan, pembaruan, serta identitas pengubah.
- **Soft Delete**: Gunakan penghapusan logis untuk data transaksi penting agar tidak hilang dari sistem.

### 3.4 Navigasi & State (URL-First)
- **Source of Truth**: Gunakan parameter URL (Search Params) sebagai state utama untuk filter dan navigasi hierarkis.

### 3.5 Next.js Bundling & Safety (Crucial)
Untuk mencegah error *build* pada Client Components akibat dependensi modul Node.js (seperti `pg`):
- **Pemisahan Model**: Wajib memisahkan `db/` (schema & types) dari `client/` (instance & connection).
- **Client Components**: HANYA boleh mengimpor dari `@/models/db`.
- **Server Components/API Routes**: HANYA boleh mengimpor `db` (instance) dari `@/models/client`.
- **Kepatuhan**: Setiap modul baru yang berinteraksi dengan database WAJIB mematuhi pemisahan ini.

---

## 4. UI, UX, Asset & Aksesibilitas

### 4.1 Design & Asset Stack
- **Styling**: Tailwind CSS & **shadcn/ui** untuk komponen dasar.
- **Icons**: Wajib menggunakan **Remix Icons** (`react-icons/ri`) untuk konsistensi visual.
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

### 5.2 Sanitasi Konten
- Wajib mensanitasi konten dinamis menggunakan **DOMPurify** untuk mencegah celah keamanan seperti XSS.

### 5.3 Peran & Izin Akses (RBAC)
- **Matriks Akses**: Definisikan peran pengguna dan tingkat akses yang diizinkan.
- **Keamanan Antarmuka**: Sembunyikan elemen aksi atau navigasi yang tidak sesuai dengan izin akses pengguna.

---

## 6. Alur Kerja Git & Testing

### 6.1 Conventional Commits
Format pesan commit: `<type>(<scope>): <description>`
- `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

### 6.2 Strategi Testing (Playwright)
- **E2E Testing**: Fokus pada alur kritis pengguna (User Journeys).
- **Component Testing**: Simpan file spec di folder komponen terkait (`*.spec.tsx`).

---

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

---

## Lampiran: Glosarium Umum
- **Unit/Organisasi**: Struktur pengelompokan pengguna atau data.
- **Hierarki Kriteria**: Tingkatan data yang berjenjang.
- **Siklus Proses**: Tahapan rutin dalam manajemen tugas atau mutu.
- **Autentikasi Hybrid**: Sistem masuk yang mendukung berbagai sumber identitas.
