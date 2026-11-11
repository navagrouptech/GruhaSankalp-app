import '../models/property.dart';
import '../models/search_filter.dart';
import 'api_client.dart';
import 'mock_data.dart';

class PropertyService {
  PropertyService._();
  static final PropertyService instance = PropertyService._();

  /// Gets featured properties from backend with fallback
  Future<List<Property>> getFeaturedProperties({int limit = 6, String? city}) async {
    try {
      final res = await ApiClient.instance.get(
        '/api/v1/properties/featured',
        queryParams: {
          'limit': limit,
          if (city != null && city != 'All') 'city': city,
        },
      );
      if (res is List) {
        return res.map((item) => Property.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Fallback to offline seed properties
    }
    return MockData.defaultProperties.where((p) {
      if (city != null && city != 'All') return p.city.toLowerCase() == city.toLowerCase();
      return true;
    }).take(limit).toList();
  }

  /// Gets exclusive deals from backend with fallback
  Future<List<Property>> getDeals({int limit = 6}) async {
    try {
      final res = await ApiClient.instance.get(
        '/api/v1/properties/deals',
        queryParams: {'limit': limit},
      );
      if (res is List) {
        return res.map((item) => Property.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Fallback
    }
    return MockData.defaultProperties.where((p) => p.isDeal).take(limit).toList();
  }

  /// Searches properties with multi-criteria filtering
  Future<List<Property>> searchProperties(SearchFilter filter) async {
    try {
      final res = await ApiClient.instance.get(
        '/api/v1/properties',
        queryParams: filter.toQueryParameters(),
      );
      if (res is List) {
        return res.map((item) => Property.fromJson(item as Map<String, dynamic>)).toList();
      } else if (res is Map && res.containsKey('items') && res['items'] is List) {
        return (res['items'] as List).map((item) => Property.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Offline search simulation
    }

    // Filter local seed properties
    var filtered = MockData.defaultProperties.where((p) {
      // Category match
      if (filter.category.isNotEmpty && filter.category != 'All') {
        if (p.category.toLowerCase() != filter.category.toLowerCase()) return false;
      }
      // City match
      if (filter.city != 'All' && filter.city.isNotEmpty) {
        if (!p.city.toLowerCase().contains(filter.city.toLowerCase())) return false;
      }
      // Locality match
      if (filter.locality != null && filter.locality!.isNotEmpty) {
        if (!p.locality.toLowerCase().contains(filter.locality!.toLowerCase())) return false;
      }
      // Property type
      if (filter.propertyType != null && filter.propertyType != 'Any' && filter.propertyType!.isNotEmpty) {
        if (p.type.toLowerCase() != filter.propertyType!.toLowerCase()) return false;
      }
      // BHK
      if (filter.bhk != null && filter.bhk != 'Any BHK') {
        final bhkNum = int.tryParse(filter.bhk!.replaceAll(RegExp(r'[^0-9]'), ''));
        if (bhkNum != null && p.bedrooms != null) {
          if (filter.bhk!.contains('+') ? p.bedrooms! < bhkNum : p.bedrooms != bhkNum) {
            return false;
          }
        }
      }
      // Price min/max
      if (filter.minPrice != null && p.price < filter.minPrice!) return false;
      if (filter.maxPrice != null && p.price > filter.maxPrice!) return false;
      // Furnishing
      if (filter.furnishing != null && filter.furnishing != 'Any') {
        if (p.furnishing?.toLowerCase() != filter.furnishing!.toLowerCase()) return false;
      }
      // Verified only
      if (filter.verifiedOnly && !p.verified) return false;
      // Deals only
      if (filter.dealsOnly && !p.isDeal) return false;

      return true;
    }).toList();

    // Sorting
    if (filter.sortBy == 'price_asc') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (filter.sortBy == 'price_desc') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (filter.sortBy == 'rating') {
      filtered.sort((a, b) => b.aiMatch.compareTo(a.aiMatch));
    }

    return filtered;
  }

  /// Gets property by ID
  Future<Property?> getPropertyById(String id) async {
    try {
      final res = await ApiClient.instance.get('/api/v1/properties/$id');
      if (res is Map<String, dynamic>) {
        return Property.fromJson(res);
      }
    } catch (_) {}

    // Check offline list
    final matches = MockData.defaultProperties.where((p) => p.id == id);
    if (matches.isNotEmpty) return matches.first;
    return MockData.defaultProperties.first;
  }

  /// Gets similar properties
  Future<List<Property>> getSimilarProperties(String id, {int limit = 3}) async {
    try {
      final res = await ApiClient.instance.get(
        '/api/v1/properties/$id/similar',
        queryParams: {'limit': limit},
      );
      if (res is List) {
        return res.map((item) => Property.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {}

    return MockData.defaultProperties.where((p) => p.id != id).take(limit).toList();
  }

  /// Creates / lists a new property
  Future<String> createProperty(Map<String, dynamic> data) async {
    try {
      final res = await ApiClient.instance.post('/api/v1/properties', body: data);
      if (res is Map && res.containsKey('id')) {
        return res['id'].toString();
      }
    } catch (_) {}
    return 'prop-${DateTime.now().millisecondsSinceEpoch}';
  }
}

