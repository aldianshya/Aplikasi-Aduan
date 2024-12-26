import 'package:aplikasi_aduan/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuatAduan extends StatefulWidget {
  final String email;
  const BuatAduan({required this.email});

  @override
  State<BuatAduan> createState() => _HalamanAduan();
}

class _HalamanAduan extends State<BuatAduan> {
  final _judulAduanController = TextEditingController();
  final _namaController = TextEditingController();
  final _tanggalAduanController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String? _selectedJenisAduan; // Untuk menyimpan pilihan dari dropdown

  // Daftar opsi jenis aduan
  final List<String> jenisAduanOptions = [
    'Kebersihan',
    'Kerusakan Infrastruktur',
    'Layanan Publik',
    'Pelanggaran Hukum',
    'Lainnya',
  ];
void logout() {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPageSiswa()),
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
      arguments: widget.email,  // Mengirimkan email ke halaman BuatAduan
    );
  },
),
            ListTile(
  title: Text('Buat Aduan', style: GoogleFonts.poppins()),
  onTap: () {
    Navigator.pushNamed(
      context,
      '/buatAduan',
      arguments: widget.email,  // Mengirimkan email ke halaman BuatAduan
    );
  },
),
ListTile(
  title: Text('Aduan Saya', style: GoogleFonts.poppins()),
  onTap: () {
    Navigator.pushNamed(
      context,
      '/aduansaya',
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
                // Add logout functionality here, if needed
              },
            ),
          ],
        ),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
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
                        'Buat Aduan',
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
              SizedBox(height: 16),
              TextField(
                controller: _judulAduanController,
                decoration: InputDecoration(
                  labelText: 'Judul Aduan',
                  labelStyle: GoogleFonts.poppins(),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: GoogleFonts.poppins(),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _tanggalAduanController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Aduan',
                      labelStyle: GoogleFonts.poppins(),
                      suffixIcon:
                          Icon(Icons.calendar_today, color: Colors.blue),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedJenisAduan,
                onChanged: (newValue) {
                  setState(() {
                    _selectedJenisAduan = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Jenis Aduan',
                  labelStyle: GoogleFonts.poppins(),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: jenisAduanOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.poppins()),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _deskripsiController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Aduan',
                  labelStyle: GoogleFonts.poppins(),
                  suffixIcon: Icon(Icons.text_fields, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Save button color
                    ),
                    onPressed: () {
                      _saveAduan();
                    },
                    child: Text('Save',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAduan() async {
    final aduanData = {
      'judulAduan': _judulAduanController.text,
      'nama': _namaController.text,
      'tanggalAduan': _tanggalAduanController.text,
      'jenisAduan': _selectedJenisAduan,
      'deskripsi': _deskripsiController.text,
      'email': widget.email,
      'status': false,  // Status aduan, tipe boolean dan default false
      'responguru': "", 
      'responwali': "", 
      // 'respon': "", 
      'namaPeresponWali': "", 
      'namaPeresponGuru': "", 
    };

    try {
      await FirebaseFirestore.instance.collection('aduan').add(aduanData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aduan berhasil disimpan!')),
      );

      Navigator.pop(context); // Kembali ke halaman Home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan aduan: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _tanggalAduanController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }
}
