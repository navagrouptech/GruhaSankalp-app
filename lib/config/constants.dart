library;

// GruhaSankalp Application Constants & Enums
/// Directly mapped from src/constants/categories.ts & lookups.ts

class AppConstants {
  AppConstants._();

  static const String appName = 'GruhaSankalp';
  static const String appTagline = 'Find. Compare. Decide.';

  // Categories
  static const List<String> categories = [
    'Buy',
    'Rent',
    'PG',
    'Commercial',
    'Plots',
  ];

  // Property Types
  static const List<String> propertyTypes = [
    'Apartment',
    'Villa',
    'Builder Floor',
    'Independent House',
    '1RK/Studio House',
    'Plot',
    'PG',
    'Commercial',
    'Co-Living',
    'Shared Flats',
    'Roommate',
  ];

  // Popular Indian Cities (matches website offerings)
  static const List<String> popularCities = [
    'All',
    'Hyderabad',
    'Bengaluru',
    'Mumbai',
    'Pune',
    'Chennai',
    'Visakhapatnam',
  ];

  // BHK Filter Options
  static const List<String> bhkOptions = [
    'Any BHK',
    '1 BHK',
    '2 BHK',
    '3 BHK',
    '4+ BHK',
  ];

  // Budget Filter presets in INR
  static const List<int> budgetSteps = [
    0,
    2500000,
    5000000,
    7500000,
    10000000,
    15000000,
    20000000,
    30000000,
    50000000,
  ];

  // Furnishing Options
  static const List<String> furnishingOptions = [
    'Any',
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
  ];

  // Facing Options
  static const List<String> facingOptions = [
    'East',
    'North',
    'West',
    'North-East',
    'South',
  ];

  // Limits
  static const int compareLimit = 3;
  static const int recentlyViewedLimit = 10;
  static const int searchPageSize = 20;
}

class StorageKeys {
  StorageKeys._();

  static const String savedProps = 'gruha_saved_props';
  static const String recentProps = 'gruha_recent_props';
  static const String siteVisits = 'gruha_site_visits';
  static const String enquiries = 'gruha_enquiries';
  static const String accessToken = 'gs_access_token';
  static const String userProfile = 'gs_user_profile';
  static const String userRole = 'gs_user_role';
  static const String adminSession = 'gruha_admin_session';
}
