import 'package:aplikasi_aduan/login_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _nipController = TextEditingController();
  final _roleController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  Future<void> _signup() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();
    final String username = _usernameController.text.trim();


    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Isi semua form dengan benar!")),
      );
      return;
    }
    // Validasi password
    if (_confirmPasswordController.text != _passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password tidak sama, silahkan masukkan password yang benar')),
      );
      return;
    }

    try {
      // Buat user dengan email dan password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Kirim email verifikasi
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {

        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email verifikasi telah dikirim!")),
        );

        // Simpan data pengguna ke Firestore
        await _firestore.collection('user').doc(user.uid).set({
          'nama': name,
          'email': email,
          'username': username,
      
        });
      }

      // Update profil pengguna dengan nama (opsional)
      // await userCredential.user?.updateProfile(
      //   displayName: _nameController.text.trim(),
      // );

      // Navigasi ke halaman home setelah signup berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPageAdmin()),
      );
    } on FirebaseAuthException catch (e) {
      // Tangani error spesifik dari Firebase Auth
      String errorMessage = '';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password terlalu lemah';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email sudah terdaftar';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        default:
          errorMessage = 'Terjadi kesalahan: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      
    } catch (e) {
      // Tangani error lainnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    body: Stack(
      children: [
        // Background Gradient
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF78B3CE), // Background color
          ),
        ),
        // Content
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Illustration or Logo
                    Container(
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.6,
                      child: Image.asset(
                        'assets/logo/signup.png', // Gambar ilustrasi
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Title
                    Text(
                      "Buat Akun",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Bergabunglah dengan komunitas kami",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),

                    // Nama Input
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Color(0xFF78B3CE)),
                        hintText: "Nama",
                        hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // NIP Input
                    TextFormField(
                      controller: _nipController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.badge, color: Color(0xFF78B3CE)),
                        hintText: "NIP",
                        hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Peran Input
                    TextFormField(
                      controller: _roleController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.work, color: Color(0xFF78B3CE)),
                        hintText: "Peran",
                        hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Tanggal Lahir Input
                    TextFormField(
                      controller: _dobController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF78B3CE)),
                        hintText: "Tanggal Lahir (YYYY-MM-DD)",
                        hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Alamat Input
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.home, color: Color(0xFF78B3CE)),
                        hintText: "Alamat",
                        hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Email Input
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Color(0xFF78B3CE)),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Password Input
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF78B3CE)),
                        hintText: "Kata Sandi",
                        hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Konfirmasi Password Input
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF78B3CE)),
                        hintText: "Konfirmasi Kata Sandi",
                        hintStyle: TextStyle(color: Color(0xFF78B3CE)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Tombol Signup
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF78B3CE),
                        minimumSize: Size(200, 48), // Lebar 200, tinggi 48
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                      onPressed: _signup,
                      child: Text(
                        "Daftar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Opsi Login
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPageAdmin()),
                          (Route<dynamic> route) => false, // Menghapus semua halaman sebelumnya
                        );
                      },
                      child: Text(
                        "Sudah punya akun? Masuk",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  @override
  void dispose() {
    // Bersihkan kontroler
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}