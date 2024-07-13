import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class RegisterPage extends StatelessWidget {
  // Controller untuk input teks
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dobController = TextEditingController(); // Controller untuk tanggal lahir

  // Fungsi untuk mendaftarkan pengguna dengan email dan kata sandi
  Future<void> registerWithEmailAndPassword(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    try {
      // Membuat pengguna baru dengan email dan kata sandi
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Tambahkan data pengguna ke Firestore
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullNameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'address': addressController.text,
        'dateOfBirth': dobController.text, // Simpan tanggal lahir
      });
      
      print('User registered: ${userCredential.user!.uid}');
      // Navigasi ke halaman beranda setelah registrasi sukses
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Ganti dengan halaman yang sesuai
      );
    } catch (e) {
      print('Error registering user: $e');
      // Tambahkan penanganan error sesuai kebutuhan aplikasi Anda
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendaftar: $e'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade800,
              Colors.blue.shade400
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Daftar", style: TextStyle(color: Colors.white, fontSize: 40)), // Judul halaman
                  SizedBox(height: 10,),
                  Text("Buat akun baru", style: TextStyle(color: Colors.white, fontSize: 18)), // Sub-judul halaman
                ],
              ),
            ),
            SizedBox(height: 1),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)) // Membuat tepi atas bulat
                ),
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: SingleChildScrollView( // Membuat halaman bisa digulir
                      child: Column(
                        children: <Widget>[
                          // Input teks untuk nama lengkap
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                            ),
                            child: TextField(
                              controller: fullNameController,
                              decoration: InputDecoration(
                                hintText: "Nama Lengkap",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          // Input teks untuk username
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                            ),
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          // Input teks untuk email
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          // Input teks untuk kata sandi
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                            ),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true, // Menyembunyikan teks saat mengetik
                              decoration: InputDecoration(
                                hintText: "Kata Sandi",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          // Input teks untuk alamat
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                            ),
                            child: TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                hintText: "Alamat",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          // Input teks untuk tanggal lahir
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                            ),
                            child: TextField(
                              controller: dobController,
                              decoration: InputDecoration(
                                hintText: "Tanggal Lahir",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                          // Tombol untuk mendaftar
                          MaterialButton(
                            onPressed: () => registerWithEmailAndPassword(context), // Memanggil fungsi registerWithEmailAndPassword saat tombol ditekan
                            height: 50,
                            color: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text("Daftar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // Teks pada tombol
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
