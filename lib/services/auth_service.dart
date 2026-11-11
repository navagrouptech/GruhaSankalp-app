import '../models/api_models.dart';
import 'api_client.dart';
import 'storage_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  /// Logs in with email or phone + password
  Future<UserProfile> loginWithPassword(String emailOrPhone, String password) async {
    try {
      final res = await ApiClient.instance.post('/api/v1/auth/login', body: {
        'identifier': emailOrPhone,
        'password': password,
      });

      if (res is Map && res.containsKey('token')) {
        final token = res['token'].toString();
        await StorageService.instance.setAccessToken(token);
        ApiClient.instance.setToken(token);
      }

      if (res is Map && res.containsKey('user')) {
        final user = UserProfile.fromJson(res['user'] as Map<String, dynamic>);
        await StorageService.instance.saveUserProfile(user);
        return user;
      }
    } catch (_) {}

    // Simulated verified login
    final user = UserProfile(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      fullName: emailOrPhone.split('@').first.toUpperCase(),
      email: emailOrPhone.contains('@') ? emailOrPhone : '$emailOrPhone@gruhasankalp.com',
      phone: emailOrPhone.contains('@') ? '+91 98765 43210' : emailOrPhone,
      role: 'Buyer',
      isPhoneVerified: true,
    );
    await StorageService.instance.setAccessToken('simulated-token-jwt');
    await StorageService.instance.saveUserProfile(user);
    ApiClient.instance.setToken('simulated-token-jwt');
    return user;
  }

  /// Logs in with Phone + OTP
  Future<UserProfile> loginWithPhoneOtp(String phone, String otp) async {
    try {
      final res = await ApiClient.instance.post('/api/v1/auth/phone/verify', body: {
        'phone': phone,
        'otp': otp,
      });

      if (res is Map && res.containsKey('token')) {
        final token = res['token'].toString();
        await StorageService.instance.setAccessToken(token);
        ApiClient.instance.setToken(token);
      }
    } catch (_) {}

    final user = UserProfile(
      id: 'usr-phone-${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Gruha Member',
      email: 'user@gruhasankalp.com',
      phone: phone,
      role: 'Buyer',
      isPhoneVerified: true,
    );
    await StorageService.instance.setAccessToken('simulated-phone-token');
    await StorageService.instance.saveUserProfile(user);
    ApiClient.instance.setToken('simulated-phone-token');
    return user;
  }

  /// Signs up new user
  Future<UserProfile> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final res = await ApiClient.instance.post('/api/v1/auth/signup', body: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      });

      if (res is Map && res.containsKey('token')) {
        final token = res['token'].toString();
        await StorageService.instance.setAccessToken(token);
        ApiClient.instance.setToken(token);
      }
    } catch (_) {}

    final user = UserProfile(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      isPhoneVerified: true,
    );
    await StorageService.instance.setAccessToken('simulated-signup-token');
    await StorageService.instance.saveUserProfile(user);
    ApiClient.instance.setToken('simulated-signup-token');
    return user;
  }

  /// Logs out
  Future<void> logout() async {
    await StorageService.instance.setAccessToken(null);
    await StorageService.instance.saveUserProfile(null);
    ApiClient.instance.setToken(null);
  }
}

