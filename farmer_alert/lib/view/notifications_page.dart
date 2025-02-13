import 'package:farmer_alert/services/notification_service.dart';
import 'package:flutter/material.dart';
class NotificationsPage extends StatefulWidget {
  
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _generalNotifications = true; // Genel bildirimler
  final NotificationServiceToSave _notificationService = NotificationServiceToSave();

  Future<void> _savePreferences() async {
    try {
      final userId = "currentUserId"; // AuthService ile aktif kullanıcı ID'sini alın
      await _notificationService.updateNotificationPreferences(
        userId: userId,
        generalNotifications: _generalNotifications,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bildirim ayarları kaydedildi!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bildirimler',
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.green[50],
              child: const Text(
                'Bildirim tercihlerinizi aşağıdaki seçeneklerden yönetebilirsiniz.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            // Bildirim Ayarları
            SwitchListTile(
              title: const Text('Tüm Bildirimlere İzin Ver'),
              subtitle: const Text('Uygulama ile ilgili bildirimleri alın.'),
              value: _generalNotifications,
              onChanged: (value) {
                setState(() {
                  _generalNotifications = value;
                });
              },
              activeColor: Colors.green,
            ),
            // Kaydet Butonu
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ElevatedButton(
                onPressed: _savePreferences, // Ayarları kaydetme
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kaydet',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
