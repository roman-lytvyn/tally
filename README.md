# Tally — Card Game Score Keepers

[![pipeline status](https://git.lytvyn.org/games/tally/badges/main/pipeline.svg)](https://git.lytvyn.org/games/tally/-/pipelines)
[![latest release](https://git.lytvyn.org/games/tally/-/badges/release.svg?value_width=90)](https://git.lytvyn.org/games/tally/-/releases)

Tally is a family of seven score-keeping apps for trick-taking card games:
Deberc, Belote, Bulgarian Belot, Bela, Klaverjas, Coinche and Baloot. Each game
is its own app with its own name, icon and rules, and all of them are built from
this one Flutter codebase for Android, Windows, Linux and the browser.

The games, their rules and the downloads are described for players at
[tallycards.app](https://tallycards.app). This page is for working on the code.

---

## What is in the repository

| Path | What it holds |
|---|---|
| `lib/main.dart` | App start, the selected game, moving between screens and saving the game |
| `lib/models.dart` | The game state: recorded rounds, declarations and table rules |
| `lib/game_rules.dart` | The rules of every game: players, targets, declarations and options |
| `lib/scoring.dart` | Works out scores, the dealer and the winner from the recorded rounds |
| `lib/rules_content.dart`, `lib/<game>_rules_content.dart` | The rules texts shown inside each app |
| `lib/l10n.dart` | Interface texts in all seven languages |
| `lib/theme.dart` | Light and dark themes |
| `lib/screens/` | Setup, game, win, rules, settings and about screens |
| `lib/widgets/` | The round entry panel and the traditional score sheet |
| `test/` | Unit and widget tests |
| `web/` | The page and the offline service worker of the browser version |
| `android/`, `ios/`, `macos/`, `linux/`, `windows/` | The platform projects |
| `devops/apps/` | The description of every app in the family and its own files |
| `devops/` | The pipeline and the packaging scripts for each platform |

The apps use `shared_preferences` for saved games and settings and
`url_launcher` to open the website. Only the recorded rounds are stored; scores
and the dealer are always worked out again from them.

---

## Local development

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) on the stable channel, with Dart 3.11.5 or newer
- For the platform you want to run on:
  - **Browser** — Chrome or Edge
  - **Windows** — Visual Studio with the "Desktop development with C++" workload
  - **Linux** — the [Linux desktop dependencies](https://docs.flutter.dev/platform-integration/linux/setup) (clang, cmake, ninja, GTK 3)
  - **Android** — Android Studio or the Android SDK, and a device or emulator
  - **iPhone and Mac** — a Mac with Xcode

`flutter doctor` shows what is still missing.

### Check and test

```sh
flutter pub get
flutter analyze
flutter test
```

### Run

```sh
flutter run                                # Deberc on the default device
flutter run --dart-define=GAME=belote      # another game
flutter run -d chrome --dart-define=GAME=coinche
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

`GAME` is one of `deberc`, `belote`, `belot`, `bela`, `klaverjas`, `coinche` and
`baloot`, and defaults to `deberc`. It selects the game's rules, texts and
defaults, which is enough for development.

---

## One codebase, several apps

Besides its rules, each app has an identity of its own: its name, package id,
executable and file names, icons, and the texts of its store listings, Linux menu
entry and Windows installer. It is described by `devops/apps/<app>.env`, and its
own files, such as icons, sit under `devops/apps/<app>/` in the same layout as the
repository.

```sh
dart run devops/apps/use_app.dart belote
```

writes that app's identity into the Android, iOS, macOS, Windows, Linux and web
project files
and lays its own files over the checkout. The repository holds Deberc, so switching
to Deberc changes nothing. Run it before building an installable app of another
game, and use `git checkout .` to go back.

A new game needs its entry in `lib/game_rules.dart`, its scoring in
`lib/scoring.dart`, its rules texts and translations, and a
`devops/apps/<app>.env` with its icons.

---

## Pipeline

Every merge request and every merge into `main` is analysed, tested and built by
`devops/.gitlab-ci.yml`.

The iPhone and Mac apps build on a macOS runner tagged `macos`. That machine is
not always on, so each pipeline first asks GitLab whether the runner is online
and skips the Apple builds when it is not; the Apple builds never fail or hold
up the rest of the pipeline. The check reads the runner through the
`RUNNER_CHECK_TOKEN` CI/CD variable, a project access token with the `read_api`
scope. A release made while the runner is online carries a Mac app for each
game. The apps are not signed by Apple yet, so the iPhone build is
only checked and macOS asks to allow the Mac app in System Settings the first
time it is opened.

---

## License

The source code is published under the [Apache License 2.0](LICENSE). Anyone may
use, change and redistribute it, including in commercial products, as long as
they keep the copyright notice and pass on the attribution in [NOTICE](NOTICE)
with every copy and every work built on it.

The license covers the code only. The names Tally, Deberc and the other app
names, and the apps' icons, are not licensed for use in other products.
