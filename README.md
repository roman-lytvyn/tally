# Tally — Card Game Score Keepers

[![pipeline status](https://git.lytvyn.org/games/deberc/badges/main/pipeline.svg)](https://git.lytvyn.org/games/deberc/-/pipelines)
[![latest release](https://git.lytvyn.org/games/deberc/-/badges/release.svg?value_width=90)](https://git.lytvyn.org/games/deberc/-/releases)

Tally is a family of seven score-keeping apps for trick-taking card games of the
Jass family. Each game is its own app with its own name, icon and rules, and all
of them are built from this one Flutter codebase. The apps keep the score at the
table; they do not play the cards.

They run on Android, Windows and Linux and in the browser, at
[deberc.lytvyn.org](https://deberc.lytvyn.org), where each game has its own page,
its downloads and its rules.

---

## The Apps

| App | Players | Plays to | Declarations and outcomes it counts |
|---|---|---|---|
| **Deberc** | 2, 3 or 2 × 2 | 301, 501 or 1001 | tierce, fifty, bella, deberc, bait, eggs |
| **Belote** | 2, 3 or 2 × 2 | 500 or 1000 | tierce, fifty, hundred, four of a kind, belote, capot, dedans, litige |
| **Bulgarian Belot** | 2 × 2 | 151 game points | suit, no-trumps and all-trumps contracts, tierce, fifty, hundred, four of a kind, belot, valat, contra, recontra, inside, hanging points |
| **Bela** | 2 or 2 × 2 | 1001, 501 or 701 | tierce, fifty, hundred, four jacks, four nines, bela, štiglja, belot |
| **Klaverjas** | 2 × 2 | 1500 (Amsterdam rules) | three and four in a row, four of a kind, four jacks, stuk, pit, nat |
| **Coinche** | 2 × 2 | 2000, 1000, 1500 or 3000 | bids from 80 to 160, announcements, belote, capot, coinche, surcoinche |
| **Baloot** | 2 × 2 | 152 game points | Hokm and Sun deals, sira, fifty, hundred, four hundred, baloot, kaboot, double, three, four, gahwa |

The rules of each game are inside its app, in all seven languages, so a new
player can learn them at the table without going online. Their texts are in
`lib/rules_content.dart` and `lib/<game>_rules_content.dart`, and the scoring of
every game is described in `lib/game_rules.dart` and worked out in
`lib/scoring.dart`.

---

## How to Use

### 1. Set up a game

On the home screen, choose how many play where the game allows a choice, the
names of the teams or players, who deals first and the score to play to. A name
left blank falls back to its default. Tap **New game** to start. An unfinished
game is saved, and **Continue previous** picks it up again.

### 2. Record a deal

Tap **+ New round** on the game screen. The entry panel opens over the score and
the list of deals, which stay still behind it, and always fits the screen without
scrolling. In the panel:

1. Choose who took the trump, or set the contract and the bid in games that have them
2. Count the declarations with the large **−** and **+** buttons, or pick the value of the deal on a wheel if that is chosen in the settings
3. Enter the points of one side; the app works out the rest of the deal for the other side
4. Tap **Save**

Where the dealer does not have to play and everyone passed, the **Everyone passed —
redeal** button records the deal without points, and the next player deals. The panel warns
as soon as the entered points mean that the side that took the trump has lost the
deal, and applies the rule of the game.

### 3. Follow the game

The game screen shows the score of every team or player, how many points each
still needs, who deals now and the full list of deals with their outcomes.

### 4. Correct a mistake

- **↶** in the header removes the last deal
- Tapping a deal in the list opens it in the entry panel to change or delete it; the totals, the dealer and the winner are worked out again
- The win screen offers **Undo the last round** if the last deal ended the game by mistake

### 5. Settings

The **⚙** button opens the settings:

- **Theme** — light, dark or following the device
- **Score display** — circles and sticks as on a paper score sheet, or plain numbers
- **Deal value** — count the declarations with buttons, or pick the value on a wheel
- **Rules** — the table rules the game allows. They apply to new games; a game in progress keeps the rules it started with
- **Language** — Ukrainian, English, French, Bulgarian, Croatian, Dutch or Arabic, which is shown right to left. Until one is chosen, the app follows the device where players of the game commonly speak its language, and is in English everywhere else
- **About** — the installed version, the author, a contact address and a link to the website

---

## Saved Data

The state of a game is saved on the device after every change. Only the recorded
deals are stored; scores and the dealer are always worked out again from them, so
an edit can never leave the totals out of step. The apps have no accounts and send
no data anywhere.

---

## Development

The apps are written in [Flutter](https://flutter.dev) and use `shared_preferences`
for the saved games and settings and `url_launcher` to open the website.

```sh
flutter pub get
flutter analyze
flutter test
flutter run                              # Deberc
flutter run --dart-define=GAME=belote    # another game's rules
```

`GAME` is one of `deberc`, `belote`, `belot`, `bela`, `klaverjas`, `coinche` and
`baloot`. It selects the rules only; the steps below give a build the rest of an
app's identity.

### One codebase, several apps

An app is described by `devops/apps/<app>.env`: the game whose rules it keeps score
by, its package id, executable and file names, and its names and texts for the
store listings, the Linux menu and the Windows installer. Files of its own, such as
its icons, sit under `devops/apps/<app>/` in the same layout as the repository.

Before an app is built, `dart run devops/apps/use_app.dart <app>` writes its
identity into the Android, Windows and Linux project files and lays its own files
over the checkout. The repository itself holds Deberc, so switching to Deberc
changes nothing. Every build and publish job runs once per app listed in `.each-app`
in the pipeline, and its files are named after the app, so one tag and one release
carry every app.

### Layout

| Path | What it holds |
|---|---|
| `lib/` | The app: screens, the entry panel, scoring, rules and translations |
| `test/` | Unit and widget tests |
| `web/` | The page and the offline service worker of the browser version |
| `android/`, `ios/`, `linux/`, `windows/` | The platform projects |
| `devops/` | The pipeline, the description of every app and the packaging scripts |

---

## Delivery

Every merge into `main` analyses the code, runs the tests, builds every app for
every platform and records the version as a git tag named `YYYY.MM.BUILD`. The build
number doubles as the Android version code, so it only ever grows. Nothing is
published at that point.

Creating a release for one of those tags publishes it. A release webhook starts the
publish pipeline, which rebuilds that exact tag on each platform and attaches the
files to the release for direct download. Once they are attached, the `website` job
rebuilds [deberc.lytvyn.org](https://deberc.lytvyn.org) from the website project,
which then offers this release and goes live on its own. The website reads the
release files with its CI job token, so this project's job token allowlist includes
the website project. Once store credentials are configured, the publish pipeline
also uploads the AAB to the internal track of Google Play and the package to the
Microsoft Store, both as drafts.

### Platforms

Every release carries these files for each app, named `<app>-<version>`:

| File | Platform |
|---|---|
| `.apk` | Android, installed directly |
| `-setup.exe` | Windows installer; installs for the current user without administrator rights |
| `-windows.zip` | Windows without installation; runs from any folder |
| `.msix` | Windows package for the Microsoft Store |
| `.deb` | Debian, Ubuntu and their derivatives (amd64): `sudo apt install ./<app>-<version>.deb` |
| `-web.zip` | The browser version, to serve from any web server |

- **Browser** — the app runs as WebAssembly at `deberc.lytvyn.org/<game>/play/`. Once opened, it also works offline and can be added to the home screen, and it loads nothing from other sites.
- **Windows and Linux** — the app opens in a fixed, phone-sized window centred on the screen.
- **Windows signing** — the Windows files are not code-signed yet, so SmartScreen asks to confirm the first launch (More info → Run anyway).
- **iOS** — not built yet: it can only be built on Apple hardware, which no runner provides.

Linux, Android and browser builds run on Linux runners. Windows builds run on a
runner tagged `windows` with the Visual Studio build tools and Flutter, found on the
`PATH` or through the `FLUTTER_HOME` variable.

### Pipeline variables

`TAG_PUSH_TOKEN` is the project access token the pipeline uses to push version tags
and attach files to releases. All values below are set as CI/CD variables and none
are kept in the repository.

### Signing

Release builds use the upload key when these variables are set, and fall back to the
debug key when they are not. An APK signed with the debug key can be installed by
hand but is rejected by Google Play.

| Variable | Notes |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | the upload keystore, base64-encoded |
| `ANDROID_KEYSTORE_PASSWORD` | store password |
| `ANDROID_KEY_ALIAS` | key alias inside the keystore |
| `ANDROID_KEY_PASSWORD` | key password |

### Google Play

Uploading to Play additionally needs `GOOGLE_PLAY_SERVICE_ACCOUNT`, the JSON key of a
service account granted access in the Play Console. Without it the publish pipeline
still runs and still attaches the APK to the release; only the upload is skipped.

### Microsoft Store

The Windows package is submitted to Partner Center when the Store credentials are
set. The identity fields come from the app reserved in Partner Center, and the
submission uses an Azure AD application authorised for that account. Without these
the Windows package is still built and attached to the release; only the Store
submission is skipped.

| Variable | Notes |
|---|---|
| `MSIX_IDENTITY_NAME` | Package/Identity/Name from the reserved app |
| `MSIX_PUBLISHER` | Publisher (`CN=…`) from the reserved app |
| `MSIX_PUBLISHER_DISPLAY_NAME` | publisher display name |
| `MS_STORE_APP_ID` | the app's Store ID (product ID) |
| `MS_TENANT_ID` | Azure AD tenant of the account |
| `MS_CLIENT_ID` | Azure AD application (client) ID |
| `MS_CLIENT_SECRET` | client secret for that application |
| `MS_SELLER_ID` | Partner Center seller ID |
