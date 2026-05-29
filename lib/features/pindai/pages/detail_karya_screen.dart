import 'package:flutter/material.dart';
import 'panduan_interaktif_pindai.dart';

class DetailKaryaPage extends StatelessWidget {
  // 1. TAMBAHKAN VARIABEL UNTUK MENAMPUNG URL GAMBAR DINAMIS
  final String imageUrl;

  // 2. PASANGKAN DI CONSTRUCTOR (Hapus kata const paling depan karena nilainya dinamis)
  const DetailKaryaPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF17AC64);

    // DATA ALAT DAN BAHAN (Disesuaikan persis dengan gambar mockup)
    final List<Map<String, dynamic>> toolsAndMaterials = [
      {"icon": Icons.content_cut_rounded, "label": "Gunting/\nCutter"},
      {"icon": Icons.format_color_fill_rounded, "label": "Cat Akrilik"},
      {"icon": Icons.delete_outline_rounded, "label": "1 Botol\nPlastik"},
      {"icon": Icons.edit_rounded, "label": "Pensil"},
    ];

    // DATA CARA MEMBUAT
    final List<String> steps = [
      "Menggambar pola pada botol bekas yang akan kamu buat. Kamu bisa menggambar hewan, bunga, atau beberapa buah-buahan.",
      "Kemudian gambar sesuka hati kamu, lalu potong mengikuti pola gambaran pada botol.",
      "Kemudian siapkan cat akrilik, lalu warnai semua botol yang sudah digambar dengan warna dasar seperti putih.",
      "Selanjutnya, kamu dapat mewarnai sesuai dengan karakter yang kamu buat, sesuaikan dengan gambaran serta pola yang sudah ada di botol sesuka hati.",
      "Jika sudah diwarnai, keringkan botol agar cat tidak luntur.",
      "Botol bekas sudah siap dijadikan sebagai pot bunga yang cantik."
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Gambar Dinamis (Mengikuti yang di-klik pengguna)
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration( // Hapus const di sini karena memakai variabel imageUrl
                    image: DecorationImage(
                      // 3. GANTI URL STATIS DENGAN VARIABEL imageUrl
                      image: NetworkImage(imageUrl), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Tombol Back Bulat Putih
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: primaryGreen,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Area Konten Utama
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul, Kategori, Harga, dan Status (Sesuai Gambar Mockup)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pot Tanaman Kucing',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Botol plastik • PET",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Rp10.000",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Mudah • 10-15 menit",
                            style: TextStyle(
                              fontSize: 13,
                              color: primaryGreen,
                              fontWeight: FontWeight.w600,
                             ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi Meowholder (Sesuai teks gambar mockup)
                  const Text(
                    "Meowholder adalah tempat pensil berbahan dasar botol plastik bekas yang dirancangkan menyerupai tubuh kucing. Desainnya unik karena tidak hanya berfungsi sebagai tempat penyimpanan alat tulis, tetapi juga memiliki bentuk yang lucu dan menarik sehingga dapat mempercantik meja belajar.",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section Alat dan Bahan (4 Box Grid sesuai gambar mockup)
                  const Text(
                    "Alat dan Bahan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: toolsAndMaterials.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85, 
                    ),
                    itemBuilder: (context, index) {
                      final item = toolsAndMaterials[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12.withOpacity(0.06),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item["icon"] as IconData,
                              color: primaryGreen,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item["label"].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Section Video Tutorial (Banner Gambar juga disesuaikan)
                  const Text(
                    "Video Tutorial",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            // 4. BIAR SERASI, GAMBAR BANNER VIDEO JUGA BISA PAKAI imageUrl
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text(
                          "Lihat di YouTube",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section Cara Membuat
                  const Text(
                    "Cara Membuat",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: steps.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                                height: 1.4,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                steps[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Tombol Aksi Utama Paling Bawah
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PanduanInteraktifPage(
                              title: 'Pot Tanaman Kucing',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Mulai panduan interaktif",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}