# Baba Mlezi v1.0 Beta

Bilingual Flutter MVP for parenting and education guidance for families with children aged 0–18.

## Included
- Kiswahili / English switch
- Home and age groups: 0–2, 3–5, 6–12, 13–18
- Parenting topic cards and starter library
- Baba Mlezi AI chat UI
- Safe AI demo mode when no backend is configured
- Material 3 UI and Baba Mlezi branding

## Prepare Android platform (first time only)
Install Flutter, then from this folder run:

    flutter create --org com.babamlezi --platforms=android .
    flutter pub get
    flutter run

`flutter create` generates the standard Android build files while preserving this app source.

## Connect Baba Mlezi AI securely
Do NOT put an OpenAI API key in the Flutter app. Deploy a server endpoint that accepts JSON:

    {"message":"...", "language":"sw"}

and returns:

    {"answer":"..."}

Then run/build with:

    flutter run --dart-define=BABA_MLEZI_AI_URL=https://YOUR-BACKEND/api/chat

## Build APK

    flutter build apk --release --dart-define=BABA_MLEZI_AI_URL=https://YOUR-BACKEND/api/chat

APK output:

    build/app/outputs/flutter-apk/app-release.apk

## Safety
Baba Mlezi AI should provide general parenting/education guidance, avoid diagnosis, and escalate urgent health or safety concerns to qualified local services.
