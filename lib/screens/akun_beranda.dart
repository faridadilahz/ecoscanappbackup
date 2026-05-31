import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecoscan/providers/history_provider.dart';

class AkunBeranda extends StatelessWidget {
  const AkunBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
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
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF17AC64),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFFE57373),
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
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
                  // Mengambil jumlah scan dan nama barang terakhir dari provider
                  _buildStatCard(
                    "${history.jumlahScan} barang dipindai",
                    history.lastScan,
                  ),
                  const SizedBox(width: 12),
                  // Mengambil jumlah ide yang dilihat dari provider
                  _buildStatCard(
                    "${history.jumlahIde} ide dilihat",
                    history.lastIde,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStatCard(
                "Terakhir dibuat",
                history.lastMade, // Data real barang yang terakhir dibuat
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
            _buildMenuTile(
              title: "Set Ulang Data",
              isWarning: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    // Kita pake Dialog biar lebih bebas custom bentuknya
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Biar tinggi dialog ngikutin konten
                        children: [
                          // Icon Peringatan yang Menonjol
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Judul
                          const Text(
                            "Yakin ingin Set Ulang Data?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Semua riwayat pindai, ide yang dilihat, dan progres karya akan dihapus.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Tombol Aksi Row
                          Row(
                            children: [
                              // Tombol Batal
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Batal",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Tombol Hapus (Confirm)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<HistoryProvider>()
                                        .resetHistory();
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          "Data berhasil direset",
                                        ),
                                        backgroundColor: Colors.black87,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Ya, Hapus",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

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
    VoidCallback? onTap,
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
        onTap: onTap,
      ),
    );
  }
}
