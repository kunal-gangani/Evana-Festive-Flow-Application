# Repository Guidelines

## Project Structure & Module Organization
This repository is a Flutter application. Main app code lives in `lib/`, with startup in `lib/main.dart` and app wiring in `lib/MyApp/my_app.dart`. Feature screens are grouped under `lib/Views/` by page or flow, for example `lib/Views/HomePage/` and `lib/Views/OrganizersView/`. Shared logic sits in `lib/Controllers/`, `lib/Helpers/`, and `lib/Routes/`. Platform wrappers are in `android/`, `ios/`, `web/`, `windows/`, `linux/`, and `macos/`. Tests belong in `test/`. Keep static assets declared in `pubspec.yaml`; current splash assets are under `lib/Views/SplashScreen/Assets/`.

## Build, Test, and Development Commands
Use Flutter CLI from the repository root:

- `flutter pub get` installs Dart and Flutter dependencies.
- `flutter run` launches the app on the selected emulator or device.
- `flutter analyze` runs static analysis using `analysis_options.yaml`.
- `flutter test` runs the test suite in `test/`.
- `flutter build apk` or `flutter build web` creates production builds for Android or web.

## Coding Style & Naming Conventions
Follow the `flutter_lints` rules configured in `analysis_options.yaml`. Use 2-space indentation and keep imports package-based where practical. Match the existing structure: widget classes use `PascalCase`, files use `snake_case.dart`, and route/controller/helper files should be named for their responsibility, such as `auth_controller.dart` or `routes.dart`. Prefer small widgets and keep page-specific UI inside its feature folder.

## Testing Guidelines
The project currently uses `flutter_test`, with a minimal baseline in `test/widget_test.dart`. Add new tests beside the behavior they cover using names like `home_page_test.dart` or `auth_controller_test.dart`. Run `flutter test` before opening a PR. For UI changes, add at least one widget test when the screen logic is stable.

## Commit & Pull Request Guidelines
Recent history is sparse and not standardized (`Initial Commit`, date-based summaries). Use short, imperative commit messages going forward, for example `Add organizer QR scan flow`. Keep commits focused. PRs should include a clear description, impacted screens or modules, linked issue if available, and screenshots or screen recordings for visible UI changes.

## Configuration Notes
Firebase, Google Sign-In, and Razorpay dependencies are present in `pubspec.yaml`. Do not commit secrets, generated credentials, or environment-specific config changes without review.
