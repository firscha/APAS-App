import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final DatabaseReference _sensorRef =
      FirebaseDatabase.instance.ref().child('sensor');

  double? ph, suhu, kelembapan;
  String? kondisiCahaya, ketinggianAir;

  @override
  void initState() {
    super.initState();
    _sensorRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          ph = (data['ph'] ?? 0).toDouble();
          suhu = (data['suhu'] ?? 0).toDouble();
          kelembapan = (data['kelembapan'] ?? 0).toDouble();
          kondisiCahaya = data['kondisi_cahaya'] ?? '-';
          ketinggianAir = data['ketinggian_air'] ?? '-';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Sensor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildSensorCard('pH Air', ph?.toStringAsFixed(2) ?? '-'),
            buildSensorCard('Suhu (°C)', suhu?.toStringAsFixed(1) ?? '-'),
            buildSensorCard('Kelembapan (%)', kelembapan?.toStringAsFixed(1) ?? '-'),
            buildSensorCard('Cahaya', kondisiCahaya ?? '-'),
            buildSensorCard('Ketinggian Air', ketinggianAir ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget buildSensorCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}