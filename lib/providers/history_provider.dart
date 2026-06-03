import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  int _jumlahScan = 0;
  int _jumlahIde = 0;

  String _lastScan = "Belum ada scan";
  String _lastIde = "Belum ada ide dilihat";
  String _lastMade = "Belum ada barang dibuat";

  // Getters
  int get jumlahScan => _jumlahScan;
  int get jumlahIde => _jumlahIde;
  String get lastScan => _lastScan;
  String get lastIde => _lastIde;
  String get lastMade => _lastMade;

  HistoryProvider() {
    loadHistoryFromStorage();
  }

  // Ini buat nyimpen data histori ke storage
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('jumlahScan', _jumlahScan);
    await prefs.setInt('jumlahIde', _jumlahIde);
    await prefs.setString('lastScan', _lastScan);
    await prefs.setString('lastIde', _lastIde);
    await prefs.setString('lastMade', _lastMade);
  }

// Ini buat ambil data histori dari storage
Future<void> loadHistoryFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Ambil data, kalau null kasih nilai default bawaan lo
    _jumlahScan = prefs.getInt('jumlahScan') ?? 0;
    _jumlahIde = prefs.getInt('jumlahIde') ?? 0;
    _lastScan = prefs.getString('lastScan') ?? "Belum ada scan";
    _lastIde = prefs.getString('lastIde') ?? "Belum ada ide dilihat";
    _lastMade = prefs.getString('lastMade') ?? "Belum ada barang dibuat";
    
    notifyListeners(); // Update UI setelah data berhasil dimuat
  }

  // Fungsi buat nambah riwayat scan
  void addScan(String namaBarang) async {
    _jumlahScan++;
    _lastScan = namaBarang;
    notifyListeners(); // Ini biar halaman lain tau ada data baru
    await _saveToStorage();
  }

  // Fungsi buat nambah riwayat ide dilihat
  void viewIde(String judulIde) async {
    _jumlahIde++;
    _lastIde = judulIde;
    notifyListeners();
    await _saveToStorage();
  }

  // Fungsi buat nambah riwayat barang dibuat
  void createBarang(String namaBarang) async {
    _lastMade = namaBarang;
    notifyListeners();
    await _saveToStorage();
  }

  // Di dalam class HistoryProvider
  void resetHistory() async {
    _jumlahScan = 0;
    _jumlahIde = 0;
    _lastScan = "Belum ada scan";
    _lastIde = "Belum ada ide dilihat";
    _lastMade = "Belum ada barang dibuat";

    notifyListeners();

    // Ini buat hapus total kalau histori di set ulang
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jumlahScan');
    await prefs.remove('jumlahIde');
    await prefs.remove('lastScan');
    await prefs.remove('lastIde');
    await prefs.remove('lastMade');
  }
}
