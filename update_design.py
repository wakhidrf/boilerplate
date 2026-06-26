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

design_path = 'guides/Design.md'

search1 = """### 21.10 Accessibility & Reduced Motion"""
replace1 = """### 21.10 Accessibility (WCAG AA Compliance) & Reduced Motion

Setiap komponen WAJIB memenuhi standar WCAG AA:
- **Interactive Elements**: Minimal target sentuh 44x44px.
- **Color Contrast**: Rasio minimal 4.5:1 untuk teks normal dan 3:1 untuk teks besar.
- **Focus Indicators**: Wajib terlihat jelas dan tidak boleh dihilangkan (`outline: none` dilarang tanpa pengganti).
- **Alt Text**: Semua image/ilustrasi non-dekoratif wajib memiliki alt text deskriptif.
- **Empty States**: Setiap list, tabel, atau dashboard wajib memiliki desain *empty state* yang informatif (ilustrasi + teks ajakan aksi).

### 21.11 Voice & Tone per Nuansa

Setiap nuansa memiliki kepribadian (persona) yang tercermin dalam teks (copywriting):

| Nuansa | Voice | Tone | Contoh |
|---|---|---|---|
| Modern | Profesional | Efisien, langsung | "Data Anda telah disimpan." |
| Cyberpunk | Futuristik | Provokatif, neon-vibes | "System override: Data uplink secured." |
| Nature | Organik | Menenangkan, ramah | "Bibit data Anda sudah kami tanam." |
| Oldstyle | Klasik | Formal, sopan | "Dengan hormat, data telah tercatat." |"""

if apply_patch(design_path, search1, replace1):
    print("Design patch applied successfully")
else:
    sys.exit(1)
