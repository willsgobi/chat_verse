# ChatVerse

## Description

ChatVerse is a project created for chatting with Google's AI, Gemini! However, it's possible to easily chat with any other AI that provides an API or SDK for Flutter.

## Key Features

- Seamless conversation with Google's AI, Gemini
- Capability to interact with other AIs via APIs or SDKs for Flutter

## Installation

1. Clone this repository: [https://github.com/willsgobi/chat_verse.git](https://github.com/willsgobi/chat_verse.git)
2. Run `flutter pub get`
3. It is of utmost importance that you create a .env file at the root of your project, following the structure below:

```json
{
    "GOOGLE_GEMINI_KEY": "YOUR_GOOGLE_AI_KEY"    
}
```

Once you've done that, simply run the project using the command below:

> flutter run --dart-define-from-file=.env

If you're using Visual Studio Code's debug mode (F5) to run the project, update your launch.json file with the following property:

```json
 "toolArgs": [
    "--dart-define-from-file",
    ".env"      
 ]
```

## Technologies Used

- Flutter and Dart
- Google AI SDK (Gemini)
- Bloc
- Shared Preferences

## Contribution

Contributions are welcome! If you want to contribute to ChatVerse, follow these steps:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a pull request

## License

[Add your license here]

## Contact

If you have any questions, suggestions, or just need to talk, feel free to [contact me](william_sgobi@hotmail.com).
