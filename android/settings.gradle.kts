import java.util.*

include(":app", ":framework")

val flutterProjectRoot: File = rootProject.projectDir.parentFile

val plugins = Properties()
val pluginsFile = flutterProjectRoot.resolve(".flutter-plugins")
if (pluginsFile.exists()) {
    pluginsFile.reader(Charsets.UTF_8).use { reader -> plugins.load(reader) }
}

plugins.forEach { name, path ->
    val pluginDirectory = flutterProjectRoot.resolve(path.toString()).resolve("android")
    include(":$name")
    project(":$name").projectDir = pluginDirectory
}


pluginManagement {
    /**
     * Repositories for resolving plugins.
     */
    repositories {
        gradlePluginPortal()
        google()
    }
    resolutionStrategy {
        eachPlugin {
            val module = when(requested.id.id) {
                "com.android.application" -> "com.android.tools.build:gradle:${requested.version}"
                else -> null
            }
            if (module != null) {
                logger.debug("Use module '$module' for requested plugin '${requested.id}' (version ${requested.version}).")
                useModule(module)
            }
        }
    }
}