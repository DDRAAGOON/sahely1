import re

with open('d:/project/sahely/lib/core/navigation/app_router.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Add import
import_stmt = "import 'package:sahely/core/navigation/app_routes.dart';"
if import_stmt not in content:
    content = content.replace("import 'package:go_router/go_router.dart';", "import 'package:go_router/go_router.dart';\n" + import_stmt)

# Update imports for BrokerDashboardPage
content = content.replace("import 'package:sahely/features/broker/presentation/screens/profile/pages/broker_profile_page.dart';", "import 'package:sahely/features/broker/presentation/screens/dashboard/pages/broker_dashboard_page.dart';")

# Replacements mapping
replacements = {
    "'/splash'": "AppRoutes.splash",
    "'/welcome'": "AppRoutes.welcome",
    "'/onboarding'": "AppRoutes.onboarding",
    "'/role'": "AppRoutes.roleSelection",
    "'/create'": "AppRoutes.createAccount",
    "'/signin'": "AppRoutes.signIn",
    "'/verify-email'": "AppRoutes.verifyEmail",
    "'/verify-phone'": "AppRoutes.verifyPhone",
    "'/forgot'": "AppRoutes.forgotPassword",
    "'/reset-otp'": "AppRoutes.resetOtp",
    "'/new-password'": "AppRoutes.newPassword",
    "'/password-updated'": "AppRoutes.passwordUpdated",
    "'/id-verification'": "AppRoutes.idVerification",
    "'/facial-scan'": "AppRoutes.facialScan",
    "'/verification-complete'": "AppRoutes.verificationComplete",
    
    "'/renter/home'": "AppRoutes.renterHome",
    "'/renter/wishlist'": "AppRoutes.renterWishlist",
    "'/renter/bookings'": "AppRoutes.renterBookings",
    "'/renter/services'": "AppRoutes.renterServices",
    "'/renter/profile'": "AppRoutes.renterProfile",
    
    "'/broker/home'": "AppRoutes.brokerHome",
    "'/broker/wishlist'": "AppRoutes.brokerWishlist",
    "'/broker/bookings'": "AppRoutes.brokerBookings",
    "'/broker/services'": "AppRoutes.brokerServices",
    
    "'/owner/home'": "AppRoutes.ownerHome",
    "'/owner/wishlist'": "AppRoutes.ownerWishlist",
    "'/owner/bookings'": "AppRoutes.ownerBookings",
    "'/owner/services'": "AppRoutes.ownerServices",
    "'/owner/profile'": "AppRoutes.ownerProfile",
    
    "'/notifications'": "AppRoutes.notifications",
    "'/notif-banner'": "AppRoutes.notifBanner",
    "'/notif-top'": "AppRoutes.notifTop",
}

for old, new in replacements.items():
    content = content.replace(old, new)

# Special handling for Broker Tab 5
content = content.replace("path: '/broker/profile',\n                  builder: (context, state) => const BrokerProfilePage()", "path: AppRoutes.brokerDashboard,\n                  builder: (context, state) => const BrokerDashboardPage()")

# Write back
with open('d:/project/sahely/lib/core/navigation/app_router.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print('Done app_router.dart')
