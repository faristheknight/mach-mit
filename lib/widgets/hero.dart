import 'package:flutter/material.dart';
import 'package:mach_mit/constants.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/event_model.dart';
import 'package:mach_mit/screens/event_screen.dart';

class MyHero extends StatelessWidget {
  final DateTime date;
  final String eventName;
  final String location;
  final String categorie;
  final Image image;
  final EventData event;

  const MyHero({
    super.key,
    required this.date,
    required this.categorie,
    required this.eventName,
    required this.location,
    required this.image,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => EventScreen(event: event)),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(30),
          child: Stack(
            children: [
              image,
              Container(color: Colors.black.withValues(alpha: 0.2)),
              Positioned(
                left: 16.0,
                top: null,
                bottom: 16.0,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: bgcolor_categories,
                      ),
                      child: Text(
                        categorie,
                        style: TextStyle(color: text_color1, fontSize: 11),
                      ),
                    ),
                    Text(
                      eventName,
                      style: GoogleFonts.fraunces(
                        fontWeight: FontWeight.bold,
                        color: text_color1,
                        fontSize: 22,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: text_color1,
                            ),
                            SizedBox(width: 2),
                            Text(
                              DateFormat.MEd().format(date),
                              style: TextStyle(
                                color: text_color1,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: text_color1,
                            ),
                            SizedBox(width: 2),
                            Text(
                              location,
                              style: TextStyle(
                                color: text_color1,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
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
