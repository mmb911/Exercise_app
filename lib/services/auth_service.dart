import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _logger = Logger();

  // Get auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Convert Firebase User to UserModel
  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  // Get current user model
  UserModel? get currentUserModel => _userFromFirebase(currentUser);

  // Sign up with email and password
  Future<UserModel?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('User signed up successfully: ${credential.user?.email}');
      return _userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign up error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      _logger.e('Sign up error: $e');
      throw 'An error occurred during sign up';
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('User signed in successfully: ${credential.user?.email}');
      return _userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign in error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      _logger.e('Sign in error: $e');
      throw 'An error occurred during sign in';
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _logger.i('Google sign in cancelled by user');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      _logger.i('User signed in with Google: ${userCredential.user?.email}');
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      _logger.e('Google sign in error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      _logger.e('Google sign in error: $e');

      // Check for specific developer error (ApiException: 10)
      if (e.toString().contains('ApiException: 10')) {
        throw 'Google Sign-In configuration error. Please ensure SHA-1 fingerprint is added to Firebase Console.';
      }

      throw 'An error occurred during Google sign in. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      _logger.i('User signed out successfully');
    } catch (e) {
      _logger.e('Sign out error: $e');
      throw 'An error occurred during sign out';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak';
      case 'email-already-in-use':
        return 'An account already exists for this email';
      case 'user-not-found':
        return 'No user found for this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'invalid-email':
        return 'The email address is not valid';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }
}
