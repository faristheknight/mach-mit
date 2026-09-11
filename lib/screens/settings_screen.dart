import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/screens/edit_profile_screen.dart';
import 'package:mach_mit/screens/notifications_screen.dart';
import 'package:mach_mit/screens/privacy_screen.dart';
import 'package:mach_mit/screens/impressum_screen.dart';
import 'package:mach_mit/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          color: text_color2,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> tiles) {
    return Material(
      color: card_backgroud_color,
      borderRadius: BorderRadius.circular(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: tiles),
    );
  }

  ListTile _tile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? titleColor,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: text_color2, size: 20),
      title: Text(
        title,
        style: TextStyle(color: titleColor ?? text_color1, fontSize: 15),
      ),
      trailing:
          trailing ??
          Icon(Icons.chevron_right, color: text_color2, size: 20),
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
                    'Settings',
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: text_color1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('ACCOUNT'),
                      _settingsCard([
                        _tile(
                          icon: Icons.person_outline,
                          title: 'Edit profile',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          ),
                        ),
                        _tile(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationsScreen(),
                            ),
                          ),
                        ),
                        _tile(
                          icon: Icons.lock_outline,
                          title: 'Privacy',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyScreen(),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 24),

                      _sectionLabel('APP'),
                      _settingsCard([
                        _tile(
                          icon: Icons.language,
                          title: 'Language',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'English',
                                style: TextStyle(
                                  color: text_color2,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right,
                                color: text_color2,
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                        _tile(
                          icon: Icons.cleaning_services_outlined,
                          title: 'Clear cache',
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 24),

                      _sectionLabel('ABOUT'),
                      _settingsCard([
                        _tile(
                          icon: Icons.gavel_outlined,
                          title: 'Impressum',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImpressumScreen(),
                            ),
                          ),
                        ),
                        _tile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {},
                        ),
                        _tile(
                          icon: Icons.info_outline,
                          title: 'App version',
                          trailing: Text(
                            '1.0.0',
                            style: TextStyle(
                              color: text_color2,
                              fontSize: 14,
                            ),
                          ),
                          onTap: null,
                        ),
                      ]),
                      const SizedBox(height: 24),

                      _settingsCard([
                        _tile(
                          icon: Icons.logout,
                          title: 'Sign out',
                          titleColor: Colors.deepOrangeAccent,
                          onTap: () async {
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
                        ),
                      ]),
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
