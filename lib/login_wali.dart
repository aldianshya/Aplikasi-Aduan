// import 'package:aplikasi_aduan/home_guru.dart';
// import 'package:aplikasi_aduan/home_siswa.dart';
// import 'package:aplikasi_aduan/home_staff.dart';
import 'package:aplikasi_aduan/home_wali.dart';
import 'package:aplikasi_aduan/login.dart';
import 'package:aplikasi_aduan/login_admin.dart';
import 'package:aplikasi_aduan/login_guru.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPageWali extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageWali> {
  late TapGestureRecognizer _adminTapRecognizer;
  late TapGestureRecognizer _orangTuaTapRecognizer;
  late TapGestureRecognizer _guruTapRecognizer;
  bool passwordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';


  Future<void> signIn() async {
    try {
      // Verifikasi email dan password menggunakan Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Jika login berhasil, navigasikan ke halaman HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeWali(email: emailController.text.trim())),
      );
    } catch (e) {
      // Jika login gagal, tampilkan error
      setState(() {
        errorMessage = e.toString();
      });
    }
  }
  void navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void initState() {
    super.initState();
    _adminTapRecognizer = TapGestureRecognizer();
    _orangTuaTapRecognizer = TapGestureRecognizer();
    _guruTapRecognizer = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _adminTapRecognizer.dispose();
    _orangTuaTapRecognizer.dispose();
    _guruTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(MediaQuery.of(context).size.width / 2),
                  bottomRight:
                      Radius.circular(MediaQuery.of(context).size.width / 2),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 80,
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        'Selamat Datang \n Anda login sebagai Wali SIswa',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Masukan ID User",
                        hintStyle: GoogleFonts.poppins(color: Colors.white),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        hintText: "Masukan Password",
                        hintStyle: GoogleFonts.poppins(color: Colors.white),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Login as Admin, Orang Tua, Guru links
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Ingin login sebagai Admin? ',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'klik disini',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  navigateToPage(LoginPageAdmin());
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Ingin login sebagai SIswa? ',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'klik disini',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  navigateToPage(LoginPageSiswa());
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Ingin login sebagai Guru? ',
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'klik disini',
                              style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  navigateToPage(LoginPageGuru());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
