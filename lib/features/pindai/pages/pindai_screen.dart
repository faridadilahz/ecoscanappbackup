import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

import 'pengepul_screen.dart';
import 'detail_karya_screen.dart'; // Catatan: Sesuaikan nama file jika aslinya detail_karya_page.dart

class PindaiScreen extends StatefulWidget {
  final Function(int) onTapMenu; // Terima fungsi navigasi dari HomeScreen
  final int previousIndex; // Terima index halaman terakhir
  final bool isActive;

  const PindaiScreen({
    super.key,
    required this.onTapMenu,
    required this.previousIndex,
    required this.isActive,
  });

  @override
  State<PindaiScreen> createState() => _PindaiScreenState();
}

class _PindaiScreenState extends State<PindaiScreen>
    with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  int _scanSessionCounter = 0;
  late AnimationController _animationController;

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  XFile? _galleryImage;
  final ImagePicker _picker = ImagePicker();

  final Color primaryGreen = const Color(0xFF27AE60);

  final double boxWidth = 320.0;
  final double boxHeight = 460.0;

  @override
  void initState() {
    super.initState();
    _initLaserAnimation();
    _initLaptopCamera();
  }

  @override
  void didUpdateWidget(covariant PindaiScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && _isScanning) {
      setState(() {
        _isScanning = false;
      });
      _animationController.stop();
    }
  }

  void _initLaserAnimation() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
  }

  Future<void> _initLaptopCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        CameraDescription selectedCamera = _cameras![0];

        if (!kIsWeb && Platform.isAndroid) {
          for (var camera in _cameras!) {
            if (camera.lensDirection == CameraLensDirection.back) {
              selectedCamera = camera;
              break;
            }
          }
        }

        _cameraController = CameraController(
          selectedCamera,
          ResolutionPreset.medium,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } else {
        _showErrorSnackBar("Kamera tidak ditemukan di perangkat ini.");
      }
    } catch (e) {
      debugPrint("Gagal membuka webcam/kamera: $e");
      _showErrorSnackBar(
        "Gagal memuat kamera. Periksa izin akses perangkat Anda.",
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _getImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _galleryImage = image;
        });
        _startScan();
      }
    } catch (e) {
      debugPrint("Error membuka galeri: $e");
    }
  }

  Future<void> _captureLiveCamera() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _showErrorSnackBar("Kamera belum siap atau tidak terdeteksi.");
      return;
    }

    try {
      final XFile shotImage = await _cameraController!.takePicture();
      setState(() {
        _galleryImage = shotImage;
      });
      _startScan();
    } catch (e) {
      debugPrint("Gagal menjepret gambar dari webcam: $e");
    }
  }

  void _startScan() {
    _scanSessionCounter++;
    final currentSession = _scanSessionCounter;
    setState(() {
      _isScanning = true;
    });
    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted &&
          widget.isActive &&
          _isScanning &&
          _scanSessionCounter == currentSession &&
          ModalRoute.of(context)?.isCurrent == true) {
        setState(() {
          _isScanning = false;
        });
        _animationController.stop();
        _showHasilBottomSheet();
      }
    });
  }

  void _showHasilBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext bottomSheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Plastik • PET',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Rp4.000/kg',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    // Tutup bottom sheet terlebih dahulu agar tidak ikut terbawa
                                    Navigator.pop(bottomSheetContext);
                                    
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PengepulScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Cari pengepul terdekat ↗',
                                    style: TextStyle(
                                      color: primaryGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(
                              Icons.auto_awesome,
                              color: primaryGreen,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFigmaScoreCard('Kebersihan', '90/100', 0.9),
                            _buildFigmaScoreCard(
                              'Kondisi Fisik',
                              '100/100',
                              1.0,
                            ),
                            _buildFigmaScoreCard('Kelayakan', '95/100', 0.95),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Rekomendasi Karya',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildInteractiveGridImage(
                                    bottomSheetContext,
                                    'https://images.unsplash.com/photo-1605721911519-3dfeb3be25e7?w=300',
                                    140,
                                  ),
                                  _buildInteractiveGridImage(
                                    bottomSheetContext,
                                    'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=300',
                                    110,
                                  ),
                                  _buildInteractiveGridImage(
                                    bottomSheetContext,
                                    'https://images.unsplash.com/photo-1544816155-12df9643f363?w=300',
                                    150,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildInteractiveGridImage(
                                    bottomSheetContext,
                                    'https://images.unsplash.com/photo-1530982011887-3cc11aa8893f?w=300',
                                    95,
                                  ),
                                  _buildInteractiveGridImage(
                                    bottomSheetContext,
                                    'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=300',
                                    170,
                                  ),
                                  _buildInteractiveGridImage(
                                    bottomSheetContext,
                                    'https://images.unsplash.com/photo-1518895949257-7621c3c786d7?w=300',
                                    120,
                                  ),
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
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. AREA PREVIEW LIVE KAMERA LAPTOP / GAMBAR GALERI
          Positioned.fill(
            child: _galleryImage != null
                ? (kIsWeb
                    ? Image.network(_galleryImage!.path, fit: BoxFit.cover)
                    : Image.file(
                        File(_galleryImage!.path),
                        fit: BoxFit.cover,
                      ))
                : (_isCameraInitialized
                    ? CameraPreview(_cameraController!)
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFF27AE60),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Menghubungkan ke kamera...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
          ),

          // 2. TOMBOL NAVIGASI ATAS
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isScanning || _galleryImage != null
                      ? CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _galleryImage = null;
                                _isScanning = false;
                              });
                              _animationController.stop();
                            },
                          ),
                        )
                      : const SizedBox(width: 40, height: 40),
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.flash_on, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. KOTAK TARGET SCANNER (Tengah)
          Center(
            child: Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.5),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),

          // 4. ANIMASI LASER SCANNER
          if (_isScanning)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  top:
                      (MediaQuery.of(context).size.height * 0.5 -
                          (boxHeight / 2)) +
                      (_animationController.value * boxHeight),
                  left:
                      MediaQuery.of(context).size.width * 0.5 - (boxWidth / 2),
                  width: boxWidth,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.6),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          // 5. STATUS PILL
          if (_isScanning)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Memindai...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          // 6. PANEL TOMBOL KONTROL (Bawah)
          if (!_isScanning)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _getImageFromGallery,
                      ),
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: () {
                          if (_galleryImage != null) {
                            _showHasilBottomSheet();
                          } else {
                            _captureLiveCamera();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: _galleryImage != null
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.black,
                                    size: 35,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      const SizedBox(width: 48), // Spacer to balance the gallery button on the left
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _galleryImage != null ? 'Buka Hasil Sebelumnya' : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
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
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
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
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveGridImage(
    BuildContext bSheetContext,
    String url,
    double height,
  ) {
    return GestureDetector(
      onTap: () {
        // 1. Tutup bottom sheet terlebih dahulu menggunakan bSheetContext
        Navigator.pop(bSheetContext);

        // 2. Transisi membuka halaman detail karya
        Future.delayed(const Duration(milliseconds: 150), () {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailKaryaPage()),
          );
        });
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