import 'package:farmer_alert/services/mock_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final mockAuthService = MockAuthService();

  // Test 1: Geçerli kimlik bilgileri ile giriş yapma
  test('Sign in with valid credentials should succeed', () async {
    final response = await mockAuthService.SignInWithEmailPassword(
        "test@example.com", "password123");

    expect(response.user?.email, equals("test@example.com"));
    expect(response.user?.id, equals("mockUserId"));
  });

  // Test 2: Hatalı kimlik bilgileri ile giriş yapma
  test('Sign in with invalid credentials should fail', () async {
    expect(
      () async => await mockAuthService.SignInWithEmailPassword(
          "wrong@example.com", "wrongpassword"),
      throwsA(isA<Exception>()),
    );
  });

  // Test 3: Kopya e-posta ile kayıt olma
  test('Sign up with duplicate email should fail', () async {
    expect(
      () async => await mockAuthService.signUpWithEmailPassword(
          "test@example.com", "newpassword"),
      throwsA(isA<Exception>()),
    );
  });

  // Test 4: Yeni e-posta ile kayıt olma
  test('Sign up with new email should succeed', () async {
    final response = await mockAuthService.signUpWithEmailPassword(
        "newuser@example.com", "newpassword");

    expect(response.user?.email, equals("newuser@example.com"));
    expect(response.user?.id, equals("mockUserId"));
  });

  // Test 5: Şifre sıfırlama işlemi (geçerli e-posta)
  test('Reset password with valid email should succeed', () async {
    await mockAuthService.resetPassword("test@example.com");

    // Test başarılıysa herhangi bir hata fırlatılmadığını bekleriz.
  });

  // Test 6: Şifre sıfırlama işlemi (geçersiz e-posta)
  test('Reset password with invalid email should fail', () async {
    expect(
      () async => await mockAuthService.resetPassword("invalid@example.com"),
      throwsA(isA<Exception>()),
    );
  });

  // Test 7: Hesap silme isteği (geçerli kullanıcı)
  test('Request account deletion should succeed', () async {
    await mockAuthService.requestAccountDeletion();

    // Test başarılıysa herhangi bir hata fırlatılmadığını bekleriz.
  });
  // Test 9: Kullanıcı e-posta bilgilerini doğru şekilde alabilme
  test('Get current user email should return correct email', () async {
    final email = mockAuthService.getCurrentUserEmail();
    expect(email, equals("test@example.com"));
  });

  // Test 10: Kullanıcı ID bilgisini doğru şekilde alabilme
  test('Get current user ID should return correct user ID', () async {
    final userId = mockAuthService.getCurrentUserId();
    expect(userId, equals("mockUserId"));
  });

  // Test 11: Çift kullanıcı kaydı yapma (başarısız)
  test('Register user with same email twice should fail', () async {
    await mockAuthService.registerUser(
        "Jane", "Doe", "jdoe", "jane@example.com", "password123", "New York",
        "Manhattan", "+1-123-456-7890", "Female");

    expect(
      () async => await mockAuthService.registerUser(
          "Jane", "Doe", "jdoe", "jane@example.com", "password123", "New York",
          "Manhattan", "+1-123-456-7890", "Female"),
      throwsA(isA<Exception>()),
    );
  });

  // Test 12: Kullanıcı kaydını başlatma ve başarılı sonuç
  test('Register new user should succeed', () async {
    await mockAuthService.registerUser(
        "John", "Smith", "jsmith", "john@example.com", "password123", "San Francisco",
        "Bay Area", "+1-987-654-3210", "Male");

    // Test başarılıysa herhangi bir hata fırlatılmadığını bekleriz.
  });

  // Test 13: Oturum kapatma işlemi
  test('Sign out should succeed', () async {
    await mockAuthService.signOut();

    // Test başarılıysa herhangi bir hata fırlatılmadığını bekleriz.
  });
}
