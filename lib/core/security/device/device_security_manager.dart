import 'device_security_service.dart';

class DeviceSecurityManager {
  final DeviceSecurityService _service;

  DeviceSecurityManager(this._service);

  Future<bool> isDeviceSecure() async {
    final rooted = await _service.isRooted();
    final emulator = await _service.isEmulator();
    final developerMode = await _service.isDeveloperMode();
    
    // Logic for "secure" can be customized
    return !rooted && !emulator && !developerMode;
  }

  Future<bool> isRooted() => _service.isRooted();
  Future<bool> isJailbroken() => _service.isJailbroken();
  Future<bool> isEmulator() => _service.isEmulator();
  Future<bool> isDeveloperMode() => _service.isDeveloperMode();
  Future<bool> isRealDevice() => _service.isRealDevice();
  Future<bool> isDebugged() => _service.isDebugged();
  Future<bool> isScreenLockEnabled() => _service.isScreenLockEnabled();
}
