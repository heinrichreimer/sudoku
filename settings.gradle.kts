include(":framework")
include(":android")

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
