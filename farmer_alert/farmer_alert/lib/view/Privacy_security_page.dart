import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gizlilik ve Güvenlik',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bilgilendirici kısım
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.green[50],
              child: const Text(
                'Gizlilik ve güvenlik ayarlarınızı burada yönetebilirsiniz.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            // Ayarlar listesi
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSettingTile(
                  icon: Icons.reset_tv,
                  title: 'Şifre Yenile',
                  onTap: () {
                    // İki faktörlü kimlik doğrulama ayarları
                  },
                ),
                _buildSettingTile(
                  icon: Icons.delete,
                  title: 'Hesabı Sil',
                  onTap: () {
                    // Hesap silme işlemi
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ListTile için yardımcı fonksiyon
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
