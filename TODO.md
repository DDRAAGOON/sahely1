# Sahely - Refactoring Progress

## ✅ Completed

### 1. توحيد Booking Details (3 أكونتات → ملف واحد)
- ✅ `shared/screens/active_booking_detail_screen.dart` ← `ActiveBookingRole` enum
- ✅ `shared/screens/upcoming_booking_detail_screen.dart` ← `UpcomingBookingRole` enum
- ✅ `shared/screens/past_booking_detail_screen.dart` ← `PastBookingRole` enum
- ✅ Owner routes → shared screens
- ✅ Broker routes → shared screens
- ✅ حذف `broker_booking_details_page.dart`

### 2. توحيد Wishlist
- ✅ `shared/screens/wishlist_screen.dart` يستخدم لـ Renter + Owner + Broker (مع `showNav` + `WishlistRole`)

### 3. توحيد SOS
- ✅ `shared/screens/sos_screen.dart` مع `UserRole` enum
- ✅ حذف `broker_sos_chat_screen.dart`

### 4. Property Cards - PropertyCardBase
- ✅ `PropertyCard` + `PropertyMiniCard` → يستخدم `PropertyCardBase`
- ✅ `HeroPropertyCard` → يستخدم `PropertyCardBase`
- ✅ `BrokerPropertyCard` → refactored لاستخدام `PropertyCardBase`
- ✅ `BrokerHomePage` → تم تحديثه ليمرر `Property` object
- ✅ `OwnerPropertyCard` → refactored لاستخدام `PropertyCardBase`
- ✅ `SmallPropCard` → refactored لاستخدام `PropertyCardBase`

### 5. ملفات تم إعادة كتابتها
- ✅ `broker_tier_card.dart` ← تم إصلاح `withOpacity`
- ✅ `broker_home_page.dart` ← تم إعادة بناء الملف بالكامل
- ✅ `owner_go_routes.dart` ← تم إعادة بناء الملف بالكامل

### 6. ✅ Renter's BookedPropertyScreen - تم حذف الملف القديم منذ قبل و Renter يستخدم shared بالفعل

### 7. ✅ `withOpacity` → `withValues(alpha:)` - الملفات كلها محدثة بالفعل

## 🔄 مستقبلاً (للنقاش)
- توحيد Notification screens
- توحيد Concierge vs Services screens
- توحيد FilterChips و BottomNav widgets
- توحيد Mock Data Sources
