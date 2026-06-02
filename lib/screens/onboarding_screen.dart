import 'package:ecoscan/screens/home_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Ubah Barang Bekas Jadi Lebih Berguna",
      "subtitle": "Temukan cara mengolah barang bekas menjadi sesuatu yang bermanfaat.",
      "image": "assets/images/slide1.png", 
    },
    {
      "title": "Pindai Barang Bekas & Temukan Ide Kreatif",
      "subtitle": "Dapatkan inspirasi karya sekaligus lihat potensi nilai jualnya.",
      "image": "assets/images/slide2.png",
    },
    {
      "title": "Mulai Peduli Lingkungan dari Hal Kecil",
      "subtitle": "Langkah kecilmu dapat mengurangi sampah dan menjaga lingkungan.",
      "image": "assets/images/slide3.png",
    },
  ];

  void _goToHome() {
    // Langsung loncat ke beranda, terus kalo back di beranda ga kepental ke onboarding
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text("Kembali", style: TextStyle(color: Colors.black26)),
                        )
                      : const SizedBox(width: 60),
                  
                  TextButton(
                    onPressed: _goToHome,
                    child: const Text(
                      "Lewati", 
                      style: TextStyle(color: Color(0xFF27AE60), fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            ),

            // Slider bawah
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            _onboardingData[index]["image"]!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          _onboardingData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E2E2E),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _onboardingData[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black38,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Footer onboarding (Elemen Slider)
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? const Color(0xFF27AE60) : const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _onboardingData.length - 1) {
                          _goToHome();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27AE60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1 ? "Mulai Sekarang" : "Selanjutnya",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
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