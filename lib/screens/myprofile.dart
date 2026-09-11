import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/screens/edit_profile_screen.dart';
import 'package:mach_mit/screens/notifications_screen.dart';
import 'package:mach_mit/screens/privacy_screen.dart';
import 'package:mach_mit/screens/settings_screen.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _Myprofile();
}

class _Myprofile extends State<Myprofile> {

  static const String _privacyPolicyUrl =
      'https://mach-mit-bd36f.web.app/privacy_policy.html';
  static const String _datenschutzUrl =
      'https://mach-mit-bd36f.web.app/datenschutzerklaerung.html';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: MediaQuery.of(
            context,
          ).padding.copyWith(left: 20.0, right: 20.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: GoogleFonts.fraunces(
                      fontSize: 25,
                      color: text_color1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    color: text_color1,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Profile Header Card
              Container(
                height: 110,
                decoration: BoxDecoration(
                  color: card_backgroud_color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 24,
                        top: 24,
                        left: 30,
                        right: 16,
                      ),
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset('assets/images/random.jpg'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You',
                            style: GoogleFonts.fraunces(
                              color: text_color1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Member since December 2004',
                            style: GoogleFonts.roboto(
                              color: text_color2,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.43,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: card_backgroud_color,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '0',
                          style: GoogleFonts.fraunces(
                            fontSize: 30,
                            color: selected_color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Events Joined',
                          style: GoogleFonts.roboto(color: text_color2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.43,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: card_backgroud_color,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '0',
                          style: GoogleFonts.fraunces(
                            fontSize: 30,
                            color: selected_color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Events Created',
                          style: GoogleFonts.roboto(color: text_color2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Settings Options Container
              Material(
                borderRadius: BorderRadius.circular(20),
                color: card_backgroud_color,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      focusColor: searchbar_color.withValues(alpha: 0.3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      title: Text(
                        'Edit profile',
                        style: TextStyle(color: text_color1, fontSize: 15),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: text_color2,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                      title: Text(
                        'Notifications',
                        style: TextStyle(color: text_color1, fontSize: 15),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: text_color2,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyScreen(),
                          ),
                        );
                      },
                      title: Text(
                        'Privacy',
                        style: TextStyle(color: text_color1, fontSize: 15),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: text_color2,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      title: Text(
                        'Settings',
                        style: TextStyle(color: text_color1, fontSize: 15),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: text_color2,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: Text(
                        'Help & Support',
                        style: TextStyle(color: text_color1, fontSize: 15),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: text_color2,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () => _openUrl(_privacyPolicyUrl),
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(color: text_color1, fontSize: 15),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: text_color2,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () => _openUrl(_datenschutzUrl),
                      title: Text(
                        'Datenschutz',
                        style: TextStyle(color: text_color1, fontSize: 15),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: text_color2,
                        size: 20,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: const Text(
                        'Sign out',
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
