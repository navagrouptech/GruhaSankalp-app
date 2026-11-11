import 'property.dart';

/// Interaction and Backend Models
/// Direct conversion of src/types/api.ts and app-provider.tsx interfaces

class SiteVisit {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String propertyLocation;
  final String name;
  final String phone;
  final String email;
  final String date;
  final String timeSlot;
  final String contactMethod; // 'Phone' | 'WhatsApp' | 'Email'
  final String status; // 'Confirmed' | 'Pending' | 'Completed'
  final String? gatePasscode;
  final String createdAt;

  const SiteVisit({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.propertyLocation,
    required this.name,
    required this.phone,
    required this.email,
    required this.date,
    required this.timeSlot,
    this.contactMethod = 'WhatsApp',
    this.status = 'Confirmed',
    this.gatePasscode,
    required this.createdAt,
  });

  factory SiteVisit.fromJson(Map<String, dynamic> json) {
    return SiteVisit(
      id: json['id'] as String? ?? UniqueKey().toString(),
      propertyId: json['propertyId'] as String? ?? '',
      propertyTitle: json['propertyTitle'] as String? ?? 'Scheduled Property',
      propertyLocation: json['propertyLocation'] as String? ?? 'Hyderabad',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      date: json['date'] as String? ?? '',
      timeSlot: json['timeSlot'] as String? ?? '10:00 AM - 12:00 PM',
      contactMethod: json['contactMethod'] as String? ?? 'WhatsApp',
      status: json['status'] as String? ?? 'Confirmed',
      gatePasscode: json['gatePasscode'] as String? ?? 'GP-${1000 + (DateTime.now().microsecond % 8999)}',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'propertyId': propertyId,
    'propertyTitle': propertyTitle,
    'propertyLocation': propertyLocation,
    'name': name,
    'phone': phone,
    'email': email,
    'date': date,
    'timeSlot': timeSlot,
    'contactMethod': contactMethod,
    'status': status,
    'gatePasscode': gatePasscode,
    'createdAt': createdAt,
  };
}

class Enquiry {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String name;
  final String phone;
  final String email;
  final String message;
  final String createdAt;

  const Enquiry({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.name,
    required this.phone,
    required this.email,
    required this.message,
    required this.createdAt,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      id: json['id'] as String? ?? UniqueKey().toString(),
      propertyId: json['propertyId'] as String? ?? '',
      propertyTitle: json['propertyTitle'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'propertyId': propertyId,
    'propertyTitle': propertyTitle,
    'name': name,
    'phone': phone,
    'email': email,
    'message': message,
    'createdAt': createdAt,
  };
}

class SearchAlert {
  final String id;
  final String city;
  final String? locality;
  final String category;
  final String? bhk;
  final String? maxBudget;
  final String createdAt;

  const SearchAlert({
    required this.id,
    required this.city,
    this.locality,
    required this.category,
    this.bhk,
    this.maxBudget,
    required this.createdAt,
  });

  factory SearchAlert.fromJson(Map<String, dynamic> json) {
    return SearchAlert(
      id: json['id'] as String? ?? UniqueKey().toString(),
      city: json['city'] as String? ?? 'Hyderabad',
      locality: json['locality'] as String?,
      category: json['category'] as String? ?? 'Buy',
      bhk: json['bhk'] as String?,
      maxBudget: json['maxBudget'] as String?,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'city': city,
    'locality': locality,
    'category': category,
    'bhk': bhk,
    'maxBudget': maxBudget,
    'createdAt': createdAt,
  };
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final bool read;
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    this.read = false,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String? ?? UniqueKey().toString(),
      title: json['title'] as String? ?? 'Notification',
      message: json['message'] as String? ?? '',
      read: json['read'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'read': read,
    'createdAt': createdAt,
  };
}

class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role; // 'Buyer' | 'Owner' | 'Agent' | 'Builder' | 'Admin'
  final bool isPhoneVerified;
  final String? avatar;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.role = 'Buyer',
    this.isPhoneVerified = true,
    this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'user-1',
      fullName: json['fullName'] as String? ?? 'Gruha User',
      email: json['email'] as String? ?? 'user@gruhasankalp.com',
      phone: json['phone'] as String? ?? '+91 98765 43210',
      role: json['role'] as String? ?? 'Buyer',
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? true,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'role': role,
    'isPhoneVerified': isPhoneVerified,
    'avatar': avatar,
  };
}

class AiChatMessage {
  final String id;
  final bool isUser;
  final String text;
  final DateTime timestamp;
  final List<Property>? properties;
  final List<String>? quickReplies;

  const AiChatMessage({
    required this.id,
    required this.isUser,
    required this.text,
    required this.timestamp,
    this.properties,
    this.quickReplies,
  });
}
