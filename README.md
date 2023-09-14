# Flutter Social Media App

Welcome to the Flutter Social Media App! This app allows users to sign in with their Facebook and Google accounts using Firebase Authentication. After logging in, users can view their profile details, including their name, profile photo, and email address.

## Getting Started

To get started with the app, follow these steps:

### Prerequisites

1. Make sure you have Flutter installed on your development machine. If not, you can follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

2. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/). This project will be used for authentication and storing user data.

3. Configure your app with Firebase by following the [Firebase setup instructions for Flutter](https://firebase.google.com/docs/flutter/setup).

### Integrating Facebook and Google Sign-In

To enable Facebook and Google sign-in, follow these steps:

#### Facebook Integration

1. Create a Facebook App in the [Facebook Developers Console](https://developers.facebook.com/apps).

2. Add your Facebook App ID to the Firebase project settings in the Firebase Console.

3. Follow the [Firebase Facebook authentication setup guide](https://firebase.google.com/docs/auth/flutter/facebook-login) to configure Facebook authentication.

#### Google Integration

1. Create a Google Cloud project in the [Google Cloud Console](https://console.cloud.google.com/).

2. Enable the Google Sign-In API for your project in the [Google Cloud Console](https://console.cloud.google.com/).

3. Add your OAuth 2.0 client ID to the Firebase project settings in the Firebase Console.

4. Follow the [Firebase Google authentication setup guide](https://firebase.google.com/docs/auth/flutter/google-signin) to configure Google authentication.

### Displaying User Details

After a successful login, you can retrieve and display user details such as name, photo, and email.