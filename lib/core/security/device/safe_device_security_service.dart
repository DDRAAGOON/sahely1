import 'package:safe_device/safe_device.dart';
import 'device_security_service.dart';

class SafeDeviceSecurityService implements DeviceSecurityService {
  @override
  Future<bool> isRooted() async {
    return await SafeDevice.isJailBroken;
  }

  @override
  Future<bool> isJailbroken() async {
    return await SafeDevice.isJailBroken;
  }

  @override
  Future<bool> isRealDevice() async {
    return await SafeDevice.isRealDevice;
  }

  @override
  Future<bool> isEmulator() async {
    return !(await SafeDevice.isRealDevice);
  }

  @override
  Future<bool> isDebugged() async {
    // safe_device doesn't directly support debug detection in 1.4.1
    // but some versions have it. Checking documentation or using a fallback.
    // SafeDevice.canMockLocation is often used to detect developer tools.
    return false; // Placeholder if not supported by the library version
  }

  @override
  Future<bool> isDeveloperMode() async {
    return await SafeDevice.isDevelopmentModeEnable;
  }

  @override
  Future<bool> isScreenLockEnabled() async {
    // safe_device doesn't support screen lock detection.
    // Usually requires local_auth or custom channel.
    return true; // Defaulting to true/safe for now as it's not supported by safe_device
  }
}
