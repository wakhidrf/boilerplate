# Peningkatan Standar (Senior Developer & Designer) — Versi Terbaru (2025)

Dokumen ini adalah "Bridge" yang menjembatani gap antara pengetahuan model AI dengan versi library terbaru hasil eksekusi `npx npm-check-updates -u`. Gunakan panduan ini sebagai referensi utama saat mengimplementasikan fitur menggunakan stack terbaru.

## 1. Perspektif Senior Developer (Technical)

### 1.1 Next.js 16 & React 19
- **React 19 Native**: Gunakan fitur native React 19 seperti `useActionState`, `useFormStatus`, dan `useOptimistic`.
- **Caching v16**: `fetch` default ke `no-store`. Gunakan `cacheComponents: true` di `next.config.js` untuk mengaktifkan fitur caching komponen terbaru.
- **Revalidasi**: Gunakan `updateTag('tag')` di dalam Server Actions untuk memicu update visual instan setelah mutasi data.
- **Stale Times**: Gunakan `staleTimes` di layout/page untuk mengatur caching segmen client-side secara eksplisit (Next.js 15+).

### 1.2 next-safe-action v8 (Standard Schema)
- **Standard Schema**: v8 sekarang menggunakan Standard Schema. Tidak lagi menggunakan adapter internal, langsung kompatibel dengan Valibot v1+.
- **Navigation Flow**: Saat menggunakan `redirect()` di dalam action, gunakan callback `onNavigation` di hooks (`useAction`). Status akan berubah menjadi `"hasNavigated"` bukan `"hasSucceeded"`.
- **Middleware**: Gunakan `.useValidated()` untuk logic yang membutuhkan data yang sudah divalidasi (type-safe).

### 1.3 Valibot v1.4 (Modular Rewrite)
- **Pipeline API**: Gunakan `v.pipe()` untuk validasi berantai (misal: `v.string(), v.email(), v.trim()`).
- **Explicit Optional**: Gunakan `v.optional()`, `v.undefinedable()`, atau `v.nullable()` secara eksplisit. Valibot v1 memisahkan antara missing key dan undefined value.
- **Flatten Errors**: Fungsi `v.flatten()` sekarang menerima array of issues (`error.issues`), bukan lagi objek `ValiError`.

### 1.4 Drizzle ORM v0.45 & Kit 0.31
- **Relational Queries (RQB) v2**: Gunakan `defineRelations()` untuk mendefinisikan hubungan antar tabel secara deklaratif yang lebih kuat.
- **RQB findMany**: Gunakan `db.query.table.findMany({ with: { ... } })` sebagai standar utama pengambilan data relasional.

### 1.5 Tauri v2 (Stable)
- **v2 API**: Gunakan namespace `@tauri-apps/api` v2. Perubahan besar pada cara memanggil plugin (seperti `tauri-plugin-store`).
- **Capabilities**: Izin aplikasi sekarang dikelola via `src-tauri/capabilities/*.json` untuk keamanan yang lebih granular.

## 2. Perspektif Senior Designer (UI/UX)

### 2.1 Motion v12 & React 19 Performance
- **Library Package**: Wajib menggunakan `motion/react` (bukan `framer-motion`).
- **useAnimationFrame**: Gunakan `useAnimationFrame` dari `motion/react` untuk animasi yang sinkron dengan refresh rate layar untuk performa maksimal.
- **useMotionValueEvent**: Gunakan hook ini untuk memantau perubahan nilai animasi tanpa memicu re-render React yang tidak perlu.
- **React 19 Integration**: Motion v12 dioptimalkan untuk concurrent rendering React 19.

### 2.2 Micro-interactions & Polish
- **Natural Paths**: Gunakan transisi `arc()` untuk elemen yang berpindah secara non-linear.
- **Performance Tiers**: Gunakan `detect-gpu` v5 untuk deteksi hardware yang lebih akurat guna menentukan level animasi (High/Medium/Low tier).

---
*Dokumen ini diperbarui secara otomatis berdasarkan hasil audit dependensi terbaru.*
