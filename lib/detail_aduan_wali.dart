// import 'package:aplikasi_aduan/respon_guru.dart';
import 'package:aplikasi_aduan/respon_wali.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Complain {
  final bool status;  // Change to bool
  final String tanggalAduan;
  final String jenisAduan;
  final String judulAduan;
  final String deskripsi;
  final String respon;

  Complain({
    required this.status,
    required this.tanggalAduan,
    required this.jenisAduan,
    required this.judulAduan,
    required this.deskripsi,
    required this.respon,
  });
}

class DetailAduanWali extends StatelessWidget {
  final String judulAduan;
  DetailAduanWali({required this.judulAduan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.blue,
  title: Text(
    'Detail Aduan',
    style: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pop(context); // Navigate back to the previous screen (DaftarAduan)
    },
  ),
),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('aduan')
            .where('judulAduan', isEqualTo: judulAduan)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Data tidak ditemukan'));
          }

          var aduanData = snapshot.data!.docs.first;
          bool status = aduanData['status'];  // Treat as boolean
          String responguru = aduanData['responguru'] ?? 'Belum ada respon';
          String responwali = aduanData['responwali'] ?? 'Belum ada respon';
          String namaPeresponGuru = aduanData['namaPeresponGuru'] ?? 'N/A';
          String namaPeresponWali = aduanData['namaPeresponWali'] ?? 'N/A';
          String tanggalAduan = aduanData['tanggalAduan'] ?? 'N/A';
          String jenisAduan = aduanData['jenisAduan'] ?? 'N/A';
          String deskripsi = aduanData['deskripsi'] ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDetailField("Status", status ? 'Sudah Direspon' : 'Belum Direspon'),
                buildDetailField("Tanggal Aduan", tanggalAduan),
                buildDetailField("Jenis Aduan", jenisAduan),
                buildDetailField("Judul Aduan", judulAduan, maxLines: 3),
                buildDetailField("Deskripsi", deskripsi, maxLines: 5),
                buildDetailField("Respon Guru", responguru, maxLines: 5),
                buildDetailField("Respon Wali", responwali, maxLines: 5),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      String judulAduan = aduanData['judulAduan'];
                      // Panggil fungsi untuk menghapus aduan
                      try {
                        final querySnapshot = await FirebaseFirestore.instance
                            .collection('aduan')
                            .where('judulAduan', isEqualTo: judulAduan)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          String docId = querySnapshot.docs.first.id;

                          await FirebaseFirestore.instance
                              .collection('aduan')
                              .doc(docId)
                              .delete();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Aduan berhasil dihapus')),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Aduan dengan judul tersebut tidak ditemukan')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terjadi kesalahan saat menghapus aduan')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Hapus',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    String judulAduan = aduanData['judulAduan'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResponWali(judulAduan: judulAduan),
                      ),
                    );
                  },
                  child: Text(
                    'Respon',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDetailField(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                value,
                style: GoogleFonts.poppins(),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
