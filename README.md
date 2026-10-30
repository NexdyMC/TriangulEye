# TriangulEye 🎯

**TriangulEye (Calculator Stronghold)** adalah aplikasi desktop modern Windows berkinerja tinggi untuk menghitung dan melacak lokasi **Minecraft Stronghold** secara akurat menggunakan triangulasi dua lemparan *Eye of Ender*.

Dibuat menggunakan **C++20, Qt 6 (Qt Quick / QML)** untuk performa instan, konsumsi RAM yang sangat ringan, dan antarmuka gelap (*Ender Void theme*) yang responsif.

---

## ✨ Fitur Utama

- **Mode Manual:** Input koordinat `X`, `Z`, dan sudut lemparan `Angle (Yaw °)` untuk dua lemparan Eye of Ender.
- **Mode F3 + C (Speedrun Ready):** Cukup tekan `F3 + C` saat melempar Eye of Ender di Minecraft, lalu klik tombol **Paste** 1-klik di aplikasi. Parser cerdas akan mengekstrak data koordinat secara otomatis.
- **Tabel Koordinat Interaktif (Button Card):**
  - Koordinat Balok (*Block Coordinates*) Overworld & Nether.
  - Koordinat Chunk `[X, Z]` beserta posisi *in-chunk* `[0-15]`.
  - Klik langsung pada sel koordinat untuk menyalin perintah `/tp` atau koordinat portal ke Windows Clipboard.
- **Peta Radar & 8 Cincin Stronghold (2D Interactive Canvas):**
  - Visualisasi 8 Ring konsentris Stronghold (128 total struktur) sesuai mekanisme generasi Minecraft Java.
  - Navigasi layaknya mini-map: Geser (*drag*) bebas ke mana saja dan perbesar/perkecil (*zoom in/out*) dengan scroll roda mouse atau tombol kontrol floating.
  - HUD info real-time untuk memantau koordinat kursor dan nama Ring wilayah balok.
- **Native Clipboard Helper:** Integrasi clipboard native C++ untuk penyalinan instan.

---

## 🛠️ Persyaratan Sistem & Kompilasi

- **OS:** Windows 10 / 11 (64-bit)
- **Framework:** Qt 6.10+ (Qt Quick, Qt Svg)
- **Compiler:** MinGW 64-bit / MSVC
- **Build System:** CMake & Ninja

### Cara Build & Menjalankan:
```bash
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```
Atau buka proyek langsung di **Qt Creator** dan tekan `Ctrl + R`.

---

## 📄 Lisensi
Open-source under the MIT License.
