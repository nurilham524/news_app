import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String userId;

  // Konstruktor untuk menerima ID pengguna
  ProfileSettingsScreen({required this.userId});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Controller untuk input teks
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Variabel untuk mengelola status loading
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Memanggil fungsi untuk mengambil data pengguna saat inisialisasi
  }

  // Fungsi untuk mengambil data pengguna dari Firestore
  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true; // Menampilkan indikator loading
    });

    try {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      
      if (userData.exists) {
        _nameController.text = userData['fullName']; // Mengisi teks nama
        _addressController.text = userData['address'] ?? ''; // Mengisi teks alamat jika ada
        _birthdateController.text = userData['dateOfBirth'] ?? ''; // Mengisi teks tanggal lahir jika ada
      }
    } catch (e) {
      print('Error fetching user data: $e'); // Menampilkan pesan error jika terjadi kesalahan
    } finally {
      setState(() {
        isLoading = false; // Menghilangkan indikator loading
      });
    }
  }

  // Fungsi untuk menyimpan perubahan data pengguna ke Firestore
  Future<void> saveChanges() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'address': _addressController.text,
        'dateOfBirth': _birthdateController.text,
      });
      // Menampilkan snackbar jika berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil berhasil diperbarui'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error updating profile: $e'); // Menampilkan pesan error jika terjadi kesalahan
      // Menampilkan snackbar jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui profil'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Membebaskan resource controller saat widget dihancurkan
    _nameController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Profil'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Menampilkan indikator loading jika sedang mengambil data
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Input teks untuk nama
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama'),
                  ),
                  SizedBox(height: 10.0),
                  // Input teks untuk alamat
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Alamat'),
                  ),
                  SizedBox(height: 10.0),
                  // Input teks untuk tanggal lahir
                  TextField(
                    controller: _birthdateController,
                    decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                  ),
                  SizedBox(height: 10.0),
                  // Input teks untuk kata sandi
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Kata Sandi'),
                    obscureText: true, // Menyembunyikan teks saat mengetik
                  ),
                  SizedBox(height: 20.0),
                  // Tombol untuk menyimpan perubahan
                  ElevatedButton(
                    onPressed: saveChanges, // Memanggil fungsi saveChanges saat tombol ditekan
                    child: Text('Simpan Perubahan'),
                  ),
                ],
              ),
            ),
    );
  }
}
