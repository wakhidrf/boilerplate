import sys

def replace_content(filepath, search_text, replace_text):
    with open(filepath, 'r') as f:
        content = f.read()
    if search_text not in content:
        print(f"Error: Search text not found in {filepath}")
        return False
    new_content = content.replace(search_text, replace_text)
    with open(filepath, 'w') as f:
        f.write(new_content)
    return True

rules_path = 'guides/Rules.md'

# 1. Update Mode Scoring
mode_intro = """# Sistem Skoring Kepatuhan AI (Compliance Scoring)

Sistem ini digunakan untuk mengevaluasi apakah sebuah **Plan** (sebelum eksekusi) atau **Kode** (sesudah eksekusi) memenuhi standar SOP dan Design yang telah ditetapkan.

### Mode Skoring:
1.  **Pre-execution (Plan Evaluation)**: Mengevaluasi niat, pemilihan library, dan struktur yang direncanakan. Fokus pada arsitektur.
2.  **Post-execution (Code Evaluation)**: Mengevaluasi implementasi nyata, kebersihan kode, dan detail fungsional."""

# 2. Update Section A (A3 View Layer)
section_a3_search = """| **0** | Melakukan akses database/fetching langsung di View layer. |"""
section_a3_replace = """| **0** | Melakukan akses database/fetching di View layer yang seharusnya *pure reusable UI* (kecuali Async Server Component yang berfungsi sebagai Feature View/Container). |"""

# 3. Update Section C (UI/UX)
section_c_search = """## C — UI/UX Stack & Design System (25 poin)

Evaluasi apakah plan menggunakan stack UI/UX yang benar sesuai SOP 4.1 dan seluruh `Design.md`.

### C1. Fluent UI sebagai Satu-satunya Design System (10 poin)"""
section_c_replace = """## C — UI/UX Stack & Design System (35 poin)

Evaluasi apakah plan menggunakan stack UI/UX yang benar sesuai SOP dan seluruh `Design.md`.

### C1. Fluent UI sebagai Satu-satunya Design System (10 poin)"""

section_c3_search = """**Larangan keras (langsung 0 untuk C3)**:
- `import { motion } from "framer-motion"` — wajib dari `motion/react`
- Three.js, `animejs` masuk main bundle (bukan lazy import)
- WebGL tanpa fallback CSS untuk GPU tier rendah
- Lenis aktif di halaman form/checkout/payment
- Animasi properti selain `transform` dan `opacity`
- Tidak ada `useReducedMotion()` di komponen animasi"""
section_c3_replace = """**Larangan keras (langsung 0 untuk C3)**:
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
| **0** | Tidak ada empty state, melanggar standar aksesibilitas dasar, atau tone bahasa asal-asalan. |"""

# 4. Update Section E (Security) - Make it blocking and more weight
section_e_search = """## E — Security, Performance & Code Quality (10 poin)

### E1. Security Essentials (5 poin)

| Skor | Kondisi |
|---|---|
| **5** | `next-safe-action` di semua mutasi. DOMPurify untuk konten dinamis di client. Rate limiting via `@upstash/ratelimit`. CSRF check di Server Actions. Xendit webhook dengan signature verification. |
| **3** | Sebagian besar ada, tapi 1 aspek keamanan yang terlewat (misal: tidak ada rate limiting atau CSRF check). |
| **0** | Tidak ada validasi server-side, atau mutasi tanpa `next-safe-action`, atau Xendit webhook tanpa verifikasi signature. |"""
section_e_replace = """## E — Security, Performance & Code Quality (25 poin)

### E1. Security Essentials (20 poin) — [BLOCKING CATEGORY]

| Skor | Kondisi |
|---|---|
| **20** | `next-safe-action` di semua mutasi + CSRF middleware. DOMPurify di client. Rate limiting aktif. Xendit webhook signature verified. |
| **10** | Keamanan dasar ada, tapi ada celah minor (misal: rate limiting kurang ketat). |
| **0** | **CRITICAL FAILURE**: Tidak ada validasi server-side, mutasi tanpa `next-safe-action`, atau webhook tanpa verifikasi. |

*Catatan: Skor 0 di E1 otomatis membuahkan verdict REJECT meskipun total skor tinggi.*"""

# 5. Update Verdict & Actions
verdict_search = """## Verdict & Tindakan

| Total Skor | Verdict | Tindakan AI |
|---|---|---|
| **90–100** | ✅ **APPROVED** | Lanjutkan eksekusi plan. Catat skor di memory log. |
| **75–89** | ⚠️ **CONDITIONAL** | Lanjutkan dengan catatan. Sebutkan poin yang kurang dan komitmen perbaikan. Catat di log. |
| **50–74** | 🔄 **REVISE** | Hentikan. Revisi plan dulu sebelum eksekusi. Buat draf revisi dan minta persetujuan User. |
| **< 50** | 🚫 **REJECT** | Tolak plan. Jelaskan bagian yang melanggar SOP/Design dan susun ulang plan dari awal. |"""
verdict_replace = """## Verdict & Tindakan

| Total Skor | Verdict | Tindakan AI |
|---|---|---|
| **90–100** | ✅ **APPROVED** | Lanjutkan eksekusi plan. Catat skor di memory log. |
| **75–89** | ⚠️ **CONDITIONAL** | Lanjutkan dengan catatan. Sebutkan poin yang kurang dan komitmen perbaikan. Catat di log. |
| **50–74** | 🔄 **REVISE** | Hentikan. Revisi plan dulu sebelum eksekusi. Buat draf revisi dan minta persetujuan User. |
| **< 50** | 🚫 **REJECT** | Tolak plan. Jelaskan bagian yang melanggar SOP/Design dan susun ulang plan dari awal. |

**Kondisi Khusus**: Jika Skor E1 (Security) adalah **0**, verdict otomatis menjadi **REJECT**."""

# 6. Add Override and Fast Path
additional_search = """## Catatan Maintenance Rules.md"""
additional_replace = """## Mekanisme "Override dengan Alasan"

Jika AI merasa perlu melanggar aturan (misal: file > 200 baris demi kohesi schema), AI wajib mencantumkan alasan di kolom "Catatan" pada Laporan Skoring. Jika User menyetujui, skor untuk poin tersebut dianggap penuh (Override Approved).

---

## Fast Path Reporting (Minor Changes)

Untuk perubahan kecil (perbaikan typo, update teks, perubahan warna minor), AI tidak perlu tabel lengkap. Gunakan format singkat:
`[FAST PATH] Compliance: PASSED (Security & SOP Checked)`

---

## Catatan Maintenance Rules.md"""

with open(rules_path, 'r') as f:
    content = f.read()

# Apply Mode Intro
content = mode_intro + "\n\n" + content

# Apply replacements
content = content.replace(section_a3_search, section_a3_replace)
content = content.replace(section_c_search, section_c_replace)
content = content.replace(section_c3_search, section_c3_replace)
content = content.replace(section_e_search, section_e_replace)
content = content.replace(verdict_search, verdict_replace)
content = content.replace(additional_search, additional_replace)

# Update Format Laporan Skoring table to reflect new points
content = content.replace("| C3. Animation Compliance | X | 7 | ... |", "| C3. Animation Compliance | X | 7 | ... |\n| C4. Design Quality | X | 10 | ... |")
content = content.replace("| E1. Security | X | 5 | ... |", "| E1. Security | X | 20 | ... |")
content = content.replace("| **TOTAL** | **XX** | **100** | |", "| **TOTAL** | **XX** | **125** | |")

with open(rules_path, 'w') as f:
    f.write(content)

print("Rules overhaul applied successfully")
