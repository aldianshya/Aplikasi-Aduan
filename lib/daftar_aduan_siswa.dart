import 'package:aplikasi_aduan/detail_aduan_Siswa.dart';
import 'package:aplikasi_aduan/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarAduanSiswa extends StatefulWidget {
  const DaftarAduanSiswa({required this.email, super.key});
  final String email;
  // const DaftarAduanSiswa({required this.email});

  @override
  State<DaftarAduanSiswa> createState() => _HalamanDaftarAduanSiswa();
}

int currentPage = 1;
final int complaintsPerPage = 4;

class _HalamanDaftarAduanSiswa extends State<DaftarAduanSiswa> {
  List<Map<String, dynamic>> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    try {
      // Filter data berdasarkan email pengguna
      final querySnapshot = await FirebaseFirestore.instance
          .collection('aduan')
          .where('email', isEqualTo: widget.email) // Filter berdasarkan email pengguna
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> loadedComplaints = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        setState(() {
          complaints = loadedComplaints;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada aduan ditemukan')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat mengambil data')),
      );
    }
  }

  List<Map<String, dynamic>> getCurrentPageComplaints() {
    int startIndex = (currentPage - 1) * complaintsPerPage;
    int endIndex = (startIndex + complaintsPerPage);
    endIndex = endIndex > complaints.length ? complaints.length : endIndex;
    return complaints.sublist(startIndex, endIndex);
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPageSiswa()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (complaints.length / complaintsPerPage).ceil();

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
                'Sidebar - Siswa',
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
                  '/siswa',
                  arguments: widget.email,
                );
              },
            ),
            ListTile(
              title: Text('Buat Aduan', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/buatAduan',
                  arguments: widget.email,
                );
              },
            ),
            ListTile(
              title: Text('Daftar Aduan', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(context, '/daftarAduanSiswa');
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
          ? const Center(child: CircularProgressIndicator())
          : complaints.isEmpty
              ? const Center(child: Text('Tidak ada aduan ditemukan'))
              : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: complaints.length,
                          itemBuilder: (context, index) {
                            var complaint = complaints[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.expand_more,
                                      color: Colors.white),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaint['judulAduan'] ?? 'Judul Tidak Tersedia',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          complaint['tanggalAduan'] ?? 'Tanggal Tidak Tersedia',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailAduanSiswa(
                                              judulAduan: complaint['judulAduan']),
                                        ),
                                      );
                                    },
                                    child: Text('Detail'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }
}