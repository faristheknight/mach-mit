import 'package:cloud_firestore/cloud_firestore.dart';

class EventData {
  final String id;
  final String categorie;
  final String eventName;
  final String description;
  final DateTime date;
  final int maxAttendees;
  final String imagePath; // download URL from Firebase Storage
  final String location;
  final String createdBy; // uid of the user who made the event
  final List<String> joinedUserIds;

  EventData({
    required this.id,
    required this.categorie,
    required this.eventName,
    required this.description,
    required this.date,
    required this.maxAttendees,
    required this.imagePath,
    required this.location,
    required this.createdBy,
    required this.joinedUserIds,
  });

  int get peopleGoing => joinedUserIds.length;
  int get spotsLeft => (maxAttendees - joinedUserIds.length).clamp(
    0,
    maxAttendees,
  );

  bool isJoinedBy(String? uid) => uid != null && joinedUserIds.contains(uid);

  factory EventData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventData(
      id: doc.id,
      categorie: data['categorie'] ?? '',
      eventName: data['eventName'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      maxAttendees: data['maxAttendees'] ?? 0,
      imagePath: data['imagePath'] ?? '',
      location: data['location'] ?? '',
      createdBy: data['createdBy'] ?? '',
      joinedUserIds: List<String>.from(data['joinedUserIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categorie': categorie,
      'eventName': eventName,
      'description': description,
      'date': Timestamp.fromDate(date),
      'maxAttendees': maxAttendees,
      'imagePath': imagePath,
      'location': location,
      'createdBy': createdBy,
      'joinedUserIds': joinedUserIds,
    };
  }
}
