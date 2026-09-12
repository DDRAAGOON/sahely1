# Sahely release shrinking rules.
#
# The Flutter Gradle plugin already contributes the engine rules; these cover
# the plugins this app uses whose classes are reached reflectively.

# Flutter embedding
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-dontwarn com.google.android.gms.**

# flutter_secure_storage relies on the AndroidX security/crypto providers
-keep class androidx.security.crypto.** { *; }

# Keep annotations used for reflective JSON handling
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod

# Strip verbose logging from release builds
-assumenosideeffects class android.util.Log {
    public static *** v(...);
    public static *** d(...);
}
