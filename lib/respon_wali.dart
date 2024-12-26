import 'package:aplikasi_aduan/detail_aduan_wali.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // Import halaman DetailAduan

class ResponWali extends StatefulWidget {
  final String judulAduan;  // Parameter yang diterima
  ResponWali({required this.judulAduan});

  @override
  _ResponWaliState createState() => _ResponWaliState();
}

class _ResponWaliState extends State<ResponWali> {
  TextEditingController namaPeresponwaliController = TextEditingController();
  TextEditingController deskripsiResponController = TextEditingController();

  // Method to handle the submit action
  Future<void> addRespon(String judulAduan, String namaPeresponwali, String deskripsiRespon) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('aduan')
          .where('judulAduan', isEqualTo: judulAduan)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('aduan')
            .doc(docId)
            .update({
          'responwali': deskripsiRespon,
          'namaPeresponWali': namaPeresponwali,
          'tanggalRespon': Timestamp.now(),
        });

        // Updating the status to 'true' (resolved)
        await updateStatus(judulAduan);

        print("Respon berhasil ditambahkan");

        // Arahkan ke halaman DetailAduan setelah berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailAduanWali(judulAduan: judulAduan),
          ),
        );
      }
    } catch (e) {
      print("Gagal menambahkan respons: $e");
    }
  }

  // Fungsi untuk memperbarui status
  Future<void> updateStatus(String judulAduan) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('aduan')
          .where('judulAduan', isEqualTo: judulAduan)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('aduan')
            .doc(docId)
            .update({'status': true});
        print("Status berhasil diperbarui");
      } else {
        print("Dokumen dengan judulAduan '$judulAduan' tidak ditemukan");
      }
    } catch (e) {
      print("Gagal memperbarui status: $e");
    }
  }

  @override
  void dispose() {
    namaPeresponwaliController.dispose();
    deskripsiResponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Respon Aduan',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
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
                        'Respon',
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

              // Nama Perespon Field
              TextField(
                controller: namaPeresponwaliController,
                decoration: InputDecoration(
                  labelText: 'Nama Perespon',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: deskripsiResponController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Respon',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
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
                    onPressed: () async {
                      String namaPeresponwali = namaPeresponwaliController.text;
                      String deskripsiRespon = deskripsiResponController.text;
                      String judulAduan = widget.judulAduan; // Ambil judulAduan yang diterima

                      await addRespon(judulAduan, namaPeresponwali, deskripsiRespon);

                      // Clear input fields after submission
                      namaPeresponwaliController.clear();
                      deskripsiResponController.clear();
                    },
                    child: Text(
                      'Kirim',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
