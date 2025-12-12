// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/main_wrapper.dart'; // <-- Pastikan Anda mengimpor MainWrapper
import 'providers/user_provider.dart'; 

void main() {
  runApp(
    // 1. Daftarkan UserProvider di atas MyApp
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StageTalk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      // 2. Tentukan Home sebagai MainScreenLoader
      home: const MainScreenLoader(), 
    );
  }
}


// Widget BARU: Menangani Pemuatan Status Login
class MainScreenLoader extends StatelessWidget {
  const MainScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil UserProvider dan panggil checkLoginStatus() saat build pertama kali
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // FutureBuilder akan menunggu hasil dari checkLoginStatus
    return FutureBuilder(
      // Panggil checkLoginStatus() untuk memuat data dari SharedPreferences
      future: userProvider.checkLoginStatus(),
      builder: (context, snapshot) {
        // Tampilkan loading screen selama Future berjalan
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Ambil status login secara real-time (listen: true di dalam builder)
        // Kita gunakan Consumer untuk menghindari Provider.of(listen: true) di FutureBuilder
        return Consumer<UserProvider>(
          builder: (context, provider, child) {
            // Jika currentUser tidak null, pengguna sudah login -> navigasi ke MainWrapper
            if (provider.currentUser != null) {
              return const MainWrapper();
            } 
            // Jika currentUser null, pengguna belum login -> navigasi ke LoginPage
            else {
              return const LoginPage();
            }
          },
        );
      },
    );
  }
}