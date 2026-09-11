import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mach_mit/constants.dart';
import 'package:mach_mit/event_model.dart';
import 'package:mach_mit/event_service.dart';

class EventScreen extends StatefulWidget {
  final EventData event;

  const EventScreen({super.key, required this.event});

  @override
  State<EventScreen> createState() => _EventScreen();
}

class _EventScreen extends State<EventScreen> {
  final EventService _eventService = EventService();
  bool _isProcessing = false;

  Future<void> _toggleJoin(bool alreadyJoined) async {
    setState(() => _isProcessing = true);
    try {
      if (alreadyJoined) {
        await _eventService.leaveEvent(widget.event.id);
      } else {
        await _eventService.joinEvent(widget.event.id);
      }
      // No manual state update needed here — the StreamBuilder below is
      // listening live to this exact event document, so as soon as
      // Firestore confirms the write, the UI rebuilds itself automatically.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _confirmDelete(EventData event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: card_backgroud_color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete this event?',
          style: TextStyle(color: text_color1, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This removes the event for everyone who joined. This can\'t be undone.',
          style: TextStyle(color: text_color2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel', style: TextStyle(color: text_color2)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _eventService.deleteEvent(event.id, event.createdBy);
      if (!mounted) return;
      Navigator.pop(context); // leave the event screen, it no longer exists
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete this event.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .snapshots(),
      builder: (context, snapshot) {
        // Use the freshest data available: live Firestore data once it
        // arrives, falling back to the snapshot passed in from the feed
        // for the very first frame before the stream has responded yet.
        final event = snapshot.hasData && snapshot.data!.exists
            ? EventData.fromFirestore(snapshot.data!)
            : widget.event;

        final uid = FirebaseAuth.instance.currentUser?.uid;
        final alreadyJoined = event.isJoinedBy(uid);
        final isFull = event.spotsLeft <= 0;

        return _buildScaffold(context, event, alreadyJoined, isFull);
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    EventData event,
    bool alreadyJoined,
    bool isFull,
  ) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: event.imagePath.isNotEmpty
                      ? Image.network(event.imagePath, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/images/random.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  bottom: 10,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: bgcolor_categories,
                    ),
                    child: Text(
                      event.categorie,
                      style: TextStyle(fontSize: 11, color: text_color1),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 30),
                    color: text_color1,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                if (event.createdBy ==
                    FirebaseAuth.instance.currentUser?.uid)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, size: 26),
                      color: text_color1,
                      onPressed: () => _confirmDelete(event),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.eventName,
                      style: GoogleFonts.fraunces(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: text_color1,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        color: card_backgroud_color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: selected_color,
                                  size: 20,
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'When',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMMMEd().add_jm().format(
                                        event.date,
                                      ),
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: selected_color,
                                  size: 20,
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Where',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      event.location,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outlined,
                                  color: selected_color,
                                  size: 20,
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Spots',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${event.peopleGoing}/${event.maxAttendees} going',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'About',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      event.description.isNotEmpty
                          ? event.description
                          : 'No description provided.',
                      style: GoogleFonts.plusJakartaSans(
                        color: text_color1,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (_isProcessing || (isFull && !alreadyJoined))
                      ? null
                      : () => _toggleJoin(alreadyJoined),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54,
                    width: (MediaQuery.of(context).size.width - 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: alreadyJoined
                          ? searchbar_color
                          : (isFull ? Colors.grey : selected_color),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                alreadyJoined
                                    ? "You're going \u00b7 Leave"
                                    : (isFull ? 'Event full' : 'Join Event'),
                                style: GoogleFonts.roboto(
                                  color: text_color1,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                        if (!alreadyJoined && !isFull) ...[
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: text_color2,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
