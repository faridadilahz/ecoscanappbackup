import 'package:flutter/material.dart';
import 'panduan_interaktif_pindai.dart';

class DetailKaryaPage extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String estimation;
  final String description;
  final List<String> toolsAndMaterials;
  final List<String> steps;
  final String imageUrl;

  const DetailKaryaPage({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    required this.estimation,
    required this.description,
    required this.toolsAndMaterials,
    required this.steps,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF17AC64);

    final List<Map<String, dynamic>> mappedTools = this.toolsAndMaterials.map((tool) {
      IconData icon = Icons.build_rounded;
      final t = tool.toLowerCase();
      if (t.contains('gunting') || t.contains('cutter') || t.contains('potong')) {
        icon = Icons.content_cut_rounded;
      } else if (t.contains('cat') || t.contains('warna') || t.contains('lukis')) {
        icon = Icons.format_color_fill_rounded;
      } else if (t.contains('botol') || t.contains('plastik') || t.contains('wadah') || t.contains('kaleng') || t.contains('kardus') || t.contains('gelas')) {
        icon = Icons.delete_outline_rounded;
      } else if (t.contains('pensil') || t.contains('pena') || t.contains('spidol') || t.contains('gambar') || t.contains('tulis')) {
        icon = Icons.edit_rounded;
      } else if (t.contains('lem') || t.contains('perekat') || t.contains('selotip') || t.contains('perekat')) {
        icon = Icons.bolt;
      }
      return {"icon": icon, "label": tool};
    }).toList();

    final List<Map<String, dynamic>> toolsAndMaterials = mappedTools;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Gambar Dinamis (Mengikuti yang di-klik pengguna)
            Stack(
              children: [
                SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 48,
                          ),
                        ),
                      );
                    },
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
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category,
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
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            estimation,
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
                  Text(
                    description,
                    style: const TextStyle(
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
                            builder: (context) => PanduanInteraktifPage(
                              title: title,
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