$ErrorActionPreference = "Continue"

# Helper function to move files with output
function Move-File($Source, $Dest) {
    if (Test-Path $Source) {
        Move-Item -Path $Source -Destination $Dest -Force
        Write-Host "Moved: $Source -> $Dest"
    } else {
        Write-Host "Not found: $Source" -ForegroundColor Yellow
    }
}

# Helper function to move directory contents
function Move-DirContents($SourceDir, $DestDir) {
    if (Test-Path $SourceDir) {
        Get-ChildItem -Path $SourceDir | ForEach-Object {
            Move-Item -Path $_.FullName -Destination $DestDir -Force
            Write-Host "Moved: $($_.FullName) -> $DestDir"
        }
    } else {
        Write-Host "Dir Not found: $SourceDir" -ForegroundColor Yellow
    }
}

# --- Booking Feature ---
Move-File "lib/features/shared/screens/booking_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/shared/screens/my_bookings_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/shared/screens/booking_confirmed_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/shared/screens/active_booking_detail_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/shared/screens/past_booking_detail_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/shared/screens/upcoming_booking_detail_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/shared/screens/smart_lock_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/renter/presentation/screens/arrival_checklist_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/shared/screens/arrival_checklist_screen.dart" "lib/features/booking/presentation/screens/"
Move-File "lib/features/shared/widgets/booking_screen_widgets.dart" "lib/features/booking/presentation/widgets/"

Move-DirContents "lib/features/renter/presentation/screens/bookings/pages" "lib/features/booking/presentation/screens"
if (!(Test-Path "lib/features/booking/presentation/screens/gallery")) { New-Item -ItemType Directory "lib/features/booking/presentation/screens/gallery" }
Move-DirContents "lib/features/renter/presentation/screens/bookings/pages/gallery" "lib/features/booking/presentation/screens/gallery"
Move-DirContents "lib/features/renter/presentation/screens/bookings/widgets" "lib/features/booking/presentation/widgets"
if (!(Test-Path "lib/features/booking/presentation/widgets/stars")) { New-Item -ItemType Directory "lib/features/booking/presentation/widgets/stars" }
Move-DirContents "lib/features/renter/presentation/screens/bookings/widgets/stars" "lib/features/booking/presentation/widgets/stars"

# --- Search Feature ---
Move-File "lib/features/shared/screens/browse_screen.dart" "lib/features/search/presentation/screens/"
Move-File "lib/features/shared/screens/filters_screen.dart" "lib/features/search/presentation/screens/"
Move-File "lib/features/shared/screens/all_properties_screen.dart" "lib/features/search/presentation/screens/"
Move-File "lib/features/shared/widgets/browse_empty_state.dart" "lib/features/search/presentation/widgets/"
Move-File "lib/features/shared/widgets/filter_widgets.dart" "lib/features/search/presentation/widgets/"
Move-File "lib/features/shared/widgets/search_header_with_input.dart" "lib/features/search/presentation/widgets/"
Move-File "lib/features/renter/presentation/screens/Search/pages/search_empty_state.dart" "lib/features/search/presentation/screens/"
Move-File "lib/features/renter/presentation/screens/Search/pages/search_filters_sheet.dart" "lib/features/search/presentation/screens/"
Move-File "lib/features/renter/presentation/screens/Search/pages/search_results_screen.dart" "lib/features/search/presentation/screens/"
Move-File "lib/features/renter/presentation/screens/Search/widgets/filter_chips.dart" "lib/features/search/presentation/widgets/"
Move-File "lib/features/renter/presentation/screens/Search/widgets/search_result_card.dart" "lib/features/search/presentation/widgets/"
Move-DirContents "lib/features/renter/presentation/screens/Search/pages" "lib/features/search/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/Search/widgets" "lib/features/search/presentation/widgets"

# --- Home Feature ---
Move-DirContents "lib/features/renter/presentation/screens/home/pages" "lib/features/home/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/home/widgets" "lib/features/home/presentation/widgets"
Move-DirContents "lib/features/renter/presentation/screens/home/widgets1" "lib/features/home/presentation/widgets"

# --- Property Feature ---
Move-File "lib/features/shared/screens/property_detail_screen.dart" "lib/features/property/presentation/screens/"
Move-File "lib/features/shared/widgets/property_widgets.dart" "lib/features/property/presentation/widgets/"
Move-File "lib/features/shared/widgets/hero_property_card.dart" "lib/features/property/presentation/widgets/"
Move-File "lib/features/shared/widgets/small_prop_card.dart" "lib/features/property/presentation/widgets/"
Move-DirContents "lib/features/renter/presentation/screens/property/page" "lib/features/property/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/property/widgets" "lib/features/property/presentation/widgets"

# --- Wishlist Feature ---
Move-File "lib/features/shared/screens/wishlist_screen.dart" "lib/features/wishlist/presentation/screens/"
Move-File "lib/features/shared/screens/compare_screen.dart" "lib/features/wishlist/presentation/screens/"
Move-File "lib/features/shared/screens/share_collection_screen.dart" "lib/features/wishlist/presentation/screens/"
Move-File "lib/features/shared/screens/collection_chat_screen.dart" "lib/features/wishlist/presentation/screens/"
Move-File "lib/features/shared/widgets/collab_card.dart" "lib/features/wishlist/presentation/widgets/"

# Rename collection_inside_screen -> collection_inside_shared_screen
if (Test-Path "lib/features/shared/screens/collection_inside_screen.dart") {
    Move-Item -Path "lib/features/shared/screens/collection_inside_screen.dart" -Destination "lib/features/wishlist/presentation/screens/collection_inside_shared_screen.dart" -Force
}

Move-DirContents "lib/features/renter/presentation/screens/wishlist/pages" "lib/features/wishlist/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/wishlist/presentation/bloc" "lib/features/wishlist/presentation/bloc"
Move-DirContents "lib/features/renter/presentation/screens/wishlist/presentation/widgets" "lib/features/wishlist/presentation/widgets"
Move-DirContents "lib/features/renter/presentation/screens/wishlist/widgets" "lib/features/wishlist/presentation/widgets"
Move-DirContents "lib/features/renter/presentation/screens/wishlist/domain/models" "lib/features/wishlist/domain/entities"
Move-DirContents "lib/features/renter/presentation/screens/wishlist/data/repositories" "lib/features/wishlist/data/repositories"

Move-File "lib/features/shared/widgets/chat_message_bubble.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/collection_bottom_nav.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/collection_header.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/collection_members_actions.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/collection_property_card.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/collection_strip.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/compare_header.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/compare_input_bar.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/create_collection_sheet.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/new_collection_tile.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/property_comparison_bar.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/share_collection_sheet.dart" "lib/features/wishlist/presentation/widgets/"
Move-File "lib/features/shared/widgets/wishlist_collection_card.dart" "lib/features/wishlist/presentation/widgets/"

# --- Mawsem Feature ---
Move-File "lib/features/shared/screens/mawsem_dashboard_screen.dart" "lib/features/mawsem/presentation/screens/"
Move-File "lib/features/shared/screens/level_up_screen.dart" "lib/features/mawsem/presentation/screens/"
Move-File "lib/features/shared/screens/stars_earned_screen.dart" "lib/features/mawsem/presentation/screens/"
Move-File "lib/features/shared/screens/star_nudges_screen.dart" "lib/features/mawsem/presentation/screens/"
Move-File "lib/features/shared/screens/mawsem_level_screen.dart" "lib/features/mawsem/presentation/screens/"
Move-File "lib/features/shared/screens/share_earn_screen.dart" "lib/features/mawsem/presentation/screens/"
Move-DirContents "lib/features/renter/presentation/screens/mawsem/pages" "lib/features/mawsem/presentation/screens"
if (!(Test-Path "lib/features/mawsem/presentation/screens/celebration")) { New-Item -ItemType Directory "lib/features/mawsem/presentation/screens/celebration" }
Move-DirContents "lib/features/renter/presentation/screens/mawsem/celebration/pages" "lib/features/mawsem/presentation/screens/celebration"
if (!(Test-Path "lib/features/mawsem/presentation/widgets/celebration")) { New-Item -ItemType Directory "lib/features/mawsem/presentation/widgets/celebration" }
Move-DirContents "lib/features/renter/presentation/screens/mawsem/celebration/widgets" "lib/features/mawsem/presentation/widgets/celebration"
Move-DirContents "lib/features/renter/presentation/screens/mawsem/widgets" "lib/features/mawsem/presentation/widgets"

# --- Concierge Feature ---
Move-File "lib/features/shared/screens/services_screen.dart" "lib/features/concierge/presentation/screens/"
Move-DirContents "lib/features/renter/presentation/screens/concierge/pages" "lib/features/concierge/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/concierge/widgets" "lib/features/concierge/presentation/widgets"

# --- Profile Feature ---
Move-File "lib/features/shared/screens/change_password_screen.dart" "lib/features/profile/presentation/screens/"
Move-File "lib/features/shared/screens/currency_screen.dart" "lib/features/profile/presentation/screens/"
Move-File "lib/features/shared/screens/language_screen.dart" "lib/features/profile/presentation/screens/"
Move-DirContents "lib/features/renter/presentation/screens/profile/pages" "lib/features/profile/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/profile/widgets" "lib/features/profile/presentation/widgets"
if (!(Test-Path "lib/features/profile/presentation/widgets/level")) { New-Item -ItemType Directory "lib/features/profile/presentation/widgets/level" }
Move-DirContents "lib/features/renter/presentation/screens/profile/widgets/level" "lib/features/profile/presentation/widgets/level"

# --- Verification Feature ---
Move-File "lib/features/shared/screens/add_payment_card_screen.dart" "lib/features/verification/presentation/screens/"
Move-File "lib/features/shared/screens/blocked_gate_screen.dart" "lib/features/verification/presentation/screens/"
Move-DirContents "lib/features/renter/presentation/verification/pages" "lib/features/verification/presentation/screens"
Move-DirContents "lib/features/renter/presentation/verification/presentation/bloc" "lib/features/verification/presentation/bloc"
Move-DirContents "lib/features/renter/presentation/verification/presentation/widgets" "lib/features/verification/presentation/widgets"
Move-DirContents "lib/features/renter/presentation/verification/widgets" "lib/features/verification/presentation/widgets"
Move-DirContents "lib/features/renter/presentation/verification/domain/models" "lib/features/verification/domain/entities"
Move-DirContents "lib/features/renter/presentation/verification/data/repositories" "lib/features/verification/data/repositories"

# --- Support Feature ---
Move-File "lib/features/shared/screens/ai_chat_screen.dart" "lib/features/support/presentation/screens/"
Move-File "lib/features/shared/screens/sos_screen.dart" "lib/features/support/presentation/screens/"
Move-DirContents "lib/features/renter/presentation/screens/support/pages" "lib/features/support/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/support/widgets" "lib/features/support/presentation/widgets"

# --- Reviews Feature ---
Move-File "lib/features/shared/screens/write_review_screen.dart" "lib/features/reviews/presentation/screens/"
Move-File "lib/features/shared/screens/property_reviews_screen.dart" "lib/features/reviews/presentation/screens/"
Move-DirContents "lib/features/renter/presentation/screens/reviews/pages" "lib/features/reviews/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/reviews/widgets" "lib/features/reviews/presentation/widgets"

# --- Wallet Feature ---
Move-DirContents "lib/features/renter/presentation/screens/wallet/pages" "lib/features/wallet/presentation/screens"
Move-DirContents "lib/features/renter/presentation/screens/wallet/widgets" "lib/features/wallet/presentation/widgets"

# --- Notifications Feature ---
Move-File "lib/features/notifications/notifications_screen.dart" "lib/features/notifications/presentation/screens/"

# --- Owner Feature ---
Move-DirContents "lib/features/owner/screens" "lib/features/owner/presentation/screens"
Move-DirContents "lib/features/owner/widgets" "lib/features/owner/presentation/widgets"
Remove-Item "lib/features/owner/owner_screens.dart" -ErrorAction SilentlyContinue

# --- Broker Feature ---
Move-DirContents "lib/features/broker/screens" "lib/features/broker/presentation/screens"
Remove-Item "lib/features/broker/broker_nav.dart" -ErrorAction SilentlyContinue
Remove-Item "lib/features/broker/broker_screens.dart" -ErrorAction SilentlyContinue

# --- Auth Feature ---
Move-DirContents "lib/features/auth/screens" "lib/features/auth/presentation/screens"
Move-DirContents "lib/features/auth/widgets" "lib/features/auth/presentation/widgets"
Remove-Item "lib/features/auth/auth_screens.dart" -ErrorAction SilentlyContinue

# --- Core Widgets & Constants ---
Move-File "lib/features/renter/presentation/widgets/map_view.dart" "lib/core/widgets/"
Move-File "lib/features/renter/presentation/widgets/property_card.dart" "lib/core/widgets/"
Move-File "lib/widgets/map_view.dart" "lib/core/widgets/"
Move-File "lib/widgets/property_card.dart" "lib/core/widgets/"
Move-File "lib/core/constants/app_routes.dart" "lib/core/router/"

# --- Data Migration ---
Move-File "lib/data/models.dart" "lib/core/api/models.dart"
Move-File "lib/data/role_state.dart" "lib/core/auth/"
Move-File "lib/data/sample_data.dart" "lib/core/utils/sample_data.dart"
Move-File "lib/data/wishlist_state.dart" "lib/features/wishlist/presentation/bloc/wishlist_state.dart"

# --- BLoC Migration ---
if (Test-Path "lib/core/providers/auth_provider.dart") {
    Move-Item -Path "lib/core/providers/auth_provider.dart" -Destination "lib/features/auth/presentation/bloc/auth_bloc.dart" -Force
}
if (Test-Path "lib/core/providers/bookings_provider.dart") {
    Move-Item -Path "lib/core/providers/bookings_provider.dart" -Destination "lib/features/booking/presentation/bloc/booking_bloc.dart" -Force
}
if (Test-Path "lib/core/providers/profile_provider.dart") {
    Move-Item -Path "lib/core/providers/profile_provider.dart" -Destination "lib/features/profile/presentation/bloc/profile_bloc.dart" -Force
}
if (Test-Path "lib/core/providers/currency_provider.dart") {
    Move-Item -Path "lib/core/providers/currency_provider.dart" -Destination "lib/core/bloc/currency_cubit.dart" -Force
}
if (Test-Path "lib/core/providers/locale_provider.dart") {
    Move-Item -Path "lib/core/providers/locale_provider.dart" -Destination "lib/core/bloc/locale_cubit.dart" -Force
}

# --- Router & L10n ---
Remove-Item "lib/routes.dart" -ErrorAction SilentlyContinue
Remove-Item "lib/core/navigation/app_navigation.dart" -ErrorAction SilentlyContinue
Move-DirContents "lib/i10n" "lib/l10n"
if (Test-Path "lib/i10n") { Remove-Item -Path "lib/i10n" -Recurse -Force }

Write-Host "Migration complete!"
