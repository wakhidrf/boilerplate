import sys

def apply_patch(filepath, search_text, replace_text):
    with open(filepath, 'r') as f:
        content = f.read()
    if search_text not in content:
        print(f"Error: Search text not found in {filepath}")
        return False
    new_content = content.replace(search_text, replace_text)
    with open(filepath, 'w') as f:
        f.write(new_content)
    return True

sop_path = 'guides/SOP.md'

search1 = """- **Views** (`src/views`): Komponen UI Reusable. Dilarang melakukan akses database langsung."""
replace1 = """- **Views** (`src/views`): Komponen UI Reusable. Secara default dilarang melakukan akses database langsung jika komponen bersifat *pure reusable UI*. Namun, **Feature Views** atau **Layout Containers** di dalam folder ini diperbolehkan berupa Async Server Components yang melakukan direct fetch atau database access via Drizzle untuk kemudahan komposisi (Next.js App Router pattern)."""

search2 = """### 5.6 CSRF Protection
- Semua mutasi data via form wajib memverifikasi bahwa request berasal dari origin yang sah.
- Gunakan origin check di Server Actions: cocokkan header `Origin` / `Referer` dengan `NEXT_PUBLIC_API_URL`. Jika tidak cocok → tolak dengan `403`.
- `next-safe-action` wajib dikombinasikan dengan pengecekan origin ini untuk semua aksi yang bersifat mutasi."""
replace2 = """### 5.6 CSRF Protection
- Semua mutasi data via form wajib memverifikasi bahwa request berasal dari origin yang sah.
- Gunakan origin check di Server Actions: cocokkan header `Origin` / `Referer` dengan `NEXT_PUBLIC_API_URL`. Jika tidak cocok → tolak dengan `403`.
- **Implementasi**: Wajib menggunakan middleware `next-safe-action` untuk melakukan pengecekan ini secara terpusat pada `actionClient`.
- `next-safe-action` wajib dikombinasikan dengan pengecekan origin ini untuk semua aksi yang bersifat mutasi."""

if apply_patch(sop_path, search1, replace1) and apply_patch(sop_path, search2, replace2):
    print("Patch applied successfully")
else:
    sys.exit(1)
