import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// 🔐 تحميل بيانات keystore (المسار الصح 100%)
val keystoreProperties = Properties()
val keystorePropertiesFile = file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    throw GradleException("❌ key.properties file not found")
}


android {
    namespace = "com.hussein.studentlifemanager"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.hussein.studentlifemanager"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {

            val keyAliasProp = keystoreProperties.getProperty("keyAlias")
            val keyPasswordProp = keystoreProperties.getProperty("keyPassword")
            val storeFileProp = keystoreProperties.getProperty("storeFile")
            val storePasswordProp = keystoreProperties.getProperty("storePassword")

            if (
                keyAliasProp.isNullOrBlank() ||
                keyPasswordProp.isNullOrBlank() ||
                storeFileProp.isNullOrBlank() ||
                storePasswordProp.isNullOrBlank()
            ) {
                throw GradleException("❌ key.properties is missing required values")
            }

            keyAlias = keyAliasProp
            keyPassword = keyPasswordProp
            storeFile = file(storeFileProp)
            storePassword = storePasswordProp
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
