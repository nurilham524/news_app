import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profilSettingScreen.dart';
import 'home_page.dart';
import 'news_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  // Konstruktor untuk menerima objek User yang sedang login
  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<DocumentSnapshot> userDoc;

  @override
  void initState() {
    super.initState();
    // Mengambil data pengguna dari Firestore berdasarkan UID
    userDoc = FirebaseFirestore.instance.collection('users').doc(widget.user.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: userDoc,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat menunggu data
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Menampilkan pesan error jika terjadi kesalahan
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Data pengguna tidak ditemukan')); // Menampilkan pesan jika data pengguna tidak ada
            }

            // Mengambil data pengguna dari snapshot
            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.user.photoURL ?? ""), // Menampilkan foto profil pengguna
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    userData['username'] ?? "Username tidak tersedia",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 20.0),
                ListTile(
                  leading: Icon(Icons.article),
                  title: Text('Berita Saya'),
                  onTap: () {
                    // Navigasi ke layar Berita
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewsScreen(user: widget.user)),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Pengaturan Profil'),
                  onTap: () async {
                    // Navigasi ke layar Pengaturan Profil
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileSettingsScreen(userId: widget.user.uid)),
                    );
                    // Memuat ulang data pengguna setelah layar pengaturan ditutup
                    setState(() {
                      userDoc = FirebaseFirestore.instance.collection('users').doc(widget.user.uid).get();
                    });
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Pengaturan Keamanan'),
                  onTap: () {
                    // Navigasi ke halaman 'Pengaturan Keamanan'
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text('Kebijakan Privasi'),
                  onTap: () {
                    // Navigasi ke halaman 'Kebijakan Privasi'
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Keluar'),
                  onTap: () async {
                    // Melakukan logout dari FirebaseAuth
                    await FirebaseAuth.instance.signOut();
                    // Navigasi kembali ke halaman utama dan menghapus semua rute sebelumnya
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
