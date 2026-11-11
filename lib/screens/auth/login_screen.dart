import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../providers/app_state.dart';
import '../../widgets/common/toast_widget.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController(text: 'user@gruhasankalp.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _phoneController = TextEditingController(text: '9876543210');
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _loginPassword() async {
    setState(() => _isLoading = true);
    final appState = context.read<AppState>();

    try {
      await appState.loginWithPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        ToastHelper.showSuccess(context, 'Welcome back, ${appState.userProfile?.fullName}!');
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) ToastHelper.showError(context, 'Login failed. Please check credentials.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().length < 10) {
      ToastHelper.showError(context, 'Please enter a valid 10-digit mobile number.');
      return;
    }
    setState(() => _otpSent = true);
    ToastHelper.showSuccess(context, 'OTP sent to ${_phoneController.text.trim()}! (Use 123456)');
    _otpController.text = '123456';
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);
    final appState = context.read<AppState>();

    try {
      await appState.loginWithPhone(
        _phoneController.text.trim(),
        _otpController.text.trim(),
      );
      if (mounted) {
        ToastHelper.showSuccess(context, 'Phone verified! Logged in successfully.');
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) ToastHelper.showError(context, 'Invalid OTP. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In to GruhaSankalp', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo_GruhaSankalp.png',
                height: 50,
                errorBuilder: (_, __, ___) => const Icon(Icons.home_work, size: 50, color: GruhaColors.navy900),
              ),
            ),
            const SizedBox(height: 20),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: GruhaColors.navy50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: GruhaColors.navy900,
                labelColor: GruhaColors.navy900,
                unselectedLabelColor: GruhaColors.textMuted,
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                tabs: const [
                  Tab(text: 'Password'),
                  Tab(text: 'Phone OTP'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab Views
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Email & Password
                  Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email Address or Phone', prefixIcon: Icon(Icons.email_outlined, size: 18)),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline, size: 18)),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _loginPassword,
                          child: _isLoading
                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),

                  // Tab 2: Phone OTP
                  Column(
                    children: [
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone_outlined, size: 18), prefixText: '+91 '),
                      ),
                      const SizedBox(height: 12),
                      if (_otpSent) ...[
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Enter 6-digit OTP', prefixIcon: Icon(Icons.security, size: 18)),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyOtp,
                            child: _isLoading
                                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Verify & Sign In'),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _sendOtp,
                            child: const Text('Send Verification OTP'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Signup Link
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: GruhaColors.textMuted, fontSize: 13)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      'Sign Up Free',
                      style: TextStyle(color: GruhaColors.navy900, fontWeight: FontWeight.w800, fontSize: 13),
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
