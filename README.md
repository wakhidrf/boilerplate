# Boilerplate Setup Script

Repository ini berisi skrip otomatisasi untuk mengatur standar proyek Next.js sesuai dengan SOP tim.

## Fitur
1. **Otomatisasi Folder**: Menambahkan folder `guides/` dan `scripts/`.
2. **Dokumentasi SOP**: Menyertakan `guides/SOP.md` sebagai panduan arsitektur.
3. **Project Tree Generator**: Menambahkan skrip `scripts/generate-tree.ts` untuk memantau struktur proyek.
4. **Integrasi package.json**: Menambahkan perintah `npm run gen-tree` dan menginstal dependensi `tsx`.
5. **Dukungan Proyek Baru**: Jika dijalankan di luar folder Next.js, skrip akan membantu membuat proyek baru menggunakan `create-next-app`.

## Cara Penggunaan

### Menggunakan curl (Rekomendasi)
Anda dapat menjalankan skrip ini langsung dari terminal tanpa harus mendownload file terlebih dahulu:

```bash
curl -sSL https://raw.githubusercontent.com/wakhidrf/boilerplate/main/setup.sh | bash
```

*(Catatan: Ganti URL di atas dengan link raw file `setup.sh` Anda setelah di-upload ke GitHub/Gist)*

### Menjalankan Lokal
Jika Anda sudah memiliki file `setup.sh` di komputer Anda:

1. Berikan izin eksekusi:
   ```bash
   chmod +x setup.sh
   ```
2. Jalankan skrip:
   ```bash
   ./setup.sh
   ```

## Apa yang dilakukan skrip ini?

1. **Cek Proyek**: Memeriksa apakah folder saat ini adalah proyek Next.js.
2. **Setup Baru**: Jika bukan proyek Next.js, akan menjalankan `npx create-next-app@latest` dan meminta nama proyek.
3. **Injeksi File**:
   - `guides/SOP.md`: Dokumen standar operasional prosedur.
   - `scripts/generate-tree.ts`: Script untuk generate `ProjectTree.md`.
4. **Konfigurasi**:
   - Menambahkan `"gen-tree": "tsx scripts/generate-tree.ts"` ke dalam `scripts` di `package.json`.
   - Menjalankan `npm install -D tsx`.

## Lisensi
MIT
