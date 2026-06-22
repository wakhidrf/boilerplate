import * as crypto from "node:crypto";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const PROJECT_ROOT = path.join(__dirname, "..");
const OUTPUT_DIR = path.join(PROJECT_ROOT, "guides");
const OUTPUT_FILE = path.join(OUTPUT_DIR, "ProjectTree.md");

// Daftar file/folder yang diabaikan saat membuat tree
const IGNORE_LIST = new Set([
  "node_modules",
  ".next",
  ".git",
  ".vercel",
  ".DS_Store",
  ".pnp",
  ".yarn",
  "coverage",
  "out",
  "build",
  "package-lock.json",
  "next_dev.log",
]);

// Pola ekstensi file yang diabaikan
const IGNORE_EXTENSIONS = new Set([".pem", ".tsbuildinfo"]);

/**
 * Mengecek apakah sebuah item harus diabaikan.
 */
function shouldIgnore(itemName: string): boolean {
  if (IGNORE_LIST.has(itemName)) return true;
  if (itemName.startsWith(".env")) return true;
  if (itemName.endsWith("-debug.log") || itemName.includes("-debug.log"))
    return true;
  const ext = path.extname(itemName);
  if (IGNORE_EXTENSIONS.has(ext)) return true;
  return false;
}

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
 * Membuat representasi string dari isi sebuah direktori secara rekursif,
 * sekaligus menghitung total baris kode di dalamnya.
 *
 * Fungsi ini memproses *isi* dari `dirPath`, bukan `dirPath` itu sendiri.
 * Header root ditambahkan oleh pemanggil (fungsi main).
 */
function generateTreeAndCount(
  dirPath: string,
  prefix = "",
): { treeString: string; totalLines: number } {
  let treeString = "";
  let totalLines = 0;

  if (!fs.existsSync(dirPath) || !fs.statSync(dirPath).isDirectory()) {
    return { treeString, totalLines };
  }

  const items = fs
    .readdirSync(dirPath)
    .filter((item) => !shouldIgnore(item))
    .sort((a, b) => {
      // Memastikan folder berada di atas file secara visual
      const statA = fs.statSync(path.join(dirPath, a)).isDirectory();
      const statB = fs.statSync(path.join(dirPath, b)).isDirectory();
      if (statA && !statB) return -1;
      if (!statA && statB) return 1;
      return a.localeCompare(b);
    });

  items.forEach((item, index) => {
    const itemPath = path.join(dirPath, item);
    const isLast = index === items.length - 1;
    const connector = isLast ? "└── " : "├── ";
    const childPrefix = isLast ? `${prefix}    ` : `${prefix}│   `;
    const stats = fs.statSync(itemPath);

    if (stats.isDirectory()) {
      treeString += `${prefix}${connector}${item}/\n`;
      const res = generateTreeAndCount(itemPath, childPrefix);
      treeString += res.treeString;
      totalLines += res.totalLines;
    } else {
      const lines = countLines(itemPath);
      treeString += `${prefix}${connector}${item} (${lines} lines)\n`;
      totalLines += lines;
    }
  });

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
  console.log("🔍 Memeriksa perubahan struktur proyek...");

  if (!fs.existsSync(PROJECT_ROOT)) {
    console.error(`❌ Root proyek tidak ditemukan: ${PROJECT_ROOT}`);
    process.exit(1);
  }

  // 1. Generate konten Tree baru
  const rootName = path.basename(PROJECT_ROOT);
  const { treeString, totalLines } = generateTreeAndCount(PROJECT_ROOT);

  const timestamp = new Date().toLocaleString("id-ID", {
    timeZone: "Asia/Jakarta",
  });

  // Bungkus dalam format Markdown yang rapi
  const markdownContent =
    `# Project Tree\n\n` +
    `> **Terakhir Diperbarui:** ${timestamp} WIB\n` +
    `> **Total Baris Kode:** ${totalLines} baris\n\n` +
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