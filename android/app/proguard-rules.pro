-keep class androidx.annotation.Keep
-keep @androidx.annotation.Keep class * { *; }

-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

-keep class org.json.** { *; }
-dontwarn org.json.**
