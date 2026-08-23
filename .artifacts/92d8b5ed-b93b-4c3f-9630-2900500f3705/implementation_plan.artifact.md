# Harmonizing Dashboard Smoothness for Owner and Renter

This plan aims to align the `OwnerHomeScreen` and Renter `HomeScreen` with the design language of the `BrokerDashboardPage`, which the user identified as the "smoothest".

## User Review Required

> [!IMPORTANT]
> The Renter `HomeScreen` currently serves as the main discovery hub (search, categories, trending). I will transform it into a "Member Dashboard" that prioritizes the user's status and quick actions, while keeping discovery features slightly further down or under an "Explore" section.

## Proposed Changes

### Core UI Components
I will identify common components from the `BrokerDashboardPage` (Header, Action Tiles, Highlight Card, Section Headers) and apply them to the other two screens.

---

### Owner Feature

#### [MODIFY] [owner_home_screen.dart](file:///D:/project/sahely/lib/features/owner/screens/owner_home_screen.dart)
- Replace the current greeting with the `Broker`-style header (Avatar + Name/Role).
- Replace the Search/Tools row with a **Portfolio Performance Card** (Gradient card with active listings, revenue progress).
- Add **Action Tiles** for `Manage`, `Portfolio`, `Wallet`, and `Bookings`.
- Standardize Section Headers and "See All" buttons.
- Simplify the "List new property" button to be more consistent with the action grid or as a prominent secondary action.

---

### Shared / Renter Feature

#### [MODIFY] [home_screen.dart](file:///D:/project/sahely/lib/features/shared/screens/home_screen.dart)
- Adopt the `Broker`-style header.
- Introduce a **Sahely Loyalty Card** (Highlight gradient card showing points, membership level, or "Nights stayed").
- Add **Action Tiles** for `My Bookings`, `Wishlist`, `Wallet`, and `Concierge`.
- Move discovery elements (Search bar, Categories) into a dedicated section below the actions to maintain the "Dashboard" feel.

## Verification Plan

### Automated Tests
- N/A (UI-centric refactoring).

### Manual Verification
- Visual inspection of all three dashboards to ensure they share the same rhythm, spacing, and component types.
- Verify navigation from new action tiles works correctly.
