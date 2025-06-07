import 'package:flutter/material.dart';

class CreditAppPage extends StatelessWidget {
  const CreditAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Credit App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tim Pengembang:',
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildPerson('👩 Wineu Putri Setiana'),
            _buildPerson('👩 Nazwa Nurazizah Zain'),
            _buildPerson('👩 Firscha Aulia Ghassani Fikri'),
            _buildPerson('👩 Rr Nurrizka Puspa Wiranti'),
            const SizedBox(height: 24),

            const Text(
              'Pembimbing:',
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildPerson('👨‍🏫 Bapak Dr. Nyoman Bogi Aditya Karna, S.T., M.T.'),
            _buildPerson('👨‍🏫 Ibu Yulinda Eliskar, S.Si., M.Si.'),
          ],
        ),
      ),
    );
  }

  Widget _buildPerson(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        name,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
