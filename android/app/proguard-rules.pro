# Prevent R8 from stripping out BackEvent class
-keep class android.window.** { *; }
-dontwarn android.window.**

# Keep Flutter InAppWebView-related classes
-keep class com.pichillilorenzo.** { *; }
-dontwarn com.pichillilorenzo.**
