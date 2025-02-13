import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationServiceToSave {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> updateNotificationPreferences({
    required String userId,
    required bool generalNotifications,
  }) async {
    final response = await supabase
        .from('notification_preferences')
        .upsert({
          'user_id': userId,
          'general_notifications': generalNotifications,
        })
        ;

    if (response.error != null) {
      throw Exception('Bildirim tercihleri güncellenirken hata oluştu: ${response.error!.message}');
    }
  }
}
