import 'package:aplikasi_aduan/login_guru.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWali extends StatefulWidget {
  final String email;
  const HomeWali({super.key, required this.email});

  @override
  State<HomeWali> createState() => _HomeWaliState();
}

class AppUser {
  final String nama;
  final String tanggal_lahir;
  final String kelas;
  final String alamat;
  final String nip;
  final String peran;
  final String email;
  final String emailanak;

  AppUser({
    required this.nama,
    required this.tanggal_lahir,
    required this.alamat,
    required this.nip,
    required this.peran,
    required this.kelas,
    required this.email,
    required this.emailanak,
  });
}

class _HomeWaliState extends State<HomeWali> {
  AppUser? user;
  bool isLoading = true;
  String? namaAnak;  // Untuk menyimpan nama anak
  
  @override
  void initState() {
    super.initState();
    fetchUserData(widget.email);
  }

  Future<void> fetchUserData(String email) async {
  try {
    print("Email yang dicari: $email");

    final userDoc = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    print("Jumlah dokumen ditemukan: ${userDoc.docs.length}");

    if (userDoc.docs.isNotEmpty) {
      final data = userDoc.docs.first.data();
      print("Data ditemukan: $data");
      
      setState(() {
        user = AppUser(
          nama: data['nama'] ?? '',
          tanggal_lahir: data['tanggal_lahir'] ?? '',
          nip: data['nip'] ?? '',
          peran: data['peran'] ?? '',
          kelas: data['kelas'] ?? '',
          alamat: data['alamat'] ?? '',
          email: data['email'] ?? '',
          emailanak: data['emailanak'] ?? '',
        );
        isLoading = false;
      });

      if (user?.emailanak != null && user?.emailanak!.isNotEmpty == true) {
        fetchNamaAnak(user!.emailanak!);
      } else {
        setState(() {
          namaAnak = 'Email anak tidak ditemukan';
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pengguna tidak ditemukan')),
      );
    }
  } catch (e) {
    print("Error detail: $e");
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terjadi kesalahan saat mengambil data')),
    );
  }
}

Future<void> fetchNamaAnak(String emailAnak) async {
  try {
    final anakDoc = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: emailAnak)
        .get();

    print("Jumlah anak ditemukan: ${anakDoc.docs.length}");

    if (anakDoc.docs.isNotEmpty) {
      final dataAnak = anakDoc.docs.first.data();
      print("Nama anak ditemukan: ${dataAnak['nama']}");
      
      setState(() {
        namaAnak = dataAnak['nama'] ?? 'Nama anak tidak ditemukan';
      });
    } else {
      setState(() {
        namaAnak = 'Anak tidak ditemukan dengan email tersebut';
      });
    }
  } catch (e) {
    print("Error detail: $e");
    setState(() {
      namaAnak = 'Gagal memuat nama anak';
    });
  }
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
                'Sidebar - Wali',
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
                  '/wali',
                  arguments: widget.email,
                );
              },
            ),
            ListTile(
              title: Text('Daftar Aduan', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/daftarAduanWali',
                  arguments: user?.emailanak,
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
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/pic.png',
                      height: 150,
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
                    Text('Nama: ${user?.nama ?? "Loading..."}'),
                    SizedBox(height: 16),
                    // Nama anak yang ditampilkan
                    Text('Nama Anak: ${namaAnak ?? "Loading..."}'),
                    SizedBox(height: 16),
                    Text('Tanggal Lahir: ${user?.tanggal_lahir ?? "Loading..."}'),
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

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPageGuru()),
      (Route<dynamic> route) => false,
    );
  }
}
