# flutter-android-ci

Base container image for Android/Flutter CI workflows, with all tool versions defined and built directly in this repository.

## Included toolchain

- Ubuntu 24.04
- OpenJDK 21
- Flutter 3.44.2
- Android SDK platform 36
- Android Build Tools 36.0.0
- Android command-line tools 13114758
- Ruby + Bundler

## Build the image

```bash
docker build -t flutter-android-ci:3.44.2 .
```

## Use with your project

Linux/macOS:

```bash
docker run --rm -it \
  -v "$(pwd):/workspace" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  flutter-android-ci:3.44.2 \
  bash
```

Windows PowerShell:

```powershell
docker run --rm -it `
  -v "${PWD}:/workspace" `
  -v "$HOME\.ssh:/root/.ssh:ro" `
  flutter-android-ci:3.44.2 `
  bash
```

Inside the container:

```bash
flutter pub get
flutter test
flutter build apk --release
```

If the project needs private git dependencies, mount SSH keys as shown above so `flutter pub get` can access private repositories.

## Notes for CI

- Default working directory is `/workspace`.
- The image accepts Android SDK licenses during build.
- The image does not install Android NDK by default.
- `flutter`, `dart`, `java`, `sdkmanager`, `adb`, `ruby`, `gem`, and `bundle` are available in `PATH`.

## Docker Hub publish

A GitHub Actions workflow is available at `.github/workflows/dockerhub.yml`.

Required repository secrets:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

Publish behavior:

- Push to `main`: publishes `latest` and the `FLUTTER_VERSION` from `Dockerfile`
- Manual execution: available through `workflow_dispatch`
