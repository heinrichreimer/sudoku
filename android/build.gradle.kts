allprojects {
    repositories {
        jcenter()
        google()
    }
}

rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
    project.evaluationDependsOn(":app")
}

/**
 * Task to clean the build directory.
 *
 * This might be useful when a build fails and one doesn't want the next build to depend
 * on possibly broken cached build files.
 */
val clean by tasks.registering(Delete::class) {
    delete(rootProject.buildDir)
}