import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResponStaff extends StatefulWidget {
  @override
  _ResponStaffState createState() => _ResponStaffState();
}

class _ResponStaffState extends State<ResponStaff> {
  // Controllers for text fields
  TextEditingController namaPeresponController = TextEditingController();
  TextEditingController deskripsiResponController = TextEditingController();

  // Method to handle the submit action
  void submitRespon() {
    // Logic to handle form submission can be added here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Respon berhasil dikirim!')),
    );

    // Clear the input fields after submission
    namaPeresponController.clear();
    deskripsiResponController.clear();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    namaPeresponController.dispose();
    deskripsiResponController.dispose();
    super.dispose();
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
                'Sidebar - OpenUser',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(context, '/staff');
              },
            ),
            ListTile(
              title: Text('Daftar Aduan', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(context, '/daftarAduanStaff');
              },
            ),
            ListTile(
              title: Text('Statistik', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(context, '/laporanAduan');
              },
            ),
            ListTile(
              title: Text('Bantuan', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pushNamed(context, '/bantuan');
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
                // Add logout functionality here, if needed
              },
            ),
          ],
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
                        'Respon ',
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
                controller: namaPeresponController,
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
                    onPressed: () {},
                    child: Text('Kirim',
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
}
