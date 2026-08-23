abstract class DeviceSecurityService {
  Future<bool> isRooted();
  Future<bool> isJailbroken();
  Future<bool> isRealDevice();
  Future<bool> isEmulator();
  Future<bool> isDebugged();
  Future<bool> isDeveloperMode();
  Future<bool> isScreenLockEnabled();
}
