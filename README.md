# Sahely — Flutter app

> **Verified Chalets. Zero Chaos.** — a luxury North-Coast (Egypt) property-rental app.

This is a Flutter implementation of the Sahely design board (`../project/Sahely.dc.html`),
built from the handoff bundle exported from Claude Design. It recreates the full
~90-screen design system across **Authentication, Renter, Owner, Broker** and the
**AL MAWSEM** seasonal loyalty program.

Verified locally with **Flutter 3.24.5**: `flutter analyze` → 0 errors,
`flutter build web` succeeds, widget test passes.

## Running

```bash
flutter pub get
flutter run            # pick a device, or:
flutter run -d chrome  # web
```

The app opens on a **Design Index** launcher (mirrors the board's "Jump to" bar) so
every screen is directly reachable. "Start the full flow" walks
Splash → Welcome → Onboarding → Sign up → Home, and the role home feeds wire up the
floating bottom-nav and cross-links between screens.

> Property imagery uses the same live Unsplash CDN URLs as the prototype, so an
> internet connection is needed to see photos (each image has a graceful
> placeholder fallback). For production, swap these for the client's own
> Marassi / North-Coast photography.

## Design system

- **Colours** — Navy `#1B2744` · Champagne Gold `#C9A84C` · Cream `#F5F0E8`
  (layered cream gradient background). Role accents: Renter = navy, Owner = green,
  Broker = gold. See `lib/theme/app_colors.dart`.
- **Type** — DM Sans throughout (via `google_fonts`).
- **Signature components** — translucent "floating-island" bottom nav, blended
  property photography, rounded/pill controls, plain-navy prices, iOS-style status
  bar and lock-screen notifications.

## Structure

```
lib/
  main.dart, app.dart, routes.dart   # entry, MaterialApp, master route table (96 routes)
  theme/                             # colours, typography, AppTheme.dm() helper
  data/                              # Property/Service models + sample data
  widgets/                           # shared kit: status bar, floating nav, cards,
                                     #   chips, buttons, badges, calendar, success check…
  features/
    design_index.dart                # launcher / screen registry
    auth/                            # 15 screens: splash → verify → ID → selfie → done
    renter/                          # home feed, profile, reviews, wallet, history
    shared/                          # browse, filters, property detail, booking,
                                     #   wishlist + collections + compare, services,
                                     #   AL MAWSEM, smart-lock, SOS, AI chat, account…
    owner/                           # home, manage, properties, insights, edit,
                                     #   add-property wizard, requests, earnings,
                                     #   withdraw, violations, portfolio, payout…
    broker/                          # home, dashboard, referrals, portfolio, tiers,
                                     #   commission wallet, referral issue, refer…
    notifications/                   # lock screen, banner anatomy, top banner
```

Screens shared across roles (browse/booking/wishlist/services/AL MAWSEM/account)
are built once in `features/shared/` and reused, matching how the design board
duplicates them per role section.

## Notes for the build team

- The screens reproduce the **visual design**. Behaviour that the spec describes but
  isn't wired to a backend (OTP delivery, GPS-proximity passcode reveal, payments,
  payouts, listing-review workflow, the AL MAWSEM points engine) is represented as
  static/mocked UI — hook these to real services as they come online.
- Logo assets live in `assets/images/` (navy + light variants).
- The phone status bar (`9:41`, notch, battery) is drawn into each screen to match
  the mockups; on real hardware you may prefer the OS status bar via `SafeArea`.
