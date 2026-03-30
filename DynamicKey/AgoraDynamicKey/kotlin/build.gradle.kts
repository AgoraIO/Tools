plugins {
    kotlin("jvm") version "1.9.0"
}

group = "io.agora"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
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

tasks.register<JavaExec>("runSample") {
    mainClass.set("io.agora.sample.RtcTokenBuilder2Sample")
    classpath = sourceSets["sample"].runtimeClasspath
}
