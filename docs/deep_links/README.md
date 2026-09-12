# Share links that open the app

The API generates the share links (`share_url` / `referral_url`) on the web
frontend's domain, today `sahely-frontend-gg5v.vercel.app`:

| Link | Opens in the app |
| --- | --- |
| `/wishlists/join/<token>` | Joins the shared collection, then the Wishlist tab |
| `/join?ref=<code>` | Keeps the invite code for registration, then Welcome (or Home) |
| `/properties/<id>` | The listing's page |

The app already routes these paths (`lib/features/shared/links/`) and also
accepts them as `sahely://app/<path>`. Someone without the app just sees the
website. To make the https links open the app directly, the website has to
prove it trusts the app:

## Android (App Links)

1. Put the release signing certificate's SHA-256 in `assetlinks.json`
   (Play Console > App integrity > App signing, or
   `keytool -list -v -keystore <release.jks>`).
2. Serve it at `https://<host>/.well-known/assetlinks.json` with
   `Content-Type: application/json` on every host listed in
   `android/app/src/main/AndroidManifest.xml`.

## iOS (universal links)

1. Put the Apple Team ID in `apple-app-site-association`.
2. Serve it (no file extension) at
   `https://<host>/.well-known/apple-app-site-association`.
3. In Xcode: Runner target > Signing & Capabilities > + Associated Domains,
   and select the existing `Runner/Runner.entitlements`. It is not wired into
   the project yet on purpose: signing fails if the Apple developer account
   does not have the capability enabled.

When the production website moves to its own domain, add that host to the
Android manifest and to `Runner.entitlements`.
