import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mach_mit/event_model.dart';

/// Central place for every read/write that touches events. Screens call
/// these methods instead of talking to Firestore/Storage directly, so if
/// you ever need to change how data is structured, you only change it here.
class EventService {
  final CollectionReference _eventsRef = FirebaseFirestore.instance
      .collection('events');

  /// Live stream of all events, soonest first. Home screen listens to this.
  Stream<List<EventData>> streamAllEvents() {
    return _eventsRef
        .orderBy('date')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => EventData.fromFirestore(doc)).toList(),
        );
  }

  /// Live stream of only the events the current user has joined.
  Stream<List<EventData>> streamJoinedEvents() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _eventsRef
        .where('joinedUserIds', arrayContains: uid)
        .orderBy('date')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => EventData.fromFirestore(doc)).toList(),
        );
  }

  /// Live stream of events the current user created themselves.
  Stream<List<EventData>> streamCreatedEvents() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _eventsRef
        .where('createdBy', isEqualTo: uid)
        .orderBy('date')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => EventData.fromFirestore(doc)).toList(),
        );
  }

  /// Uploads an event image to Firebase Storage and returns its download URL.
  Future<String> uploadEventImage(File imageFile, String eventId) async {
    final ref = FirebaseStorage.instance.ref().child(
      'event_images/$eventId.jpg',
    );
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  /// Creates a new event. Pass the image file separately since the event
  /// needs an id before the image can be uploaded to a matching path.
  Future<void> createEvent({
    required String categorie,
    required String eventName,
    required String description,
    required DateTime date,
    required int maxAttendees,
    required String location,
    File? imageFile,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('You must be signed in to post an event');

    final docRef = _eventsRef.doc(); // generates the id up front

    String imagePath = '';
    if (imageFile != null) {
      imagePath = await uploadEventImage(imageFile, docRef.id);
    }

    final event = EventData(
      id: docRef.id,
      categorie: categorie,
      eventName: eventName,
      description: description,
      date: date,
      maxAttendees: maxAttendees,
      imagePath: imagePath,
      location: location,
      createdBy: uid,
      joinedUserIds: [],
    );

    await docRef.set(event.toFirestore());
  }

  /// Adds the current user to an event's attendee list.
  Future<void> joinEvent(String eventId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('You must be signed in to join');

    await _eventsRef.doc(eventId).update({
      'joinedUserIds': FieldValue.arrayUnion([uid]),
    });
  }

  /// Removes the current user from an event's attendee list.
  Future<void> leaveEvent(String eventId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('You must be signed in');

    await _eventsRef.doc(eventId).update({
      'joinedUserIds': FieldValue.arrayRemove([uid]),
    });
  }

  /// Only the event's creator can delete it. Firestore security rules
  /// enforce this too, so this check is really just for a fast, friendly
  /// error message before the request even leaves the device.
  Future<void> deleteEvent(String eventId, String createdBy) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != createdBy) {
      throw Exception('Only the event creator can delete this event');
    }
    await _eventsRef.doc(eventId).delete();
  }
}
