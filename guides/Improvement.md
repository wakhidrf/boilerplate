# Peningkatan Standar (Senior Developer & Designer)

Dokumen ini berfungsi sebagai jembatan antara panduan yang ada di `SOP.md` dan `Design.md` dengan praktik terbaik terbaru dari library versi terkini (Next.js 15, Tauri v2, next-safe-action v7, dll).

## 1. Perspektif Senior Developer (Technical)

### 1.1 Next.js 15 & React 19
- **Caching Default**: `fetch` sekarang default ke `no-store`. Jika membutuhkan caching, wajib menggunakan `cache: 'force-cache'` secara eksplisit.
- **Metadata API**: Gunakan `'use cache'` di dalam `generateMetadata` untuk data yang tidak berubah di runtime agar tetap bisa di-prerender.
- **Server Actions**: Gunakan `revalidateTag('tag', 'max')` untuk behavior stale-while-revalidate yang lebih optimal.

### 1.2 next-safe-action v7
- **Middleware**: Gunakan `.useValidated()` untuk logika yang membutuhkan data yang sudah divalidasi (misal: pengecekan kepemilikan resource berdasarkan ID yang diinput).
- **Client Hooks**: Gunakan `useOptimisticAction` untuk update UI instan. Untuk form, gunakan adapter `@next-safe-action/adapter-react-hook-form`.
- **Validation**: Integrasi Valibot tetap direkomendasikan karena bundle size yang kecil.

### 1.3 Drizzle ORM (v0.31+)
- **Relational Queries (RQB)**: Gunakan `db.query.tableName.findMany({ with: { ... } })` untuk pengambilan data relasional yang lebih intuitif dibanding join manual.
- **Relations Definition**: Gunakan `relations()` atau `defineRelations()` untuk mendefinisikan hubungan antar tabel secara deklaratif di schema.

### 1.4 Zustand v5
- **Persist Middleware**: State awal tidak lagi otomatis disimpan ke storage saat pembuatan store. Panggil `setState` secara eksplisit jika ingin melakukan persist pada nilai awal yang dinamis.
- **React 18/19**: Pastikan `use-sync-external-store` tersedia sebagai peer dependency.

### 1.5 Tauri v2 (Stable)
- **Mobile Support**: Konfigurasi `capabilities.json` untuk izin spesifik platform (Android/iOS).
- **Deep Linking**: Gunakan `tauri-plugin-deep-link` untuk menangani OAuth redirect di desktop dan mobile.
- **Persistence**: Gunakan `tauri-plugin-store` v2 dengan `autoSave` yang dikonfigurasi (default 100ms).

## 2. Perspektif Senior Designer (UI/UX)

### 2.1 Motion (v12) & React 19
- **Library Transition**: Pastikan menggunakan `motion/react` bukan `framer-motion` (rebranding).
- **Scroll-Driven Animation**: Gunakan `useScroll` dan `whileInView` dengan `amount` prop untuk kontrol trigger yang lebih presisi.
- **Performance**: Manfaatkan `frame.render` (sebelumnya `sync`) untuk manipulasi DOM di luar cycle render React demi performa 60fps yang stabil.

### 2.2 Design System & Accessibility
- **Reduced Motion**: Wajib mengimplementasikan `useReducedMotion` di level root atau komponen berat untuk mematuhi preferensi sistem pengguna.
- **Micro-interactions**: Gunakan `arc()` transition untuk path pergerakan yang lebih natural (curved) pada elemen UI tertentu.
- **Consistency**: Pastikan Fluent Icons digunakan secara konsisten dan semua elemen interaktif memiliki visible focus indicator yang sesuai dengan nuansa aktif.

---
*Catatan: Gunakan `npx npm-check-updates -u` secara berkala untuk menjaga dependensi tetap di versi terbaru.*
