import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthService {
  final List<String> registeredEmails = [];
  String? currentUserId;
  String? currentUserEmail;

  // Sahte oturum açma
  Future<AuthResponse> SignInWithEmailPassword(
      String email, String password) async {
    // Gerçekçi başarısız durum: Hatalı e-posta veya şifre
    if (email == "test@example.com" && password == "password123") {
      return AuthResponse(
        user: User(
          id: "mockUserId",
          email: email,
          phone: "+1-234-567-8901",  // Gerçekçi bir telefon numarası
          appMetadata: {
            "provider": "email",
            "isLoggedIn": "true",
          },
          userMetadata: {
            "firstName": "John",
            "lastName": "Doe",
            "dob": "1990-05-15",  // Kullanıcı doğum tarihi
            "gender": "Male",     // Cinsiyet
          },
          aud: "authenticated",
          role: "user",
          createdAt: "2022-01-01T12:00:00Z",
          updatedAt: "2023-01-01T12:00:00Z",
          confirmedAt: "2022-01-02T12:00:00Z",
          emailConfirmedAt: "2022-01-02T12:00:00Z",
          lastSignInAt: "2023-01-15T15:00:00Z",
          phoneConfirmedAt: "2022-01-10T12:00:00Z",  // Telefon onayı
        ),
        session: Session(
          accessToken: "mockAccessToken",
          refreshToken: "mockRefreshToken",
          user: User(
            id: "mockUserId",
            email: email,
            phone: "+1-234-567-8901",  // Gerçekçi telefon numarası
            appMetadata: {},
            userMetadata: {},
            aud: "authenticated",
            role: "user",
            createdAt: "null",
            updatedAt: null,
            confirmedAt: null,
            emailConfirmedAt: null,
            lastSignInAt: null,
            phoneConfirmedAt: null,
          ), 
          tokenType: 'bearer',  // Gerçekçi token tipi
        ),
      );
    } else {
      throw Exception("Invalid email or password");
    }
  }

  // Sahte kayıt olma
  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password) async {
    // Gerçekçi senaryo: Aynı e-posta ile kayıt olmaya çalışmak
    if (email == "test@example.com") {
      throw Exception("Email already in use");
    }
    return AuthResponse(
      user: User(
        id: "mockUserId",
        email: email,
        phone: "+1-234-567-8901",  // Gerçekçi telefon numarası
        appMetadata: {"provider": "email"},
        userMetadata: {
          "firstName": "New",
          "lastName": "User",
          "dob": "2000-01-01",  // Kullanıcı doğum tarihi
          "gender": "Female",    // Cinsiyet
        },
        aud: "authenticated",
        role: "user",
        createdAt: "2023-01-15T15:00:00Z",
        updatedAt: "2023-01-15T15:00:00Z",
        confirmedAt: "2023-01-16T15:00:00Z",  // Hesap onayı
        emailConfirmedAt: "2023-01-16T15:00:00Z",  // E-posta onayı
        lastSignInAt: null,
        phoneConfirmedAt: null,
      ),
      session: Session(
        accessToken: "mockAccessToken",
        refreshToken: "mockRefreshToken",
        user: User(
          id: "mockUserId",
          email: email,
          phone: "+1-234-567-8901",  // Gerçekçi telefon numarası
          appMetadata: {},
          userMetadata: {},
          aud: "authenticated",
          role: "user",
          createdAt: "null",
          updatedAt: null,
          confirmedAt: null,
          emailConfirmedAt: null,
          lastSignInAt: null,
          phoneConfirmedAt: null,
        ), 
        tokenType: 'bearer',  // Gerçekçi token tipi
      ),
    );
  }

  // Sahte oturum kapatma
  Future<void> signOut() async {
    // Oturum kapandıktan sonra kullanıcı bilgileri sıfırlanır
    print("Mock user signed out");
  }

  // Sahte kullanıcı email'i
  String? getCurrentUserEmail() {
    return currentUserEmail ?? "test@example.com";
  }

  // Sahte kullanıcı ID'si
  String? getCurrentUserId() {
    return currentUserId ?? "mockUserId";
  }

  // Kullanıcı kaydını taklit etme
  Future<void> registerUser(
      String name,
      String surname,
      String username,
      String email,
      String password,
      String city,
      String district,
      String phoneNumber,
      String gender) async {
    // Gerçekçi simülasyon: Kullanıcı kaydı ve işlem çıktısı
    if (registeredEmails.contains(email)) {
      throw Exception("Email already in use");
    }
    registeredEmails.add(email);
    print("Mock user registered with email: $email");
  }

  // Şifre sıfırlama
  Future<void> resetPassword(String email) async {
    if (email == "test@example.com") {
      print("Password reset email sent to $email");
    } else {
      throw Exception("Email not found");
    }
  }

  Future<void> requestAccountDeletion() async {
  final userId = currentUserId ?? getCurrentUserId();
  final email = currentUserEmail ?? getCurrentUserEmail();

  if (userId == null || email == null) {
    throw Exception("User information is not available.");
  }

  print('Account deletion requested for user: $userId');
}
}
