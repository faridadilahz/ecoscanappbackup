import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart';
// Import Halaman Eksplor sesuai keinginan lo
import 'package:ecoscan/features/eksplor/pages/eksplor_page.dart';
// Tetap import HomeScreen untuk handle tombol Beranda jika dibutuhkan
import 'package:ecoscan/screens/home_screen.dart'; 

class PengepulScreen extends StatefulWidget {
  const PengepulScreen({super.key});

  @override
  State<PengepulScreen> createState() => _PengepulScreenState();
}

class _PengepulScreenState extends State<PengepulScreen> {
  final MapController _mapController = MapController();
  
  // Koordinat Titik Pusat Kota Bogor (Alun-Alun / Stasiun Bogor)
  final LatLng _kotaBogor = const LatLng(-6.5971, 106.8060);
  final Color primaryGreen = const Color(0xFF27AE60);

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // =========================================================
          // 1. PETA ASLI INTERAKTIF (Grafik bergaya Google Maps)
          // =========================================================
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _kotaBogor, 
                initialZoom: 14.5,         
                minZoom: 11.0,             
                maxZoom: 18.0,             
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://b.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.ecoscan.app',
                ),
                
                // Lapisan Pin / Marker Pengepul
                MarkerLayer(
                  markers: [
                    // Pin Merah Pusat Kota Bogor
                    Marker(
                      point: _kotaBogor,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 38),
                    ),
                    // Pin Pengepul Mitra A (Hijau)
                    Marker(
                      point: const LatLng(-6.6050, 106.8090),
                      width: 40,
                      height: 40,
                      child: Icon(Icons.location_on, color: primaryGreen, size: 34),
                    ),
                    // Pin Pengepul Mitra B (Hijau)
                    Marker(
                      point: const LatLng(-6.5820, 106.7950),
                      width: 40,
                      height: 40,
                      child: Icon(Icons.location_on, color: primaryGreen, size: 34),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =========================================================
          // 2. HEADER HIJAU SOLID (Sesuai Aturan Figma)
          // =========================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: primaryGreen,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 16,
                left: 12,
                right: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context), // Kembali ke PindaiScreen
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Cari pengepul terdekat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =========================================================
          // 3. SEARCH BAR MELAYANG
          // =========================================================
          Positioned(
            top: MediaQuery.of(context).padding.top + 68,
            left: 20,
            right: 20,
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari tempat pengepul disini',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 13, fontWeight: FontWeight.w400),
                  prefixIcon: Icon(Icons.search, color: Colors.black26, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),

          // =========================================================
          // 4. PILL BUTTON "Cari pengepul di area ini"
          // =========================================================
          Positioned(
            top: MediaQuery.of(context).padding.top + 130,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, color: primaryGreen, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Cari pengepul di area ini',
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =========================================================
          // 5. FLOATING TARGET BUTTON (Tombol GPS Kembali Ke Bogor)
          // =========================================================
          Positioned(
            bottom: 20, 
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              onPressed: () {
                _mapController.move(_kotaBogor, 14.5);
              },
              child: Icon(Icons.my_location, color: Colors.grey[700], size: 22),
            ),
          ),
        ],
      ),

      // =========================================================
      // 6. BOTTOM NAVIGATION BAR (Sama Persis dengan HomeScreen)
      // =========================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Tetap aktif di visual Pindai karena bagian dari fiturnya
        onTap: (index) {
          if (index == 0) {
            // Beranda dipencet: balikkan HomeScreen ke index 0, lalu pop map ini
            final homeState = context.findAncestorStateOfType<State<HomeScreen>>();
            if (homeState != null) {
              (homeState as dynamic)._changePage(0);
            }
            Navigator.pop(context);
          } else if (index == 1) {
            // Pindai dipencet: langsung pop map ini untuk balik ke kamera awal
            Navigator.pop(context);
          } else if (index == 2) {
            // Eksplor dipencet: LANGSUNG DIARAHIN KE EKSPLOR PAGE LEWAT ROUTE
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EksplorPage()),
            );
          }
        },
        selectedItemColor: const Color(0xFF17AC64),
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