import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/app_background.dart'; // Pastikan path ini benar
import '../models/notification_model.dart'; // Import model notifikasi
import 'notification_page.dart'; // Import halaman notifikasi

class SensorControlPage extends StatefulWidget {
  const SensorControlPage({super.key});

  @override
  State<SensorControlPage> createState() => _SensorControlPageState();
}

class _SensorControlPageState extends State<SensorControlPage> {
  final DatabaseReference _sensorRef = FirebaseDatabase.instance.ref('sensor');

  double? suhu, ph, kelembapan;
  int? ldr; // ldr adalah integer
  String? kondisiCahaya, ketinggianAir;

  // List Notifikasi Lokal (untuk contoh sederhana)
  static final List<NotificationModel> generatedNotifications = [];

  // State untuk status ON/OFF tombol Kontrol Manual
  bool _isHeaterManualOn = false;
  bool _isCoolerManualOn = false;

  @override
  void initState() {
    super.initState();
    _sensorRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          suhu = double.tryParse(data['suhu'].toString());
          ph = double.tryParse(data['ph'].toString());
          kelembapan = double.tryParse(data['kelembapan'].toString());
          ldr = int.tryParse(data['ldr'].toString());
          // kondisiCahaya dari Firebase mungkin string seperti "Normal" atau "Redup"
          // Namun, fungsi _getStatusKondisiCahaya Anda bekerja dengan angka LDR.
          // Jadi, kita akan gunakan ldr (int) untuk logika kondisi cahaya.
          // kondisiCahaya (String) dari Firebase bisa dipakai untuk tampilan mentah jika diperlukan.
          kondisiCahaya = data['kondisi_cahaya']?.toString();
          ketinggianAir = data['ketinggian_air']?.toString();

          _checkAndGenerateNotifications();
        });
      }
    });
  }

  // Fungsi untuk memeriksa kondisi sensor dan membuat notifikasi
  void _checkAndGenerateNotifications() {
    // Notifikasi Suhu
    final currentSuhu = suhu;
    if (currentSuhu != null) {
      if (currentSuhu < 26) {
        _addNotification(
          NotificationModel(
            category: 'Suhu Air',
            title: 'Suhu Air Rendah!',
            description: 'Suhu air terlalu dingin (${currentSuhu}°C). Heater otomatis dihidupkan.',
            timestamp: DateTime.now(),
          ),
        );
      } else if (currentSuhu > 30) {
        _addNotification(
          NotificationModel(
            category: 'Suhu Air',
            title: 'Suhu Air Tinggi!',
            description: 'Suhu air terlalu panas (${currentSuhu}°C). Cooler otomatis dihidupkan.',
            timestamp: DateTime.now(),
          ),
        );
      }
    }

    // Notifikasi pH
    final currentPh = ph;
    if (currentPh != null) {
      if (currentPh < 6.0) {
        _addNotification(
          NotificationModel(
            category: 'pH Air',
            title: 'pH Air Rendah!',
            description: 'pH air terlalu rendah (${currentPh}). Kondisi kurang ideal untuk akuaponik.',
            timestamp: DateTime.now(),
          ),
        );
      } else if (currentPh > 8.0) {
        _addNotification(
          NotificationModel(
            category: 'pH Air',
            title: 'pH Air Tinggi!',
            description: 'pH air terlalu tinggi (${currentPh}). Kondisi kurang stabil untuk akuaponik.',
            timestamp: DateTime.now(),
          ),
        );
      }
    }

    // Notifikasi Ketinggian Air
    final currentKetinggianAir = ketinggianAir;
    if (currentKetinggianAir != null) {
      if (currentKetinggianAir.toLowerCase().contains("rendah")) {
        _addNotification(
          NotificationModel(
            category: 'Ketinggian Air',
            title: 'Ketinggian Air Rendah!',
            description: 'Ketinggian air rendah! Segera isi air untuk menjaga sistem.',
            timestamp: DateTime.now(),
          ),
        );
      } else if (currentKetinggianAir.toLowerCase().contains("tidak terdeteksi")) {
        _addNotification(
          NotificationModel(
            category: 'Ketinggian Air',
            title: 'Air Tidak Terdeteksi!',
            description: 'Sensor tidak mendeteksi air. Periksa level air akuarium.',
            timestamp: DateTime.now(),
          ),
        );
      }
    }

    // Notifikasi Intensitas Cahaya
    final currentLdr = ldr;
    if (currentLdr != null) {
      if (currentLdr < 100) { // Angka ini harus disesuaikan dengan nilai LDR sensor Anda untuk "redup"
        _addNotification(
          NotificationModel(
            category: 'Intensitas Cahaya',
            title: 'Cahaya Redup!',
            description: 'Intensitas cahaya (${currentLdr} lux) kurang optimal untuk fotosintesis tanaman.',
            timestamp: DateTime.now(),
          ),
        );
      } else if (currentLdr > 350) { // Angka ini harus disesuaikan dengan nilai LDR sensor Anda untuk "terlalu terang"
        _addNotification(
          NotificationModel(
            category: 'Intensitas Cahaya',
            title: 'Cahaya Terlalu Terang!',
            description: 'Intensitas cahaya (${currentLdr} lux) berlebihan. Berisiko menyebabkan stres pada tanaman.',
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  // Fungsi untuk menambahkan notifikasi baru ke daftar (dengan menghindari duplikasi cepat)
  void _addNotification(NotificationModel newNotification) {
    bool alreadyExistsRecently = generatedNotifications.any((notif) =>
        notif.title == newNotification.title &&
        notif.timestamp.difference(newNotification.timestamp).inMinutes.abs() < 5);

    if (!alreadyExistsRecently) {
      generatedNotifications.insert(0, newNotification);
      print('Notifikasi Baru: ${newNotification.title}');
    }
  }

  // Fungsi untuk handle tap tombol manual (toggle On/Off)
  void _toggleManualControl(String deviceName) {
    setState(() {
      if (deviceName == 'Heater') {
        _isHeaterManualOn = !_isHeaterManualOn;
        print('Manual Heater is now ${_isHeaterManualOn ? "ON" : "OFF"}');
        // TODO: Kirim perintah ke Firebase untuk Heater
      } else if (deviceName == 'Cooler') {
        _isCoolerManualOn = !_isCoolerManualOn;
        print('Manual Cooler is now ${_isCoolerManualOn ? "ON" : "OFF"}');
        // TODO: Kirim perintah ke Firebase untuk Cooler
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo_aplikasi.png', height: 30),
        centerTitle: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(
                        notifications: _SensorControlPageState.generatedNotifications,
                      ),
                    ),
                  ).then((_) {
                    setState(() {
                      // Ini akan merefresh tampilan badge notifikasi setelah kembali
                    });
                  });
                },
                color: const Color(0xDD9FBA98),
              ),
              if (generatedNotifications.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '${generatedNotifications.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 18,
          ),
          const SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Spasi setelah AppBar (jika AppBar di atas)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'PENGONTROLAN\nSENSOR PADA\nAKUAPONIK',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color(0xDD424242),
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _sensorCard('Suhu Air',
                          icon: Icons.thermostat,
                          value: suhu != null ? suhu!.toStringAsFixed(1) : '-',
                          status: _getStatusSuhu(suhu),
                          statusColor: _getStatusColorSuhu(suhu),
                          description: _getDeskripsiSuhu(suhu)),
                      _sensorCard('pH Air',
                          icon: Icons.science,
                          value: ph != null ? ph!.toStringAsFixed(1) : '-',
                          status: _getStatuspH(ph),
                          statusColor: _getStatusColorpH(ph),
                          description: _getDeskripsipH(ph)),
                      _sensorCard('Kelembapan',
                          icon: Icons.water_drop,
                          value: kelembapan != null ? kelembapan!.toStringAsFixed(1) : '-',
                          status: _getStatusKelembapan(kelembapan),
                          statusColor: _getStatusColorKelembapan(kelembapan),
                          description: _getDeskripsiKelembapan(kelembapan)),
                      _sensorCard('Intensitas Cahaya',
                          icon: Icons.wb_sunny,
                          value: ldr != null ? '$ldr lux' : '-',
                          // Menggunakan ldr.toString() untuk parameter kondisi cahaya
                          status: _getStatusKondisiCahaya(ldr?.toString()),
                          statusColor: _getStatusColorKondisiCahaya(ldr?.toString()),
                          description: _getDeskripsiKondisiCahaya(ldr?.toString())),
                      // KARTU KETINGGIAN AIR
                      _sensorCard(
                        'Ketinggian Air',
                        icon: Icons.waves,
                        value: '',
                        status: (_getLevelStatus(ketinggianAir ?? 'Tidak terdeteksi'))['label'],
                        statusColor: (_getLevelStatus(ketinggianAir ?? 'Tidak terdeteksi'))['color'],
                        description: _getLevelDescription(ketinggianAir ?? 'Tidak terdeteksi'),
                        mainDisplayWidget: Icon(
                          Icons.circle,
                          color: (_getLevelStatus(ketinggianAir ?? 'Tidak terdeteksi'))['color'],
                          size: 28,
                        ),
                      ),
                      // KONTROL MANUAL
                      _sensorCard(
                        'Kontrol Manual',
                        icon: Icons.settings_remote,
                        value: '',
                        status: 'MODE MANUAL',
                        statusColor: Colors.grey.shade700,
                        description: '',
                        onOffControlButtons: {
                          'Heater': _isHeaterManualOn,
                          'Cooler': _isCoolerManualOn,
                        },
                        onManualButtonTapped: _toggleManualControl,
                        removeSpacer: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Functions ---
  Widget _sensorCard(String title,
      {required IconData icon,
      required String value,
      required String status,
      Color? statusColor,
      required String description,
      Widget? valueIcon,
      Widget? mainDisplayWidget,
      Map<String, bool>? onOffControlButtons,
      Function(String)? onManualButtonTapped,
      bool removeSpacer = false,
      List<String> buttons = const [],
      Map<String, IconData>? buttonIcons,
      }) {
    List<Widget> cardChildren = [
      Icon(icon, size: 32, color: const Color(0xFF9FBA98)),
      const SizedBox(height: 12),
    ];

    if (onOffControlButtons == null) {
      cardChildren.add(
        Visibility(
          visible: mainDisplayWidget != null || value.isNotEmpty,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (mainDisplayWidget != null) ...[
                mainDisplayWidget,
              ] else if (value.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (valueIcon != null) valueIcon,
                    const SizedBox(width: 4),
                    Text(
                      value,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 4),
            ],
          ),

        ),
      );

      cardChildren.add(
        Text(
          status,
          style: TextStyle(
            color: statusColor ?? Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (description.isNotEmpty) {
      cardChildren.add(const SizedBox(height: 8));
      cardChildren.add(
        Text(description,
            style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
      );
    }

    if (!removeSpacer) {
      cardChildren.add(const Spacer());
    }

    if (onOffControlButtons != null && onManualButtonTapped != null) {
      cardChildren.add(const SizedBox(height: 10));
      cardChildren.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: onOffControlButtons.keys.map((deviceName) {
            bool isOn = onOffControlButtons[deviceName]!;
            Color textColor = isOn ? Colors.green.shade700 : Colors.grey.shade600;
            IconData deviceIcon;

            if (deviceName == 'Heater') {
              deviceIcon = Icons.thermostat;
            } else if (deviceName == 'Cooler') {
              deviceIcon = Icons.ac_unit;
            } else {
              deviceIcon = Icons.power_settings_new;
            }

            return Expanded(
              child: GestureDetector(
                onTap: () => onManualButtonTapped(deviceName),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(deviceIcon, size: 30, color: textColor),
                      const SizedBox(height: 4),
                      Text(
                        deviceName,
                        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else if (buttons.isNotEmpty) {
      cardChildren.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons.map((buttonText) {
            Color buttonColor;
            IconData? currentIcon = buttonIcons?[buttonText];

            if (buttonText == 'Heater') {
              buttonColor = Colors.orange.shade700;
            } else if (buttonText == 'Cooler') {
              buttonColor = Colors.blue.shade700;
            } else {
              buttonColor = Colors.green.shade700;
            }

            return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Material(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 3,
                      child: InkWell(
                        onTap: () {
                          if (buttonText == 'Heater') {
                            print('Tombol Heater ditekan!');
                          } else if (buttonText == 'Cooler') {
                            print('Tombol Cooler ditekan!');
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (currentIcon != null)
                                Icon(currentIcon, size: 28, color: Colors.white),
                              Text(
                                buttonText,
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: cardChildren,
          ),
        ),
        Positioned(
          top: -12,
          left: 16,
          right: 16,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.green.shade200, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusSuhu(double? suhu) {
    if (suhu == null) return '-';
    if (suhu < 26) return 'DINGIN';
    if (suhu > 30) return 'PANAS';
    return 'NORMAL';
  }

  Color _getStatusColorSuhu(double? suhu) {
    if (suhu == null) return Colors.grey;
    if (suhu < 26 || suhu > 30) return Colors.red.shade700;
    return Colors.green.shade800;
  }

  String _getDeskripsiSuhu(double? suhu) {
    if (suhu == null) return 'Data suhu tidak tersedia';
    if (suhu < 26) return 'Suhu terlalu dingin!\nHeater otomatis dihidupkan!';
    if (suhu > 30) return 'Suhu terlalu panas!\nCooler otomatis dihidupkan!';
    return 'Suhu air berada pada suhu\nyang optimal untuk akuaponik';
  }

  String _getStatuspH(double? ph) {
    if (ph == null) return '-';
    if (ph < 6.0) return 'ASAM';
    if (ph > 8.0) return 'BASA';
    return 'NETRAL';
  }

  Color _getStatusColorpH(double? ph) {
    if (ph == null) return Colors.grey;
    if (ph < 6.0 || ph > 8.0) return Colors.red.shade700;
    return Colors.green.shade800;
  }

  String _getDeskripsipH(double? ph) {
    if (ph == null) return 'Data pH tidak tersedia';
    if (ph < 6.0) return 'pH terlalu rendah!\nKondisi kurang ideal untuk akuaponik.';
    if (ph > 8.0) return 'pH terlalu tinggi!\nKondisi kurang stabil untuk akuaponik.';
    return 'pH berada pada kisaran optimal\nuntuk sistem akuaponik';
  }

  String _getStatusKelembapan(double? kelembapan) {
    if (kelembapan == null) return '-';
    if (kelembapan < 80) return 'KURANG';
    if (kelembapan > 90) return 'LEBIH';
    return 'IDEAL';
  }

  Color _getStatusColorKelembapan(double? kelembapan) {
    if (kelembapan == null) return Colors.grey;
    if (kelembapan < 80 || kelembapan > 90) return Colors.red.shade700;
    return Colors.green.shade800;
  }

  String _getDeskripsiKelembapan(double? kelembapan) {
    if (kelembapan == null) return 'Data kelembapan tidak tersedia';
    if (kelembapan < 80) return 'Kelembapan udara rendah!\nTanaman berisiko mengalami stres';
    if (kelembapan > 90) return 'Kelembapan udara tinggi!\nDapat meningkatkan risiko jamur';
    return 'Kelembapan udara berada\npada kisaran optimal\nuntuk sistem akuaponik';
  }

    String _getStatusKondisiCahaya(String? kondisiCahayaString) {
    final int? nilai = int.tryParse(kondisiCahayaString?.replaceAll(' lux', '') ?? '');
    if (nilai == null) return '-';
    if (nilai < 100) return 'REDUP';
    if (nilai > 350) return 'TERLALU TERANG';
    return 'TERANG';
  }

  Color _getStatusColorKondisiCahaya(String? kondisiCahayaString) {
    final int? nilai = int.tryParse(kondisiCahayaString?.replaceAll(' lux', '') ?? '');
    if (nilai == null) return Colors.grey;
    if (nilai < 100 || nilai > 350) return Colors.red.shade700;
    return Colors.green.shade800;
  }

  String _getDeskripsiKondisiCahaya(String? kondisiCahayaString) {
    final int? nilai = int.tryParse(kondisiCahayaString?.replaceAll(' lux', '') ?? '');

    if (nilai == null) return 'Data intensitas cahaya tidak tersedia';
    if (nilai < 100) return 'Cahaya terlalu redup!\nFotosintesis tanaman mungkin terhambat';
    if (nilai > 350) return 'Cahaya berlebihan!\nBerisiko menyebabkan stres pada tanaman.';
    return 'Intensitas cahaya optimal\nuntuk pertumbuhan tanaman';
  }

  Map<String, dynamic> _getLevelStatus(String status) {
    if (status.toLowerCase().contains("penuh")) {
      return {
        'label': 'PENUH',
        'color': Colors.green.shade700,
        'icon': Icons.water,
      };
    } else if (status.toLowerCase().contains("cukup") || status.toLowerCase().contains("setengah")) {
      return {
        'label': 'CUKUP',
        'color': Colors.lightGreen.shade400,
        'icon': Icons.water,
      };
    } else if (status.toLowerCase().contains("rendah")) {
      return {
        'label': 'RENDAH',
        'color': Colors.orange,
        'icon': Icons.water_drop,
      };
    } else {
      return {
        'label': 'TIDAK TERDETEKSI',
        'color': Colors.red,
        'icon': Icons.block,
      };
    }
  }

  String _getLevelDescription(String status) {
    if (status.toLowerCase().contains("penuh")) {
      return 'Ketinggian air dalam kondisi penuh.';
    } else if (status.toLowerCase().contains("cukup") || status.toLowerCase().contains("setengah")) {
      return 'Ketinggian air berada pada kondisi cukup.';
    } else if (status.toLowerCase().contains("rendah")) {
      return 'Ketinggian air rendah! Segera isi air.';
    } else {
      return 'Tidak ada air terdeteksi!';
    }
  }
}