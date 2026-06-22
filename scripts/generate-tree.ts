import * as crypto from "node:crypto";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

// Replikasi manual __dirname agar kompatibel di scope ES Module (ESM)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

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
  isLast = true
): { treeString: string; totalLines: number } {
  let treeString = "";
  let totalLines = 0;

  if (!fs.existsSync(currentPath)) {
    return { treeString, totalLines };
  }

  const stats = fs.statSync(currentPath);
  const baseName = path.basename(currentPath);

  if (stats.isFile()) {
    const lines = countLines(currentPath);
    const marker = isLast ? "└── " : "├── ";
    return {
      treeString: `${prefix}${marker}${baseName} (${lines} lines)\n`,
      totalLines: lines,
    };
  }

  if (stats.isDirectory()) {
    // Menampilkan nama folder saat ini jika bukan root folder
    if (prefix !== "") {
      const marker = isLast ? "└── " : "├── ";
      treeString += `${prefix}${marker}${baseName}/\n`;
    }

    const items = fs.readdirSync(currentPath).sort((a, b) => {
      // Memastikan folder berada di atas file secara visual
      const statA = fs.statSync(path.join(currentPath, a)).isDirectory();
      const statB = fs.statSync(path.join(currentPath, b)).isDirectory();
      if (statA && !statB) return -1;
      if (!statA && statB) return 1;
      return a.localeCompare(b);
    });

    items.forEach((item, index) => {
      const itemPath = path.join(currentPath, item);
      const itemIsLast = index === items.length - 1;
      
      // Menentukan indentasi untuk level berikutnya
      let nextPrefix = prefix;
      if (prefix !== "") {
        nextPrefix += isLast ? "    " : "│   ";
      } else {
        // Jika ini adalah level pertama di bawah root folder (src)
        nextPrefix = ""; 
      }

      const res = generateTreeAndCount(itemPath, nextPrefix, itemIsLast);
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
  const { treeString, totalLines } = generateTreeAndCount(SRC_DIR, "", true);

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

    // Bersihkan timestamp dari perbandingan agar fokus hanya pada struktur konten Tree
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