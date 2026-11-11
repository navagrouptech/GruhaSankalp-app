library;

// Property Search and Filter State Model
/// Directly converts src/types/search.ts and utils/property-query.ts

class SearchFilter {
  String category;
  String city;
  String? locality;
  String? propertyType;
  String? bhk;
  int? minPrice;
  int? maxPrice;
  String? furnishing;
  bool verifiedOnly;
  bool dealsOnly;
  String sortBy; // 'relevance' | 'price_asc' | 'price_desc' | 'newest'

  SearchFilter({
    this.category = 'Buy',
    this.city = 'All',
    this.locality,
    this.propertyType,
    this.bhk,
    this.minPrice,
    this.maxPrice,
    this.furnishing,
    this.verifiedOnly = false,
    this.dealsOnly = false,
    this.sortBy = 'relevance',
  });

  SearchFilter copyWith({
    String? category,
    String? city,
    String? locality,
    String? propertyType,
    String? bhk,
    int? minPrice,
    int? maxPrice,
    String? furnishing,
    bool? verifiedOnly,
    bool? dealsOnly,
    String? sortBy,
  }) {
    return SearchFilter(
      category: category ?? this.category,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      propertyType: propertyType ?? this.propertyType,
      bhk: bhk ?? this.bhk,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      furnishing: furnishing ?? this.furnishing,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      dealsOnly: dealsOnly ?? this.dealsOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  void reset() {
    category = 'Buy';
    city = 'All';
    locality = null;
    propertyType = null;
    bhk = null;
    minPrice = null;
    maxPrice = null;
    furnishing = null;
    verifiedOnly = false;
    dealsOnly = false;
    sortBy = 'relevance';
  }

  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {};
    if (category.isNotEmpty) params['category'] = category;
    if (city != 'All' && city.isNotEmpty) params['city'] = city;
    if (locality != null && locality!.isNotEmpty) params['locality'] = locality!;
    if (propertyType != null && propertyType != 'Any' && propertyType!.isNotEmpty) {
      params['type'] = propertyType!;
    }
    if (bhk != null && bhk != 'Any BHK' && bhk!.isNotEmpty) {
      params['bhk'] = bhk!;
    }
    if (minPrice != null && minPrice! > 0) params['minPrice'] = minPrice.toString();
    if (maxPrice != null && maxPrice! > 0) params['maxPrice'] = maxPrice.toString();
    if (furnishing != null && furnishing != 'Any') params['furnishing'] = furnishing!;
    if (verifiedOnly) params['verified'] = 'true';
    if (dealsOnly) params['isDeal'] = 'true';
    if (sortBy.isNotEmpty) params['sort'] = sortBy;
    return params;
  }
}
