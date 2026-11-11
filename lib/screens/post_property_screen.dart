import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../config/constants.dart';
import '../providers/app_state.dart';
import '../widgets/common/toast_widget.dart';

class PostPropertyScreen extends StatefulWidget {
  const PostPropertyScreen({super.key});

  @override
  State<PostPropertyScreen> createState() => _PostPropertyScreenState();
}

class _PostPropertyScreenState extends State<PostPropertyScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String _category = 'Buy';
  String _type = 'Apartment';
  String _city = 'Hyderabad';
  final _localityController = TextEditingController(text: 'Gachibowli');
  final _addressController = TextEditingController();
  final _projectController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  int _bhk = 3;
  final int _baths = 3;
  String _furnishing = 'Semi Furnished';
  final String _facing = 'East';
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final List<String> _selectedAmenities = ['24/7 Security', 'Covered Parking', 'Power Backup'];
  final List<String> _availableAmenities = [
    'Clubhouse',
    'Swimming Pool',
    'Gymnasium',
    'Power Backup',
    '24/7 Security',
    'Covered Parking',
    'Children Play Area',
    'EV Charging',
    'Visitor Parking',
    'Intercom',
  ];

  bool _isAiGenerating = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _localityController.dispose();
    _addressController.dispose();
    _projectController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _generateAiDescription() {
    setState(() => _isAiGenerating = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final title = 'Spacious $_bhk BHK $_type in ${_localityController.text.trim()}, $_city';
        _titleController.text = title;
        _descController.text =
            'Excellent $_bhk BHK $_type located in prime area of ${_localityController.text.trim()}, $_city. '
            'Features Vastu-compliant $_facing facing layout with premium $_furnishing interiors and high ceiling ventilation. '
            'Includes modern amenities: ${_selectedAmenities.join(", ")}. '
            'Direct listing from verified owner with zero brokerage and clear bank approved title.';
        setState(() => _isAiGenerating = false);
        ToastHelper.showSuccess(context, '✨ Description generated with Gruha AI!');
      }
    });
  }

  Future<void> _submitListing() async {
    setState(() => _isSubmitting = true);
    final appState = context.read<AppState>();

    final price = int.tryParse(_priceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 15000000;
    final area = int.tryParse(_areaController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1800;

    final data = {
      'title': _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : '$_bhk BHK $_type in ${_localityController.text.trim()}',
      'type': _type,
      'purpose': _category == 'Rent' ? 'Rent' : 'Buy',
      'category': _category,
      'city': _city,
      'locality': _localityController.text.trim(),
      'address': _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : '${_localityController.text.trim()}, $_city',
      'price': price,
      'area': area,
      'bedrooms': _bhk,
      'bathrooms': _baths,
      'furnishing': _furnishing,
      'facing': _facing,
      'amenities': _selectedAmenities,
      'description': _descController.text.trim(),
      'images': [
        if (_imageUrlController.text.trim().isNotEmpty)
          _imageUrlController.text.trim()
        else
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80',
      ],
    };

    await appState.postProperty(data);
    setState(() => _isSubmitting = false);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: GruhaColors.verifiedGreen, size: 28),
              SizedBox(width: 8),
              Text('Property Listed!', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          content: const Text(
            'Your listing has been submitted and is now published for buyers and tenants. You can manage it from your Seller Dashboard.',
            style: TextStyle(fontSize: 13, color: GruhaColors.textBody),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Property FREE', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 4) {
              setState(() => _currentStep += 1);
            } else {
              _submitListing();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          controlsBuilder: (ctx, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : details.onStepContinue,
                      child: _isSubmitting
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(_currentStep == 4 ? 'Publish Listing' : 'Next Step'),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            // STEP 1: Basic Classification
            Step(
              title: const Text('Category & Type', style: TextStyle(fontWeight: FontWeight.w800)),
              isActive: _currentStep >= 0,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('I want to:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: ['Buy', 'Rent'].map((p) {
                      final isSel = _category == p;
                      return ChoiceChip(
                        label: Text(p == 'Buy' ? 'Sell Property' : 'Rent Out Property'),
                        selected: isSel,
                        selectedColor: GruhaColors.navy900,
                        labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark),
                        onSelected: (val) => setState(() => _category = p),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  const Text('Property Type:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: AppConstants.propertyTypes.take(6).map((t) {
                      final isSel = _type == t;
                      return ChoiceChip(
                        label: Text(t, style: const TextStyle(fontSize: 11)),
                        selected: isSel,
                        selectedColor: GruhaColors.navy900,
                        labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark),
                        onSelected: (val) => setState(() => _type = t),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // STEP 2: Location
            Step(
              title: const Text('Location', style: TextStyle(fontWeight: FontWeight.w800)),
              isActive: _currentStep >= 1,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _city,
                    decoration: const InputDecoration(labelText: 'City'),
                    items: AppConstants.popularCities.where((c) => c != 'All').map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (val) => setState(() => _city = val ?? 'Hyderabad'),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _localityController,
                    decoration: const InputDecoration(labelText: 'Locality / Area', hintText: 'e.g. Gachibowli, Kokapet'),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _projectController,
                    decoration: const InputDecoration(labelText: 'Society / Project Name', hintText: 'e.g. Aparna CyberLife'),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Complete Address / Landmark'),
                  ),
                ],
              ),
            ),

            // STEP 3: Specs & Pricing
            Step(
              title: const Text('Specs & Pricing', style: TextStyle(fontWeight: FontWeight.w800)),
              isActive: _currentStep >= 2,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _category == 'Rent' ? 'Expected Rent (₹ / month)' : 'Total Price (₹ INR)',
                      prefixText: '₹ ',
                      hintText: _category == 'Rent' ? '35000' : '15000000',
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _areaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Super Built-up Area (sq.ft)', hintText: '1850'),
                  ),
                  const SizedBox(height: 14),

                  const Text('Bedrooms (BHK):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [1, 2, 3, 4, 5].map((bhkNum) {
                      final isSel = _bhk == bhkNum;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text('$bhkNum BHK'),
                          selected: isSel,
                          selectedColor: GruhaColors.navy900,
                          labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark),
                          onSelected: (val) => setState(() => _bhk = bhkNum),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  const Text('Furnishing Status:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: ['Fully Furnished', 'Semi Furnished', 'Unfurnished'].map((f) {
                      final isSel = _furnishing == f;
                      return ChoiceChip(
                        label: Text(f, style: const TextStyle(fontSize: 11)),
                        selected: isSel,
                        selectedColor: GruhaColors.navy900,
                        labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark),
                        onSelected: (val) => setState(() => _furnishing = f),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // STEP 4: Amenities
            Step(
              title: const Text('Amenities', style: TextStyle(fontWeight: FontWeight.w800)),
              isActive: _currentStep >= 3,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select all available amenities:', style: TextStyle(fontSize: 13, color: GruhaColors.textMuted)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _availableAmenities.map((amenity) {
                      final isSel = _selectedAmenities.contains(amenity);
                      return FilterChip(
                        label: Text(amenity, style: const TextStyle(fontSize: 11)),
                        selected: isSel,
                        selectedColor: GruhaColors.navy50,
                        checkmarkColor: GruhaColors.navy900,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedAmenities.add(amenity);
                            } else {
                              _selectedAmenities.remove(amenity);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // STEP 5: AI Description & Photos
            Step(
              title: const Text('Description & Photos', style: TextStyle(fontWeight: FontWeight.w800)),
              isActive: _currentStep >= 4,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gruha AI Auto-Description Button
                  OutlinedButton.icon(
                    icon: _isAiGenerating
                        ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.auto_awesome, color: GruhaColors.gold600, size: 16),
                    label: const Text('✨ Generate with Gruha AI', style: TextStyle(color: GruhaColors.navy900, fontWeight: FontWeight.bold)),
                    onPressed: _isAiGenerating ? null : _generateAiDescription,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: GruhaColors.gold400),
                      backgroundColor: GruhaColors.gold50,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Listing Title'),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Detailed Description'),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Property Photo URL (Optional)',
                      hintText: 'https://images.unsplash.com/...',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
