# Deberc — Score Tracker

[![pipeline status](https://git.lytvyn.org/games/deberc/badges/main/pipeline.svg)](https://git.lytvyn.org/games/deberc/-/pipelines)
[![latest release](https://git.lytvyn.org/games/deberc/-/badges/release.svg?value_width=90)](https://git.lytvyn.org/games/deberc/-/releases)

A Flutter app for keeping the score in Deberc (Деберць), a trick-taking card
game of the Klaverjas / Klabberjass family that is especially popular in
Ukraine.

---

## Where the Game Comes From

Deberc has no single inventor and no documented birthday. What can be traced
is the family it belongs to and the path that family took across Europe.

- **The Klaverjas family.** Deberc is one of the *Jass* or *jack–nine* games,
  where the jack and the nine are the highest trumps. The family comes from the
  Low Countries: the Dutch *klaverjassen* is recorded in the 18th century, and
  *jas* was originally the name of the trump jack. Protestant mercenaries in
  Dutch service carried the game to Switzerland in the late 18th century, where
  the first record of *Jassen* dates from 1796. Its relatives include the Swiss
  Jass, the French Belote, the Bulgarian Bela, the Cypriot Pilotta and the
  Armenian Bazar Blot. Belote is a sibling of Deberc, not its ancestor.
- **Central and Eastern Europe.** Under names such as *Klabberjass*,
  *Kalabriás* and *Klabrias* the game spread through the German lands and
  Austria-Hungary. It became a particular favourite in Jewish communities: in
  1890 Vienna staged a popular farce, *Die Klabriaspartie*, about friends playing
  it in a café, and emigrants later took the two-handed form (*Clobyosh*,
  *Klob*, *Bela*) to Britain, the United States, South Africa and Israel.
- **Ukrainian lands.** A large part of that Jewish world lived in today's
  Ukraine — Odesa, Galicia, Podillia, the Kyiv region — and this is where the
  game took the form known as Deberc. Its vocabulary still shows the route:
  the Odesa variant is called *klabor* (from *Klabber*), the trump nine is the
  *manela* (the *Nell* / *Menel* of Jass), and a lost deal is *bet* or *bait*,
  matching the *bête* of Klaberjass. During the 20th century the game spread
  across the whole Soviet Union, which is why "Moscow" and "Kharkiv" variants
  also exist; that spread does not make it a Russian game.

**Legends without sources.** Stories that Deberc was invented by convicts on
Sakhalin in the early 20th century, or in the village of Kybyntsi in the
1870s, are repeated online but are not backed by any document, and the
Sakhalin story contradicts the much older history of the family. They are
legends, not history. The origin of the word *Deberc* itself is not
established.

---

## The Rules in Brief

Local rules differ from table to table; this is the common core.

### Players and cards

Deberc is played by two players, by three players each for themselves, or by
four players in two teams of two. It uses a **32-card deck**, seven to ace in
each suit.

### Taking the trump

After the first cards are dealt, one card is turned face up. The player on the
dealer's left has the first right to take its suit as trump or to pass; the
right then goes round the table. If everybody passes, another suit may be
named in a second round, and if everybody passes again the cards go to the
next dealer. Some tables play "with obligation", where the dealer must play
when everybody else passes.

The player who takes the trump, together with their partner, **must score more
points than the opponents** in that deal.

### Card values

| Card | Trump | Other suits |
|---|---|---|
| Jack | 20 | 2 |
| Nine | 14 | 0 |
| Ace | 11 | 11 |
| Ten | 10 | 10 |
| King | 4 | 4 |
| Queen | 3 | 3 |
| Eight, seven | 0 | 0 |

The cards are worth 152 points in total and the last trick adds 10, so **every
deal is worth 162 points** before declarations.

### Declarations

| Declaration | Points |
|---|---|
| Tierce — three cards of a suit in sequence | 20 |
| Four in a row (*kopa*, "fifty") | 50 |
| Bella — king and queen of trumps | 20 |
| **Deberc** — seven trumps in a row | wins the whole game at once |

Only the side holding the highest sequence scores its sequences. The deal's
total value is 162 plus every declaration that is scored.

### Special outcomes

- **Bait (байт).** If the trump-taker scores **less** than the opponents, the
  opponents receive the whole value of the deal and the trump-taker gets
  nothing. In a three-player game the points go to the opponent who scored
  more, and two opponents level on the most share them; the app does this
  automatically.
- **Tied deal (яйця).** If both sides score exactly the same, the most common
  rule is a "hanging bait": the opponents keep their points and the
  trump-taker's points are put on hold for whichever side wins the next deal.
  Some tables give the whole deal to the opponents instead.

### Winning

The first side to reach the agreed target wins: **301** (short game), **501**
or **1001**. When both sides pass the target in the same deal, the side that
took the trump in that deal goes out first, even if the other side has more
points; the app applies this rule automatically.

### Sources

- [Wikipedia — Jass](https://en.wikipedia.org/wiki/Jass)
- [Wikipedia — Klaverjas](https://en.wikipedia.org/wiki/Klaverjas)
- [Wikipedia — Klaberjass](https://en.wikipedia.org/wiki/Klaberjass)
- [Swiss National Museum — before Jass](https://blog.nationalmuseum.ch/en/2017/10/before-jass/)
- [Pagat — Jass group](https://pagat.com/jass) and [Card games in Ukraine](https://pagat.com/national/ukraine.html)
- [Tablet Magazine — In the cards: Klaberjass](https://www.tabletmag.com/sections/community/articles/in-the-cards-klaberjass)
- [Ukrainian Wikipedia — Деберць](https://uk.wikipedia.org/wiki/Деберц)

---

## How the App Scores a Deal

Each deal has a **game value (GV)**: 162 plus the declarations. You count the
tierces and fifties declared and tick bella if it was shown; the app adds them
up, so any value the table can reach is possible. You then enter the points of
one side and the app gives the rest of the GV to the other side.

- **Who took the trump** — every deal records which side took the trump. The
  side to the dealer's left has the first right to it and is preselected; tap
  the other side if they took it instead. With the **«Dealer must play»** rule
  the dealer takes the trump when everyone else passes.
- **Bait** — when the side that took the trump ends up with fewer points than
  its opponents, the app records the deal as bait on its own: the opponents
  get the whole GV and the trump-taker scores 0. A warning appears in the
  entry panel as soon as the entered points mean bait. When nobody counted
  the points, the «Bait» button records it straight away.
- **Eggs** — when both sides are entered with the same points the deal is
  marked with an «Eggs» badge and scored by the tie rule chosen for the game:
  - **Held over** (default) — the opponents score their points; the
    trump-taker's points are held and go to whoever wins the next deal. While
    points are held, the game screen shows how many.
  - **To opponents** — a tie counts as bait and the opponents get the whole GV.
  - **Each keeps own** — both sides score what they took.
- **Deberc** — when a side declares seven trumps in a row, tap the
  **«Deberc»** key beside 0 and pick the side holding it: that side wins the game at once, whatever the
  score. The pressed key turns gold with a 🏆 to show the game is decided. The deal is marked with a
  «Deberc» badge and can still be undone.

---

## How to Use

### 1. Set Up a Game

On the home screen, configure:
- **How many play** — **2** or **3** each for themselves, or **2 × 2** in two teams
- **Team or player names** — or leave the defaults («Us» / «Them» for teams,
  «Player 1», «Player 2», … otherwise); a name left blank falls back to its
  default
- **First dealer** — which team or player deals the first round
- **Point limit** — 301 (short game), 501 or 1001

The game rules — whether the dealer must play and what happens to «eggs» —
are set once in **Settings** and apply to every new game.

Tap **«New game»** to start.

> If there is an unfinished game saved, a **«Continue previous»** button will appear below «New game».

The **«📖 Rules and history»** button on the home screen opens the rules and
the story of the game inside the app, in the chosen language, so a new player
can learn them at the table without going online.

### 2. Recording a Round

After each round, tap **«+ New round»** at the bottom of the screen:

1. **Who took the trump** — the sides are listed one under another on the left; the side to the dealer's left is preselected, tap the other side if they took it
2. **Deal value** — on the right, under the deal's value, use **−** / **+** to count the tierces (20) and fifties (50), which sit side by side, and tap **«Bella»** (20) under them if it was declared; with the wheel chosen in the settings, a scroll wheel as tall as the side buttons takes their place
3. **Enter the score** for one of the teams — the opponent's score is calculated automatically (GV minus what you entered). Tap a team's column to switch which side you are entering. With three players, type two of the scores and the third is worked out
4. If the scores are equal, an «Eggs» hint appears automatically
5. If the side that took the trump has fewer points, the app warns that this is bait and gives the whole GV to the opponents; tap **«Bait»** to record bait without entering points
6. Tap **«Save»** to record the round

In the history the side that took the trump is marked with **♠**.

When the dealer does not have to play, an **«Everyone passed — redeal»** link
appears under the sides. If everybody passed and the cards were thrown in, tap
it instead: the deal is recorded with a «Redeal» badge, nobody scores, points
held from a tie keep waiting, and the next player deals.

### 3. Following the Game

The game screen shows:
- Current score for every team or player
- Progress toward the point limit (as a bar or numerically, depending on display style)
- Who is currently dealing: the team or player is marked «deals»
- Full round history with **BAIT**, **EGGS** and **DEBERC** badges

### 4. Correcting a Mistake

- **Undo** — the **↶** button in the header removes the last recorded deal.
- **Edit or remove any deal** — tap a deal in the history to open it in the
  entry panel, change the declarations, the points or who took the trump and tap **«Save»**,
  or tap **«Delete»** to remove it. Totals, the dealer and the winner are
  recalculated from the remaining deals.
- **Undo a win** — if the last deal ended the game by mistake, the win screen
  offers **«Undo the last round»** and returns to the game.

### 5. Settings

Accessible via the ⚙ button:
- **Theme** — light, system (follows device setting), or dark
- **Score display** — traditional style (circles and sticks, like pen-and-paper notation) or plain numbers.
  In the traditional style a crossed circle is 100, a circle 50 and a stick
  20; ten points or more past the last stick are written as one more stick
  with what it lacks noted beside it (36 is two sticks and «−4»), and smaller
  remainders as «+N» (44 is two sticks and «+4»)
- **Deal value** — count the declarations with the tierce, fifty and bella
  buttons, or pick the value of the deal straight from a scroll wheel like the
  ones in the iOS clock (162, 182, 202, 212, 222, …): spin it up to raise the
  value and down to lower it
- **Rules** — whether the dealer must play when everyone else passes (on by
  default), and what happens to a tied deal («eggs»). They are remembered and
  apply to new games; a game in progress keeps the rules it started with
- **Language** — English or Ukrainian. Until one is chosen the app follows
  the device: Ukrainian on a Ukrainian device, English everywhere else. Team
  names still at their defaults switch along with it

---

## Game State Persistence

The game state is automatically saved after every change. Only the recorded deals are stored; scores and the dealer are always recalculated from them, so an edit can never leave the totals out of step. When you reopen the app, the **«Continue previous»** button lets you pick up right where you left off. Finishing a game clears the saved state.

---

## Tech Stack

- **Flutter** — cross-platform UI framework
- **Dart** — programming language
- **shared_preferences** — game state and settings persistence
- Supported platforms: **Android**, **iOS**, **Windows**, **Linux**
- On Windows and Linux the app opens in a fixed, phone-sized window centred on the screen, which cannot be resized or maximised

## Delivery

Every merge into `main` analyses the code, runs the tests, builds a release APK,
AAB and Linux `.deb` on the Linux runners and a Windows package on the Windows
runner, and records the version as a git tag named `YYYY.MM.BUILD`. The build
number doubles as the Android version code, so it only ever grows. Nothing is
published at that point.

Creating a release for one of those tags publishes it: a release webhook starts
the publish pipeline, which rebuilds that exact tag on each platform, attaches
the APK, the Windows `.msix` and the Linux `.deb` to the release for direct
download, and — once store credentials are configured — uploads the AAB to the
internal track of Google Play and the package to the Microsoft Store, both as
drafts.

### Platforms

Android, the AAB and the Linux `.deb` build on the Kubernetes Linux runners.
The `.deb` installs the app to `/opt/deberc` with a `deberc` command and an
entry in the applications menu, and runs on Debian, Ubuntu and their
derivatives (amd64): `sudo apt install ./deberc-<version>.deb`.

Windows builds on a self-hosted runner tagged `windows` with the Visual Studio
build tools. iOS is not built yet: it may only be built on Apple hardware, which
no runner provides.

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
