import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart';
import 'package:ecoscan/widgets/cors_image.dart';

// Model Data Pengepul & Bank Sampah
class PengepulData {
  final String nama;
  final String status;
  final String wilayah;
  final LatLng koordinat;
  final List<String> kategori;
  final List<String> galeri; 

  PengepulData({
    required this.nama,
    required this.status,
    required this.wilayah,
    required this.koordinat,
    required this.kategori,
    required this.galeri,
  });
}

class PengepulScreen extends StatefulWidget {
  const PengepulScreen({super.key});

  @override
  State<PengepulScreen> createState() => _PengepulScreenState();
}

class _PengepulScreenState extends State<PengepulScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  
  final LatLng _kotaBogor = const LatLng(-6.597629, 106.799568);
  final Color primaryGreen = const Color(0xFF27AE60);


  final List<PengepulData> _daftarPengepulAsli = [
    PengepulData(
      nama: "BANK SAMPAH RANGGA MEKAR &\nRUMAH KREATIF NUSANTARA",
      status: "Buka",
      wilayah: "Rangga mekar, Bogor Selatan",
      koordinat: const LatLng(-6.6215, 106.7992), 
      kategori: ["Plastik", "Botol", "Kertas", "Kardus"],
      galeri: [
        "https://asset.tribunnews.com/N-lcDFhqBjOke7_5m5d5Rh-2F3k=/1200x675/filters:upscale():quality(30):format(webp):focal(0.5x0.5:0.5x0.5)/bogor/foto/bank/originals/Program-Bank-Sampah-Rangga-Mekar.jpg",
        "https://bogorchannel.id/wp-content/uploads/2023/02/IMG-20230223-WA0020.jpg",
      ],
    ),
    PengepulData(
      nama: "PENGEPUL SAMPAH BARANG BEKAS BAROKAH",
      status: "Buka",
      wilayah: "Mulyaharja, Bogor Selatan",
      koordinat: const LatLng(-6.6085, 106.7975),
      kategori: ["Besi", "Plastik", "Tembaga", "Kertas"],
      galeri: [
        "https://jurnalbogor.com/wp-content/uploads/2025/01/WhatsApp-Image-2025-01-07-at-18.06.25.jpeg",
        "https://jurnalbogor.com/wp-content/uploads/2025/06/IMG-20250622-WA0010.jpg"
      ], 
    ),
    PengepulData(
      nama: "BANK SAMPAH BARANANGSIANG",
      status: "Buka",
      wilayah: "Baranangsiang, Bogor Timur",
      koordinat: const LatLng(-6.6042, 106.8124),
      kategori: ["Plastik", "Kaca", "Koran", "Kardus"],
      galeri: [
        "https://i0.wp.com/bharatanews.id/wp-content/uploads/2022/05/IMG-20220530-WA0034.jpg",
      ],
    ),
    PengepulData(
      nama: "BANK SAMPAH INDUK BERKAH",
      status: "Buka",
      wilayah: "Tanah Sareal, Kota Bogor",
      koordinat: const LatLng(-6.5652, 106.7992),
      kategori: ["Elektronik", "Plastik", "Besi", "Botol"],
      galeri: [
        "assets/images/bsi.png",
      ],
    ),
    PengepulData(
      nama: "BANK SAMPAH TAJUR BERSIH",
      status: "Tutup",
      wilayah: "Tajur, Bogor Timur",
      koordinat: const LatLng(-6.6321, 106.8295),
      kategori: ["Plastik", "Minyak Jelantah", "Kertas"],
      galeri: [
        "https://www.radarbogor.id/files/2020/12/Desa-Tajur-Halang.jpg",
      ],
    ),
  ];

  List<PengepulData> _filteredPengepul = [];
  List<PengepulData> _suggestions = []; 
  PengepulData? _selectedPengepul;
  
  bool _hasSearched = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _filteredPengepul = List.from(_daftarPengepulAsli);
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _resetToDefaultView() {
    setState(() {
      _searchController.clear();
      _suggestions = [];
      _showSuggestions = false;
      _hasSearched = false;
      _selectedPengepul = null;
      _filteredPengepul = List.from(_daftarPengepulAsli);
    });
    _animatedMapMove(_kotaBogor, 14.5);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    final controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    final animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
        _hasSearched = false;
        _filteredPengepul = List.from(_daftarPengepulAsli);
      });
      return;
    }

    setState(() {
      _suggestions = _daftarPengepulAsli
          .where((p) => p.nama.toLowerCase().contains(query.toLowerCase()) || 
                       p.wilayah.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showSuggestions = _suggestions.isNotEmpty;
    });
  }

  void _executeSearch(String query) {
    setState(() {
      _showSuggestions = false; 
    });

    if (query.isEmpty) {
      _resetToDefaultView();
      return;
    }

    final urutanHasil = _daftarPengepulAsli
        .where((pengepul) => pengepul.nama.toLowerCase().contains(query.toLowerCase()) || 
                             pengepul.wilayah.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (urutanHasil.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lokasi '$query' tidak ditemukan!"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _hasSearched = false;
      });
    } else {
      setState(() {
        _filteredPengepul = urutanHasil;
        _hasSearched = true;
        
        if (urutanHasil.length == 1) {
          _selectedPengepul = urutanHasil.first;
        } else {
          _selectedPengepul = null; 
        }
      });

      if (urutanHasil.length == 1) {
        _animatedMapMove(urutanHasil.first.koordinat, 16.0);
      } else {
        _animatedMapMove(_kotaBogor, 13.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. PETA INTERAKTIF
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _kotaBogor, 
                initialZoom: 14.5,         
                minZoom: 11.0,             
                maxZoom: 18.0,             
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://b.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.ecoscan.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _kotaBogor,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                    ),
                    ..._filteredPengepul.map((pengepul) {
                      final isSelected = _selectedPengepul == pengepul;
                      return Marker(
                        point: pengepul.koordinat,
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPengepul = pengepul;
                              _hasSearched = true; 
                            });
                            _animatedMapMove(pengepul.koordinat, 16.0);
                          },
                          child: Icon(
                            Icons.location_on, 
                            color: isSelected && _hasSearched ? Colors.orange : primaryGreen, 
                            size: isSelected && _hasSearched ? 46 : 36,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          // 2. HEADER GREEN SOLID
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              color: primaryGreen,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 16, left: 12, right: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context), 
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Cari pengepul terdekat',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // 3. SEARCH BAR
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 20, right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: _showSuggestions 
                        ? const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                        : BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onSubmitted: _executeSearch, 
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Cari tempat pengepul disini',
                      hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: Colors.black26, size: 20),
                      suffixIcon: (_searchController.text.isNotEmpty || _hasSearched)
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.black26, size: 18),
                              onPressed: _resetToDefaultView, 
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
                if (_showSuggestions)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final item = _suggestions[index];
                        return ListTile(
                          dense: true,
                          leading: Icon(Icons.location_on, color: primaryGreen, size: 18),
                          title: Text(item.nama.replaceAll('\n', ' '), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          subtitle: Text(item.wilayah, style: const TextStyle(fontSize: 11)),
                          onTap: () {
                            _searchController.text = item.nama.replaceAll('\n', ' ');
                            _executeSearch(item.nama);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // 4. PILL BUTTON
          if (!_showSuggestions)
            Positioned(
              top: MediaQuery.of(context).padding.top + 146, 
              left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, color: primaryGreen, size: 14),
                      const SizedBox(width: 6),
                      Text('Cari pengepul di area ini', style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),

          // 5. DRAGGABLE BOTTOM SHEET PANEL
          if (_hasSearched && !_showSuggestions && _filteredPengepul.isNotEmpty)
            Positioned.fill(
              child: DraggableScrollableSheet(
                initialChildSize: 0.38, 
                minChildSize: 0.18,     
                maxChildSize: 0.90,     
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        Center(
                          child: Container(
                            width: 40, height: 5,
                            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // KONDISI A: DETAIL TEMPAT SPESIFIK
                        if (_selectedPengepul != null) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                              icon: Icon(Icons.arrow_back, color: primaryGreen, size: 16),
                              label: Text(
                                _filteredPengepul.length > 1 ? "Kembali ke daftar" : "Tutup Detail", 
                                style: TextStyle(color: primaryGreen, fontSize: 12)
                              ),
                              onPressed: () {
                                if (_filteredPengepul.length > 1) {
                                  setState(() {
                                    _selectedPengepul = null;
                                  });
                                  _animatedMapMove(_kotaBogor, 13.0);
                                } else {
                                  _resetToDefaultView();
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          Text(
                            _selectedPengepul!.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                                child: Text(_selectedPengepul!.status, style: TextStyle(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Text(_selectedPengepul!.wilayah, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.directions, color: Colors.white, size: 18),
                              label: const Text("Lihat Lokasi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                _animatedMapMove(_selectedPengepul!.koordinat, 16.5);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          const Text("Kategori Sampah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 28,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedPengepul!.kategori.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    border: Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(_selectedPengepul!.kategori[index], style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                );
                              },
                            ),
                          ),
                          
                          // ==========================================================
                          // SEKSI GALERI HORIZONTAL BERIKUT PERBAIKAN LOADING & ERROR
                          // ==========================================================
                          if (_selectedPengepul!.galeri.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text("Galeri", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 100, 
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectedPengepul!.galeri.length,
                                itemBuilder: (context, index) {
                                  final imgPath = _selectedPengepul!.galeri[index];
                                  final isNetwork = imgPath.startsWith('http://') || imgPath.startsWith('https://');

                                  return Container(
                                    width: 110, 
                                    margin: const EdgeInsets.only(right: 6), 
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8), 
                                      child: isNetwork
                                          ? createCorsImage(
                                              imgPath,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              imgPath,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ] 
                        
                        // KONDISI B: DAFTAR REKOMENDASI TEMPAT
                        else ...[
                          Text(
                            "Hasil Pencarian (${_filteredPengepul.length})", 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)
                          ),
                          const SizedBox(height: 8),
                          ..._filteredPengepul.map((item) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.green[50],
                                    child: Icon(Icons.location_on, color: primaryGreen),
                                  ),
                                  title: Text(item.nama.replaceAll('\n', ' '), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                  subtitle: Text(item.wilayah, style: const TextStyle(fontSize: 11)),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: item.status == "Buka" ? Colors.green[50] : Colors.red[50],
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Text(
                                      item.status, 
                                      style: TextStyle(
                                        color: item.status == "Buka" ? primaryGreen : Colors.red, 
                                        fontSize: 10, 
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedPengepul = item;
                                    });
                                    _animatedMapMove(item.koordinat, 16.5);
                                  },
                                ),
                                const Divider(height: 1),
                              ],
                            );
                          }),
                        ]
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}