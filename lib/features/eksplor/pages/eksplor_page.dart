import 'package:flutter/material.dart';
import 'eksplor_detail_page.dart';

class DaurUlangModel {
  final String title;
  final String category;
  final String difficulty;
  final String timeEstimate;
  final String imageUrl;

  DaurUlangModel({
    required this.title,
    required this.category,
    required this.difficulty,
    required this.timeEstimate,
    required this.imageUrl,
  });
}

class EksplorPage extends StatefulWidget {
  const EksplorPage({super.key});

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
    allIdeas = [
      DaurUlangModel(
        title: "Pot Tanaman Kucing",
        category: "Botol",
        difficulty: "Mudah",
        timeEstimate: "10-15 menit",
        imageUrl: "https://images.pexels.com/photos/3075993/pexels-photo-3075993.jpeg?auto=compress&cs=tinysrgb&w=400",
      ),
      DaurUlangModel(
        title: "Celengan Babi",
        category: "Plastik",
        difficulty: "Sedang",
        timeEstimate: "20-30 menit",
        imageUrl: "https://images.unsplash.com/photo-1599599810769-bcde5a160d32?q=80&w=500",
      ),
      DaurUlangModel(
        title: "Kotak Tisu Estetik",
        category: "Kardus",
        difficulty: "Mudah",
        timeEstimate: "15-20 menit",
        imageUrl: "https://images.unsplash.com/photo-1532634922-8fe0b757fb13?q=80&w=500",
      ),
      DaurUlangModel(
        title: "Bunga Hias Meja",
        category: "Kertas",
        difficulty: "Sangat Mudah",
        timeEstimate: "5-10 menit",
        imageUrl: "https://images.pexels.com/photos/6045148/pexels-photo-6045148.jpeg?auto=compress&cs=tinysrgb&w=400",
      ),
      DaurUlangModel(
        title: "Lampion Botol Bekas",
        category: "Botol",
        difficulty: "Susah",
        timeEstimate: "45-60 menit",
        imageUrl: "https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?q=80&w=500",
      ),
      DaurUlangModel(
        title: "Mainan Mobil Kardus",
        category: "Kardus",
        difficulty: "Sedang",
        timeEstimate: "30-40 menit",
        imageUrl: "https://images.pexels.com/photos/3920610/pexels-photo-3920610.jpeg?auto=compress&cs=tinysrgb&w=400",
      ),
    ];
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Temukan Ide Kreatif',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF17AC64), size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune_rounded, color: Color(0xFF17AC64)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          SizedBox(
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

          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: displayList.isEmpty
                  ? const Center(
                      child: Text(
                        "Ide tidak ditemukan 😢",
                        style: TextStyle(color: Colors.black45, fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      itemCount: displayList.length,
                      key: ValueKey<String>('${displayList.length}_${selectedCategory}_$searchQuery'), 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.80,
                      ),
                      itemBuilder: (context, index) {
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
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdeaGridCard(DaurUlangModel idea) {
    return GestureDetector(
      onTap: () {
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
                    "${idea.category} plastik",
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