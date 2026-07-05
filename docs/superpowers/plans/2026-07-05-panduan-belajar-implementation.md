# Restruktur Panduan Belajar — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite `docs/panduan-belajar.md` from technical documentation into a project-based learning guide for complete beginners, organized per-component of the Flutter Seller Dashboard project.

**Architecture:** Single markdown document (~1500 lines) with 10 sequential learning stages (Tahap 0-9), each building on the previous. Each tahap introduces concepts "just in time" as the student encounters them in the project code, with exercises at the end.

**Tech Stack:** Markdown, Flutter/Dart code snippets, project file references

## Global Constraints

- Full Bahasa Indonesia throughout
- Zero assumed programming knowledge — every term explained on first use
- All code examples reference actual files in this project (`lib/`, `test/`, `.github/workflows/`)
- Each tahap ends with 2-3 practical exercises modifying the project
- One concept per sub-section
- Visual widget tree diagrams (ASCII) for layout-heavy sections

---

### Task 1: Header + Daftar Isi + Tahap 0 (Persiapan & Halo Flutter)

**Files:**
- Modify: `docs/panduan-belajar.md` (start fresh, write header + Tahap 0)

- [ ] **Step 1: Write file header and Daftar Isi**

Write the document header (title, project description, repo link, target audience) and a complete Daftar Isi linking to all 10 tahap + Penutup.

- [ ] **Step 2: Write Tahap 0 — Persiapan & Halo Flutter**

Covers:
- Install Flutter SDK (link download, extract, PATH)
- Install VS Code + Flutter/Dart extensions
- Setup emulator (Android Studio) or connect physical device (USB debugging)
- Clone project from GitHub
- `flutter pub get` — what are dependencies
- First run: `flutter run`, see app on emulator
- Hot reload demo — change text, see instant changes
- Project folder structure overview: `lib/`, `test/`, `pubspec.yaml`
- Key terms: SDK, emulator, widget, hot reload, pubspec, dependency
- **Latihan:** change theme color from blue to green, change AppBar title

- [ ] **Step 3: Verify content reads well**

Read through Tahap 0 — is every term explained? Does the setup flow make sense? Any missing steps?

- [ ] **Step 4: Commit**

```bash
git add docs/panduan-belajar.md
git commit -m "feat: add header, TOC, and Tahap 0 (Setup)"
```

---

### Task 2: Tahap 1-2 (Model + StatCard — Dart & Widget Dasar)

**Files:**
- Modify: `docs/panduan-belajar.md` (append Tahap 1-2)

- [ ] **Step 1: Write Tahap 1 — Model: Belajar Dart Lewat Data Transaksi**

Covers:
- Open `lib/models/transaction.dart`
- Variable & tipe data: `String`, `int`, `double`
- `final` — immutability
- Class & constructor: `class`, `required`, `this.`
- Object literal: `TransactionItem(name: 'Beras', ...)`
- Getter: `double get subtotal => quantity * price`
- String interpolation: `${expression}`
- List & `fold` for accumulation
- Switch-case for payment label
- Array index offset: `date.month - 1`
- **Latihan:** add `discount` field + getter `totalAfterDiscount`; create `Customer` model

- [ ] **Step 2: Write Tahap 2 — StatCard: Widget Flutter Pertama**

Covers:
- Open `lib/widgets/stat_card.dart`
- `StatelessWidget` — widget with no mutable state
- `build(BuildContext context)` — returns widget tree
- Widget tree diagram (ASCII):
  ```
  Card → Padding → Column
                      ├── Container (icon)
                      ├── Text (value)
                      ├── Text (title)
                      └── Text? (subtitle)
  ```
- Widget parameter: `required` vs optional (`String?`)
- Basic widgets: `Card`, `Padding`, `Column`, `Container`, `Text`, `Icon`
- `BorderRadius`, `EdgeInsets` — corners and spacing
- Conditional widget: `if (subtitle != null) Text(subtitle!)`
- Null assertion: `!`
- `copyWith` — modify style without creating from scratch
- **Latihan:** create `StatusBadge` widget; add optional `onTap` to StatCard

- [ ] **Step 3: Verify content reads well**

Check: does the explanation of class/constructor work for someone who's never seen Dart? Is the StatCard explanation clear enough to build without copying?

- [ ] **Step 4: Commit**

```bash
git add docs/panduan-belajar.md
git commit -m "feat: add Tahap 1 (Model - Dart basics) and Tahap 2 (StatCard - Flutter widgets)"
```

---

### Task 3: Tahap 3-4 (Provider + Dashboard — State Management & Layout)

**Files:**
- Modify: `docs/panduan-belajar.md` (append Tahap 3-4)

- [ ] **Step 1: Write Tahap 3 — Provider & State Management**

Covers:
- Open `lib/providers/transaction_provider.dart` and `lib/main.dart`
- State concept — data that can change and affects display
- `ChangeNotifier` + `notifyListeners()`
- `Consumer<T>` — auto-rebuild on data change
- `context.watch<T>` vs `context.read<T>` (when to use which)
- Encapsulation: private `_transactions` + `List.unmodifiable`
- Computed properties: `todayRevenue`, `last7DaysRevenue`, `todayCount`
- `ChangeNotifierProvider` wrapping root widget
- Cascade notation: `TransactionProvider()..seedSampleData()`
- **Latihan:** add computed property `totalItemsSoldAllTime`; add method `clearAllTransactions()`; add Consumer in AppBar showing today's count

- [ ] **Step 2: Write Tahap 4 — Dashboard: Layout & Grafik**

Covers:
- Open `lib/screens/dashboard_screen.dart`
- `Scaffold`, `AppBar`, `RefreshIndicator` — page structure
- Layout: `Column`, `Row`, `Expanded`, `SizedBox`
- 4 stat cards in 2-row grid
- fl_chart integration: `BarChart` > `BarChartData` > `BarChartGroupData` > `BarChartRodData`
- 7-day revenue data from `provider.last7DaysRevenue`
- Safety: `maxY` fallback when data is empty
- Interactive tooltip with formatted Rupiah
- Recent transactions: `.take(5)` + spread operator `...`
- `_TransactionCard` private widget
- Manual date format (Indonesian day/month name arrays)
- **Latihan:** change bar chart color to gradient; add 5th stat card "Average per Transaction"; change recent items from 5 to 3

- [ ] **Step 3: Verify content reads well**

Check: does the Provider explanation make sense? Is the fl_chart hierarchy clear? Are the context.watch/context.read examples practical?

- [ ] **Step 4: Commit**

```bash
git add docs/panduan-belajar.md
git commit -m "feat: add Tahap 3 (Provider) and Tahap 4 (Dashboard)"
```

---

### Task 4: Tahap 5-6 (Form + Transaction List — Input & Navigation)

**Files:**
- Modify: `docs/panduan-belajar.md` (append Tahap 5-6)

- [ ] **Step 1: Write Tahap 5 — Form Tambah Transaksi: Input & Validasi**

Covers:
- Open `lib/screens/add_transaction_screen.dart`
- `StatefulWidget` vs `StatelessWidget`
- `setState()` — trigger rebuild
- `TextEditingController` — bridge between text input and code
- `Form` + `GlobalKey<FormState>` — validation
- `TextFormField` + validator callback
- `tryParse` pattern: `int.tryParse(text) ?? 0`
- Dynamic item list: `List<_ItemEntry>` with add/remove via setState
- `AnimatedContainer` — automatic animation on property change
- `GestureDetector` — tap detection
- `Navigator.push()` / `Navigator.pop()`
- `SnackBar` — user feedback
- Submit flow: validate → create Transaction → add to provider → pop
- **Latihan:** add "Phone Number" field with 10-digit validation; add "Cancel" button with confirmation; change ID format to "TRX-001"

- [ ] **Step 2: Write Tahap 6 — Daftar Transaksi: List & Navigasi**

Covers:
- Open `lib/screens/transactions_screen.dart`
- `ListView.builder` — efficient list rendering
- `ExpansionTile` — expandable list item
- Empty state pattern: icon + message when no transactions
- Bottom navigation: `NavigationBar` with `selectedIndex`, `onDestinationSelected`
- `IndexedStack` vs `PageView` — preserving tab state
- Item row layout: `Expanded(flex:)` + `SizedBox` fixed width
- Delete button
- `_paymentAvatar` helper function (returns widget)
- **Latihan:** add sort feature (newest/oldest/highest); add badge showing today's count on bottom nav; navigate to separate detail page instead of ExpansionTile

- [ ] **Step 3: Verify content reads well**

Check: is the StatefulWidget vs StatelessWidget distinction clear? Does the dynamic form logic flow make sense?

- [ ] **Step 4: Commit**

```bash
git add docs/panduan-belajar.md
git commit -m "feat: add Tahap 5 (Form) and Tahap 6 (Transaction List)"
```

---

### Task 5: Tahap 7-9 + Penutup + Glossary (Utility, Testing, CI/CD)

**Files:**
- Modify: `docs/panduan-belajar.md` (append Tahap 7-9 + Penutup)

- [ ] **Step 1: Write Tahap 7 — Utility: Error Handling & Formatting**

Covers:
- Open `lib/utils/currency_helper.dart`
- Top-level function
- `NumberFormat.currency` — Indonesian locale problem
- `try-catch` cascade (3-level fallback)
- Regex thousand separator: `RegExp(r'(\d)(?=(\d{3})+(?!\d))')`
- Positive lookahead `(?=...)` and negative lookahead `(?!\d)`
- `replaceAllMapped`
- **Latihan:** create `formatDate` with fallback pattern; create `parseRupiah` helper

- [ ] **Step 2: Write Tahap 8 — Widget Testing**

Covers:
- Open `test/app_test.dart`
- Why testing matters
- `testWidgets`, `pumpWidget`, `pumpAndSettle`
- `setUpAll` for locale setup
- Finder methods: `find.text()`, `find.textContaining()`, `find.widgetWithText()`
- Matchers: `findsOneWidget`, `findsWidgets`, `findsNothing`, `findsAtLeastNWidgets(n)`
- Simulating interaction: `tester.tap()`, `tester.enterText()`
- **Latihan:** write test for form submission; write test for transaction deletion

- [ ] **Step 3: Write Tahap 9 — CI/CD dengan GitHub Actions**

Covers:
- What is CI/CD
- Open `.github/workflows/build-debug-apk.yml`
- Workflow triggers: push to main, PR to main, manual dispatch
- Job steps: checkout → Java → Flutter → flutter create → analyze → test → build → upload
- APK download from Artifacts
- **Latihan:** add Telegram/email notification on build failure; add appbundle build step

- [ ] **Step 4: Write Penutup + Glossary**

Covers:
- Summary table: konsep → implementasi
- Glossary with all terms organized by tahap
- Next steps: edit transaction, search/filter, customer history, export, SQLite, API

- [ ] **Step 5: Verify content reads well**

Read through Tahap 7-9 + Penutup. Check consistency of terminology with earlier sections.

- [ ] **Step 6: Commit**

```bash
git add docs/panduan-belajar.md
git commit -m "feat: add Tahap 7-9 (Utility, Testing, CI/CD) and Penutup"
```

---

### Task 6: Final Verification Pass

**Files:**
- Modify: `docs/panduan-belajar.md` (proofread entire document)

- [ ] **Step 1: Read through entire document**

Read `docs/panduan-belajar.md` from start to finish. Check:
- Consistent terminology across all tahap
- All file references are correct (paths match actual project files)
- No orphaned references or broken markdown links
- All code snippets are syntactically valid
- Glossary terms cover all bold/emphasized terms in the document
- Spacing and formatting are consistent

- [ ] **Step 2: Fix any issues found**

Address any inconsistencies, typos, formatting issues.

- [ ] **Step 3: Final commit**

```bash
git add docs/panduan-belajar.md
git commit -m "fix: final review pass and polish"
```
