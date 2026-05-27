import 'package:flutter/material.dart';

class AkunBeranda extends StatelessWidget {
  const AkunBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(86),
  child: AppBar(
    backgroundColor: const Color(0xFF17AC64),
    elevation: 0,
    automaticallyImplyLeading: false,
    flexibleSpace: SafeArea(
      child: Padding(
        // Atur padding biar posisinya pas di tengah header yang baru
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), 
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(Icons.arrow_back, color: Color(0xFF17AC64), size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFFE57373),
                      child: Text('S', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Eco #Supernova2112',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text(
                "Statistik",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatCard(
                    "8 barang dipindai",
                    "Botol plastik, Sterofoam, Sa...",
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    "12 ide dilihat",
                    "Pot tanaman, Isian bantal, H...",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStatCard(
                "Terakhir dibuat",
                "Pot tanaman botol plastik, Tempat pensil botol plastik, Rak kec...",
                isFullWidth: true,
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Text(
                "Pengaturan",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Menu Options
            _buildMenuTile(title: "Tentang EcoScan", icon: Icons.chevron_right),
            _buildMenuTile(
              title: "Kebijakan Privasi",
              icon: Icons.chevron_right,
            ),
            _buildMenuTile(title: "Set Ulang Data", isWarning: true),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget Helper buat Kartu Statistik
  Widget _buildStatCard(String title, String desc, {bool isFullWidth = false}) {
    Widget content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return isFullWidth
        ? SizedBox(width: double.infinity, child: content)
        : Expanded(child: content);
  }

  // Widget Helper buat List Menu
  Widget _buildMenuTile({
    required String title,
    IconData? icon,
    bool isWarning = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isWarning ? Colors.redAccent : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: icon != null ? Icon(icon, color: Colors.grey) : null,
        onTap: () {
          // Aksi menu di sini
        },
      ),
    );
  }
}
