import 'package:firebase_auth/firebase_auth.dart';
import 'package:madunia_admin/core/utils/errors/failure.dart';

class FirebaseFailure extends Failure {
  FirebaseFailure(super.message);

  /// Factory constructor to handle FirebaseAuth exceptions
  factory FirebaseFailure.fromFirebaseAuthException(
    FirebaseAuthException exception,
  ) {
    switch (exception.code) {
      case 'invalid-email':
        return FirebaseFailure('The email address is not valid.');
      case 'user-disabled':
        return FirebaseFailure('This user has been disabled.');
      case 'user-not-found':
        return FirebaseFailure('No user found for this email.');
      case 'wrong-password':
        return FirebaseFailure('Incorrect password.');
      case 'email-already-in-use':
        return FirebaseFailure('This email is already in use.');
      case 'weak-password':
        return FirebaseFailure('The password is too weak.');
      case 'operation-not-allowed':
        return FirebaseFailure('This sign-in method is not allowed.');
      case 'too-many-requests':
        return FirebaseFailure('Too many attempts. Please try again later.');
      default:
        return FirebaseFailure('Authentication error: ${exception.message}');
    }
  }

  /// Factory constructor to handle Firestore exceptions
  factory FirebaseFailure.fromFirestoreException(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return FirebaseFailure('Permission denied.');
      case 'unavailable':
        return FirebaseFailure('Service unavailable. Please try again later.');
      case 'not-found':
        return FirebaseFailure('Document not found.');
      case 'already-exists':
        return FirebaseFailure('Document already exists.');
      case 'resource-exhausted':
        return FirebaseFailure('Quota exceeded.');
      default:
        return FirebaseFailure('Firestore error: ${exception.message}');
    }
  }

  /// Generic handler (optional fallback)
  factory FirebaseFailure.fromException(Exception exception) {
    if (exception is FirebaseAuthException) {
      return FirebaseFailure.fromFirebaseAuthException(exception);
    } else if (exception is FirebaseException) {
      return FirebaseFailure.fromFirestoreException(exception);
    } else {
      return FirebaseFailure('An unknown Firebase error occurred.');
    }
  }
}
