import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Stores simple per-user preference toggles (notifications, privacy) in
/// a single Firestore document per user, so they persist across sessions
/// instead of resetting every time the app restarts.
class UserSettingsService {
  DocumentReference? get _docRef {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('user_settings').doc(uid);
  }

  Future<Map<String, dynamic>> loadSettings() async {
    final ref = _docRef;
    if (ref == null) return {};
    final snap = await ref.get();
    if (!snap.exists) return {};
    return snap.data() as Map<String, dynamic>? ?? {};
  }

  Future<void> updateSetting(String key, bool value) async {
    final ref = _docRef;
    if (ref == null) return;
    await ref.set({key: value}, SetOptions(merge: true));
  }
}
