import 'package:flutter/material.dart';

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

  // Fungsi buat nambah riwayat scan
  void addScan(String namaBarang) {
    _jumlahScan++;
    _lastScan = namaBarang;
    notifyListeners(); // Ini biar halaman lain tau ada data baru
  }

  // Fungsi buat nambah riwayat ide dilihat
  void viewIde(String judulIde) {
    _jumlahIde++;
    _lastIde = judulIde;
    notifyListeners();
  }

  // Fungsi buat nambah riwayat barang dibuat
  void createBarang(String namaBarang) {
    _lastMade = namaBarang;
    notifyListeners();
  }
}