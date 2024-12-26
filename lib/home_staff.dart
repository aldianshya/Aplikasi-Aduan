import 'package:aplikasi_aduan/login_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeStaff extends StatefulWidget {
  final String email;
  const HomeStaff({super.key, required this.email});

  @override
  State<HomeStaff> createState() => _HomeStaffState();
}

class AppUser {
  final String nama;
  final String  tanggal_lahir;
  final String peran;
  final String alamat;
  final String nip;
  final String email;

  AppUser({
    required this.nama,
    required this.tanggal_lahir,
    required this.nip,
    required this.alamat,
    required this.peran,
    required this.email,
  });
}
class _HomeStaffState extends State<HomeStaff> {
  AppUser? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.email);
  }

  Future<void> fetchUserData(String email) async {
    try {
      print("Email yang dicari: $email"); // Debug

      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      print("Query result: ${userDoc.docs}"); // Debug

      if (userDoc.docs.isNotEmpty) {
        final data = userDoc.docs.first.data();
        print("Data ditemukan: $data"); // Debug

        setState(() {
          user = AppUser(
            nama: data['nama'] ?? '',
            tanggal_lahir: data['tanggal_lahir'] ?? '',
            nip: data['nip'] ?? '',
            peran: data['peran'] ?? '',
            alamat: data['alamat'] ?? '',
            email: data['email'] ?? '',
          );
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pengguna tidak ditemukan')),
        );
      }
    } catch (e) {
      print("Error detail: $e"); // Debug
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat mengambil data')),
      );
    }
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPageAdmin()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Sidebar - Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/admin',
                  arguments: widget.email,  // Mengirimkan email ke halaman BuatAduan
                );
              },
            ),
            ListTile(
              title: Text('Daftar Aduan', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/daftarAduanStaf',
                  arguments: widget.email,  // Mengirimkan email ke halaman BuatAduan
                );
              },
            ),
            ListTile(
              title: Text('Statistik', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/laporanAduan',
                  arguments: widget.email,  // Mengirimkan email ke halaman BuatAduan
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Keluar',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
              leading: Icon(Icons.logout, color: Colors.red),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Show loading spinner until data is fetched
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/pic.png',
                      height: 150, // Adjust height as needed
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 70,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'Selamat Datang',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 102, 192),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Check if user data is available before displaying it
                    Text('Nama: ${user?.nama ?? "Loading..."}'),
                    SizedBox(height: 16),
                    Text('Tanggal Lahir: ${user?.tanggal_lahir ?? "Loading..."}'),
                    SizedBox(height: 16),
                    Text('NIP: ${user?.nip ?? "Loading..."}'),
                    SizedBox(height: 16),
                    Text('Peran: ${user?.peran ?? "Loading..."}'),
                    SizedBox(height: 16),
                    Text('Alamat: ${user?.alamat ?? "Loading..."}'),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper function to create text fields with controllers
  Widget buildTextField({
    required String labelText,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 132, 197, 255),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 132, 197, 255),
          ),
        ),
      ),
    );
  }
}
