# Global UI Animations Implementation Plan

Add animations to all interactive elements (buttons, chips, etc.) and ensure screen transitions are smooth and consistent across the app.

## User Review Required

> [!NOTE]
> Most buttons will now have a "Bouncy" scale effect when pressed, similar to Instagram's interaction style. This is achieved using the existing `BouncyButton` widget.

> [!IMPORTANT]
> Global screen transitions are already configured in `AppTheme.light` using a custom `FadeTransition` + `SlideTransition`. I will review if any screen specific transitions are overriding this.

## Proposed Changes

### Core Widgets
Update common interactive widgets to use `BouncyButton` for consistent haptic and visual feedback.

#### [MODIFY] [primary_button.dart](file:///D:/project/sahely/lib/core/widgets/primary_button.dart)
- Wrap the main button structure with `BouncyButton`.

#### [MODIFY] [wide_button.dart](file:///D:/project/sahely/lib/core/widgets/wide_button.dart)
- Update `WideButton` and `ReviewButton` to use `BouncyButton`.

#### [MODIFY] [chips.dart](file:///D:/project/sahely/lib/core/widgets/chips.dart)
- Update `ChoiceChipPill` and `SearchHeaderRow` interactive elements to use `BouncyButton`.

#### [MODIFY] [back_button_circle.dart](file:///D:/project/sahely/lib/core/widgets/back_button_circle.dart)
- Update to use `BouncyButton`.

#### [MODIFY] [cards.dart](file:///D:/project/sahely/lib/core/widgets/cards.dart)
- Ensure all interactive cards use `BouncyButton` (some already do).

### Theme & Transitions

#### [MODIFY] [app_theme.dart](file:///D:/project/sahely/lib/core/theme/app_theme.dart)
- Review and refine `_SmoothPageTransitionsBuilder` for a more "app-like" feel if needed.

## Verification Plan

### Manual Verification
- Test button clicks in various screens (Owner Home, Renter Home, Broker Home) to ensure the scale animation is present.
- Verify screen transitions when navigating between different sections of the app.
- Ensure haptic feedback is working as expected (where supported).
