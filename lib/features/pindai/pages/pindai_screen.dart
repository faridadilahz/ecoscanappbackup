import 'dart:convert'; // jsonEncode & base64
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ecoscan/providers/history_provider.dart';
import 'package:http/http.dart' as http; // Untuk hit API
import 'pengepul_screen.dart';
import 'package:ecoscan/features/eksplor/pages/eksplor_page.dart';
import 'package:ecoscan/features/eksplor/pages/eksplor_detail_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// API Key dimuat secara dinamis dari file .env lokal (diabaikan oleh Git)
final String openRouterApiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';

class PindaiScreen extends StatefulWidget {
  final Function(int) onTapMenu; 
  final int previousIndex; 
  final int currentIndex;
  final bool isActive;
  final bool isFromScanButton; // Tambahkan parameter baru ini

  const PindaiScreen({
    super.key,
    required this.onTapMenu,
    required this.previousIndex,
    required this.currentIndex,
    required this.isActive,
    this.isFromScanButton = false, // Set default ke false agar navbar tidak terpengaruh
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

  // Variabel dinamis dari AI
  String _namaSampahAI = 'Memuat...';
  String _jenisSampahAI = 'Memuat...';
  String _hargaSampahAI = 'Rp-/kg';
  
  // State Skor Penilaian dari AI (Dibuat Dinamis)
  int _skorKebersihan = 0;
  int _skorKondisiFisik = 0;
  int _skorKelayakan = 0;

  // Daftar rekomendasi karya yang akan berubah sesuai jenis sampah
  List<DaurUlangModel> _rekomendasiKarya = [];

  final Color primaryGreen = const Color(0xFF27AE60);

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
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _initLaptopCamera();
      } else {
        _cameraController?.dispose();
        _cameraController = null;
        setState(() {
          _isCameraInitialized = false;
        });
      }
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
    if (_cameraController != null) {
      await _cameraController!.dispose();
      _cameraController = null;
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
      }
    }
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
        _prosesDanKirimKeAI(image);
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
      _prosesDanKirimKeAI(shotImage);
    } catch (e) {
      debugPrint("Gagal menjepret gambar dari webcam: $e");
    }
  }

  Future<void> _prosesDanKirimKeAI(XFile imageFile) async {
    _scanSessionCounter++;
    final currentSession = _scanSessionCounter;

    setState(() {
      _isScanning = true;
      _namaSampahAI = 'Menganalisis...';
      _jenisSampahAI = 'Memuat...';
    });
    _animationController.forward();

    try {
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // FIX: Endpoint & model disesuaikan dengan versi rilis stabil agar tidak memicu 404
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $openRouterApiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://ecoscan.id', 
          'X-Title': 'EcoScan App',
        },
        body: jsonEncode({
          "model": "google/gemini-2.5-flash", 
          "max_tokens": 1000,
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": "Analisis gambar sampah ini. Berikan respon wajib berupa JSON mentah pendek tanpa format markdown dengan struktur: "
                          "{"
                          "\"nama\": \"Nama barang\", "
                          "\"jenis\": \"Kategori Ringkas (Botol/Plastik/Kertas/Kardus/Lainnya)\", "
                          "\"harga\": \"Rp4.000/kg\", "
                          "\"kebersihan\": 90, "
                          "\"kondisi\": 85, "
                          "\"kelayakan\": 95"
                          "}. "
                          "Gunakan nilai integer untuk kebersihan, kondisi, dan kelayakan (skala 0-100). Tentukan harga taksiran barang bekas per kg (tulis satuan seperti /kg atau /pcs)."
                },
                {
                  "type": "image_url",
                  "image_url": {
                    "url": "data:image/jpeg;base64,$base64Image"
                  }
                }
              ]
            }
          ]
        }),
      );

      if (!mounted || currentSession != _scanSessionCounter || !widget.isActive) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String aiContent = responseData['choices'][0]['message']['content'].toString().trim();
        
        // Pembersihan jika AI nakal tetap memberikan tag markdown ```json
        if (aiContent.startsWith('```')) {
          aiContent = aiContent.replaceAll(RegExp(r'^```(json)?\n|```$'), '').trim();
        }

        final Map<String, dynamic> parsedResult = jsonDecode(aiContent);

        setState(() {
          _isScanning = false;
          _namaSampahAI = parsedResult['nama'] ?? 'Sampah Tidak Dikenal';
          _jenisSampahAI = parsedResult['jenis'] ?? 'Residu';
          _hargaSampahAI = parsedResult['harga'] ?? 'Rp4.000/kg';
          
          _skorKebersihan = parsedResult['kebersihan'] ?? 80;
          _skorKondisiFisik = parsedResult['kondisi'] ?? 80;
          _skorKelayakan = parsedResult['kelayakan'] ?? 80;

          _rekomendasiKarya = _getMatchingIdeas(_jenisSampahAI);
        });
        _animationController.stop();

        // Daftarkan ke provider history
        context.read<HistoryProvider>().addScan(_namaSampahAI);
        _showHasilBottomSheet();
      } else {
        throw Exception("Server memberikan kode error: ${response.statusCode}\nDetail: ${response.body}");
      }
    } catch (e) {
      debugPrint("Gagal memproses AI: $e");
      if (mounted && currentSession == _scanSessionCounter) {
        setState(() {
          _isScanning = false;
        });
        _animationController.stop();
        _showErrorSnackBar("Gagal menganalisis objek. Hubungan ke server terputus.");
      }
    }
  }

  void _resetPindaiPage() {
    _scanSessionCounter++; // Batalkan sesi pemindaian aktif agar hasil API diabaikan
    setState(() {
      _galleryImage = null;
      _isScanning = false;
    });
    _animationController.stop();
    _initLaptopCamera();
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _namaSampahAI,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _jenisSampahAI,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _hargaSampahAI,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PengepulScreen(),
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
                          children: [
                            Expanded(child: _buildFigmaScoreCard('Kebersihan', '$_skorKebersihan/100', _skorKebersihan / 100)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildFigmaScoreCard('Kondisi Fisik', '$_skorKondisiFisik/100', _skorKondisiFisik / 100)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildFigmaScoreCard('Kelayakan', '$_skorKelayakan/100', _skorKelayakan / 100)),
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
                        _rekomendasiKarya.isEmpty
                            ? const Text("Tidak ada rekomendasi karya daur ulang untuk item ini.")
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _rekomendasiKarya.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.85,
                                ),
                                itemBuilder: (context, index) {
                                  final item = _rekomendasiKarya[index];
                                  return _buildInteractiveGridItem(
                                    bottomSheetContext,
                                    item,
                                  );
                                },
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
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate scan box size responsively
    final boxWidth = (screenWidth * 0.78).clamp(240.0, 320.0);
    final boxHeight = (screenHeight * 0.50).clamp(280.0, 420.0);
    
    final topMargin = (screenHeight - boxHeight) / 2;
    final bottomMargin = (screenHeight + boxHeight) / 2;

    return PopScope(
      canPop: !_isScanning && _galleryImage == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isScanning || _galleryImage != null) {
          _resetPindaiPage();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: _galleryImage != null
                  ? (kIsWeb
                      ? Image.network(_galleryImage!.path, fit: BoxFit.cover)
                      : Image.file(File(_galleryImage!.path), fit: BoxFit.cover))
                  : (_isCameraInitialized
                      ? CameraPreview(_cameraController!)
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Color(0xFF27AE60)),
                              SizedBox(height: 16),
                              Text(
                                "Menghubungkan ke kamera...",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        )),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // --- TOMBOL KIRI (BACK KHUSUS) ---
                    _isScanning || _galleryImage != null
                        ? CircleAvatar(
                            backgroundColor: Colors.black45,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: _resetPindaiPage,
                            ),
                          )
                        : (widget.isFromScanButton // SEKARANG BERPATOKAN PADA FLAG INI
                            ? CircleAvatar(
                                backgroundColor: Colors.black45,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () {
                                    // Kembalikan ke Eksplor (Index 2)
                                    widget.onTapMenu(2);
                                  },
                                ),
                              )
                            : const SizedBox(width: 40, height: 40)), // Sembunyi jika lewat navbar bawah

                    // --- TOMBOL KANAN (FLASH) ---
                    CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: const Icon(Icons.flash_on, color: Colors.white),
                        onPressed: () {
                          // Logika flash Anda
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            if (_isScanning)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: SizedBox(
                    width: boxWidth,
                    height: boxHeight,
                    child: Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Positioned(
                              top: _animationController.value * (boxHeight - 4),
                              left: 0,
                              right: 0,
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
                      ],
                    ),
                  ),
                ),
              ),
            if (_isScanning)
              Positioned(
                top: (topMargin - 52).clamp(MediaQuery.of(context).padding.top + 70, topMargin - 20),
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
                      'Memindai dengan AI...',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            if (!_isScanning)
              Positioned(
                bottom: (screenHeight - bottomMargin > 160) ? 60 : (screenHeight - bottomMargin - 95).clamp(16.0, 40.0),
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo_library, color: Colors.white, size: 28),
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
                                  ? const Icon(Icons.keyboard_arrow_up, color: Colors.black, size: 35)
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        const SizedBox(width: 48), 
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_galleryImage != null)
                      const Text(
                        'Buka Hasil Sebelumnya',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFigmaScoreCard(String title, String score, double percentage) {
    return Container(
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            score,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveGridItem(BuildContext bSheetContext, DaurUlangModel idea) {
    return GestureDetector(
      onTap: () {
        context.read<HistoryProvider>().viewIde(idea.title);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EksplorDetailPage(
              idea: idea,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  idea.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                idea.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DaurUlangModel> _getMatchingIdeas(String category) {
    final c = category.toLowerCase();
    String targetCategory = '';
    
    if (c.contains('botol')) {
      targetCategory = 'Botol';
    } else if (c.contains('plastik')) {
      targetCategory = 'Plastik';
    } else if (c.contains('kardus') || c.contains('karton') || c.contains('kotak')) {
      targetCategory = 'Kardus';
    } else if (c.contains('kertas') || c.contains('buku')) {
      targetCategory = 'Kertas';
    }
    
    final matches = DaurUlangModel.allIdeas.where((idea) => idea.category == targetCategory).toList();
    if (matches.isNotEmpty) {
      return matches;
    }
    
    return DaurUlangModel.allIdeas.take(2).toList();
  }
}