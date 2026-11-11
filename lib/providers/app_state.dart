import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/api_models.dart';
import '../models/property.dart';
import '../models/search_filter.dart';
import '../services/auth_service.dart';
import '../services/interaction_service.dart';
import '../services/mock_data.dart';
import '../services/property_service.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  // Navigation & Category
  int _currentBottomNavIndex = 0;
  String _activeCategory = 'Buy';
  String _selectedCity = 'All';

  // State slices
  List<String> _savedPropertyIds = [];
  List<String> _recentlyViewedIds = [];
  final List<Property> _compareList = [];
  List<SiteVisit> _siteVisits = [];
  List<Enquiry> _enquiries = [];
  List<NotificationItem> _notifications = [];

  // Search Filter
  final SearchFilter _searchFilter = SearchFilter();

  // Auth
  UserProfile? _userProfile;
  bool _isLoggedIn = false;

  // AI Assistant Chat History
  final List<AiChatMessage> _aiMessages = [];
  bool _isAiTyping = false;

  // Getters
  int get currentBottomNavIndex => _currentBottomNavIndex;
  String get activeCategory => _activeCategory;
  String get selectedCity => _selectedCity;
  List<String> get savedPropertyIds => _savedPropertyIds;
  List<String> get recentlyViewedIds => _recentlyViewedIds;
  List<Property> get compareList => _compareList;
  List<SiteVisit> get siteVisits => _siteVisits;
  List<Enquiry> get enquiries => _enquiries;
  List<NotificationItem> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.read).length;
  SearchFilter get searchFilter => _searchFilter;
  UserProfile? get userProfile => _userProfile;
  bool get isLoggedIn => _isLoggedIn;
  List<AiChatMessage> get aiMessages => _aiMessages;
  bool get isAiTyping => _isAiTyping;

  /// Initializes state from local storage on app launch
  Future<void> init() async {
    await StorageService.instance.init();

    _savedPropertyIds = StorageService.instance.getSavedPropertyIds();
    _recentlyViewedIds = StorageService.instance.getRecentlyViewedIds();
    _siteVisits = StorageService.instance.getSiteVisits();
    _enquiries = StorageService.instance.getEnquiries();
    _userProfile = StorageService.instance.getUserProfile();
    _isLoggedIn = _userProfile != null;

    if (_siteVisits.isEmpty) {
      _siteVisits = MockData.defaultSiteVisits;
    }
    if (_enquiries.isEmpty) {
      _enquiries = MockData.defaultEnquiries;
    }
    _notifications = MockData.defaultNotifications;

    // Initial AI Welcome Message
    if (_aiMessages.isEmpty) {
      _aiMessages.add(
        AiChatMessage(
          id: 'welcome',
          isUser: false,
          text: '### 👋 Welcome to Gruha AI!\n\n'
              'I am your 24/7 personal property advisor. How can I help you find your dream home today?\n\n'
              '- **Zero Brokerage**: Connect directly with verified owners.\n'
              '- **Instant Match**: Tell me your budget, preferred locality, or BHK requirement.',
          timestamp: DateTime.now(),
          quickReplies: const [
            '3 BHK in Gachibowli under 2 Cr',
            'Villas in Kokapet with pool',
            'Flats for rent near Mindspace',
            'Show top verified deals',
          ],
        ),
      );
    }

    notifyListeners();
  }

  void setBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    notifyListeners();
  }

  void setActiveCategory(String cat) {
    _activeCategory = cat;
    _searchFilter.category = cat;
    notifyListeners();
  }

  void setSelectedCity(String city) {
    _selectedCity = city;
    _searchFilter.city = city;
    notifyListeners();
  }

  // --- Saved Properties ---
  bool isSaved(String propertyId) => _savedPropertyIds.contains(propertyId);

  Future<void> toggleSaveProperty(String propertyId) async {
    if (_savedPropertyIds.contains(propertyId)) {
      _savedPropertyIds.remove(propertyId);
    } else {
      _savedPropertyIds.add(propertyId);
    }
    await StorageService.instance.setSavedPropertyIds(_savedPropertyIds);
    notifyListeners();
  }

  // --- Recently Viewed ---
  Future<void> addRecentlyViewed(String propertyId) async {
    _recentlyViewedIds.remove(propertyId);
    _recentlyViewedIds.insert(0, propertyId);
    if (_recentlyViewedIds.length > AppConstants.recentlyViewedLimit) {
      _recentlyViewedIds = _recentlyViewedIds.sublist(0, AppConstants.recentlyViewedLimit);
    }
    await StorageService.instance.setRecentlyViewedIds(_recentlyViewedIds);
    notifyListeners();
  }

  // --- Compare List (up to 3) ---
  bool isInCompare(String propertyId) {
    return _compareList.any((p) => p.id == propertyId);
  }

  bool toggleCompare(Property property) {
    if (isInCompare(property.id)) {
      _compareList.removeWhere((p) => p.id == property.id);
      notifyListeners();
      return false;
    } else {
      if (_compareList.length >= AppConstants.compareLimit) {
        return false; // Reached limit
      }
      _compareList.add(property);
      notifyListeners();
      return true;
    }
  }

  void clearCompare() {
    _compareList.clear();
    notifyListeners();
  }

  // --- Site Visits & Enquiries ---
  Future<SiteVisit> scheduleSiteVisit({
    required String propertyId,
    required String propertyTitle,
    required String propertyLocation,
    required String name,
    required String phone,
    required String email,
    required String date,
    required String timeSlot,
    required String contactMethod,
  }) async {
    final visit = await InteractionService.instance.scheduleVisit(
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      propertyLocation: propertyLocation,
      name: name,
      phone: phone,
      email: email,
      date: date,
      timeSlot: timeSlot,
      contactMethod: contactMethod,
    );

    _siteVisits.insert(0, visit);
    await StorageService.instance.saveSiteVisits(_siteVisits);

    // Add notification
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Site Visit Booked! 📅',
        message: 'Your visit for $propertyTitle on $date is confirmed. Passcode: ${visit.gatePasscode}',
        read: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    notifyListeners();
    return visit;
  }

  Future<Enquiry> sendPropertyEnquiry({
    required String propertyId,
    required String propertyTitle,
    required String name,
    required String phone,
    required String email,
    required String message,
  }) async {
    final enq = await InteractionService.instance.sendEnquiry(
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      name: name,
      phone: phone,
      email: email,
      message: message,
    );

    _enquiries.insert(0, enq);
    await StorageService.instance.saveEnquiries(_enquiries);
    notifyListeners();
    return enq;
  }

  // --- Gruha AI Assistant Chat ---
  Future<void> sendAiMessage(String text) async {
    if (text.trim().isEmpty) return;

    _aiMessages.add(
      AiChatMessage(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        isUser: true,
        text: text,
        timestamp: DateTime.now(),
      ),
    );
    _isAiTyping = true;
    notifyListeners();

    final response = await InteractionService.instance.askGruhaAi(text);
    _isAiTyping = false;
    _aiMessages.add(response);
    notifyListeners();
  }

  // --- Notifications ---
  void markNotificationRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final old = _notifications[idx];
      _notifications[idx] = NotificationItem(
        id: old.id,
        title: old.title,
        message: old.message,
        read: true,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  // --- Auth ---
  Future<void> loginWithPassword(String emailOrPhone, String password) async {
    _userProfile = await AuthService.instance.loginWithPassword(emailOrPhone, password);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> loginWithPhone(String phone, String otp) async {
    _userProfile = await AuthService.instance.loginWithPhoneOtp(phone, otp);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    _userProfile = await AuthService.instance.signup(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.instance.logout();
    _userProfile = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // --- Post Property ---
  Future<String> postProperty(Map<String, dynamic> data) async {
    final newId = await PropertyService.instance.createProperty(data);
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Listing Published Successfully! 🏠',
        message: 'Your property "${data['title']}" is now live and searchable by thousands of buyers.',
        read: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    notifyListeners();
    return newId;
  }
}
