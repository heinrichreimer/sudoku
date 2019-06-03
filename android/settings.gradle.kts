import java.util.*

include(":app", ":framework")

// Load and include Flutter plugins.
val flutterProjectRoot: File = rootProject.projectDir.parentFile
Properties()
        .apply {
            flutterProjectRoot
                    .resolve(".flutter-plugins")
                    .takeIf(File::exists)
                    ?.reader(Charsets.UTF_8)
                    ?.use(::load)
        }
        .forEach { name, path ->
            include(":$name")
            val pluginDirectory = flutterProjectRoot.resolve(path.toString()).resolve("android")
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
            val module = when (requested.id.id) {
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
