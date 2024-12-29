import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yardım ve Destek',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bilgilendirici Kısım
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.green[50],
              child: Text(
                'Herhangi bir sorun yaşıyorsanız veya yardıma ihtiyacınız varsa aşağıdaki seçeneklerden birini kullanarak bize ulaşabilirsiniz.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            // Yardım ve Destek Listesi
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildSettingTile(
                  icon: Icons.chat,
                  title: 'Canlı Destek',
                  onTap: () {
                    // Canlı destek sayfası
                  },
                ),
                _buildSettingTile(
                  icon: Icons.email,
                  title: 'E-posta Gönder',
                  onTap: () {
                    // E-posta gönderme işlemi
                  },
                ),
                _buildSettingTile(
                  icon: Icons.phone,
                  title: 'Bizi Ara',
                  onTap: () {
                    // Telefon numarası üzerinden iletişim
                  },
                ),
                _buildSettingTile(
                  icon: Icons.question_answer,
                  title: 'SSS (Sıkça Sorulan Sorular)',
                  onTap: () {
                    // SSS sayfası
                  },
                ),
                _buildSettingTile(
                  icon: Icons.feedback,
                  title: 'Geri Bildirim Gönder',
                  onTap: () {
                    // Geri bildirim formu
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
