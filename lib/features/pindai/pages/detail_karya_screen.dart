import 'package:flutter/material.dart';
import 'panduan_interaktif_pindai.dart';

class DetailKaryaPage extends StatelessWidget {
  const DetailKaryaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menyelaraskan warna hijau utama dengan eksplor_detail_page.dart (0xFF17AC64)
    final Color primaryGreen = const Color(0xFF17AC64);

    // Menyesuaikan struktur data alat dan bahan agar bisa dirender dalam bentuk Grid 4 box
    final List<Map<String, dynamic>> toolsAndMaterials = [
      {"icon": Icons.content_cut_rounded, "label": "Gunting"},
      {"icon": Icons.brush_rounded, "label": "Cat Warna"},
      {"icon": Icons.opacity_rounded, "label": "Lem Glue"},
      {"icon": Icons.layers_rounded, "label": "Aksesoris"},
    ];

    // Mengubah data teks cara membuat menjadi List agar bisa dirender dengan format nomor terpisah
    final List<String> steps = [
      "Potong bagian tengah botol plastik bekas menjadi dua bagian menggunakan gunting.",
      "Cat permukaan luar botol dengan warna dasar kesukaanmu, lalu tunggu hingga kering.",
      "Gambar pola wajah hewan lucu atau pasang aksesoris pelengkap di pinggirannya.",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Menggunakan Stack Gambar Penuh ke Atas (Meniru gaya eksplor_detail_page)
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1605721911519-3dfeb3be25e7?w=500',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Tombol Back Bulat Putih khas layout kamu
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

            // 2. Area Konten Utama
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dan Detail Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pot Tanaman',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Daur Ulang Plastik • PET",
                              style: const TextStyle(
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
                            "Rp2.000",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Mudah • 15-30 Menit",
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

                  // Teks Deskripsi Singkat Karya
                  const Text.rich(
                    TextSpan(
                      text:
                          "Ubah botol plastik bekas menjadi pot tanaman yang fungsional sekaligus estetik. Selain mengurangi limbah plastik di lingkungan rumah, aktivitas ini juga melatih kreativitas dalam mewarnai dan membentuk karakter pot sesuai keinginan.",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Section Alat dan Bahan (Menggunakan GridView 4 Box Bulat Kotak)
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
                      childAspectRatio: 1,
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
                            const SizedBox(height: 12),
                            Text(
                              item["label"].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black38,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 4. Section Video Tutorial
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
                            image: const NetworkImage(
                              'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=500',
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.15),
                              BlendMode.darken,
                            ),
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

                  // 5. Section Cara Membuat (Dipisah baris nomornya pakai ListView.builder)
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

                  // 6. Tombol Aksi Utama Paling Bawah
                  SizedBox(
  width: double.infinity,
  height: 48,
  child: ElevatedButton(
    onPressed: () {
      // Menambahkan navigasi pindah halaman saat tombol di klik
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PanduanInteraktifPage(
            title: 'Pot Tanaman', // Mengirim data title karya
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
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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