plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.fruitsense"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.fruitsense"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    // --- TAMBAHAN PENTING: Mengatasi Konflik Kelas Duplikat ---
    configurations.all {
        resolutionStrategy {
            // Memaksa menggunakan versi tertentu jika ada konflik
            force("com.google.firebase:firebase-iid:21.1.0")
        }
        // Mengecualikan modul yang sering bikin konflik
        exclude(group = "com.google.firebase", module = "firebase-iid")
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Core Library Desugaring (Wajib)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    
    // Multidex (Wajib karena multiDexEnabled = true)
    implementation("androidx.multidex:multidex:2.0.1")

    // --- FIREBASE BOM (Bill of Materials) ---
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
    
    // Dependency Firebase (TANPA menuliskan versi, karena diatur oleh BoM)
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-messaging")
}