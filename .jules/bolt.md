## 2026-07-14 - [Avoiding Network Image Latency and Test Blockages]
**Learning:** Hardcoding external network URLs (like Unsplash or Google gstatic URLs) in Flutter UI elements causes slow rendering, high dependency on internet connection, and fatal test suite errors due to Flutter's block on network traffic during testing (returning HTTP 400).
**Action:** Always refactor external network image assets to use local assets (under `assets/images/`) or configure dynamic fallback to local placeholders within custom image widgets to guarantee offline performance, safety, and green test suite runs.
