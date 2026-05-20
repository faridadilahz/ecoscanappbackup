import 'package:flutter/material.dart';
import 'pengepul_screen.dart';
import 'detail_karya_screen.dart'; 

class PindaiScreen extends StatefulWidget {
  const PindaiScreen({super.key});

  @override
  State<PindaiScreen> createState() => _PindaiScreenState();
}

class _PindaiScreenState extends State<PindaiScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  bool _showHasil = false; 
  late AnimationController _animationController;

  final Color primaryGreen = const Color(0xFF27AE60);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _showHasil = false; 
    });
    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _showHasil = true; 
        });
        _animationController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Kamera Latar Belakang Mockup
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1523293182086-7651a899d37f?q=80&w=600',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Tombol Navigasi Atas
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        // Menutup bottom sheet hasil dan mengembalikan ke tampilan awal PindaiScreen
                        if (_showHasil || _isScanning) {
                          setState(() {
                            _showHasil = false;
                            _isScanning = false;
                          });
                          _animationController.reset();
                        }
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(icon: const Icon(Icons.flash_on, color: Colors.white), onPressed: () {}),
                  ),
                ],
              ),
            ),
          ),

          // 3. Kotak Target Scanner di Tengah
          Center(
            child: Container(
              width: 260,
              height: 380,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.5),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          // 4. Animasi Laser
          if (_isScanning)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  top: (MediaQuery.of(context).size.height * 0.5 - 190) + (_animationController.value * 380),
                  left: MediaQuery.of(context).size.width * 0.5 - 130,
                  width: 260,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      boxShadow: [BoxShadow(color: primaryGreen.withOpacity(0.6), blurRadius: 10, spreadRadius: 2)],
                    ),
                  ),
                );
              },
            ),

          // 5. Status Pill
          if (_isScanning)
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Mendeteksi...',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          // 6. Tombol Shutter Pindai Utama
          if (!_isScanning && !_showHasil)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _startScan,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: primaryGreen,
                        child: const Icon(Icons.document_scanner_outlined, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Pindai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),

          // 7. Bottom Sheet Hasil Scan
          AnimatedPositioned(
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutCubic,
            bottom: _showHasil ? 0 : -MediaQuery.of(context).size.height,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height,
            child: _showHasil 
                ? DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.5,
                    maxChildSize: 0.92, 
                    snap: true,
                    snapSizes: const [0.5, 0.92],
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            
                            Expanded(
                              child: ListView(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Botol Air Mineral',
                                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Plastik • PET',
                                            style: TextStyle(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Rp4.000/kg',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                                          ),
                                          const SizedBox(height: 4),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const PengepulScreen()),
                                              );
                                            },
                                            child: Text(
                                              'Cari pengepul terdekat ↗',
                                              style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  Row(
                                    children: [
                                      const Text(
                                        'Ringkasan dari AI ',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                      ),
                                      Icon(Icons.auto_awesome, color: primaryGreen, size: 16),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildFigmaScoreCard('Kebersihan', '90/100', 0.9),
                                      _buildFigmaScoreCard('Kondisi Fisik', '100/100', 1.0),
                                      _buildFigmaScoreCard('Kelayakan', '95/100', 0.95),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  
                                  const Text(
                                    'Rekomendasi Karya',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            _buildInteractiveGridImage(context, 'https://images.unsplash.com/photo-1605721911519-3dfeb3be25e7?w=300', 140),
                                            _buildInteractiveGridImage(context, 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=300', 110),
                                            _buildInteractiveGridImage(context, 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=300', 150),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            _buildInteractiveGridImage(context, 'https://images.unsplash.com/photo-1530982011887-3cc11aa8893f?w=300', 95),
                                            _buildInteractiveGridImage(context, 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=300', 170),
                                            _buildInteractiveGridImage(context, 'https://images.unsplash.com/photo-1518895949257-7621c3c786d7?w=300', 120),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40), 
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFigmaScoreCard(String title, String score, double percentage) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 3,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            score, 
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveGridImage(BuildContext context, String url, double height) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailKaryaPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            url,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}