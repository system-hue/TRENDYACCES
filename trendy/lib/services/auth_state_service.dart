import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthStateService extends ChangeNotifier {
  static final AuthStateService _instance = AuthStateService._internal();
  factory AuthStateService() => _instance;
  AuthStateService._internal();

  User? _currentUser;
  bool _isSigningIn = false;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;
  bool get isSigningIn => _isSigningIn;
  bool get isInitialized => _isInitialized;

  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _currentUser = user;
      _isInitialized = true;
      notifyListeners();
    });
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    if (_isSigningIn) return false;
    
    _isSigningIn = true;
    notifyListeners();
    
    try {
      // Check if user is already signed in
      if (_currentUser != null) {
        debugPrint('User already signed in: ${_currentUser?.email}');
        return true;
      }
      
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _currentUser = result.user;
      return _currentUser != null;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return false;
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    if (_isSigningIn) return false;
    
    _isSigningIn = true;
    notifyListeners();
    
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _currentUser = result.user;
      return _currentUser != null;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return false;
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> reloadUser() async {
    if (_currentUser != null) {
      await _currentUser!.reload();
      _currentUser = FirebaseAuth.instance.currentUser;
      notifyListeners();
    }
  }
}
