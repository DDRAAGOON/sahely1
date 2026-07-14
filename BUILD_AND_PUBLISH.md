# Building & publishing Sahely

One Flutter codebase → a native **iOS** app (App Store) and **Android** app (Play
Store). The Dart in `lib/` is shared; only the signing/upload steps differ per store.

App identity (change before first publish if you want your own domain):
- **Bundle ID / applicationId:** `com.sahely.sahely`
- **Display name:** Sahely
- **Icons:** generated from `assets/icon/app_icon.png` via `flutter_launcher_icons`
  (navy background, gold logo). To regenerate after changing the source image:
  `dart run flutter_launcher_icons`.

## 0. Prerequisites

```bash
flutter pub get
flutter doctor      # resolve any ✗ before building
```

- **Android build:** Android SDK (via Android Studio) + JDK 17.
- **iOS build:** a **Mac** with **Xcode** + an **Apple Developer account** ($99/yr).
  iOS apps can only be compiled & signed on macOS — there is no way around this on
  Windows/Linux.

---

## 1. Android → Google Play

### Create a release signing key (once, keep it safe & backed up)
```bash
keytool -genkey -v -keystore ~/sahely-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Create `android/key.properties` (do **not** commit it):
```
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=/absolute/path/to/sahely-upload.jks
```
Then wire it into `android/app/build.gradle` (`signingConfigs.release` reading
`key.properties`) — see Flutter's "Sign the app" guide. (Losing this key means you
can't update the app, so back it up; or use Play App Signing and upload an `.aab`.)

### Build the Play Store bundle
For production, always enable code obfuscation and debug info splitting to protect our business logic:
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
# output: build/app/outputs/bundle/release/app-release.aab
```
For local testing on a device instead:
```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols        # build/app/outputs/flutter-apk/app-release.apk
```

### Upload
1. Google Play Console → Developer account ($25 one-time).
2. Create app → upload `app-release.aab` to a track (internal → closed → production).
3. Fill store listing, content rating, data-safety, privacy policy, then submit.

---

## 2. iOS → App Store (on a Mac)

For production, always enable code obfuscation and debug info splitting to protect our business logic:
```bash
flutter build ipa --release --obfuscate --split-debug-info=build/ios/symbols
# or open the Xcode workspace and Archive from there:
open ios/Runner.xcworkspace
```

In Xcode:
1. Signing & Capabilities → select your Team (Apple Developer account); Xcode
   manages the provisioning profile for bundle ID `com.sahely.sahely`.
2. Set the version/build number (also in `pubspec.yaml: version:`).
3. Product → Archive → Distribute App → App Store Connect → Upload.
4. In App Store Connect: create the app record, attach the build, fill metadata,
   screenshots, privacy details, then submit for review.

`flutter build ipa` produces `build/ios/ipa/*.ipa` which you can upload via Xcode's
Organizer or `xcrun altool` / Transporter.

---

## 3. Versioning

Bump the shared version in `pubspec.yaml`:
```
version: 1.0.0+1     # <marketing version>+<build number>
```
`1.0.0` → CFBundleShortVersionString / versionName; `+1` → build / versionCode.

## 4. Before store submission — checklist
- [ ] Replace the live Unsplash image URLs in `lib/data/sample_data.dart` and the
      screen files with the client's licensed Marassi / North-Coast photography
      (Unsplash CDN links need internet and aren't a licensing basis for production).
- [ ] Point the mocked flows (OTP, payments, payouts, smart-lock passcode, AL MAWSEM
      points) at real backend services.
- [ ] Add a privacy policy URL (both stores require one).
- [ ] Provide store screenshots (you can capture them from `flutter run`).
