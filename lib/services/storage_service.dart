import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/api_models.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Token
  String? getAccessToken() => _prefs?.getString(StorageKeys.accessToken);
  Future<void> setAccessToken(String? token) async {
    if (token == null) {
      await _prefs?.remove(StorageKeys.accessToken);
    } else {
      await _prefs?.setString(StorageKeys.accessToken, token);
    }
  }

  // Saved Property IDs
  List<String> getSavedPropertyIds() {
    return _prefs?.getStringList(StorageKeys.savedProps) ?? [];
  }

  Future<void> setSavedPropertyIds(List<String> ids) async {
    await _prefs?.setStringList(StorageKeys.savedProps, ids);
  }

  // Recently Viewed Property IDs
  List<String> getRecentlyViewedIds() {
    return _prefs?.getStringList(StorageKeys.recentProps) ?? [];
  }

  Future<void> setRecentlyViewedIds(List<String> ids) async {
    await _prefs?.setStringList(StorageKeys.recentProps, ids);
  }

  // Site Visits
  List<SiteVisit> getSiteVisits() {
    final raw = _prefs?.getString(StorageKeys.siteVisits);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => SiteVisit.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSiteVisits(List<SiteVisit> visits) async {
    final encoded = jsonEncode(visits.map((v) => v.toJson()).toList());
    await _prefs?.setString(StorageKeys.siteVisits, encoded);
  }

  // Enquiries
  List<Enquiry> getEnquiries() {
    final raw = _prefs?.getString(StorageKeys.enquiries);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => Enquiry.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveEnquiries(List<Enquiry> enquiries) async {
    final encoded = jsonEncode(enquiries.map((e) => e.toJson()).toList());
    await _prefs?.setString(StorageKeys.enquiries, encoded);
  }

  // User Profile
  UserProfile? getUserProfile() {
    final raw = _prefs?.getString(StorageKeys.userProfile);
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserProfile.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUserProfile(UserProfile? profile) async {
    if (profile == null) {
      await _prefs?.remove(StorageKeys.userProfile);
    } else {
      await _prefs?.setString(StorageKeys.userProfile, jsonEncode(profile.toJson()));
    }
  }
}

