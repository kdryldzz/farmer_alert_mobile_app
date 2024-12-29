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
        title: Text(
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.green[50],
              child: Text(
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
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildSettingTile(
                  icon: Icons.security,
                  title: 'Hesap Güvenliği',
                  onTap: () {
                    // Hesap güvenliği ayarları
                  },
                ),
                _buildSettingTile(
                  icon: Icons.privacy_tip,
                  title: 'Veri Gizliliği',
                  onTap: () {
                    // Veri gizliliği ayarları
                  },
                ),
                _buildSettingTile(
                  icon: Icons.shield,
                  title: 'İki Faktörlü Kimlik Doğrulama',
                  onTap: () {
                    // İki faktörlü kimlik doğrulama ayarları
                  },
                ),
                _buildSettingTile(
                  icon: Icons.block,
                  title: 'Engellenen Kullanıcılar',
                  onTap: () {
                    // Engellenen kullanıcılar ayarları
                  },
                ),
                _buildSettingTile(
                  icon: Icons.delete,
                  title: 'Hesabı Sil',
                  onTap: () {
                    // Hesap silme işlemi
                  },
                ),
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
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
