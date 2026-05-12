allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")

    plugins.withId("com.android.library") {
        val android = extensions.findByName("android")
        if (android != null) {
            try {
                val method =
                    android.javaClass.getMethod("setNamespace", String::class.java)
                method.invoke(android, "com.tflite_flutter.fix")
            } catch (e: Exception) {
                // Đã có namespace thì bỏ qua
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}