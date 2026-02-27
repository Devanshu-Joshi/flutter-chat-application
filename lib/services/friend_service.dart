// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// FILE: lib/services/friend_service.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Canonical relationship types stored in the global relationships collection
enum RelationshipType { pending, friends }

/// Per-user relationship perspective
enum UserRelationshipType { pendingSent, pendingReceived, friends }

/// UI-friendly status including "none" and "loading"
enum FriendStatus { none, requestSent, requestReceived, friends, loading }

/// Centralized service for all friend/relationship operations.
/// All mutations use Firestore transactions to prevent race conditions.
/// All reads can be real-time via streams.
class FriendService {
  static final FriendService _instance = FriendService._internal();
  factory FriendService() => _instance;
  FriendService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── CANONICAL ID ──────────────────────────────────────────────────────
  /// Produces a deterministic, order-independent document ID for any user pair.
  /// This is the single most important function in the entire system.
  /// It guarantees that for users A and B, there is exactly ONE possible ID.
  String canonicalId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // ─── REFERENCES ────────────────────────────────────────────────────────
  DocumentReference _relationshipRef(String uid1, String uid2) {
    return _db.collection('relationships').doc(canonicalId(uid1, uid2));
  }

  DocumentReference _userRelRef(String ownerUid, String otherUid) {
    return _db
        .collection('users')
        .doc(ownerUid)
        .collection('relationships')
        .doc(otherUid);
  }

  // ─── GET STATUS (one-time) ────────────────────────────────────────────
  Future<FriendStatus> getStatus(String currentUid, String targetUid) async {
    if (currentUid == targetUid) return FriendStatus.none;

    final doc = await _userRelRef(currentUid, targetUid).get();
    if (!doc.exists) return FriendStatus.none;

    final data = doc.data() as Map<String, dynamic>;
    final type = data['type'] as String?;
    switch (type) {
      case 'friends':
        return FriendStatus.friends;
      case 'pending_sent':
        return FriendStatus.requestSent;
      case 'pending_received':
        return FriendStatus.requestReceived;
      default:
        return FriendStatus.none;
    }
  }

  // ─── STREAM STATUS (real-time) ─────────────────────────────────────────
  /// Returns a real-time stream of the relationship status between two users.
  /// The UI should listen to this instead of doing one-time reads.
  Stream<FriendStatus> statusStream(String currentUid, String targetUid) {
    if (currentUid == targetUid) {
      return Stream.value(FriendStatus.none);
    }

    return _userRelRef(currentUid, targetUid).snapshots().map((snapshot) {
      if (!snapshot.exists) return FriendStatus.none;

      final data = snapshot.data() as Map<String, dynamic>;
      final type = data['type'] as String?;
      switch (type) {
        case 'friends':
          return FriendStatus.friends;
        case 'pending_sent':
          return FriendStatus.requestSent;
        case 'pending_received':
          return FriendStatus.requestReceived;
        default:
          return FriendStatus.none;
      }
    });
  }

  // ─── SEND FRIEND REQUEST ──────────────────────────────────────────────
  /// Sends a friend request from [currentUid] to [targetUid].
  ///
  /// Uses a transaction to atomically check existing state:
  /// - If already friends → no-op, returns 'already_friends'
  /// - If current user already sent a request → no-op, returns 'already_sent'
  /// - If target already sent a request to current user → AUTO-ACCEPT,
  ///   returns 'auto_accepted'
  /// - If no relationship exists → create pending request, returns 'request_sent'
  Future<String> sendRequest(String currentUid, String targetUid) async {
    if (currentUid == targetUid) return 'cannot_self_request';

    final relRef = _relationshipRef(currentUid, targetUid);

    return _db.runTransaction<String>((transaction) async {
      final relSnap = await transaction.get(relRef);

      if (relSnap.exists) {
        final data = relSnap.data() as Map<String, dynamic>;
        final type = data['type'] as String?;
        final requestedBy = data['requestedBy'] as String?;

        if (type == 'friends') {
          return 'already_friends';
        }

        if (type == 'pending') {
          if (requestedBy == currentUid) {
            return 'already_sent';
          }

          // REVERSE REQUEST EXISTS → AUTO-ACCEPT
          // Target already sent us a request, so this is mutual — become friends
          final now = FieldValue.serverTimestamp();

          transaction.update(relRef, {
            'type': 'friends',
            'requestedBy': FieldValue.delete(),
            'updatedAt': now,
          });

          transaction.set(_userRelRef(currentUid, targetUid), {
            'type': 'friends',
            'updatedAt': now,
          });

          transaction.set(_userRelRef(targetUid, currentUid), {
            'type': 'friends',
            'updatedAt': now,
          });

          return 'auto_accepted';
        }
      }

      // No relationship exists → create pending request
      final now = FieldValue.serverTimestamp();

      transaction.set(relRef, {
        'users': [currentUid, targetUid],
        'type': 'pending',
        'requestedBy': currentUid,
        'createdAt': now,
        'updatedAt': now,
      });

      transaction.set(_userRelRef(currentUid, targetUid), {
        'type': 'pending_sent',
        'updatedAt': now,
      });

      transaction.set(_userRelRef(targetUid, currentUid), {
        'type': 'pending_received',
        'updatedAt': now,
      });

      return 'request_sent';
    });
  }

  // ─── ACCEPT FRIEND REQUEST ────────────────────────────────────────────
  /// Accepts a pending friend request from [requesterUid] to [currentUid].
  ///
  /// Uses a transaction to verify:
  /// - The relationship document exists
  /// - It is in 'pending' state
  /// - The request was sent BY the other user (not by current user)
  Future<String> acceptRequest(String currentUid, String requesterUid) async {
    final relRef = _relationshipRef(currentUid, requesterUid);

    return _db.runTransaction<String>((transaction) async {
      final relSnap = await transaction.get(relRef);

      if (!relSnap.exists) {
        return 'no_request_found';
      }

      final data = relSnap.data() as Map<String, dynamic>;
      final type = data['type'] as String?;
      final requestedBy = data['requestedBy'] as String?;

      if (type == 'friends') {
        return 'already_friends';
      }

      if (type != 'pending') {
        return 'invalid_state';
      }

      if (requestedBy == currentUid) {
        // Current user sent this request — they can't accept their own request
        return 'cannot_accept_own_request';
      }

      final now = FieldValue.serverTimestamp();

      transaction.update(relRef, {
        'type': 'friends',
        'requestedBy': FieldValue.delete(),
        'updatedAt': now,
      });

      transaction.set(_userRelRef(currentUid, requesterUid), {
        'type': 'friends',
        'updatedAt': now,
      });

      transaction.set(_userRelRef(requesterUid, currentUid), {
        'type': 'friends',
        'updatedAt': now,
      });

      return 'accepted';
    });
  }

  // ─── DECLINE FRIEND REQUEST ───────────────────────────────────────────
  /// Declines (rejects) a pending friend request from [requesterUid].
  Future<String> declineRequest(String currentUid, String requesterUid) async {
    final relRef = _relationshipRef(currentUid, requesterUid);

    return _db.runTransaction<String>((transaction) async {
      final relSnap = await transaction.get(relRef);

      if (!relSnap.exists) {
        return 'no_request_found';
      }

      final data = relSnap.data() as Map<String, dynamic>;
      final type = data['type'] as String?;
      final requestedBy = data['requestedBy'] as String?;

      if (type != 'pending') {
        return 'not_pending';
      }

      if (requestedBy == currentUid) {
        return 'cannot_decline_own_request';
      }

      transaction.delete(relRef);
      transaction.delete(_userRelRef(currentUid, requesterUid));
      transaction.delete(_userRelRef(requesterUid, currentUid));

      return 'declined';
    });
  }

  // ─── REVOKE SENT REQUEST ──────────────────────────────────────────────
  /// Revokes (cancels) a friend request that [currentUid] previously sent.
  Future<String> revokeRequest(String currentUid, String targetUid) async {
    final relRef = _relationshipRef(currentUid, targetUid);

    return _db.runTransaction<String>((transaction) async {
      final relSnap = await transaction.get(relRef);

      if (!relSnap.exists) {
        return 'no_request_found';
      }

      final data = relSnap.data() as Map<String, dynamic>;
      final type = data['type'] as String?;
      final requestedBy = data['requestedBy'] as String?;

      if (type != 'pending') {
        return 'not_pending';
      }

      if (requestedBy != currentUid) {
        // Can't revoke a request you didn't send
        return 'not_your_request';
      }

      transaction.delete(relRef);
      transaction.delete(_userRelRef(currentUid, targetUid));
      transaction.delete(_userRelRef(targetUid, currentUid));

      return 'revoked';
    });
  }

  // ─── REMOVE FRIEND ────────────────────────────────────────────────────
  /// Removes an existing friendship between [currentUid] and [friendUid].
  Future<String> removeFriend(String currentUid, String friendUid) async {
    final relRef = _relationshipRef(currentUid, friendUid);

    return _db.runTransaction<String>((transaction) async {
      final relSnap = await transaction.get(relRef);

      if (!relSnap.exists) {
        return 'not_friends';
      }

      final data = relSnap.data() as Map<String, dynamic>;
      final type = data['type'] as String?;

      if (type != 'friends') {
        return 'not_friends';
      }

      transaction.delete(relRef);
      transaction.delete(_userRelRef(currentUid, friendUid));
      transaction.delete(_userRelRef(friendUid, currentUid));

      return 'removed';
    });
  }

  // ─── QUERY: INCOMING FRIEND REQUESTS ──────────────────────────────────
  /// Returns a real-time stream of all pending friend requests received by [uid].
  Stream<List<RelationshipInfo>> incomingRequestsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('relationships')
        .where('type', isEqualTo: 'pending_received')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return RelationshipInfo(
              otherUid: doc.id,
              type: UserRelationshipType.pendingReceived,
              updatedAt: doc.data()['updatedAt'] as Timestamp?,
            );
          }).toList();
        });
  }

  // ─── QUERY: OUTGOING FRIEND REQUESTS ──────────────────────────────────
  Stream<List<RelationshipInfo>> outgoingRequestsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('relationships')
        .where('type', isEqualTo: 'pending_sent')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return RelationshipInfo(
              otherUid: doc.id,
              type: UserRelationshipType.pendingSent,
              updatedAt: doc.data()['updatedAt'] as Timestamp?,
            );
          }).toList();
        });
  }

  // ─── QUERY: FRIENDS LIST ──────────────────────────────────────────────
  Stream<List<RelationshipInfo>> friendsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('relationships')
        .where('type', isEqualTo: 'friends')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return RelationshipInfo(
              otherUid: doc.id,
              type: UserRelationshipType.friends,
              updatedAt: doc.data()['updatedAt'] as Timestamp?,
            );
          }).toList();
        });
  }

  // ─── QUERY: INCOMING REQUEST COUNT ────────────────────────────────────
  Stream<int> incomingRequestCountStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('relationships')
        .where('type', isEqualTo: 'pending_received')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // ─── BATCH STATUS CHECK ───────────────────────────────────────────────
  /// Checks relationship status for multiple targets at once.
  /// Much more efficient than checking one at a time.
  Future<Map<String, FriendStatus>> batchGetStatuses(
    String currentUid,
    List<String> targetUids,
  ) async {
    if (targetUids.isEmpty) return {};

    final results = <String, FriendStatus>{};

    // Firestore 'in' queries support max 30 values, but we're querying by doc ID
    // so we'll do individual gets in parallel
    final futures = targetUids.map((targetUid) async {
      final status = await getStatus(currentUid, targetUid);
      return MapEntry(targetUid, status);
    });

    final entries = await Future.wait(futures);
    for (final entry in entries) {
      results[entry.key] = entry.value;
    }

    return results;
  }
}

/// Data class for relationship query results
class RelationshipInfo {
  final String otherUid;
  final UserRelationshipType type;
  final Timestamp? updatedAt;

  RelationshipInfo({
    required this.otherUid,
    required this.type,
    this.updatedAt,
  });
}
