import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database/database.dart';

/// Firebase Firestore Sync Service
/// Syncs local Drift database with cloud Firestore for backup/multi-device sync
class FirebaseSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sync a work to Firestore
  Future<void> syncWork(Work work) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('works')
        .doc(work.id)
        .set(_workToFirestore(work));
  }

  /// Sync multiple works to Firestore (batch operation)
  Future<void> syncWorks(List<Work> works) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();

    for (final work in works) {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('works')
          .doc(work.id);
      batch.set(docRef, _workToFirestore(work));
    }

    await batch.commit();
  }

  /// Listen to user's works from Firestore (real-time sync)
  Stream<List<Map<String, dynamic>>> watchUserWorks() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('works')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList(),);
  }

  /// Delete work from Firestore
  Future<void> deleteWork(String workId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('works')
        .doc(workId)
        .delete();
  }

  /// Pull all works from Firestore (for initial sync)
  Future<List<Map<String, dynamic>>> pullAllWorks() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('works')
        .get();

    return snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();
  }

  /// Convert Work to Firestore document
  Map<String, dynamic> _workToFirestore(Work work) {
    return {
      'title': work.title,
      'author': work.author,
      'subjectTags': work.subjectTags,
      'reviewStatus': work.reviewStatus,
      'synthetic': work.synthetic,
      'primaryProvider': work.primaryProvider,
      'contributors': work.contributors,
      'googleBooksVolumeIDs': work.googleBooksVolumeIDs,
      'openLibraryWorkID': work.openLibraryWorkID,
      'createdAt': Timestamp.fromDate(work.createdAt),
      'updatedAt': Timestamp.fromDate(work.updatedAt),
    };
  }

  /// Convert Firestore document to Work companion (for Drift insert)
  WorksCompanion firestoreToWorkCompanion(Map<String, dynamic> data) {
    return WorksCompanion.insert(
      id: data['id'] as String,
      title: data['title'] as String,
      author: Value(data['author'] as String?),
      subjectTags: Value((data['subjectTags'] as List?)?.cast<String>() ?? []),
      reviewStatus: Value(ReviewStatus.values[data['reviewStatus'] as int? ?? 0]),
      synthetic: Value(data['synthetic'] as bool? ?? false),
      primaryProvider: Value(data['primaryProvider'] as String?),
      contributors: Value((data['contributors'] as List?)?.cast<String>()),
      googleBooksVolumeIDs: Value((data['googleBooksVolumeIDs'] as List?)?.cast<String>()),
      openLibraryWorkID: Value(data['openLibraryWorkID'] as String?),
      createdAt: Value((data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()),
      updatedAt: Value((data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now()),
    );
  }
}
