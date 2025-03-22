// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter_firebase_2/auth/repo/auth_method.dart';

// // class FacebookAuth extends AuthMethod {
// //   @override
// //   Future<void> authenticate() async {
// //     // Trigger the sign-in flow
// //   final LoginResult loginResult = await FacebookAuth.instance.login();

// //   // Create a credential from the access token
// //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);

// //   // Once signed in, return the UserCredential
// //    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// //   }

// // }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_firebase_2/auth/repo/auth_method.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// class FacebookAuth implements AuthMethod {
//   @override
//   Future<void> authenticate() async {
//     try {
//       // Start the Facebook login process
//       final LoginResult loginResult = await FacebookAuth.instance.login(
//         permissions: ['email', 'public_profile'], // Requested permissions
//       );

//       // Check the login status
//       if (loginResult.status == LoginStatus.success) {
//         // Get the access token
//         final AccessToken? accessToken = loginResult.accessToken;
//         if (accessToken == null) {
//           throw Exception("Failed to obtain access token from Facebook.");
//         }

//         // Create Firebase credential using the access token
//         final OAuthCredential facebookAuthCredential =
//             FacebookAuthProvider.credential(accessToken.token);

//         // Sign in to Firebase with the credential
//         await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//       } else if (loginResult.status == LoginStatus.cancelled) {
//         throw Exception("Facebook login was canceled by the user.");
//       } else {
//         throw Exception("Facebook login failed: ${loginResult.message}");
//       }
//     } catch (e) {
//       // Rethrow the exception to be handled by BaseAuthCubit
//       rethrow;
//     }
//   }
// }