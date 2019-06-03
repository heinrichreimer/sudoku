import software.reimer.sudoku.FlutterSdkNotFoundException
import java.util.*

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

val flutterRoot = localProperties.getProperty("flutter.sdk") ?: throw FlutterSdkNotFoundException

var flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
var flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

plugins {
    id("com.android.application").version(Versions.androidBuildTools)
    kotlin("android").version(Versions.kotlin)
}

apply {
    from("$flutterRoot/packages/flutter_tools/gradle/flutter.gradle")
}

android {
    compileSdkVersion(28)

    lintOptions {
        disable("InvalidPackage")
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "software.reimer.sudoku"
        minSdkVersion(16)
        targetSdkVersion(28)
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        testInstrumentationRunner = "android.support.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        getByName("release") {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            //signingConfig = signingConfigs.debug
        }
    }
}

extensions.configure("flutter") {
    withGroovyBuilder {
        "source"("../..")
    }
}
//flutter {
//    source = "../.."
//}

dependencies {
    implementation(kotlin("stdlib-jdk7", Versions.kotlin))
    testImplementation("junit:junit:4.12")
    androidTestImplementation("com.android.support.test:runner:1.0.2")
    androidTestImplementation("com.android.support.test.espresso:espresso-core:3.0.2")
}

val copyDebugApk by tasks.registering(Copy::class) {
    val apkDir = buildDir.resolve("outputs/apk")
    from(apkDir.resolve("debug/app-debug.apk"))
    into(apkDir)
}

tasks.named("build") {
    dependsOn(copyDebugApk)
}
