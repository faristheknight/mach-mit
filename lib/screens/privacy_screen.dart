import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/widgets/textfield.dart';
import 'package:mach_mit/screens/login_screen.dart';
import 'package:mach_mit/user_settings_service.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _publicProfile = true;
  bool _showJoinedEvents = true;
  bool _showLocation = false;
  bool _isLoading = true;

  final UserSettingsService _settingsService = UserSettingsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final saved = await _settingsService.loadSettings();
    if (!mounted) return;
    setState(() {
      _publicProfile = saved['publicProfile'] ?? true;
      _showJoinedEvents = saved['showJoinedEvents'] ?? true;
      _showLocation = saved['showLocation'] ?? false;
      _isLoading = false;
    });
  }

  Widget _toggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: text_color1,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: text_color2, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: selected_color,
            inactiveThumbColor: text_color2,
            inactiveTrackColor: searchbar_color,
          ),
        ],
      ),
    );
  }

  final TextEditingController _passwordController = TextEditingController();
  bool _isDeleting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _actuallyDeleteAccount(BuildContext dialogContext) async {
    setState(() => _isDeleting = true);
    final user = FirebaseAuth.instance.currentUser;

    try {
      // Firebase requires a RECENT sign-in for destructive actions like
      // account deletion. Since we can't know how long ago the user last
      // logged in, we re-authenticate with their password right before
      // deleting, every time, to guarantee it succeeds.
      if (user?.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _passwordController.text,
        );
        await user.reauthenticateWithCredential(credential);
      }

      await user?.delete();

      if (!mounted) return;
      Navigator.of(dialogContext).pop(); // close the dialog
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Something went wrong. Please try again.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Incorrect password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: card_backgroud_color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete account?',
          style: TextStyle(color: text_color1, fontWeight: FontWeight.bold),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This permanently deletes your account and event history. '
                  'This can\'t be undone. Enter your password to confirm.',
                  style: TextStyle(color: text_color2),
                ),
                const SizedBox(height: 14),
                MyTextField(
                  controller: _passwordController,
                  lines: 1,
                  hinttext: 'Your password',
                  obscureText: true,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: text_color2)),
          ),
          TextButton(
            onPressed: _isDeleting
                ? null
                : () => _actuallyDeleteAccount(context),
            child: _isDeleting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.redAccent,
                    ),
                  )
                : const Text(
                    'Delete',
                    style: TextStyle(color: Colors.redAccent),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back),
                    color: text_color1,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Privacy',
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: text_color1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PROFILE VISIBILITY',
                        style: GoogleFonts.roboto(
                          color: text_color2,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: card_backgroud_color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            _toggleRow(
                              title: 'Public profile',
                              subtitle:
                                  'Let other users see your profile and events',
                              value: _publicProfile,
                              onChanged: (v) {
                                setState(() => _publicProfile = v);
                                _settingsService.updateSetting(
                                  'publicProfile',
                                  v,
                                );
                              },
                            ),
                            Divider(color: searchbar_color, height: 1),
                            _toggleRow(
                              title: 'Show joined events',
                              subtitle:
                                  'Display events you\'re attending on your profile',
                              value: _showJoinedEvents,
                              onChanged: (v) {
                                setState(() => _showJoinedEvents = v);
                                _settingsService.updateSetting(
                                  'showJoinedEvents',
                                  v,
                                );
                              },
                            ),
                            Divider(color: searchbar_color, height: 1),
                            _toggleRow(
                              title: 'Share approximate location',
                              subtitle:
                                  'Used to show events happening near you',
                              value: _showLocation,
                              onChanged: (v) {
                                setState(() => _showLocation = v);
                                _settingsService.updateSetting(
                                  'showLocation',
                                  v,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'YOUR DATA',
                        style: GoogleFonts.roboto(
                          color: text_color2,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Material(
                        color: card_backgroud_color,
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {},
                              title: Text(
                                'Download my data',
                                style: TextStyle(
                                  color: text_color1,
                                  fontSize: 15,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: text_color2,
                                size: 20,
                              ),
                            ),
                            ListTile(
                              onTap: _confirmDeleteAccount,
                              title: const Text(
                                'Delete my account',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
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
