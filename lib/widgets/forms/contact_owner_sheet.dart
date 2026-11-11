import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/colors.dart';
import '../../models/property.dart';
import '../../providers/app_state.dart';
import '../common/toast_widget.dart';

class ContactOwnerSheet extends StatefulWidget {
  final Property property;

  const ContactOwnerSheet({super.key, required this.property});

  @override
  State<ContactOwnerSheet> createState() => _ContactOwnerSheetState();
}

class _ContactOwnerSheetState extends State<ContactOwnerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _msgController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _quickMessages = [
    'I am interested in this property. Is the price negotiable?',
    'When is the earliest I can visit this property?',
    'Can you please share additional photos and video tour?',
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
    _msgController.text = 'Hi ${widget.property.owner.name}, I am interested in your listing "${widget.property.title}". Please get in touch.';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      await context.read<AppState>().sendPropertyEnquiry(
        propertyId: widget.property.id,
        propertyTitle: widget.property.title,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        message: _msgController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        ToastHelper.showSuccess(
          context,
          'Enquiry sent directly to owner ${widget.property.owner.name}!',
        );
      }
    } catch (_) {
      if (mounted) {
        ToastHelper.showError(context, 'Failed to send enquiry. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _callOwner() async {
    final phone = widget.property.owner.phone ?? '+919849012345';
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _whatsappOwner() async {
    final phone = (widget.property.owner.phone ?? '+919849012345').replaceAll(RegExp(r'[^0-9]'), '');
    final msg = Uri.encodeComponent('Hi ${widget.property.owner.name}, I found your property "${widget.property.title}" on GruhaSankalp.');
    final uri = Uri.parse('https://wa.me/$phone?text=$msg');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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

              // Owner Info Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: GruhaColors.navy900,
                    child: Text(
                      widget.property.owner.name.substring(0, 1),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact ${widget.property.owner.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: GruhaColors.navy900,
                          ),
                        ),
                        Text(
                          '${widget.property.owner.type} • Direct Zero Brokerage',
                          style: const TextStyle(
                            fontSize: 11,
                            color: GruhaColors.verifiedGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Direct WhatsApp / Call Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.phone, size: 16, color: GruhaColors.navy900),
                      label: const Text('Call Owner', style: TextStyle(fontSize: 12)),
                      onPressed: _callOwner,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white),
                      label: const Text('WhatsApp', style: TextStyle(fontSize: 12, color: Colors.white)),
                      onPressed: _whatsappOwner,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),

              // Quick Message Chips
              const Text('Quick Inquiries:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: GruhaColors.textMuted)),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickMessages.map((msg) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(msg, style: const TextStyle(fontSize: 10)),
                        backgroundColor: GruhaColors.navy50,
                        onPressed: () {
                          setState(() {
                            _msgController.text = msg;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Input Fields
              TextFormField(
                controller: _msgController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Your Message'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a message' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name', prefixIcon: Icon(Icons.person_outline, size: 18)),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Your Phone', prefixIcon: Icon(Icons.phone_outlined, size: 18)),
                validator: (v) => v == null || v.trim().length < 10 ? 'Enter valid phone number' : null,
              ),
              const SizedBox(height: 16),

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
                          'Send Direct Message',
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

