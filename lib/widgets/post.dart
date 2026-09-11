import 'package:mach_mit/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/event_model.dart';
import 'package:mach_mit/screens/event_screen.dart';

class Post extends StatelessWidget {
  final String categorie;
  final String eventName;
  final DateTime date;
  final int spotsLeft;
  final int peopleGoing;
  final Image image;
  final EventData event;

  const Post({
    super.key,
    required this.categorie,
    required this.eventName,
    required this.date,
    required this.spotsLeft,
    required this.peopleGoing,
    required this.image,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: null,
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => EventScreen(event: event)),
        );
      },
      child: SizedBox(
        height: 140,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 4.0,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: card_backgroud_color,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(width: 100, height: 100, child: image),
                ),
              ),
              Column(
                mainAxisAlignment: .center,
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
                      style: TextStyle(color: text_color1, fontSize: 11),
                      categorie,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    eventName,
                    style: GoogleFonts.fraunces(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: text_color1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        DateFormat.yMEd().format(date),
                        style: TextStyle(color: text_color2, fontSize: 12),
                      ),
                      SizedBox(width: 20),
                      Text(
                        '$spotsLeft Spots left',
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    '$peopleGoing people are joining',
                    style: TextStyle(fontSize: 12, color: text_color2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
