plugins {
    kotlin("jvm") version "1.9.0"
    jacoco
}

group = "io.agora"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation("junit:junit:4.13.2")
}

kotlin {
    jvmToolchain(8)
}

sourceSets {
    main {
        kotlin.setSrcDirs(listOf("src/main/kotlin"))
    }
    test {
        kotlin.setSrcDirs(listOf("src/test/kotlin"))
    }
    create("sample") {
        kotlin.setSrcDirs(listOf("src/sample/kotlin"))
        compileClasspath += sourceSets.main.get().output + sourceSets.test.get().compileClasspath
        runtimeClasspath += sourceSets.main.get().output + sourceSets.test.get().runtimeClasspath
    }
}

val sampleJar = task<Jar>("sampleJar") {
    archiveClassifier.set("sample")
    from(sourceSets["sample"].allSource)
}

val sampleMainClasses = listOf(
    "io.agora.sample.RtcTokenBuilder2Sample",
    "io.agora.sample.RtmTokenBuilder2Sample",
    "io.agora.sample.ChatTokenBuilder2Sample",
    "io.agora.sample.ApaasTokenBuilderSample",
    "io.agora.sample.EducationTokenBuilder2Sample",
    "io.agora.sample.FpaTokenBuilderSample"
)

val sampleTasks = sampleMainClasses.map { sampleMainClass ->
    val sampleName = sampleMainClass.substringAfterLast('.')
    tasks.register<JavaExec>("run$sampleName") {
        dependsOn(tasks.named("sampleClasses"))
        mainClass.set(sampleMainClass)
        classpath = sourceSets["sample"].runtimeClasspath
    }
}

tasks.register("runSample") {
    dependsOn(sampleTasks)
}

jacoco {
    toolVersion = "0.8.12"
}

tasks.test {
    finalizedBy(tasks.jacocoTestReport)
}

tasks.jacocoTestReport {
    dependsOn(tasks.test)
    reports {
        csv.required.set(true)
        html.required.set(false)
        xml.required.set(false)
    }
}
