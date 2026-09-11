import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/user_settings_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _newEventsNearby = true;
  bool _eventReminders = true;
  bool _chatMessages = true;
  bool _eventUpdates = true;
  bool _marketingEmails = false;
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
      _newEventsNearby = saved['newEventsNearby'] ?? true;
      _eventReminders = saved['eventReminders'] ?? true;
      _chatMessages = saved['chatMessages'] ?? true;
      _eventUpdates = saved['eventUpdates'] ?? true;
      _marketingEmails = saved['marketingEmails'] ?? false;
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
                    'Notifications',
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
                        'EVENTS',
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: card_backgroud_color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            _toggleRow(
                              title: 'New events nearby',
                              subtitle:
                                  'Get notified when new events pop up close to you',
                              value: _newEventsNearby,
                              onChanged: (v) {
                                setState(() => _newEventsNearby = v);
                                _settingsService.updateSetting(
                                  'newEventsNearby',
                                  v,
                                );
                              },
                            ),
                            Divider(color: searchbar_color, height: 1),
                            _toggleRow(
                              title: 'Event reminders',
                              subtitle:
                                  'A heads up before events you\'ve joined start',
                              value: _eventReminders,
                              onChanged: (v) {
                                setState(() => _eventReminders = v);
                                _settingsService.updateSetting(
                                  'eventReminders',
                                  v,
                                );
                              },
                            ),
                            Divider(color: searchbar_color, height: 1),
                            _toggleRow(
                              title: 'Event updates',
                              subtitle:
                                  'Changes to time, location, or details for your events',
                              value: _eventUpdates,
                              onChanged: (v) {
                                setState(() => _eventUpdates = v);
                                _settingsService.updateSetting(
                                  'eventUpdates',
                                  v,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'CHATS',
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
                        child: _toggleRow(
                          title: 'Chat messages',
                          subtitle: 'New messages from people you\'ve met',
                          value: _chatMessages,
                          onChanged: (v) {
                            setState(() => _chatMessages = v);
                            _settingsService.updateSetting('chatMessages', v);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'OTHER',
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
                        child: _toggleRow(
                          title: 'Marketing emails',
                          subtitle: 'Occasional tips, news, and offers',
                          value: _marketingEmails,
                          onChanged: (v) {
                            setState(() => _marketingEmails = v);
                            _settingsService.updateSetting(
                              'marketingEmails',
                              v,
                            );
                          },
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
