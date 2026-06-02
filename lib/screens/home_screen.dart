import 'package:flutter/material.dart';
import 'package:ecoscan/features/eksplor/pages/eksplor_page.dart';
import 'package:ecoscan/features/pindai/pages/pindai_screen.dart';
import 'akun_beranda.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;
  bool _isFromScanButtonToPindai = false;

  void _changePage(int index) {
    setState(() {
      if (index == 1) {
        _previousIndex = _currentIndex;
      }
      _currentIndex = index;
      _isFromScanButtonToPindai = false;
    });
  }

  void _goToPindaiFromScanButton() {
    setState(() {
      _isFromScanButtonToPindai = true;
      _previousIndex = 2;
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      BerandaContent(onTapMenu: _changePage),
      PindaiScreen(
        onTapMenu: _changePage,
        previousIndex: _previousIndex,
        currentIndex: _currentIndex,
        isActive: _currentIndex == 1,
        isFromScanButton: _isFromScanButtonToPindai,
      ),
      EksplorPage(
        onTapMenu: _changePage,
        onTapScanButton: _goToPindaiFromScanButton,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: IndexedStack(index: _currentIndex, children: _pages),
      
      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // 1. BACKGROUND NAVBAR DENGAN LEKUKAN KUSTOM
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 6.0,
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            elevation: 10,
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  // === MENU BERANDA (HITBOX DIKECILKAN) ===
                  Expanded(
                    child: Center( // Menjaga isi tetap di tengah struktur Grid
                      child: InkWell(
                        onTap: () => _changePage(0),
                        borderRadius: BorderRadius.circular(12), // Efek splash membulat rapi seukuran teks
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Hitbox kustom yang pas
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home_filled,
                                color: _currentIndex == 0 ? const Color(0xFF17AC64) : Colors.grey,
                                size: 26,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Beranda",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: _currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                                  color: _currentIndex == 0 ? const Color(0xFF17AC64) : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // SPACE UTK MELETAKKAN TOMBOL PINDAI DI TENGAH (Lebar ditambah dikit agar aman dari jari)
                  const SizedBox(width: 76),

                  // === MENU EKSPLOR (HITBOX DIKECILKAN) ===
                  Expanded(
                    child: Center( // Menjaga isi tetap di tengah struktur Grid
                      child: InkWell(
                        onTap: () => _changePage(2),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Hitbox kustom yang pas
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                color: _currentIndex == 2 ? const Color(0xFF17AC64) : Colors.grey,
                                size: 26,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Eksplor",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: _currentIndex == 2 ? FontWeight.bold : FontWeight.normal,
                                  color: _currentIndex == 2 ? const Color(0xFF17AC64) : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. TOMBOL PINDAI KOTAK + TEKS DI BAWAHNYA
          Positioned(
            top: -24,
            child: GestureDetector(
              onTap: () => _changePage(1),
              behavior: HitTestBehavior.opaque, // Memastikan area klik FAB sensitif dan akurat
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFF17AC64),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Pindai",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: _currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                      color: _currentIndex == 1 ? const Color(0xFF17AC64) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Konten Beranda (Tetap sama seperti kode Anda)
class BerandaContent extends StatelessWidget {
  final Function(int) onTapMenu;
  const BerandaContent({super.key, required this.onTapMenu});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8F5E9).withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AkunBeranda(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 21,
                          backgroundColor: Color(0xFFE57373),
                          child: Text(
                            'S',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    "Halo! 👋",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Ayo ubah barang bekas\nbeserta sampah menjadi\nsebuah peluang yang\nbermanfaat ✨",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black38,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 172),

                  InkWell(
                    onTap: () => onTapMenu(1),
                    borderRadius: BorderRadius.circular(24),
                    child: _buildMenuCard(
                      icon: Icons.qr_code_scanner,
                      title: "Pindai Sekarang",
                      subtitle: "Lihat nilai dan ide kreatif barangmu.",
                      color: const Color(0xFF17AC64),
                      textColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  InkWell(
                    onTap: () => onTapMenu(2),
                    borderRadius: BorderRadius.circular(24),
                    child: _buildMenuCard(
                      icon: Icons.search,
                      title: "Cari Ide Daur Ulang",
                      subtitle: "Lihat berbagai ide dan inspirasi.",
                      color: Colors.white,
                      textColor: const Color(0xFF17AC64),
                      isOutline: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    bool isOutline = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: isOutline
            ? Border.all(color: textColor.withOpacity(0.2), width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 42),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isOutline ? Colors.black38 : textColor.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}