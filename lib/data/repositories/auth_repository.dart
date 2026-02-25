import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/constants/firestore_paths.dart';
import '../models/user_model.dart';

/// Auth repository — Anonim + Google Sign-In
class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Mevcut kullanıcı
  User? get currentUser => _auth.currentUser;

  /// Anonim giriş
  Future<UserCredential> signInAnonymously() async {
    final credential = await _auth.signInAnonymously();
    await _createOrUpdateUserProfile(credential.user!);
    return credential;
  }

  /// Çıkış
  Future<void> signOut() => _auth.signOut();

  /// Kullanıcı profilini Firestore'a kaydet
  Future<void> _createOrUpdateUserProfile(User user) async {
    final docRef =
        _firestore.collection(FirestorePaths.users).doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final userModel = UserModel(
        uid: user.uid,
        displayName: user.displayName ?? 'Anonim',
        email: user.email,
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      await docRef.set(userModel.toJson());
    } else {
      await docRef.update({'lastLoginAt': FieldValue.serverTimestamp()});
    }
  }
}
