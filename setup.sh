#!/bin/bash

# Function to apply boilerplate changes
apply_boilerplate() {
  echo "🚀 Applying boilerplate to $(pwd)..."

  # Create directories
  mkdir -p guides scripts

  # Create guides/SOP.md
  echo "📝 Creating guides/SOP.md..."
  cat << 'EOF' > guides/SOP.md
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
EOF

  # Create scripts/generate-tree.ts
  echo "📜 Creating scripts/generate-tree.ts..."
  cat << 'EOF' > scripts/generate-tree.ts
import * as crypto from "node:crypto";
import * as fs from "node:fs";
import * as path from "node:path";

// Konfigurasi Jalur Folder
const SRC_DIR = path.join(__dirname, "../src");
const OUTPUT_DIR = path.join(__dirname, "../guides");
const OUTPUT_FILE = path.join(OUTPUT_DIR, "ProjectTree.md");

/**
 * Menghitung jumlah baris dalam sebuah file secara sinkronus.
 */
function countLines(filePath: string): number {
  try {
    const content = fs.readFileSync(filePath, "utf-8");
    // Menangani berbagai jenis line endings (LF atau CRLF)
    return content.split(/\r?\n/).length;
  } catch (_error) {
    return 0;
  }
}

/**
 * Membuat representasi string dari struktur direktori secara rekursif
 * sekaligus menghitung total baris kode di dalamnya.
 */
function generateTreeAndCount(
  currentPath: string,
  prefix = "",
): { treeString: string; totalLines: number } {
  let treeString = "";
  let totalLines = 0;

  if (!fs.existsSync(currentPath)) {
    return { treeString, totalLines };
  }

  const stats = fs.statSync(currentPath);

  if (stats.isFile()) {
    const lines = countLines(currentPath);
    const fileName = path.basename(currentPath);
    return {
      treeString: `${prefix}├── ${fileName} (${lines} lines)\n`,
      totalLines: lines,
    };
  }

  if (stats.isDirectory()) {
    const dirName = path.basename(currentPath);
    treeString += `${prefix}└── ${dirName}/\n`;

    const items = fs.readdirSync(currentPath).sort((a, b) => {
      // Memastikan folder berada di atas file secara visual
      const statA = fs.statSync(path.join(currentPath, a)).isDirectory();
      const statB = fs.statSync(path.join(currentPath, b)).isDirectory();
      if (statA && !statB) return -1;
      if (!statA && statB) return 1;
      return a.localeCompare(b);
    });

    items.forEach((item) => {
      const itemPath = path.join(currentPath, item);
      const res = generateTreeAndCount(itemPath, `${prefix}    `);
      treeString += res.treeString;
      totalLines += res.totalLines;
    });
  }

  return { treeString, totalLines };
}

/**
 * Menghitung MD5 Hash dari sebuah string untuk validasi perubahan.
 */
function calculateHash(content: string): string {
  return crypto.createHash("md5").update(content).digest("hex");
}

/**
 * Fungsi Utama Eksekusi
 */
function main() {
  console.log("🔍 Memeriksa perubahan struktur di folder src...");

  if (!fs.existsSync(SRC_DIR)) {
    console.error(`❌ Folder sumber tidak ditemukan: ${SRC_DIR}`);
    process.exit(1);
  }

  // 1. Generate konten Tree baru
  const rootName = path.basename(SRC_DIR);
  const { treeString, totalLines } = generateTreeAndCount(SRC_DIR);

  const timestamp = new Date().toLocaleString("id-ID", {
    timeZone: "Asia/Jakarta",
  });

  // Bungkus dalam format Markdown yang rapi
  const markdownContent =
    `# Project Tree\n\n` +
    `> **Terakhir Diperbarui:** ${timestamp} WIB\n` +
    `> **Total Baris Kode (` +
    "`src/`" +
    `):** ${totalLines} baris\n\n` +
    `\`\`\`text\n` +
    `${rootName}/\n` +
    `${treeString}` +
    `\`\`\`\n`;

  // Buat folder tujuan jika belum ada
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  // 2. Strategi Update Pintar (Smart Update)
  let shouldWrite = true;

  if (fs.existsSync(OUTPUT_FILE)) {
    const existingContent = fs.readFileSync(OUTPUT_FILE, "utf-8");

    // Karena timestamp pasti berubah setiap kali dijalankan, kita bersihkan timestamp/meta
    // dari perbandingan agar fokus hanya pada struktur konten Tree dan jumlah barisnya.
    const extractCore = (text: string) => {
      const match = text.match(/```text([\s\S]*?)```/);
      return match ? match[1].trim() : text;
    };

    const oldCoreHash = calculateHash(extractCore(existingContent));
    const newCoreHash = calculateHash(extractCore(markdownContent));

    if (oldCoreHash === newCoreHash) {
      shouldWrite = false;
    }
  }

  // 3. Tulis file jika ada perubahan materiil
  if (shouldWrite) {
    fs.writeFileSync(OUTPUT_FILE, markdownContent, "utf-8");
    console.log(`✅ ProjectTree.md berhasil diperbarui di: ${OUTPUT_FILE}`);
  } else {
    console.log(
      "ℹ️ Tidak ada perubahan pada struktur atau baris kode. ProjectTree.md tetap dipertahankan.",
    );
  }
}

main();
EOF

  # Update package.json scripts
  echo "📦 Updating package.json scripts..."
  if command -v npm >/dev/null 2>&1; then
    npm pkg set scripts.gen-tree="tsx scripts/generate-tree.ts"
    echo "⚙️ Added 'gen-tree' script to package.json."
    
    echo "📥 Installing tsx as a dev dependency..."
    npm install -D tsx
  else
    echo "❌ npm not found. Please manually add 'gen-tree': 'tsx scripts/generate-tree.ts' to your package.json and install 'tsx'."
  fi

  echo "✅ Boilerplate applied successfully!"
}

# Main logic
if [ -f "package.json" ] && grep -q '"next":' "package.json"; then
  echo "✅ Detected existing Next.js project."
  apply_boilerplate
else
  echo "✨ No Next.js project detected. Creating a new one..."
  
  # Prompt for project name
  read -p "Enter project name: " PROJECT_NAME
  
  if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Project name cannot be empty."
    exit 1
  fi

  # Run create-next-app
  echo "🛠️ Running npx create-next-app@latest $PROJECT_NAME..."
  npx create-next-app@latest "$PROJECT_NAME"

  # Check if directory exists and enter it
  if [ -d "$PROJECT_NAME" ]; then
    cd "$PROJECT_NAME"
    apply_boilerplate
  else
    echo "❌ Failed to create or find project directory: $PROJECT_NAME"
    exit 1
  fi
fi
