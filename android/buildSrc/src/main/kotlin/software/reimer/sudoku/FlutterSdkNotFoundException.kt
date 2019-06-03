package software.reimer.sudoku

import org.gradle.api.GradleException

object FlutterSdkNotFoundException : GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")