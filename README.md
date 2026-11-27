# DhoopKart Flutter Starter

DhoopKart is an Online Dhoop Marketplace starter app.

## Included in this first build
- Customer home screen with categories and product cards
- Aayushri banner centered below categories and above Best Sellers
- Product search
- Add/remove cart items
- Checkout screen with COD selection and address validation
- Seller dashboard UI and product upload form UI
- Account page, Aayushri page and Admin panel UI

## Important status
This is a runnable Flutter UI prototype/starter, not yet a production marketplace.
Firebase is NOT connected in this version. Login, seller approval, image upload, database writes,
real order creation, delivery status, admin authorization, security rules and payments still need
implementation and testing. The checkout currently shows a demo confirmation only.

## Run
1. Install Flutter SDK and Android Studio.
2. Unzip this project.
3. In this folder run:
   ```bash
   flutter pub get
   flutter run
   ```
4. To create an Android APK after testing:
   ```bash
   flutter build apk --release
   ```

## Next development phase
- Connect the existing Firebase project using FlutterFire CLI (`flutterfire configure`).
- Add Firebase Authentication, Cloud Firestore and Firebase Storage.
- Implement customer/seller roles and admin authorization.
- Implement seller approval, product image uploads, cart persistence, COD orders and order status updates.
- Add Firestore security rules and test using separate customer, seller and admin accounts.

Do not publish this prototype as a live shopping app until the above backend and security work is complete.

## Build APK using only an Android phone (GitHub Actions)
1. Extract this ZIP on your phone.
2. In a mobile browser, create a new GitHub repository.
3. Upload the extracted project files and folders (including the hidden `.github` folder).
4. Open the repository's **Actions** tab.
5. Select **Build DhoopKart APK** and tap **Run workflow**.
6. When the run finishes, open it and download the `DhoopKart-release-apk` artifact.
7. Extract the downloaded artifact ZIP; install `app-release.apk` on your Android phone.

The build runs on GitHub's cloud runner; Flutter does not need to be installed on your phone.
