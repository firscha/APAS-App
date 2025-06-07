import 'package:flutter/material.dart';

class FishFeederScreen extends StatefulWidget {
  const FishFeederScreen({super.key});

  @override
  State<FishFeederScreen> createState() => _FishFeederScreenState();
}

class _FishFeederScreenState extends State<FishFeederScreen> {
  int _selectedInterval = 3; // Nilai default: 3 jam

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF9FBF8),
              Color(0xFFC7D9C5),
            ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text('PAKAN IKAN OTOMATIS'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Kotak Atas
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            height: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: AssetImage('assets/pakan_ikan.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ikan akan diberi makan\n$_selectedInterval jam sekali',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 34),
                    
                    // Kotak Bawah
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 102, 109, 103).withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Atur Pakan Otomatis',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildIntervalOption(3),
                              _buildIntervalOption(6),
                              _buildIntervalOption(12),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Tombol OK
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(120, 45),
                              ),
                              child: const Text('OK'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalOption(int hours) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedInterval = hours;
        });
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _selectedInterval == hours 
                  ? const Color.fromARGB(255, 187, 251, 210) 
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
              border: _selectedInterval == hours
                  ? Border.all(color: const Color.fromARGB(255, 126, 235, 151), width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                hours.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _selectedInterval == hours 
                      ? const Color.fromARGB(255, 0, 0, 0) 
                      : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'jam',
            style: TextStyle(
              color: _selectedInterval == hours 
                  ? const Color.fromARGB(255, 0, 0, 0) 
                  : const Color.fromARGB(255, 103, 103, 103),
            ),
          ),
        ],
      ),
    );
  }
}