import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:trendy/services/api_service.dart';
import 'package:logger/logger.dart';

class SocialAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger();

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Send user data to backend
      if (userCredential.user != null) {
        await ApiService.registerSocialUser(
          userCredential.user!.uid,
          userCredential.user!.displayName ?? 'Google User',
          userCredential.user!.email ?? '',
          'google',
          googleAuth.accessToken ?? '',
        );
      }

      return userCredential.user;
    } catch (e) {
      _logger.e('Google Sign In Error: $e');
      return null;
    }
  }

  // Facebook Sign In
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final AuthCredential credential = FacebookAuthProvider.credential(
          accessToken.toString(),
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        // Get user profile data
        final Map<String, dynamic> userData = await FacebookAuth.instance
            .getUserData();

        // Send user data to backend
        if (userCredential.user != null) {
          await ApiService.registerSocialUser(
            userCredential.user!.uid,
            userData['name'] ?? 'Facebook User',
            userData['email'] ?? '',
            'facebook',
            accessToken.toString(),
          );
        }

        return userCredential.user;
      }
      return null;
    } catch (e) {
      _logger.e('Facebook Sign In Error: $e');
      return null;
    }
  }

  // Apple Sign In
  Future<User?> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID result =
          await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: result.identityToken,
        accessToken: result.authorizationCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        oauthCredential,
      );

      // Send user data to backend
      if (userCredential.user != null) {
        await ApiService.registerSocialUser(
          userCredential.user!.uid,
          '${result.givenName ?? ''} ${result.familyName ?? ''}'
                  .trim()
                  .isNotEmpty
              ? '${result.givenName ?? ''} ${result.familyName ?? ''}'.trim()
              : 'Apple User',
          result.email ?? '',
          'apple',
          result.identityToken ?? '',
        );
      }

      return userCredential.user;
    } catch (e) {
      _logger.e('Apple Sign In Error: $e');
      return null;
    }
  }

  // Sign out from all social providers
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }

  // Check if user is signed in with social provider
  Future<bool> isSocialUser() async {
    final User? user = _auth.currentUser;
    if (user == null) return false;

    final providerData = user.providerData;
    return providerData.any(
      (provider) =>
          provider.providerId.contains('google') ||
          provider.providerId.contains('facebook') ||
          provider.providerId.contains('apple'),
    );
  }

  // Get current social provider
  Future<String?> getSocialProvider() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final providerData = user.providerData;
    for (final provider in providerData) {
      if (provider.providerId.contains('google')) return 'google';
      if (provider.providerId.contains('facebook')) return 'facebook';
      if (provider.providerId.contains('apple')) return 'apple';
    }
    return null;
  }
}
