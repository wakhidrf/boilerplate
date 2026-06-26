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

summary_table_search = """| # | Kategori | Bobot Maksimal |
|---|---|---|
| A | Struktur MVC & Layer Separation | 30 poin |
| B | Naming Convention & File Structure | 25 poin |
| C | UI/UX Stack & Design System | 25 poin |
| D | State Management & Routing | 10 poin |
| E | Security, Performance & Code Quality | 10 poin |
| | **Total** | **100 poin** |"""

summary_table_replace = """| # | Kategori | Bobot Maksimal |
|---|---|---|
| A | Struktur MVC & Layer Separation | 20 poin |
| B | Naming Convention & File Structure | 15 poin |
| C | UI/UX Stack & Design System | 30 poin |
| D | State Management & Routing | 10 poin |
| E | Security, Performance & Code Quality | 25 poin |
| | **Total** | **100 poin** |"""

a_header_search = "## A — Struktur MVC & Layer Separation (30 poin)"
a_header_replace = "## A — Struktur MVC & Layer Separation (20 poin)"

# A1, A2, A3 were 10 each. Change to 7, 7, 6.
a1_search = "### A1. Model Layer (10 poin)"
a1_replace = "### A1. Model Layer (7 poin)"
a1_10_search = "| **10** |"
a1_10_replace = "| **7** |"

a2_search = "### A2. Controller Layer (10 poin)"
a2_replace = "### A2. Controller Layer (7 poin)"
a2_10_search = "| **10** |"
a2_10_replace = "| **7** |"

a3_search = "### A3. View Layer (10 poin)"
a3_replace = "### A3. View Layer (6 poin)"
a3_10_search = "| **10** |"
a3_10_replace = "| **6** |"

b_header_search = "## B — Naming Convention & File Structure (25 poin)"
b_header_replace = "## B — Naming Convention & File Structure (15 poin)"

# B1, B2, B3 were 10, 8, 7. Change to 5, 5, 5.
b1_search = "### B1. Naming & Case (10 poin)"
b1_replace = "### B1. Naming & Case (5 poin)"
b1_10_search = "| **10** | Semua file menggunakan kebab-case."
b1_10_replace = "| **5** | Semua file menggunakan kebab-case."

b2_search = "### B2. No Index Files (8 poin)"
b2_replace = "### B2. No Index Files (5 poin)"
b2_8_search = "| **8** |"
b2_8_replace = "| **5** |"

b3_search = "### B3. Path Aliases (7 poin)"
b3_replace = "### B3. Path Aliases (5 poin)"
b3_7_search = "| **7** |"
b3_7_replace = "| **5** |"

# C header already says 35 from previous script, change to 30.
c_header_search = "## C — UI/UX Stack & Design System (35 poin)"
c_header_replace = "## C — UI/UX Stack & Design System (30 poin)"

# C1:10, C2:5, C3:5, C4:10 = 30.
# C2 was 8.
c2_search = "### C2. Token System & Design Tokens (8 poin)"
c2_replace = "### C2. Token System & Design Tokens (5 poin)"
c2_8_search = "| **8** |"
c2_8_replace = "| **5** |"

# C3 was 7.
c3_search = "### C3. Animation & WebGL Compliance (7 poin)"
c3_replace = "### C3. Animation & WebGL Compliance (5 poin)"
c3_7_search = "| **7** |"
c3_7_replace = "| **5** |"

# Update Report Table
report_table_search = """| A1. Model Layer | X | 10 | ... |
| A2. Controller Layer | X | 10 | ... |
| A3. View Layer | X | 10 | ... |
| B1. Kebab-case | X | 10 | ... |
| B2. No Index Files | X | 8 | ... |
| B3. Path Aliases | X | 7 | ... |
| C1. Fluent UI Only | X | 10 | ... |
| C2. Token System | X | 8 | ... |
| C3. Animation Compliance | X | 7 | ... |
| C4. Design Quality | X | 10 | ... |
| D1. State Manager | X | 6 | ... |
| D2. Routing vs Controller | X | 4 | ... |
| E1. Security | X | 20 | ... |
| E2. Performance & Quality | X | 5 | ... |
| **TOTAL** | **XX** | **125** | |"""

report_table_replace = """| A1. Model Layer | X | 7 | ... |
| A2. Controller Layer | X | 7 | ... |
| A3. View Layer | X | 6 | ... |
| B1. Kebab-case | X | 5 | ... |
| B2. No Index Files | X | 5 | ... |
| B3. Path Aliases | X | 5 | ... |
| C1. Fluent UI Only | X | 10 | ... |
| C2. Token System | X | 5 | ... |
| C3. Animation Compliance | X | 5 | ... |
| C4. Design Quality | X | 10 | ... |
| D1. State Manager | X | 6 | ... |
| D2. Routing vs Controller | X | 4 | ... |
| E1. Security | X | 20 | ... |
| E2. Performance & Quality | X | 5 | ... |
| **TOTAL** | **XX** | **100** | |"""

with open(rules_path, 'r') as f:
    content = f.read()

content = content.replace(summary_table_search, summary_table_replace)
content = content.replace(a_header_search, a_header_replace)
content = content.replace(a1_search, a1_replace)
content = content.replace(a2_search, a2_replace)
content = content.replace(a3_search, a3_replace)
content = content.replace(b_header_search, b_header_replace)
content = content.replace(b1_search, b1_replace)
content = content.replace(b2_search, b2_replace)
content = content.replace(b3_search, b3_replace)
content = content.replace(c_header_search, c_header_replace)
content = content.replace(c2_search, c2_replace)
content = content.replace(c3_search, c3_replace)
content = content.replace(report_table_search, report_table_replace)

# Fix sub-points (specific scores)
# This is tricky because | **10** | might appear multiple times.
# I will use more specific patterns.

content = content.replace("### A1. Model Layer (7 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **10** |", "### A1. Model Layer (7 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **7** |")
content = content.replace("### A2. Controller Layer (7 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **10** |", "### A2. Controller Layer (7 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **7** |")
content = content.replace("### A3. View Layer (6 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **10** |", "### A3. View Layer (6 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **6** |")

content = content.replace("### B2. No Index Files (5 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **8** |", "### B2. No Index Files (5 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **5** |")
content = content.replace("### B3. Path Aliases (5 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **7** |", "### B3. Path Aliases (5 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **5** |")

content = content.replace("### C2. Token System & Design Tokens (5 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **8** |", "### C2. Token System & Design Tokens (5 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **5** |")
content = content.replace("### C3. Animation & WebGL Compliance (5 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **7** |", "### C3. Animation & WebGL Compliance (5 poin)\n\n| Skor | Kondisi |\n|---|---|\n| **5** |")


with open(rules_path, 'w') as f:
    f.write(content)

print("Weights re-normalized to 100")
