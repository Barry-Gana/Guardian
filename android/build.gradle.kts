
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir = rootProject.projectDir.parentFile.resolve("build")
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    if (project.projectDir.absolutePath.startsWith(rootProject.projectDir.parentFile.absolutePath)) {
        val newSubprojectBuildDir = newBuildDir.resolve(project.name)
        project.layout.buildDirectory.set(newSubprojectBuildDir)
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
