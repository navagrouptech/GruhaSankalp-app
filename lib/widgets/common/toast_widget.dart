import 'package:flutter/material.dart';
import '../../config/colors.dart';

class ToastHelper {
  ToastHelper._();

  static void showSuccess(BuildContext context, String message, {String? title}) {
    _showSnackBar(
      context,
      title: title ?? 'Success',
      message: message,
      icon: Icons.check_circle_rounded,
      bgColor: GruhaColors.navy900,
      accentColor: GruhaColors.verifiedGreen,
    );
  }

  static void showInfo(BuildContext context, String message, {String? title}) {
    _showSnackBar(
      context,
      title: title ?? 'Info',
      message: message,
      icon: Icons.info_outline_rounded,
      bgColor: GruhaColors.navy900,
      accentColor: GruhaColors.gold400,
    );
  }

  static void showError(BuildContext context, String message, {String? title}) {
    _showSnackBar(
      context,
      title: title ?? 'Alert',
      message: message,
      icon: Icons.error_outline_rounded,
      bgColor: const Color(0xFF7F1D1D),
      accentColor: GruhaColors.dealRed,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color bgColor,
    required Color accentColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: accentColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

