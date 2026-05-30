import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecoscan/providers/history_provider.dart';

class PanduanInteraktifPage extends StatefulWidget {
  final String title;

  const PanduanInteraktifPage({super.key, required this.title});

  @override
  State<PanduanInteraktifPage> createState() => _PanduanInteraktifPageState();
}

class _PanduanInteraktifPageState extends State<PanduanInteraktifPage> {
  int _currentPage = 0;

  // Data panduan langkah 1 - 6
  final List<Map<String, String>> _steps = [
    {
      "title": "Gambar Pola",
      "desc":
          "Buat pola pada botol bekas sesuai kreativitasmu, seperti hewan, bunga, atau buah-buahan.",
      "image": "lib/features/eksplor/images/undraw_social-strategy_v9qr1.png",
    },
    {
      "title": "Potong Sesuai Pola",
      "desc":
          "Gunakan gunting atau cutter untuk memotong botol mengikuti garis pola yang sudah digambar.",
      "image": "lib/features/eksplor/images/undraw_making-art_c05m2.png",
    },
    {
      "title": "Beri Warna Dasar",
      "desc":
          "Siapkan cat akrilik lalu warnai seluruh permukaan botol dengan warna dasar, misalnya putih.",
      "image": "lib/features/eksplor/images/undraw_choose-color_wpfw1.png",
    },
    {
      "title": "Tambahkan Warna",
      "desc":
          "Warnai kembali sesuai karakter atau desain yang telah kamu buat sebelumnya.",
      "image": "lib/features/eksplor/images/undraw_add-color_62111.png",
    },
    {
      "title": "Keringkan Cat",
      "desc":
          "Diamkan sebentar hingga cat benar-benar kering agar cat tidak luntur.",
      "image": "lib/features/eksplor/images/undraw_a-moment-to-relax_mrkn1.png",
    },
    {
      "title": "Pot Siap Digunakan",
      "desc":
          "Botol bekas kini siap dijadikan pot bunga yang cantik dan bermanfaat.",
      "image": "lib/features/eksplor/images/scissors1.png",
    },
  ];

  bool get _isSuccessPage => _currentPage == _steps.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header back button hanya muncul jika bukan di halaman sukses
            if (!_isSuccessPage) _buildTopHeader(),

            // Bagian Konten yang bisa berubah (Langkah 1-6 atau Sukses)
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isSuccessPage
                    ? _buildSuccessPage(key: const ValueKey('success'))
                    : _buildStepPage(
                        _steps[_currentPage],
                        key: ValueKey(_currentPage),
                      ),
              ),
            ),

            // Navigasi bawah dipasang FIX di sini (hanya jika bukan halaman sukses)
            if (!_isSuccessPage) _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // Widget Header Atas (Tombol Back Bulat)
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F9F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF17AC64),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Konten Langkah (Hanya gambar dan teks yang di-scroll)
  Widget _buildStepPage(Map<String, String> step, {required Key key}) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Image.asset(
            step["image"]!,
            height: 220,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_outlined,
              size: 100,
              color: Colors.black12,
            ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              step["title"]!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              step["desc"]!,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24), // Spacing aman bawah scroll
        ],
      ),
    );
  }

  // Widget Bottom Navigation Kontrol (Fixed di bawah luar scrollview)
  Widget _buildBottomNavigation() {
    final isFirstPage = _currentPage == 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (isFirstPage) {
                        Navigator.pop(context);
                      } else {
                        _currentPage--;
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF17AC64),
                    side: const BorderSide(
                      color: Color(0xFF17AC64),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        isFirstPage ? "Kembali" : "Sebelumnya",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentPage++;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF17AC64),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Selanjutnya",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Indikator Bulat Smooth Gliding
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length, (index) {
              final isSelected = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: isSelected ? 24.0 : 8.0,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF17AC64)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            "Langkah ${_currentPage + 1} dari ${_steps.length}",
            style: const TextStyle(
              color: Colors.black26,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Halaman Selamat (Success Screen) - FIXED CENTERED
  Widget _buildSuccessPage({required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Badge Selamat
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF17AC64).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF17AC64),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration_outlined,
                color: Colors.white,
                size: 54,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Selamat!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17AC64),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Kamu telah mengolah botol plastik hari ini. Aksimu ini membantu mengurangi sampah dan menjaga keseimbangan lingkungan.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black45, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 40),
          // Tombol Selesai
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                context.read<HistoryProvider>().createBarang(widget.title);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF17AC64),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Selesai",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Tombol Kembali ke langkah terakhir
          TextButton(
            onPressed: () {
              setState(() {
                _currentPage = _steps.length - 1;
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.black45),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_rounded, size: 16, color: Colors.black38),
                SizedBox(width: 6),
                Text(
                  "Kembali ke langkah terakhir",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
