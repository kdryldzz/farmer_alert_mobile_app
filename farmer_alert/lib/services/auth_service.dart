import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  SupabaseClient get supabase => _supabase;

//sign in with email and password
  Future<AuthResponse> SignInWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(email: email, password: password);
  }

//sign up with email and password

  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

//sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

//get user email
  String? getCurrentUserEmail() {
    final Session = _supabase.auth.currentSession;
    final user = Session?.user;
    return user?.email;
  }
  //get user email
  String? getCurrentUserId() {
    final Session = _supabase.auth.currentSession;
    final user = Session?.user;
    return user?.id;
  }

  // save registered user informations in users table
  Future<void> registerUser( String name,String surname,
      String username, String email, String password, String city, String district, String phoneNumber,String gender) async {
    try {
      // Auth kaydı
      final response =
          await _supabase.auth.signUp(email: email, password: password);

      if (response.user == null) {
        throw Exception('Kullanıcı oluşturulamadı');
      }

      final userId = response.user!.id;

      // users tablosuna ekleme
      final insertResponse = await _supabase.from('users').insert({
        'id': userId, // Foreign key
        'username': username,
        'email': email,
        'password': password
      });

      if (insertResponse.error != null) {
        throw Exception(
            'Kullanıcı bilgileri kaydedilemedi: ${insertResponse.error!.message}');
      }

      print('Kayıt başarıyla tamamlandı.');
    } catch (e) {
      print('Hata: $e');
    }
  }
  // Password Reset
Future<void> resetPassword(String email) async {
  try {
    await _supabase.auth.resetPasswordForEmail(email);
    print("Password reset email sent to $email");
  } catch (e) {
    print("Error resetting password: $e");
    throw Exception("Password reset failed");
  }
}
Future<void> requestAccountDeletion() async {
  try {
    final userId = getCurrentUserId();
    final email = getCurrentUserEmail();

    if (userId == null || email == null) {
      throw Exception("Kullanıcı bilgilerine erişilemedi.");
    }

    final response = await _supabase.from('delete_requests').insert({
      'user_id': userId,
      'email': email,
    });

    if (response.error != null) {
      throw Exception('Hesap silme isteği kaydedilemedi: ${response.error!.message}');
    }

    print('Hesap silme isteği başarıyla kaydedildi.');
  } catch (e) {
    print('Hata: $e');
    rethrow;
  }
}

}
