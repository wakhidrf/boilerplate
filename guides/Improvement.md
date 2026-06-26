# Improvement Log — Senior Developer & Designer Standards

Dokumen ini mencatat perbaikan yang dilakukan pada sistem boilerplate (SOP, Design, Rules) berdasarkan feedback dari "Senior Developer & Designer". Perbaikan ini memastikan sistem lebih realistis, aman, dan fleksibel.

## 1. Pemisahan Mode Skoring (Pre vs Post Execution)
**Masalah**: Skoring awal tidak membedakan antara evaluasi "plan" dan "kode nyata".
**Solusi**: `Rules.md` kini memiliki dua mode:
- **Pre-execution**: Digunakan saat AI menyusun rencana kerja (evaluasi niat & arsitektur).
- **Post-execution**: Digunakan setelah kode selesai ditulis (evaluasi implementasi & kebersihan).

## 2. Peningkatan Bobot Keamanan (Blocking Security)
**Masalah**: Keamanan (E1) hanya berbobot 5 poin, tidak sebanding dengan resikonya.
**Solusi**:
- Bobot **E1. Security Essentials** dinaikkan dari 5 menjadi **20 poin**.
- Kategori E1 kini bersifat **BLOCKING**. Jika skor E1 adalah **0**, verdict otomatis menjadi **REJECT** meskipun skor kategori lain sempurna.
- Penambahan verifikasi CSRF via middleware `next-safe-action` sebagai standar wajib di `SOP.md`.

## 3. Klarifikasi Ambiguous Case (Server Components in Views)
**Masalah**: Larangan fetch di View bertentangan dengan pola Next.js App Router yang umum menggunakan Async Server Components.
**Solusi**: `SOP.md` dan `Rules.md` diperbarui untuk mengizinkan **Feature Views** atau **Layout Containers** di dalam `src/views/` sebagai Async Server Components yang melakukan direct fetch/DB access, selama tetap menjaga prinsip komposisi.

## 4. Standar Kualitas Desain & Aksesibilitas
**Masalah**: Evaluasi UI/UX terlalu fokus pada library (Fluent UI), bukan kualitas desain aktual.
**Solusi**:
- Menambahkan kriteria **C4. Design Quality & Accessibility** (10 poin) di `Rules.md`.
- Memperbarui `Design.md` dengan standar wajib:
  - **WCAG AA Compliance**: Kontras warna, target sentuh minimal, dan visible focus indicators.
  - **Empty States**: Wajib ada desain untuk kondisi data kosong di setiap list/tabel.
  - **Voice & Tone**: Copywriting harus mengikuti kepribadian nuansa yang dipilih (Modern, Cyberpunk, Nature, Oldstyle).

## 5. Mekanisme "Override dengan Alasan"
**Masalah**: Aturan kaku (seperti limit 200 baris) bisa merusak kohesi kode dalam kasus tertentu.
**Solusi**: AI kini diperbolehkan melanggar aturan tertentu jika ada alasan valid (misal: skema Valibot yang sangat kompleks). Alasan harus dicantumkan dalam laporan skoring dan disetujui oleh User.

## 6. Fast Path untuk Perubahan Minor
**Masalah**: Laporan skoring tabel 13 baris terlalu berat untuk perubahan kecil.
**Solusi**: Menambahkan format **[FAST PATH]** untuk perubahan minor (typo, update teks, warna minor) agar workflow tetap gesit tanpa meninggalkan prinsip kepatuhan.

---
*Status: Semua perbaikan telah diterapkan pada SOP.md, Design.md, dan Rules.md sesuai stack terbaru di package.json.*
