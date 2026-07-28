# Deberc — Score Tracker

[![pipeline status](https://git.lytvyn.org/games/deberc/badges/main/pipeline.svg)](https://git.lytvyn.org/games/deberc/-/pipelines)
[![latest release](https://git.lytvyn.org/games/deberc/-/badges/release.svg?value_width=90)](https://git.lytvyn.org/games/deberc/-/releases)

A Flutter mobile app for tracking scores in Deberc, a traditional Ukrainian card game.

---

## About the Game

**Deberc** is a trick-taking card game for four players split into two teams of two. It is played with a **32-card deck** (7s through Aces — 6s are not used). Each round, one team acts as the **dealers**: they name the trump suit and are obligated to score more points than their opponents.

The goal is to be the first team to reach **501** or **1001** points (chosen before the game starts).

---

## Scoring System

### Game Value (GV)

Every round has a **Game Value (GV)** — the total number of points that can be won in that round. It depends on the trump suit and any declared combinations (belote, tierce, quart, etc.) and ranges from **162 to 512 points**.

The base GV with no combinations is **162 points**. Each declared combination adds to the pool. The scores of both teams in a round always sum to the GV.

### Regular Round

The dealing team must score **more points** than their opponents. If they succeed, each team keeps what they earned. The first team to reach the point limit wins the game.

### Special Situations

#### FELL (УПАВ)

If the dealers score **equal to or less than** their opponents, they *fall*. Their points are forfeited and the opponents receive the **full GV** — their own points plus the dealers' points.

#### EGGS (ЯЙЦЯ)

If both teams score the **exact same number of points**, the dealers are also considered to have fallen. The opponents receive the full GV. This situation gets its own badge in the round history.

#### BAIT (БАЙТ)

A situation where the dealers **fail to win a single trick**. The opponents receive the full GV and the dealers score 0. Recorded via a dedicated button in the round entry panel.

---

## How to Use

### 1. Set Up a Game

On the home screen, configure:
- **Team names** — or leave the defaults «Us» / «Them»
- **First dealer** — which team deals the first round
- **Point limit** — 501 or 1001

Tap **«New game»** to start.

> If there is an unfinished game saved, a **«Continue previous»** button will appear below «New game».

### 2. Recording a Round

After each round, tap **«+ New round»** at the bottom of the screen:

1. **Select the GV** — scroll the horizontal list and pick the game value for this round
2. **Enter the score** for one of the teams — the opponent's score is calculated automatically (GV minus what you entered). Tap a team's column to switch which side you are entering
3. If the scores are equal, an «Eggs» hint appears automatically
4. If the dealers won no tricks at all, tap **«Bait»**
5. Tap **«Save»** to record the round

### 3. Following the Game

The game screen shows:
- Current score for both teams
- Progress toward the point limit (as a bar or numerically, depending on display style)
- Which team is currently dealing (a «deals» badge)
- Full round history with **BAIT**, **EGGS**, and **FELL** badges

### 4. Settings

Accessible via the ⚙ button:
- **Theme** — light, system (follows device setting), or dark
- **Score display** — traditional style (circles and sticks, like pen-and-paper notation) or plain numbers

---

## Game State Persistence

The game state is automatically saved after every round. When you reopen the app, the **«Continue previous»** button lets you pick up right where you left off. Finishing a game clears the saved state.

---

## Tech Stack

- **Flutter** — cross-platform UI framework
- **Dart** — programming language
- **shared_preferences** — game state and settings persistence
- Supported platforms: **Android**, **iOS**, **Web**, **Windows**

## Delivery

Every merge into `main` analyses the code, runs the tests, builds a release APK
and AAB on the Linux runners and a Windows package on the Windows runner, and
records the version as a git tag named `YYYY.MM.BUILD`. The build number doubles
as the Android version code, so it only ever grows. Nothing is published at that
point.

Creating a release for one of those tags publishes it: a release webhook starts
the publish pipeline, which rebuilds that exact tag on each platform, attaches
the APK and the Windows `.msix` to the release for direct download, and — once
store credentials are configured — uploads the AAB to the internal track of
Google Play and the package to the Microsoft Store, both as drafts.

### Platforms

Android and the AAB build on the Kubernetes Linux runners. Windows builds on a
self-hosted runner tagged `windows` with the Visual Studio build tools. iOS is
not built yet: it may only be built on Apple hardware, which no runner provides.

### Signing

Release builds use the upload key when these CI/CD variables are set, and fall
back to the debug key when they are not. An APK signed with the debug key can be
installed by hand but is rejected by Google Play.

| Variable | Notes |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | the upload keystore, base64-encoded |
| `ANDROID_KEYSTORE_PASSWORD` | store password |
| `ANDROID_KEY_ALIAS` | key alias inside the keystore |
| `ANDROID_KEY_PASSWORD` | key password |

### Google Play

Uploading to Play additionally needs `GOOGLE_PLAY_SERVICE_ACCOUNT`, the JSON key
of a service account granted access in the Play Console. Without it the publish
pipeline still runs and still attaches the APK to the release; only the upload is
skipped.

### Microsoft Store

The Windows package is submitted to Partner Center when the Store credentials
are set. The identity fields come from the app reserved in Partner Center, and
the submission uses an Azure AD application authorised for that account. Without
these the Windows package is still built and attached to the release; only the
Store submission is skipped.

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
