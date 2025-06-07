import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan waktu
import '../models/notification_model.dart'; // Pastikan path ini benar

class NotificationPage extends StatefulWidget {
  final List<NotificationModel> notifications;
  const NotificationPage({super.key, required this.notifications});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Contoh data notifikasi
  late final List<NotificationModel> _notifications;

    @override
    void initState(){
      super.initState();
      _notifications = widget.notifications;
    }

  @override
  Widget build(BuildContext context) {
    // Pastikan Anda menambahkan intl ke pubspec.yaml:
    // dependencies:
    //   flutter:
    //     sdk: flutter
    //   intl: ^0.18.1  <-- tambahkan ini
    // Jalankan `flutter pub get` setelah menambahkannya.

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo_aplikasi.png', // Ganti dengan path logo Anda
          height: 30, // Sesuaikan tinggi logo
        ),
        centerTitle: false, // Logo di kiri
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Aksi saat ikon notifikasi diklik (mungkin reload notifikasi?)
            },
            color: const Color(0xDD9FBA98),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'), // Ganti dengan path gambar profil
            radius: 18,
          ),
          const SizedBox(width: 16), // Padding di kanan
        ],
        backgroundColor: Colors.white, // Sesuaikan warna AppBar
        elevation: 0, // Hilangkan shadow di AppBar
      ),
      body: Container(
        color: const Color(0xFFF0F4F0), // Warna background halaman, sesuaikan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Notifikasi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return _buildNotificationCard(notification);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    // Format tanggal dan waktu
    final dateFormat = DateFormat('dd MMMM yyyy'); // Contoh: 17 Desember 2024
    final timeFormat = DateFormat('HH.mm'); // Contoh: 12.05

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notification.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${dateFormat.format(notification.timestamp)}, ${timeFormat.format(notification.timestamp)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              notification.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              notification.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              maxLines: 2, // Batasi 2 baris
              overflow: TextOverflow.ellipsis, // Tambahkan ... jika teks terlalu panjang
            ),
          ],
        ),
      ),
    );
  }
}