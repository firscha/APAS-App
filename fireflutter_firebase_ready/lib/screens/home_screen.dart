import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final DatabaseReference _sensorRef =
      FirebaseDatabase.instance.ref().child('sensor');

  double? suhu, ph, kelembapan;
  int? ldr;
  String? kondisiCahaya, ketinggianAir;

  @override
  void initState() {
    super.initState();
    _sensorRef.onValue.listen((event) {
      print("🔥 Data Firebase diterima: ${event.snapshot.value}");

    final data = event.snapshot.value as Map?;
    if (data != null) {
      setState(() {
        suhu = double.tryParse(data['suhu'].toString()) ?? 0;
        ph = double.tryParse(data['ph'].toString()) ?? 0;
        kelembapan = double.tryParse(data['kelembapan'].toString()) ?? 0;
        ldr = int.tryParse(data['ldr'].toString()) ?? 0;
        kondisiCahaya = data['kondisi_cahaya']?.toString() ?? '-';
        ketinggianAir = data['ketinggian_air']?.toString() ?? '-';
      });
    } else {
      print("❌ Data kosong dari Firebase.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFC7D9C5)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/logo_aplikasi.png', height: 40),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded,
                              size: 28, color: Color(0xDD424242)),
                          onPressed: () {},
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/credit');
                          },
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                            radius: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ✅ Sensor Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9FBA98),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'SELAMAT PAGI, USER!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pantau akuaponik anda hari ini',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _sensorBox(
                              suhu != null ? '${suhu!.toStringAsFixed(1)}°C' : '-', 'Suhu Air'),
                          _sensorBox(
                              ph != null ? ph!.toStringAsFixed(2) : '-', 'pH Air'),
                          _sensorBox(
                              kelembapan != null
                                  ? '${kelembapan!.toStringAsFixed(1)}%'
                                  : '-',
                              'Kelembapan'),
                          _sensorBox(
                              ldr != null ? '$ldr lux' : '-', 'Intensitas Cahaya'),
                          _sensorBox(ketinggianAir ?? '-', 'Ketinggian Air'),
                          _sensorBox(kondisiCahaya ?? '-', 'Kondisi Cahaya'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Center( 
                  child: const Text(
                    'Fitur Aplikasi',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),


                _menuTile(
                  context,
                  title: 'PEMANTAUAN\nKONDISI TANAMAN',
                  imagePath: 'assets/images/tanaman.png',
                  onTap: () => Navigator.pushNamed(context, '/cam'),
                ),
                _menuTile(
                  context,
                  title: 'PAKAN IKAN\nOTOMATIS',
                  imagePath: 'assets/images/ikan.png',
                  onTap: () => Navigator.pushNamed(context, '/fish'),
                ),
                _menuTile(
                  context,
                  title: 'PENGONTROLAN SENSOR\nPADA AKUAPONIK',
                  imagePath: 'assets/images/sensor.png',
                  onTap: () => Navigator.pushNamed(context, '/sensor'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sensorBox(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context,
      {required String title,
      required String imagePath,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}