import 'package:flutter/material.dart';
import 'package:mach_mit/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/screens/my_events.dart';
import 'package:mach_mit/widgets/textfield.dart';
import 'package:mach_mit/widgets/hero.dart';
import 'package:mach_mit/widgets/post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mach_mit/screens/chats.dart';
import 'package:mach_mit/screens/myprofile.dart';
import 'package:mach_mit/screens/make_events.dart';
import 'package:mach_mit/event_model.dart';
import 'package:mach_mit/event_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        shadowColor: Colors.black.withValues(alpha: 0.4),
        backgroundColor: background_color,
        onDestinationSelected: (int Index) {
          setState(() {
            currentPageIndex = Index;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.transparent,
        animationDuration: Duration(seconds: 0),
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: FaIcon(
              FontAwesomeIcons.solidHouse,
              color: selected_color,
              size: 30,
            ),
            icon: FaIcon(FontAwesomeIcons.house, size: 30),
            label: "Home",
          ),
          NavigationDestination(
            selectedIcon: FaIcon(
              FontAwesomeIcons.solidMessage,
              color: selected_color,
              size: 30,
            ),
            icon: FaIcon(FontAwesomeIcons.message, size: 30),
            label: "Chats",
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.squarePlus, size: 35),
            label: "Make Event",
          ),
          NavigationDestination(
            selectedIcon: FaIcon(
              FontAwesomeIcons.solidCalendar,
              color: selected_color,
              size: 30,
            ),
            icon: FaIcon(FontAwesomeIcons.calendar, size: 30),
            label: "My Events",
          ),
          NavigationDestination(
            selectedIcon: FaIcon(
              FontAwesomeIcons.solidUser,
              color: selected_color,
              size: 30,
            ),
            icon: FaIcon(FontAwesomeIcons.user, size: 30),
            label: "Profile",
          ),
        ],
        height: 40.0,
        elevation: 4.0,
        labelBehavior: .alwaysHide,
        maintainBottomViewPadding: false,
      ),
      body: <Widget>[
        Padding(
          padding: MediaQuery.of(
            context,
          ).padding.copyWith(left: 20.0, right: 20.0, bottom: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning \u{1F44B}',
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  "What's happening?",
                  style: GoogleFonts.fraunces(
                    color: text_color1,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                MyTextField(
                  prefixIcon: Icons.search,
                  lines: 1,
                  hinttext: 'Search Events or Places...',
                ),
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<List<EventData>>(
                    stream: _eventService.streamAllEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Something went wrong loading events.',
                            style: TextStyle(color: text_color2),
                          ),
                        );
                      }

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      final events = snapshot.data ?? [];

                      if (events.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.calendar,
                                size: 32,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'No Events Yet',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Browse Events and Tap 'Join' to add them here",
                                style: TextStyle(color: text_color2),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: events.length,
                        separatorBuilder: (context, index) {
                          if (index == 0) {
                            return SizedBox(height: 30);
                          }
                          return SizedBox(height: 20);
                        },
                        itemBuilder: (context, index) {
                          final event = events[index];
                          final image = event.imagePath.isNotEmpty
                              ? Image.network(
                                  event.imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Image.asset(
                                  'assets/images/random.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                );

                          if (index == 0) {
                            return MyHero(
                              date: event.date,
                              eventName: event.eventName,
                              categorie: event.categorie,
                              location: event.location,
                              image: image,
                              event: event,
                            );
                          }
                          return Post(
                            categorie: event.categorie,
                            eventName: event.eventName,
                            date: event.date,
                            spotsLeft: event.spotsLeft,
                            peopleGoing: event.peopleGoing,
                            image: image,
                            event: event,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const myChats(),
        const MakeEvents(),
        const MyEvents(),
        const Myprofile(),
      ][currentPageIndex],
    );
  }
}
