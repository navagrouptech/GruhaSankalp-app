import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../models/property.dart';
import '../../providers/app_state.dart';
import '../common/toast_widget.dart';

class ScheduleVisitSheet extends StatefulWidget {
  final Property property;

  const ScheduleVisitSheet({super.key, required this.property});

  @override
  State<ScheduleVisitSheet> createState() => _ScheduleVisitSheetState();
}

class _ScheduleVisitSheetState extends State<ScheduleVisitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedDate = 'Tomorrow, 11:30 AM';
  String _selectedSlot = 'Morning (10:00 AM - 12:00 PM)';
  String _selectedContact = 'WhatsApp';
  bool _isSubmitting = false;

  final List<String> _dateOptions = [
    'Tomorrow, 11:30 AM',
    'Saturday, 11:00 AM',
    'Sunday, 04:00 PM',
    'Custom Date...',
  ];

  final List<String> _slots = [
    'Morning (10:00 AM - 12:00 PM)',
    'Afternoon (12:00 PM - 03:00 PM)',
    'Evening (03:00 PM - 06:00 PM)',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().userProfile;
    if (user != null) {
      _nameController.text = user.fullName;
      _phoneController.text = user.phone;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final appState = context.read<AppState>();

    try {
      final visit = await appState.scheduleSiteVisit(
        propertyId: widget.property.id,
        propertyTitle: widget.property.title,
        propertyLocation: widget.property.locality,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        date: _selectedDate,
        timeSlot: _selectedSlot,
        contactMethod: _selectedContact,
      );

      if (mounted) {
        Navigator.pop(context);
        _showConfirmationDialog(visit.gatePasscode ?? 'GP-9421');
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'Failed to schedule visit. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showConfirmationDialog(String passcode) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: GruhaColors.verifiedGreen, size: 28),
            SizedBox(width: 8),
            Text('Visit Scheduled!', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your physical site visit appointment has been confirmed with the owner.',
              style: TextStyle(fontSize: 13, color: GruhaColors.textBody),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GruhaColors.navy50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GruhaColors.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gate Passcode:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    passcode,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: GruhaColors.navy900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Show this pass at the security gate upon arrival. You can also review this visit in your Buyer Dashboard.',
              style: TextStyle(fontSize: 11, color: GruhaColors.textMuted),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              const Text(
                'Schedule Free Site Visit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: GruhaColors.navy900,
                ),
              ),
              Text(
                widget.property.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: GruhaColors.textMuted),
              ),
              const SizedBox(height: 16),

              // Date Options
              const Text('Select Preferred Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _dateOptions.map((d) {
                  final isSelected = _selectedDate == d;
                  return ChoiceChip(
                    label: Text(d, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                    selected: isSelected,
                    selectedColor: GruhaColors.navy900,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : GruhaColors.textDark),
                    onSelected: (val) {
                      if (val) setState(() => _selectedDate = d);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Time Slots
              const Text('Select Time Slot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _slots.map((s) {
                  final isSelected = _selectedSlot == s;
                  return ChoiceChip(
                    label: Text(s.split('(').first.trim(), style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                    selected: isSelected,
                    selectedColor: GruhaColors.navy900,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : GruhaColors.textDark),
                    onSelected: (val) {
                      if (val) setState(() => _selectedSlot = s);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Name & Phone
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline, size: 18)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Mobile Phone', prefixIcon: Icon(Icons.phone_outlined, size: 18)),
                validator: (v) => v == null || v.trim().length < 10 ? 'Enter valid 10-digit number' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined, size: 18)),
              ),
              const SizedBox(height: 14),

              // Contact Preference
              const Text('Confirm Appointment Via', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 6),
              Row(
                children: ['WhatsApp', 'Phone Call', 'Email'].map((method) {
                  final isSelected = _selectedContact == method;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(method, style: const TextStyle(fontSize: 11)),
                      selected: isSelected,
                      selectedColor: GruhaColors.gold100,
                      checkmarkColor: GruhaColors.navy900,
                      onSelected: (val) {
                        if (val) setState(() => _selectedContact = method);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GruhaColors.navy900,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Confirm Free Site Visit',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

