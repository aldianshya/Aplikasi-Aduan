import 'package:aplikasi_aduan/login_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LaporanStatistik extends StatefulWidget {
  final String email;

  const LaporanStatistik({Key? key, required this.email}) : super(key: key);

  @override
  _LaporanStatistikState createState() => _LaporanStatistikState();
}

class _LaporanStatistikState extends State<LaporanStatistik> {
  String selectedYear = "Pilih Tahun";
  String selectedType = "Jenis Aduan";
  int currentPage = 1;
  int itemsPerPage = 5;

  // Fungsi untuk mengambil data dari Firebase
  Stream<List<Map<String, dynamic>>> getComplaints() {
    return FirebaseFirestore.instance
        .collection('aduan')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'judul': data['judulAduan'] ?? '',
                'tanggal': data['tanggalAduan'] ?? '',
                'status': (data['status'] == true)
                    ? 'Sudah Direspon'
                    : 'Belum Direspon',
              };
            }).toList());
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getComplaints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final complaints = snapshot.data ?? [];
          final totalItems = complaints.length;
          final totalPages = (totalItems / itemsPerPage).ceil();
          final paginatedComplaints = complaints
              .skip((currentPage - 1) * itemsPerPage)
              .take(itemsPerPage)
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/pic.png',
                        height: 50,
                      ),
                      Container(
                        width: 150,
                        height: 50,
                        color: Colors.blue.shade100,
                        child: Center(
                          child: Text(
                            'Laporan Statistik',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    color: Colors.blue.shade50,
                    padding: const EdgeInsets.all(10),
                    child: Table(
                      columnWidths: {
                        0: const FixedColumnWidth(40),
                        1: const FlexColumnWidth(),
                        2: const FlexColumnWidth(),
                        3: const FlexColumnWidth(),
                      },
                      border: TableBorder.all(color: Colors.black26),
                      children: [
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.blue.shade200),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("No",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Judul Aduan",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Tanggal Aduan",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Status Aduan",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        for (int i = 0;
                            i < paginatedComplaints.length;
                            i++)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${(currentPage - 1) * itemsPerPage + i + 1}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  paginatedComplaints[i]['judul']!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  paginatedComplaints[i]['tanggal']!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  paginatedComplaints[i]['status']!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: currentPage > 1
                            ? () => setState(() => currentPage--)
                            : null,
                      ),
                      Text("Page $currentPage of $totalPages",
                          style: GoogleFonts.poppins()),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: currentPage < totalPages
                            ? () => setState(() => currentPage++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
