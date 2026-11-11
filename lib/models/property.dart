library;

// Canonical Property Model
/// Directly converts src/types/property.ts

class Owner {
  final String? id;
  final String name;
  final String type; // 'Owner' | 'Agent' | 'Builder'
  final String? phone;
  final String? email;
  final bool verified;
  final double rating;
  final String? avatar;

  const Owner({
    this.id,
    required this.name,
    this.type = 'Owner',
    this.phone,
    this.email,
    this.verified = true,
    this.rating = 4.8,
    this.avatar,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Verified Owner',
      type: json['type'] as String? ?? 'Owner',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      verified: json['verified'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'phone': phone,
    'email': email,
    'verified': verified,
    'rating': rating,
    'avatar': avatar,
  };
}

class Property {
  final String id;
  final String title;
  final String type; // 'Apartment' | 'Villa' | 'Plot' | 'PG' | 'Commercial' etc.
  final String purpose; // 'Buy' | 'Rent'
  final String category; // 'Buy' | 'Rent' | 'PG' | 'Commercial' | 'Plots'
  final String city;
  final String locality;
  final String address;
  final int price; // in INR
  final String priceFormatted;
  final int? pricePerSqFt;
  final int? dealPrice;
  final String? dealPriceFormatted;
  final String? dealSavings;
  final String? dealTag; // 'Limited Time' | 'Price Reduced' | 'New Launch' | 'Hot Deal'
  final bool isDeal;
  final int area; // sq ft
  final String areaUnit;
  final int? bedrooms;
  final int? bathrooms;
  final int? parking;
  final String? floor;
  final String? furnishing; // 'Fully Furnished' | 'Semi Furnished' | 'Unfurnished'
  final List<String> images;
  final List<String> amenities;
  final String description;
  final double latitude;
  final double longitude;
  final bool verified;
  final bool featured;
  final Owner owner;
  final String postedDate;
  final int aiMatch; // e.g. 94 for 94%
  final List<String> aiReasons;
  final String? possessionStatus; // 'Ready to Move' | 'Under Construction' | 'Immediate'
  final String? facing; // 'East' | 'North' | 'West' etc.
  final String? reraId;
  final int? carpetArea;
  final int? balconies;
  final bool? gatedSecurity;
  final int? maintenanceFee;
  final String? projectName;

  const Property({
    required this.id,
    required this.title,
    required this.type,
    required this.purpose,
    required this.category,
    required this.city,
    required this.locality,
    required this.address,
    required this.price,
    required this.priceFormatted,
    this.pricePerSqFt,
    this.dealPrice,
    this.dealPriceFormatted,
    this.dealSavings,
    this.dealTag,
    this.isDeal = false,
    required this.area,
    this.areaUnit = 'sq.ft',
    this.bedrooms,
    this.bathrooms,
    this.parking,
    this.floor,
    this.furnishing,
    required this.images,
    required this.amenities,
    required this.description,
    this.latitude = 17.4435,
    this.longitude = 78.3772,
    this.verified = true,
    this.featured = false,
    required this.owner,
    required this.postedDate,
    this.aiMatch = 92,
    this.aiReasons = const [],
    this.possessionStatus,
    this.facing,
    this.reraId,
    this.carpetArea,
    this.balconies,
    this.gatedSecurity,
    this.maintenanceFee,
    this.projectName,
  });

  /// Formats Indian Rupees into Lakhs / Crores string (e.g. ₹72 Lakhs, ₹1.45 Cr)
  static String formatINR(num amount) {
    if (amount >= 10000000) {
      final cr = amount / 10000000;
      return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)} Cr';
    } else if (amount >= 100000) {
      final lakhs = amount / 100000;
      return '₹${lakhs.toStringAsFixed(lakhs.truncateToDouble() == lakhs ? 0 : 2)} Lakhs';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    final rawPrice = (json['price'] as num?)?.toInt() ?? 0;
    final rawDealPrice = (json['dealPrice'] as num?)?.toInt();
    final rawArea = (json['area'] as num?)?.toInt() ?? 1200;

    return Property(
      id: json['id'] as String? ?? UniqueKey().toString(),
      title: json['title'] as String? ?? 'Luxury Property',
      type: json['type'] as String? ?? 'Apartment',
      purpose: json['purpose'] as String? ?? 'Buy',
      category: json['category'] as String? ?? 'Buy',
      city: json['city'] as String? ?? 'Hyderabad',
      locality: json['locality'] as String? ?? 'Gachibowli',
      address: json['address'] as String? ?? 'Gachibowli, Hyderabad',
      price: rawPrice,
      priceFormatted: json['priceFormatted'] as String? ?? formatINR(rawPrice),
      pricePerSqFt: (json['pricePerSqFt'] as num?)?.toInt() ?? (rawArea > 0 ? (rawPrice / rawArea).round() : null),
      dealPrice: rawDealPrice,
      dealPriceFormatted: json['dealPriceFormatted'] as String? ?? (rawDealPrice != null ? formatINR(rawDealPrice) : null),
      dealSavings: json['dealSavings'] as String?,
      dealTag: json['dealTag'] as String?,
      isDeal: json['isDeal'] as bool? ?? (rawDealPrice != null && rawDealPrice < rawPrice),
      area: rawArea,
      areaUnit: json['areaUnit'] as String? ?? 'sq.ft',
      bedrooms: (json['bedrooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      parking: (json['parking'] as num?)?.toInt(),
      floor: json['floor'] as String?,
      furnishing: json['furnishing'] as String?,
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 17.4435,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 78.3772,
      verified: json['verified'] as bool? ?? true,
      featured: json['featured'] as bool? ?? false,
      owner: json['owner'] != null ? Owner.fromJson(json['owner'] as Map<String, dynamic>) : const Owner(name: 'Gruha Verified Owner'),
      postedDate: json['postedDate'] as String? ?? 'Recently',
      aiMatch: (json['aiMatch'] as num?)?.toInt() ?? 92,
      aiReasons: (json['aiReasons'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      possessionStatus: json['possessionStatus'] as String?,
      facing: json['facing'] as String?,
      reraId: json['reraId'] as String?,
      carpetArea: (json['carpetArea'] as num?)?.toInt(),
      balconies: (json['balconies'] as num?)?.toInt(),
      gatedSecurity: json['gatedSecurity'] as bool?,
      maintenanceFee: (json['maintenanceFee'] as num?)?.toInt(),
      projectName: json['projectName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'purpose': purpose,
    'category': category,
    'city': city,
    'locality': locality,
    'address': address,
    'price': price,
    'priceFormatted': priceFormatted,
    'pricePerSqFt': pricePerSqFt,
    'dealPrice': dealPrice,
    'dealPriceFormatted': dealPriceFormatted,
    'dealSavings': dealSavings,
    'dealTag': dealTag,
    'isDeal': isDeal,
    'area': area,
    'areaUnit': areaUnit,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'parking': parking,
    'floor': floor,
    'furnishing': furnishing,
    'images': images,
    'amenities': amenities,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'verified': verified,
    'featured': featured,
    'owner': owner.toJson(),
    'postedDate': postedDate,
    'aiMatch': aiMatch,
    'aiReasons': aiReasons,
    'possessionStatus': possessionStatus,
    'facing': facing,
    'reraId': reraId,
    'carpetArea': carpetArea,
    'balconies': balconies,
    'gatedSecurity': gatedSecurity,
    'maintenanceFee': maintenanceFee,
    'projectName': projectName,
  };
}

class UniqueKey {
  @override
  String toString() => DateTime.now().millisecondsSinceEpoch.toString();
}
