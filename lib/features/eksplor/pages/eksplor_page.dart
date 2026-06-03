import 'package:flutter/material.dart';
import 'eksplor_detail_page.dart';
import 'package:ecoscan/features/pindai/pages/pindai_screen.dart';
import 'package:provider/provider.dart';
import 'package:ecoscan/providers/history_provider.dart';

class DaurUlangModel {
  final String title;
  final String category;
  final String difficulty;
  final String timeEstimate;
  final String imageUrl;
  final String price;
  final String detailDescription;
  final List<Map<String, dynamic>> toolsAndMaterials;
  final List<String> steps;

  DaurUlangModel({
    required this.title,
    required this.category,
    required this.difficulty,
    required this.timeEstimate,
    required this.imageUrl,
    required this.price,
    required this.detailDescription,
    required this.toolsAndMaterials,
    required this.steps,
  });

  static final List<DaurUlangModel> allIdeas = [
    DaurUlangModel(
      title: "Pot Tanaman Kucing",
      category: "Botol",
      difficulty: "Mudah",
      timeEstimate: "10-15 menit",
      imageUrl: "https://tse2.mm.bing.net/th/id/OIP.ldM_LBn8yXEyAQUre6fNEgHaFk?rs=1&pid=ImgDetMain&o=7&rm=3",
      price: "Rp10.000",
      detailDescription: "Pot Tanaman Kucing adalah kreasi unik memanfaatkan botol plastik bekas menjadi wadah tanaman hias yang lucu. Bentuk telinga dan lukisan wajah kucing memberikan sentuhan estetis yang ceria di sudut ruangan atau meja kerja.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Gunting/\nCutter"},
        {"icon": Icons.format_color_fill_rounded, "label": "Cat Akrilik"},
        {"icon": Icons.local_drink_rounded, "label": "1 Botol\nPlastik"},
        {"icon": Icons.edit_rounded, "label": "Pensil/Spidol"},
      ],
      steps: [
        "Gambar pola wajah dan telinga kucing menggunakan pensil atau spidol pada permukaan botol plastik bekas.",
        "Potong botol menggunakan gunting atau cutter secara perlahan mengikuti garis pola yang sudah dibuat.",
        "Cat seluruh permukaan botol dengan warna dasar putih atau warna cerah lainnya menggunakan cat akrilik, lalu tunggu hingga kering.",
        "Gunakan kuas kecil untuk menggambar detail mata, kumis, dan hidung kucing di bagian depan pot.",
        "Beri lubang kecil di bagian bawah botol untuk saluran drainase air tanaman.",
        "Masukkan tanah dan tanaman hias favoritmu. Pot tanaman kucing siap dipajang!"
      ],
      
    ),
    DaurUlangModel(
      title: "Celengan Babi",
      category: "Plastik",
      difficulty: "Sedang",
      timeEstimate: "20-30 menit",
      imageUrl: "https://tse3.mm.bing.net/th/id/OIP.1I5SylKEhBHAWzvS7WrOwQHaFj?w=650&h=488&rs=1&pid=ImgDetMain&o=7&rm=3",
      price: "Rp12.000",
      detailDescription: "Ubah botol plastik bekas berukuran pendek menjadi celengan babi yang menggemaskan. Selain mengurangi limbah plastik, proyek kreatif ini bisa menjadi media edukasi menabung yang menyenangkan untuk anak-anak.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Cutter"},
        {"icon": Icons.format_color_fill_rounded, "label": "Cat Pink"},
        {"icon": Icons.local_drink_rounded, "label": "Botol Gemuk"},
        {"icon": Icons.layers_rounded, "label": "4 Tutup\nBotol Ekstra"},
      ],
      steps: [
        "Bersihkan botol plastik bekas dan pastikan label kemasannya sudah terlepas sempurna.",
        "Gunakan cutter untuk membuat celah horizontal sepanjang 3-4 cm di bagian tengah badan botol sebagai lubang masuk koin.",
        "Warnai seluruh badan botol dan 4 buah tutup botol ekstra dengan cat akrilik berwarna merah muda (pink).",
        "Tempelkan 4 tutup botol ekstra tersebut di bagian bawah botol menggunakan lem tembak sebagai kaki celengan.",
        "Gambarkan pola mata pada bagian depan dekat tutup botol asli, dan buat dua lubang hitam di tutup botol utama sebagai hidung babi.",
        "Tambahkan hiasan ekor spiral di bagian belakang botol menggunakan sisa potongan plastik atau kertas.",
      ],
    ),
    DaurUlangModel(
      title: "Kotak Tisu Estetik",
      category: "Kardus",
      difficulty: "Mudah",
      timeEstimate: "15-20 menit",
      imageUrl: "https://thf.bing.com/th/id/OIP.xzSCtei54jsAjGzM6EA0VQAAAA?w=182&h=182&c=7&r=0&o=7&cb=thfc1falcon&dpr=1.3&pid=1.7&rm=3",
      price: "Rp15.000",
      detailDescription: "Kotak Tisu Estetik dibuat dari bahan kardus sepatu atau kardus mie instan bekas yang dilapisi kain atau kertas bermotif minimalis. Sangat cocok diletakkan di ruang tamu untuk menambah kesan rapi dan modern.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Gunting"},
        {"icon": Icons.brush, "label": "Lem Kayu/\nTembak"},
        {"icon": Icons.crop_original_rounded, "label": "Kardus Bekas"},
        {"icon": Icons.style_rounded, "label": "Kertas\nKado/Kain"},
      ],
      steps: [
        "Siapkan kardus bekas kokoh, lalu potong membentuk balok ukuran kotak tisu standar jika kardus terlalu besar.",
        "Buat lubang berbentuk oval atau persegi panjang di bagian atas penutup kardus sebagai jalur mengambil tisu.",
        "Oleskan lem secara merata di seluruh permukaan luar kardus.",
        "Tempelkan kertas kado bermotif estetik atau kain flanel/canvas dengan rapi tanpa menyisakan gelembung udara.",
        "Rapikan bagian pinggir lubang tisu atas dengan melipat sisa kertas ke dalam, lalu rekatkan.",
        "Masukkan tisu kemasan isi ulang ke dalam kotak, pasang penutupnya, dan kotak tisu siap digunakan."
      ],
    ),
    DaurUlangModel(
      title: "Bunga Hias Meja",
      category: "Kertas",
      difficulty: "Sangat Mudah",
      timeEstimate: "5-10 menit",
      imageUrl: "https://img.lazcdn.com/g/ff/kf/S4c6d550f095c4483a41cdb266ddfb45b5.jpg_720x720q80.jpg",
      price: "Rp5.000",
      detailDescription: "Kerajinan tangan sederhana yang menyulap sisa kertas origami atau majalah bekas menjadi buket bunga kecil. Hiasan mini ini bebas perawatan dan dapat mencerahkan suasana meja belajar Anda secara instan.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Gunting"},
        {"icon": Icons.colorize_rounded, "label": "Lem Kertas"},
        {"icon": Icons.note_rounded, "label": "Kertas\nOrigami"},
        {"icon": Icons.architecture_rounded, "label": "Lidi/Kawat"},
      ],
      steps: [
        "Potong kertas origami berwarna cerah menjadi beberapa bagian berbentuk persegi ukuran 10x10 cm.",
        "Lipat kertas secara diagonal beberapa kali, lalu gunting bagian ujungnya melengkung membentuk kelopak bunga.",
        "Buka lipatan kertas, maka kamu akan mendapatkan bentuk dasar bunga bermahkota indah.",
        "Gunakan lidi atau kawat kecil yang dibalut kertas hijau sebagai batang bunga.",
        "Tusukkan batang ke bagian tengah bunga krtas lalu kunci posisinya menggunakan sedikit lem kertas.",
        "Satukan beberapa tangkai bunga ke dalam vas kecil dari botol bekas untuk diletakkan di meja."
      ],
    ),
    DaurUlangModel(
      title: "Lampion Botol Bekas",
      category: "Botol",
      difficulty: "Susah",
      timeEstimate: "45-60 menit",
      imageUrl: "https://patch.com/img/cdn/users/41476/2012/10/raw/e8a0585a991d35d779f6592b18366260.jpg",
      price: "Rp25.000",
      detailDescription: "Lampion gantung elegan yang memanfaatkan botol plastik besar transparan. Kerajinan ini memerlukan ketelitian ekstra saat memotong pola celah lampion, namun menghasilkan efek pendaran cahaya lampu yang dramatis dan mewah.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Cutter Tajam"},
        {"icon": Icons.linear_scale_rounded, "label": "Penggaris"},
        {"icon": Icons.lightbulb_outline_rounded, "label": "Lampu LED/\nFitting"},
        {"icon": Icons.format_color_fill_rounded, "label": "Cat Semprot"},
      ],
      steps: [
        "Bersihkan botol plastik besar, tandai garis vertikal di sekeliling badan botol dengan jarak masing-masing 1.5 cm menggunakan penggaris.",
        "Iris perlahan garis vertikal tersebut menggunakan cutter (jangan sampai memotong bagian ujung atas dan bawah botol).",
        "Tekan botol dari arah atas ke bawah secara lembut agar bilah irisan plastik mekar dan menekuk keluar membentuk lampion.",
        "Warnai lampion menggunakan cat semprot transparan atau warna metalik emas/perak sesuai seleramu.",
        "Buat lubang pada tutup botol untuk memasukkan kabel fitting lampu LED.",
        "Pasang rangkaian lampu ke dalam botol, gantungkan lampion di teras rumah, lalu nyalakan di malam hari."
      ],
    ),
    DaurUlangModel(
      title: "Mainan Mobil Kardus",
      category: "Kardus",
      difficulty: "Sedang",
      timeEstimate: "30-40 menit",
      imageUrl: "https://cf.shopee.co.id/file/2d8e178d4992e9544634846ec2d894ea",
      price: "Rp18.000",
      detailDescription: "Proyek DIY seru membuat replika mobil mini dari kotak kardus sisa logistik. Selain merangsang kreativitas, mainan ramah lingkungan ini aman dimainkan anak-anak tanpa khawatir pecah atau rusak.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Gunting/Cut"},
        {"icon": Icons.circle_outlined, "label": "4 Tutup\nBotol Besar"},
        {"icon": Icons.crop_original_rounded, "label": "Kardus Susu"},
        {"icon": Icons.hardware_rounded, "label": "Tusuk Sate"},
      ],
      steps: [
        "Potong kardus berbentuk persegi panjang, lalu buat lekukan di bagian atas untuk ruang kemudi mobil.",
        "Lubangi bagian sisi samping bawah kardus di dua titik depan dan belakang untuk memasukkan poros roda.",
        "Potong tusuk sate sepanjang lebar kardus ditambah 2 cm sebagai poros as roda mobil.",
        "Lubangi bagian tengah dari 4 tutup botol besar, lalu pasangkan ke ujung-ujung tusuk sate sebagai roda.",
        "Gunakan lem tembak pada ujung poros agar roda terpasang kuat namun tetap dapat berputar.",
        "Hias mobil dengan menambahkan gambar lampu depan, plat nomor, dan stir kemudi dari sisa potongan kertas."
      ],
    ),
    DaurUlangModel(
      title: "Tempat Pensil Meja",
      category: "Botol",
      difficulty: "Sangat Mudah",
      timeEstimate: "5-10 menit",
      imageUrl: "https://thf.bing.com/th/id/OIP.ViIB7pam_Se5sNcdpGg0VgHaEK?w=329&h=185&c=7&r=0&o=7&cb=thfc1falcon&dpr=1.3&pid=1.7&rm=3",
      price: "Rp8.000",
      detailDescription: "Tempat pensil meja praktis yang dibuat dari potongan bawah botol air mineral. Solusi instan mengorganisir pulpen, pensil, dan penggaris agar meja belajar selalu terlihat rapi, bersih, dan estetik.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Gunting"},
        {"icon": Icons.layers, "label": "Pita Hias"},
        {"icon": Icons.local_drink_rounded, "label": "Botol Bekas"},
        {"icon": Icons.brush_rounded, "label": "Spidol\nSpi/Cat"},
      ],
      steps: [
        "Potong botol plastik secara horizontal tepat di bagian tengah menggunakan gunting atau cutter.",
        "Ambil potongan silinder bagian bawah botol dan buang potongan bagian atasnya.",
        "Gunakan kertas amplas halus atau setrika hangat sebentar pada ujung bekas potongan agar tidak tajam.",
        "Lapisi lingkar atas botol dengan pita hias kain untuk menutupi tekstur potongan plastik.",
        "Gambar pola geometris atau garis minimalis menggunakan spidol permanen di sekeliling badan botol.",
        "Tempatkan alat tulismu di dalam wadah baru ini. Selesai!"
      ],
    ),
    DaurUlangModel(
      title: "Rak Buku Kardus",
      category: "Kardus",
      difficulty: "Susah",
      timeEstimate: "40-50 menit",
      imageUrl: "https://thf.bing.com/th/id/OIP.0jL4G4yInhOqYgIlLZuT3QHaHa?w=181&h=181&c=7&r=0&o=7&cb=thfc1falcon&dpr=1.3&pid=1.7&rm=3",
      price: "Rp30.000",
      detailDescription: "Rak organizer multi-layer tangguh dari susunan kardus tebal berlapis (corrugated box). Mampu menampung koleksi buku fiksi, komik, atau berkas tugas kuliah dengan rapi tanpa memakan banyak tempat di meja.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Cutter Besar"},
        {"icon": Icons.dashboard_customize_rounded, "label": "Lem Tembak"},
        {"icon": Icons.crop_square_rounded, "label": "Kardus Tebal"},
        {"icon": Icons.linear_scale_rounded, "label": "Meteran"},
      ],
      steps: [
        "Potong kardus tebal menjadi beberapa lembar panel utama: 2 panel samping, 1 panel belakang, dan 3 panel sekat horizontal.",
        "Buat pola celah interlocking (saling mengunci) pada panel samping agar sekat horizontal bisa terpasang presisi.",
        "Rakit lembaran kardus tersebut mengikuti bentuk kotak rak, perkuat setiap sambungan sudut menggunakan lem tembak tebal.",
        "Lapisi lembaran luar rak dengan kertas karton polos tebal berwarna kraft atau putih untuk menutup pori-pori kardus.",
        "Pastikan lem mengering sempurna selama 15 menit dan tes kekuatan rak dengan menekan sekatnya pelan-pelan.",
        "Rak buku mini siap diletakkan di sudut meja untuk menampung buku-buku favoritmu."
      ],
    ),
    DaurUlangModel(
      title: "Tas Belanja Eco",
      category: "Plastik",
      difficulty: "Sedang",
      timeEstimate: "25-35 menit",
      imageUrl: "https://thf.bing.com/th/id/OIP.YYx7dgpiG52Ht_2OHJeEGgHaHa?w=196&h=196&c=7&r=0&o=7&cb=thfc1falcon&dpr=1.3&pid=1.7&rm=3",
      price: "Rp20.000",
      detailDescription: "Tas belanja ramah lingkungan yang diproduksi melalui anyaman rajut kantong plastik (kresek) bekas yang disatukan. Metode ini membuat plastik yang mulanya rapuh menjadi bahan tas belanja yang tebal, kuat, dan anti air.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Gunting"},
        {"icon": Icons.iron_rounded, "label": "Setrika baju"},
        {"icon": Icons.layers_rounded, "label": "Kantong\nKresek"},
        {"icon": Icons.description_rounded, "label": "Kertas\nHVS/Perkamen"},
        {"icon": Icons.brush_rounded, "label": "Lem Kayu/\nTembak"},
        {"icon": Icons.copy_rounded, "label": "Kertas\nHVS/Perkamen"},
      ],
      steps: [
        "Kumpulkan kantong kresek bekas sewarna, gunting bagian pegangan dan alas bawahnya hingga berbentuk silinder lembaran.",
        "Tumpuk 4-6 lembar plastik kresek secara sejajar di atas meja.",
        "Apit tumpukan plastik tersebut menggunakan dua lembar kertas perkamen/HVS di bagian atas dan bawahnya agar tidak meleleh langsung.",
        "Setrika dengan suhu sedang di atas kertas HVS secara merata selama beberapa detik hingga plastik melebur menyatu menjadi lembaran tebal.",
        "Potong lembaran plastik tebal baru tersebut membentuk pola tas belanja (badan depan, belakang, dan tali tali bawaan).",
        "Satukan tepi lipatan tas menggunakan lem industri khusus plastik atau jahit manual dengan benang tebal."
      ],
    ),
    DaurUlangModel(
      title: "Pembatas Buku Unik",
      category: "Kertas",
      difficulty: "Mudah",
      timeEstimate: "10-15 menit",
      imageUrl: "https://thf.bing.com/th/id/OIP.zwZeULgeOpAdqVDqKyGXGAHaEj?w=299&h=184&c=7&r=0&o=7&cb=thfc1falcon&dpr=1.3&pid=1.7&rm=3",
      price: "Rp4.000",
      detailDescription: "Pembatas halaman buku model sudut (corner bookmark) bergaya minimalis yang dibuat dari sisa kertas cover notes. Membantu menandai batas bacaan buku novel atau jurnal ilmiah tanpa merusak struktur kertas buku.",
      toolsAndMaterials: [
        {"icon": Icons.content_cut_rounded, "label": "Gunting"},
        {"icon": Icons.create_rounded, "label": "Spidol Warna"},
        {"icon": Icons.note_rounded, "label": "Kertas Tebal"},
        {"icon": Icons.architecture_rounded, "label": "Penggaris"},
      ],
      steps: [
        "Potong kertas tebal membentuk persegi berukuran tepat 12x12 cm.",
        "Lipat kertas menjadi bentuk segitiga sama kaki, pastikan semua sudutnya saling berhimpit rapi.",
        "Lipat kedua sudut bagian bawah segitiga mengarah ke atas menuju titik puncak sudut, lalu buka kembali lipatannya.",
        "Ambil satu lapisan ujung atas segitiga dan lipat ke arah bawah dasar sebagai kantung selipan halaman.",
        "Masukkan kembali lipatan sisi samping tadi ke dalam kantung yang terbentuk hingga terkunci menjadi saku segitiga sudut.",
        "Gunakan spidol warna untuk menghias permukaan pembatas buku dengan gambar ekspresi kartun atau kutipan quotes motivasi."
      ],
    ),
  ];
}

class EksplorPage extends StatefulWidget {
  final Function(int) onTapMenu; 
  final VoidCallback onTapScanButton;
  
  const EksplorPage({
    super.key, 
    required this.onTapMenu,
    required this.onTapScanButton, 
  }); 

  @override
  State<EksplorPage> createState() => _EksplorPageState();
}

class _EksplorPageState extends State<EksplorPage> {
  String selectedCategory = "Semua";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  List<DaurUlangModel> allIdeas = [];
  final List<String> categories = ["Semua", "Botol", "Plastik", "Kertas", "Kardus"];

  @override
  void initState() {
    super.initState();
    allIdeas = DaurUlangModel.allIdeas;
  }

  List<DaurUlangModel> get filteredIdeas {
    if (allIdeas.isEmpty) return [];
    
    return allIdeas.where((idea) {
      final matchesCategory = selectedCategory == "Semua" || idea.category == selectedCategory;
      final matchesSearch = idea.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayList = filteredIdeas;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. BAGIAN HEADER (Judul + Tombol Scan QR)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Temukan Ide Kreatif',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF17AC64), size: 28), 
                      onPressed: () {
                        widget.onTapScanButton(); 
                      },
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            // 2. Bagian Input Search dan Tombol Filter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari semua ide dan inspirasi disini',
                            hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: Colors.black38),
                            suffixIcon: searchQuery.isNotEmpty 
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.black38),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        searchQuery = "";
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 3. Bagian Horizontal List View Kategori
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    padding: const EdgeInsets.only(left: 20),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category == selectedCategory;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFFF2F4F2),
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected 
                                ? Border.all(color: const Color(0xFF17AC64), width: 1.5)
                                : Border.all(color: Colors.transparent, width: 1.5),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF17AC64) : Colors.black38,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 4. Bagian Grid Content atau "Tidak Ditemukan"
            displayList.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "Ide tidak ditemukan 😢",
                        style: TextStyle(color: Colors.black45, fontSize: 16),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    sliver: SliverGrid(
                      key: ValueKey<String>('${displayList.length}_${selectedCategory}_$searchQuery'),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.80,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = displayList[index];
                          
                          return TweenAnimationBuilder<double>(
                            key: ValueKey<String>(item.title),
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 10 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildIdeaGridCard(item),
                          );
                        },
                        childCount: displayList.length,
                      ),
                    ),
                  ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeaGridCard(DaurUlangModel idea) {
    return GestureDetector(
      onTap: () {
        context.read<HistoryProvider>().viewIde(idea.title); 

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EksplorDetailPage(idea: idea),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(idea.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    idea.title,
                    style: const TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    idea.category, // Diubah agar dinamis tanpa hardcode kata "plastik"
                    style: const TextStyle(
                      fontSize: 12, 
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${idea.difficulty} • ${idea.timeEstimate}",
                    style: TextStyle(
                      fontSize: 11, 
                      color: const Color(0xFF17AC64).withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}