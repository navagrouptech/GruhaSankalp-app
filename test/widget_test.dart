import 'package:flutter_test/flutter_test.dart';
import 'package:gruhasankalp_mobile/models/property.dart';
import 'package:gruhasankalp_mobile/models/search_filter.dart';
import 'package:gruhasankalp_mobile/services/mock_data.dart';
import 'package:gruhasankalp_mobile/widgets/property/property_trust_card.dart';
import 'package:gruhasankalp_mobile/widgets/property/ai_analysis_card.dart';
import 'package:flutter/material.dart';

void main() {
  group('GruhaSankalp Model & Widget Tests', () {
    test('MockData properties are properly populated and valid', () {
      final properties = MockData.defaultProperties;
      expect(properties.isNotEmpty, isTrue);
      expect(properties.length, greaterThanOrEqualTo(5));

      final first = properties.first;
      expect(first.title.isNotEmpty, isTrue);
      expect(first.price, greaterThan(0));
      expect(first.locality, equals('Gachibowli'));
      expect(first.verified, isTrue);
    });

    test('Property formatINR formats Crores and Lakhs correctly', () {
      expect(Property.formatINR(18500000), equals('₹1.85 Cr'));
      expect(Property.formatINR(7200000), equals('₹72 Lakhs'));
      expect(Property.formatINR(35000), equals('₹35000'));
    });

    test('SearchFilter serializes query parameters correctly', () {
      final filter = SearchFilter(
        category: 'Buy',
        city: 'Hyderabad',
        locality: 'Kokapet',
        bhk: '3 BHK',
        verifiedOnly: true,
      );

      final params = filter.toQueryParameters();
      expect(params['category'], equals('Buy'));
      expect(params['city'], equals('Hyderabad'));
      expect(params['locality'], equals('Kokapet'));
      expect(params['bhk'], equals('3 BHK'));
      expect(params['verified'], equals('true'));
    });

    testWidgets('PropertyTrustCard renders verification status checklist', (tester) async {
      final property = MockData.defaultProperties.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PropertyTrustCard(property: property),
          ),
        ),
      );

      expect(find.text('Property Verification Status'), findsOneWidget);
      expect(find.textContaining('Locality (Gachibowli) & Coordinates'), findsOneWidget);
      expect(find.textContaining('Owner verified'), findsOneWidget);
    });

    testWidgets('GruhaAIAnalysisCard renders AI Match percentage and highlights', (tester) async {
      final property = MockData.defaultProperties.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GruhaAIAnalysisCard(property: property),
          ),
        ),
      );

      expect(find.text('Gruha AI Property Analysis'), findsOneWidget);
      expect(find.text('${property.aiMatch}%'), findsOneWidget);
      expect(find.text('KEY PROPERTY HIGHLIGHTS'), findsOneWidget);
    });
  });
}
