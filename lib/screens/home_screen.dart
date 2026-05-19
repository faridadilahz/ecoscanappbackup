import 'package:flutter/material.dart';
// Nanti kalo temen lo udah kelar, import-nya di sini:
// import 'package:ecoscan/features/pindai/pages/pindai_page.dart';
// import 'package:ecoscan/features/eksplor/pages/eksplor_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Fungsi navigasi utama
  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List halaman: Di sini tempat lo nyatuin kerjaan temen lo
    final List<Widget> _pages = [
      BerandaContent(onTapMenu: _changePage),
      // Ganti 'Center' ini sama 'PindaiPage()' kalo temen lo udah setor code
      const Center(child: Text("Halaman Pindai (Kamera)")), 
      // Ganti 'Center' ini sama 'EksplorPage()' kalo temen lo udah setor code
      const Center(child: Text("Halaman Eksplor (Ide)")),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: IndexedStack( // Pake ini biar state halaman nggak keriset pas pindah
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _changePage,
        selectedItemColor: const Color(0xFF27AE60),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_rounded), label: "Pindai"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Eksplor"),
        ],
      ),
    );
  }
}

// --- KONTEN BERANDA (Tugas Lo) ---
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.menu, color: Colors.green[800]),
                      const CircleAvatar(
                        radius: 21,
                        backgroundColor: Color(0xFFE57373),
                        child: Text('S', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text("Halo! 👋", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    "Ayo ubah barang bekas\nbeserta sampah menjadi\nsebuah peluang yang\nbermanfaat ✨",
                    style: TextStyle(fontSize: 20, color: Colors.black38, height: 1.3),
                  ),
                  const SizedBox(height: 144),
                  
                  // CTA 1: PINDAI
                  InkWell(
                    onTap: () => onTapMenu(1), // Ini bakal lari ke index 1 (Pindai)
                    borderRadius: BorderRadius.circular(24),
                    child: _buildMenuCard(
                      icon: Icons.qr_code_scanner,
                      title: "Pindai Sekarang",
                      subtitle: "Lihat nilai dan ide kreatif barangmu.",
                      color: const Color(0xFF27AE60),
                      textColor: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // CTA 2: EKSPLOR
                  InkWell(
                    onTap: () => onTapMenu(2), // Ini bakal lari ke index 2 (Eksplor)
                    borderRadius: BorderRadius.circular(24),
                    child: _buildMenuCard(
                      icon: Icons.search,
                      title: "Cari Ide Daur Ulang",
                      subtitle: "Lihat berbagai ide dan inspirasi.",
                      color: Colors.white,
                      textColor: const Color(0xFF27AE60),
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
        border: isOutline ? Border.all(color: textColor.withOpacity(0.2), width: 1.5) : null,
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 42),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: isOutline ? Colors.black38 : textColor.withOpacity(0.8), fontSize: 14)),
        ],
      ),
    );
  }
}