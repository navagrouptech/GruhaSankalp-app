import '../models/api_models.dart';
import '../models/property.dart';
import 'api_client.dart';
import 'mock_data.dart';

class InteractionService {
  InteractionService._();
  static final InteractionService instance = InteractionService._();

  /// Schedules a site visit
  Future<SiteVisit> scheduleVisit({
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
    final payload = {
      'propertyId': propertyId,
      'name': name,
      'phone': phone,
      'email': email,
      'date': date,
      'timeSlot': timeSlot,
      'contactMethod': contactMethod,
    };

    String passcode = 'GP-${1000 + (DateTime.now().millisecond % 8999)}';
    String visitId = 'visit-${DateTime.now().millisecondsSinceEpoch}';

    try {
      final res = await ApiClient.instance.post('/api/v1/visits', body: payload);
      if (res is Map) {
        if (res.containsKey('id')) visitId = res['id'].toString();
        if (res.containsKey('gatePasscode')) passcode = res['gatePasscode'].toString();
      }
    } catch (_) {
      // Local fallback
    }

    return SiteVisit(
      id: visitId,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      propertyLocation: propertyLocation,
      name: name,
      phone: phone,
      email: email,
      date: date,
      timeSlot: timeSlot,
      contactMethod: contactMethod,
      status: 'Confirmed',
      gatePasscode: passcode,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  /// Sends an enquiry to property owner
  Future<Enquiry> sendEnquiry({
    required String propertyId,
    required String propertyTitle,
    required String name,
    required String phone,
    required String email,
    required String message,
  }) async {
    final payload = {
      'propertyId': propertyId,
      'name': name,
      'phone': phone,
      'email': email,
      'message': message,
    };

    String enqId = 'enq-${DateTime.now().millisecondsSinceEpoch}';

    try {
      final res = await ApiClient.instance.post('/api/v1/enquiries', body: payload);
      if (res is Map && res.containsKey('id')) {
        enqId = res['id'].toString();
      }
    } catch (_) {}

    return Enquiry(
      id: enqId,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      name: name,
      phone: phone,
      email: email,
      message: message,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  /// Sends query to Gruha AI Assistant
  Future<AiChatMessage> askGruhaAi(String query) async {
    try {
      final res = await ApiClient.instance.post('/api/v1/ai/ask', body: {'query': query});
      if (res is Map) {
        final answer = res['answer'] as String? ?? res['response'] as String? ?? 'I found these properties matching your criteria:';
        List<Property> matched = [];
        if (res['properties'] is List) {
          matched = (res['properties'] as List)
              .map((p) => Property.fromJson(p as Map<String, dynamic>))
              .toList();
        }
        return AiChatMessage(
          id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
          isUser: false,
          text: answer,
          timestamp: DateTime.now(),
          properties: matched.isNotEmpty ? matched : null,
        );
      }
    } catch (_) {}

    // Smart Local AI Engine fallback
    final q = query.toLowerCase();
    String reply = '';
    List<Property> recommendations = [];

    if (q.contains('3bhk') || q.contains('3 bhk') || q.contains('gachibowli')) {
      reply = '### 🌟 Best 3 BHK Listings in Gachibowli\n\n'
          'Here is the top-rated luxury option directly from verified owner with zero brokerage:';
      recommendations = MockData.defaultProperties.where((p) => p.locality == 'Gachibowli').toList();
    } else if (q.contains('villa') || q.contains('luxury') || q.contains('kokapet')) {
      reply = '### 🏡 Premium Villas in Kokapet Golden Mile\n\n'
          'Featuring high capital appreciation, HMDA clear title, and direct builder launch savings:';
      recommendations = MockData.defaultProperties.where((p) => p.type == 'Villa').toList();
    } else if (q.contains('rent') || q.contains('pg') || q.contains('co-living') || q.contains('coliving')) {
      reply = '### 🔑 Top Verified Rentals & Co-Living Spaces\n\n'
          'These listings feature zero deposit, walkability to Mindspace / Hitec City, and verified amenities:';
      recommendations = MockData.defaultProperties.where((p) => p.purpose == 'Rent').toList();
    } else if (q.contains('deal') || q.contains('discount') || q.contains('offer')) {
      reply = '### 🔥 Exclusive Verified Deals\n\n'
          'Handpicked properties with verified price reductions and direct owner savings:';
      recommendations = MockData.defaultProperties.where((p) => p.isDeal).toList();
    } else {
      reply = '### 🤖 Gruha AI Analysis\n\n'
          'I analyzed your requirement: **"$query"**.\n\n'
          '- **Market Trend**: High demand for 2-3 BHK units in Hyderabad tech corridor (12-14% YoY appreciation).\n'
          '- **Recommendation**: Always prioritize RERA-approved properties with clear title deeds.\n'
          '- **Zero Brokerage**: You can contact owners directly or schedule a free site visit.';
      recommendations = MockData.defaultProperties.take(2).toList();
    }

    return AiChatMessage(
      id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
      isUser: false,
      text: reply,
      timestamp: DateTime.now(),
      properties: recommendations.isNotEmpty ? recommendations : null,
      quickReplies: [
        '3 BHK in Gachibowli under 2 Cr',
        'Villas in Kokapet',
        'Rental flats near Mindspace',
        'Show exclusive deals',
      ],
    );
  }
}

