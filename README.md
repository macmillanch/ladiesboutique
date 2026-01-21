# Ladies Boutique App

## Overview
A completed Flutter application for a Ladies Boutique with separate Admin and User roles.

## Features
- **User App**: Professional UI, Product Browsing, Cart, Manual UPI Payment, Order Tracking (India Post), Delivery Confirmation.
- **Admin App**: Simple UI (Large Fonts), Product Management (Add/Edit), Order Management (Pack/Ship), Tracking Slip Upload.
- **Backend**: Firebase Auth, Firestore, Storage.

## Setup Instructions

1. **Firebase Setup**:
   - Create a Firebase Project.
   - Run `flutterfire configure` to generate `firebase_options.dart` (or update the mock file provided in `lib/firebase_options.dart`).
   - Enable **Authentication** (Phone & Email/Password).
   - Enable **Firestore** and **Storage**.

2. **Admin Access**:
   - To create an admin, manually add a document to the `admins` collection in Firestore:
     - Collection: `admins`
     - Document ID: `<User UID>` (e.g., `IFwYeozhpTbJdP9YJGvBqHZOtvD2`)
     - Fields:
       - `role`: `admin`
       - `email`: `(optional)`

3. **Running the App**:
   - Install dependencies: `flutter pub get`
   - Run: `flutter run`

## Folder Structure
- `lib/core`: Themes, Colors, Constants.
- `lib/data`: Models, Services (Auth, DB, Storage), Providers.
- `lib/ui`: Screens for Auth, Admin, and User.
