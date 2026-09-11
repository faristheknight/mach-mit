import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/event_model.dart';
import 'package:mach_mit/event_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mach_mit/widgets/post.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEvents();
}

class _MyEvents extends State<MyEvents> with SingleTickerProviderStateMixin {
  final EventService _eventService = EventService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _emptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.calendar, size: 32, color: Colors.white),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: text_color2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventList(List<EventData> events) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 20),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final image = event.imagePath.isNotEmpty
            ? Image.network(event.imagePath, fit: BoxFit.cover)
            : Image.asset('assets/images/random.jpg');

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(
          context,
        ).padding.copyWith(left: 20.0, right: 20.0, bottom: 16.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'My Events',
                style: GoogleFonts.fraunces(
                  color: text_color1,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                indicatorColor: selected_color,
                labelColor: text_color1,
                unselectedLabelColor: text_color2,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Going'),
                  Tab(text: 'Hosting'),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    StreamBuilder<List<EventData>>(
                      stream: _eventService.streamJoinedEvents(),
                      builder: (context, snapshot) {
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
                          return _emptyState(
                            'No Events Yet',
                            "Browse events and tap 'Join' to add them here",
                          );
                        }
                        return _eventList(events);
                      },
                    ),
                    StreamBuilder<List<EventData>>(
                      stream: _eventService.streamCreatedEvents(),
                      builder: (context, snapshot) {
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
                          return _emptyState(
                            "You Haven't Hosted Anything Yet",
                            "Events you create will show up here",
                          );
                        }
                        return _eventList(events);
                      },
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
