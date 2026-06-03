import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecoscan/providers/history_provider.dart';

class PanduanInteraktifPage extends StatefulWidget {
  final String title;
  // 🟢 Menerima list data langkah secara dinamis berupa Map objek dari halaman detail
  final List<Map<String, dynamic>> steps;
  const PanduanInteraktifPage({
    super.key,
    required this.title,
    required this.steps,
  });

  @override
  State<PanduanInteraktifPage> createState() => _PanduanInteraktifPageState();
}

class _PanduanInteraktifPageState extends State<PanduanInteraktifPage> {
  int _currentPage = 0;

  // 🟢 Halaman sukses aktif ketika index melampaui jumlah data di list steps
  bool get _isSuccessPage => _currentPage == widget.steps.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header back button hanya muncul jika bukan di halaman sukses
            if (!_isSuccessPage) _buildTopHeader(),

            // Bagian Konten (Langkah dinamis atau Halaman Sukses) dengan transisi smooth
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isSuccessPage
                    ? _buildSuccessPage(key: const ValueKey('success'))
                    : _buildStepPage(
                        widget.steps[_currentPage], // 🟢 Aman mengirim Map data objek penuh ke fungsi
                        key: ValueKey(_currentPage),
                      ),
              ),
            ),

            // Navigasi bawah statis (hanya jika bukan halaman sukses)
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

  // Widget Konten Langkah Berdasarkan Index yang Sedang Aktif
  // 🟢 DIUBAH: Sekarang menerima parameter Map<String, dynamic> stepData
  Widget _buildStepPage(Map<String, dynamic> stepData, {required Key key}) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          
          // 🟢 MENAMPILKAN GAMBAR DINAMIS: Mengambil dari asset sesuai object data kamu
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              stepData["image"] ?? '', // Mengambil isi dari key "image"
              height: 240,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 240,
                color: Colors.grey[100],
                child: const Icon(
                  Icons.image_not_supported_outlined, 
                  size: 50, 
                  color: Colors.black26
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // 🟢 Judul Langkah Dinamis
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Langkah ${_currentPage + 1}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // 🟢 Isi Deskripsi Panduan dari objek key "desc"
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              stepData["desc"] ?? '', // Mengambil teks langkah dari key "desc"
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Widget Navigasi Bawah Otomatis Menyesuaikan Jumlah Langkah Dinamis
  Widget _buildBottomNavigation() {
    final isFirstPage = _currentPage == 0;
    final isLastStep = _currentPage == widget.steps.length - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Tombol Kembali / Sebelumnya
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
              // Tombol Selanjutnya / Selesai
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (isLastStep) {
                        // Simpan data barang ke history provider saat menekan Selesai di langkah terakhir
                        context.read<HistoryProvider>().createBarang(widget.title);
                      }
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastStep ? "Selesai" : "Selanjutnya",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        isLastStep ? Icons.check_rounded : Icons.arrow_forward_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Indikator Titik Slider Smooth Sesuai Jumlah Langkah Dinamis
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.steps.length, (index) {
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
            "Langkah ${_currentPage + 1} dari ${widget.steps.length}",
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

  // Halaman Sukses yang Fleksibel Menyesuaikan Judul Barang Dinamis
  Widget _buildSuccessPage({required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
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
          Text(
            "Kamu telah berhasil membuat '${widget.title}' hari ini. Aksimu ini membantu mengurangi sampah dan menjaga keseimbangan lingkungan.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black45, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
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
                "Kembali ke Menu Utama",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _currentPage = widget.steps.length - 1;
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