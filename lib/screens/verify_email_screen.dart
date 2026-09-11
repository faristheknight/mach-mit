import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/screens/login_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isSending = false;
  bool _isChecking = false;
  String? _message;

  Future<void> _resendEmail() async {
    setState(() {
      _isSending = true;
      _message = null;
    });
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      setState(() => _message = 'Verification email sent. Check your inbox.');
    } catch (e) {
      setState(
        () => _message = 'Could not send email. Please try again shortly.',
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _checkVerified() async {
    setState(() => _isChecking = true);
    try {
      // reload() pulls the latest state from Firebase's servers, since
      // the cached currentUser object doesn't update itself automatically
      // just because you clicked a link in an email on another device.
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (mounted && user != null && !user.emailVerified) {
        setState(() => _message = "Not verified yet — check your inbox.");
      }
      // If it IS verified, AuthGate's stream-based rebuild (triggered by
      // reload firing an internal auth state refresh) will swap screens
      // automatically. No manual navigation needed here.
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FaIcon(
                  FontAwesomeIcons.envelopeCircleCheck,
                  color: selected_color,
                  size: 36,
                ),
                const SizedBox(height: 20),
                Text(
                  'Verify your email',
                  style: GoogleFonts.fraunces(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: text_color1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We've sent a verification link to",
                  style: GoogleFonts.roboto(fontSize: 14, color: text_color2),
                ),
                Text(
                  email,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: text_color1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tap the link, then come back and press 'I've verified' below.",
                  style: GoogleFonts.roboto(fontSize: 13, color: text_color2),
                ),

                if (_message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _message!,
                    style: TextStyle(color: selected_color, fontSize: 13),
                  ),
                ],

                const SizedBox(height: 28),
                GestureDetector(
                  onTap: _isChecking ? null : _checkVerified,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected_color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _isChecking
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            "I've verified",
                            style: GoogleFonts.roboto(
                              color: text_color1,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: TextButton(
                    onPressed: _isSending ? null : _resendEmail,
                    child: Text(
                      'Resend email',
                      style: TextStyle(color: text_color2, fontSize: 14),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
