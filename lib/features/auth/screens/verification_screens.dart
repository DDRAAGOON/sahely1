import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/cream_background.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/auth/data/auth_api.dart';
import 'package:sahely/features/auth/widgets/auth_success_badge.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/core/widgets/fill_viewport.dart';

// ===================================================== 10 · ID Verification
class IdVerificationScreen extends StatefulWidget {
  const IdVerificationScreen({super.key});

  @override
  State<IdVerificationScreen> createState() => _IdVerificationScreenState();
}

class _IdVerificationScreenState extends State<IdVerificationScreen> {
  int _selectedType = 0; // 0: National ID, 1: Passport, 2: Driving Licence
  File? _frontImage;
  File? _backImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, bool isFront) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (isFront) {
            _frontImage = File(pickedFile.path);
          } else {
            _backImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showPicker(BuildContext context, bool isFront) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    _selectedType == 1
                        ? 'Upload Passport'
                        : 'Upload ${isFront ? 'Front' : 'Back'} Side',
                    style: AppTheme.dm(
                        size: 18,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.gold),
                  title: Text('Take a photo',
                      style: AppTheme.dm(size: 15, weight: FontWeight.w600)),
                  subtitle: Text('Capture with your camera',
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera, isFront);
                  },
                ),
                const Divider(
                    color: AppColors.border, indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined,
                      color: AppColors.gold),
                  title: Text('Upload from gallery',
                      style: AppTheme.dm(size: 15, weight: FontWeight.w600)),
                  subtitle: Text('Choose an existing photo',
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery, isFront);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra;

    return PhoneScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _StepBar(active: 1),
                      const SizedBox(height: 24),
                      Text('Verify Your Identity',
                          style: AppTheme.dm(
                              size: 22,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Upload your ',
                          style: AppTheme.dm(size: 14, color: AppColors.muted),
                          children: [
                            TextSpan(
                                text: 'National ID',
                                style: AppTheme.dm(
                                    size: 14,
                                    weight: FontWeight.w700,
                                    color: AppColors.ink)),
                            TextSpan(
                                text: ', ',
                                style: AppTheme.dm(
                                    size: 14, color: AppColors.muted)),
                            TextSpan(
                                text: 'Passport',
                                style: AppTheme.dm(
                                    size: 14,
                                    weight: FontWeight.w700,
                                    color: AppColors.ink)),
                            TextSpan(
                                text: ', or ',
                                style: AppTheme.dm(
                                    size: 14, color: AppColors.muted)),
                            TextSpan(
                                text: 'Driving Licence',
                                style: AppTheme.dm(
                                    size: 14,
                                    weight: FontWeight.w700,
                                    color: AppColors.ink)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                              child: _DocTypeChip('National ID',
                                  selected: _selectedType == 0,
                                  onTap: () =>
                                      setState(() => _selectedType = 0))),
                          const SizedBox(width: 8),
                          Expanded(
                              child: _DocTypeChip('Passport',
                                  selected: _selectedType == 1,
                                  onTap: () =>
                                      setState(() => _selectedType = 1))),
                          const SizedBox(width: 8),
                          Expanded(
                              child: _DocTypeChip('Driving Licence',
                                  selected: _selectedType == 2,
                                  onTap: () =>
                                      setState(() => _selectedType = 2))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_selectedType == 1) ...[
                        // Passport: Single upload box
                        const SizedBox(height: 40),
                        _UploadBox(
                          active: true,
                          uploaded: _frontImage != null,
                          image: _frontImage,
                          icon: Icons.image_outlined,
                          label: _frontImage != null
                              ? 'Passport photo uploaded'
                              : 'Tap to upload passport',
                          onTap: () => _showPicker(context, true),
                        ),
                        const SizedBox(height: 40),
                      ] else ...[
                        // National ID or Driving Licence: Front and Back
                        _UploadBox(
                          active: true,
                          uploaded: _frontImage != null,
                          image: _frontImage,
                          icon: Icons.image_outlined,
                          label: _frontImage != null
                              ? 'Front side uploaded'
                              : 'Tap to upload front',
                          onTap: () => _showPicker(context, true),
                        ),
                        const SizedBox(height: 12),
                        _UploadBox(
                          active: _frontImage != null,
                          uploaded: _backImage != null,
                          image: _backImage,
                          icon: Icons.notes_outlined,
                          label: _backImage != null
                              ? 'Back side uploaded'
                              : 'Tap to upload back',
                          onTap: _frontImage != null
                              ? () => _showPicker(context, false)
                              : null,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                          _selectedType == 1
                              ? 'JPG, PNG or PDF · Max 10MB · Upload the photo page only'
                              : 'JPG, PNG or PDF · Max 10MB',
                          style: AppTheme.dm(size: 12, color: AppColors.muted)),
                      const Spacer(),
                      const SizedBox(height: 24),
                      NavyButton(
                          label: 'Continue',
                          enabled: _selectedType == 1
                              ? _frontImage != null
                              : (_frontImage != null && _backImage != null),
                          onTap: () => AppNavigation.goToFacialScan(context,
                              extra: args)),
                      const SizedBox(height: 14),
                      Center(
                        child: GestureDetector(
                          onTap: () => AppNavigation.goToFacialScan(context,
                              extra: args),
                          child: Text('Skip for now',
                              style: AppTheme.dm(
                                  size: 13,
                                  weight: FontWeight.w600,
                                  color: AppColors.gold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.active}); // 0=personal,1=id,2=selfie
  final int active;

  @override
  Widget build(BuildContext context) {
    Widget node(int i, String label) {
      final done = i < active;
      final cur = i == active;
      final bg = done || cur
          ? (done ? AppColors.gold : AppColors.navy)
          : AppColors.border;
      final fg =
          done ? AppColors.navy : (cur ? AppColors.white : AppColors.muted);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: done
                ? const Icon(Icons.check, size: 11, color: AppColors.navy)
                : Text('${i + 1}', style: AppTheme.dm(size: 11, color: fg)),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(label,
                style: AppTheme.dm(
                    size: 12,
                    weight: FontWeight.w600,
                    color: cur
                        ? AppColors.navy
                        : (done ? AppColors.gold : AppColors.faint))),
          ],
        ],
      );
    }

    return Row(
      children: [
        node(0, 'Personal'),
        Expanded(
            child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: active >= 1 ? AppColors.gold : AppColors.border)),
        node(1, 'ID Verify'),
        Expanded(
            child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: active >= 2 ? AppColors.gold : AppColors.border)),
        node(2, ''),
      ],
    );
  }
}

class _DocTypeChip extends StatelessWidget {
  const _DocTypeChip(this.label, {this.selected = false, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.white,
          border: selected ? null : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: AppTheme.dm(
                size: 11,
                weight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.navy)),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.active,
    required this.icon,
    required this.label,
    this.onTap,
    this.uploaded = false,
    this.image,
  });

  final bool active;
  final bool uploaded;
  final File? image;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: Opacity(
        opacity: active ? 1.0 : 0.5,
        child: DottedBorder(
          color: uploaded
              ? AppColors.success
              : (active ? AppColors.gold : AppColors.border),
          child: Container(
            height: 132,
            decoration: BoxDecoration(
              color: uploaded
                  ? AppColors.goldSoft.withValues(alpha: 0.5)
                  : (active ? AppColors.goldSoft : AppColors.white),
              borderRadius: BorderRadius.circular(14),
              image: image != null
                  ? DecorationImage(
                      image: FileImage(image!),
                      fit: BoxFit.cover,
                      opacity: 0.3,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!uploaded)
                  Icon(icon,
                      size: 34,
                      color: active ? AppColors.gold : AppColors.faint),
                if (uploaded)
                  const Icon(Icons.check_circle,
                      size: 34, color: AppColors.success),
                const SizedBox(height: 10),
                Text(label,
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w600,
                        color: uploaded
                            ? AppColors.success
                            : (active ? AppColors.navy : AppColors.muted))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================== 11 · Facial Scan
class FacialScanScreen extends StatefulWidget {
  const FacialScanScreen({super.key});

  @override
  State<FacialScanScreen> createState() => _FacialScanScreenState();
}

class _FacialScanScreenState extends State<FacialScanScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2200))
    ..repeat(reverse: true);

  /// How long the live preview runs before the selfie is taken, so the user
  /// can centre their face ("Hold still").
  static const _holdStill = Duration(seconds: 3);

  CameraController? _camera;
  Timer? _captureTimer;
  bool _starting = false;
  bool _finished = false;

  /// The user refused the camera. The screen stays put - skipping is the
  /// user's own choice - and tapping the oval asks again.
  bool _cameraDenied = false;

  /// Android stops showing the prompt after repeated refusals (iOS after the
  /// first), so tapping the oval then points to the app settings instead.
  bool _permanentlyDenied = false;

  /// The camera was released because the app went to the background, so it
  /// is reopened when the app returns.
  bool _reopenOnResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Opening the camera is what raises the system permission prompt.
    WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _captureTimer?.cancel();
    _camera?.dispose();
    _c.dispose();
    super.dispose();
  }

  /// The camera must be released while the app is in the background and
  /// reopened when it returns, or the preview freezes. The permission prompt
  /// itself only makes the app inactive, so it does not trigger this.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_finished || _starting) return;
    if (state == AppLifecycleState.paused) {
      final camera = _camera;
      if (camera == null) return;
      _captureTimer?.cancel();
      _camera = null;
      _reopenOnResume = true;
      camera.dispose();
      if (mounted) setState(() {});
    } else if (state == AppLifecycleState.resumed) {
      if (_reopenOnResume) {
        _reopenOnResume = false;
        _startCamera();
      } else if (_cameraDenied) {
        // Back from the app settings: start only if the camera was allowed
        // there. Checking the status never shows a prompt, so a refusal
        // cannot turn into a prompt loop.
        _startIfAllowed();
      }
    }
  }

  /// The registration details handed down from the previous steps, plus
  /// any [extra] entries for the next screen.
  Map<String, dynamic> _args([Map<String, dynamic> extra = const {}]) {
    final current = GoRouterState.of(context).extra;
    return {
      if (current is Map) ...Map<String, dynamic>.from(current),
      ...extra,
    };
  }

  Future<void> _startCamera() async {
    if (_starting || _finished || _camera != null || !mounted) return;
    _starting = true;
    CameraController? controller;
    try {
      // Shows the system "Allow camera?" prompt while the OS still allows it.
      final status = await Permission.camera.request();
      if (!mounted || _finished) return;
      if (!status.isGranted) {
        _onCameraDenied(
          permanently: status.isPermanentlyDenied || status.isRestricted,
        );
        return;
      }
      if (_cameraDenied) {
        setState(() {
          _cameraDenied = false;
          _permanentlyDenied = false;
        });
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showCameraError(); // No camera on this device.
        return;
      }
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      controller = CameraController(
        front,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted || _finished) {
        await controller.dispose();
        return;
      }
      setState(() => _camera = controller);
      _captureTimer = Timer(_holdStill, _capture);
    } on CameraException catch (e) {
      await controller?.dispose();
      if (_isPermissionDenied(e)) {
        _onCameraDenied(permanently: true);
      } else {
        _showCameraError();
      }
    } catch (_) {
      await controller?.dispose();
      _showCameraError();
    } finally {
      _starting = false;
    }
  }

  static bool _isPermissionDenied(CameraException e) =>
      e.code.contains('Denied') ||
      e.code.contains('Restricted') ||
      e.code == 'cameraPermission';

  /// A refusal never skips the step by itself: the screen waits for the user
  /// to tap the oval again or to tap "Skip for now".
  void _onCameraDenied({required bool permanently}) {
    if (!mounted) return;
    setState(() {
      _cameraDenied = true;
      _permanentlyDenied = permanently;
    });
  }

  Future<void> _startIfAllowed() async {
    if (await Permission.camera.isGranted) _startCamera();
  }

  /// Tapping the oval after a refusal asks for the camera again - through the
  /// system prompt, or through the app settings once the OS stops showing it.
  void _onOvalTap() {
    if (!_cameraDenied || _starting || _finished) return;
    if (_permanentlyDenied) {
      _showOpenSettings();
    } else {
      _startCamera();
    }
  }

  void _showOpenSettings() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Camera access is turned off. Allow it in '
              'Settings to take your selfie, or tap "Skip for now".'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
  }

  Future<void> _capture() async {
    final camera = _camera;
    if (_finished ||
        camera == null ||
        !camera.value.isInitialized ||
        camera.value.isTakingPicture) {
      return;
    }
    try {
      final photo = await camera.takePicture();
      if (!mounted || _finished) return;
      _finished = true;
      context.pushReplacement(
        '/verification-complete',
        extra: _args({'selfiePath': photo.path}),
      );
    } on CameraException {
      _showCameraError();
    }
  }

  void _skip() {
    if (_finished || !mounted) return;
    _finished = true;
    _captureTimer?.cancel();
    context.pushReplacement('/verification-complete', extra: _args());
  }

  void _showCameraError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not start the camera. Tap "Skip for now" to '
            'continue.'),
      ),
    );
  }

  /// Fills the oval with the live preview without stretching it. The sensor
  /// reports its size in landscape, so width and height are swapped for the
  /// portrait frame.
  Widget _preview(CameraController camera) {
    final size = camera.value.previewSize;
    if (size == null) return CameraPreview(camera);
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: size.height,
        height: size.width,
        child: CameraPreview(camera),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: FillViewport(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 30),
        child: Column(
          children: [
            _SelfieStepBar(),
            const SizedBox(height: 18),
            Text('Take a Live Selfie',
                style: AppTheme.dm(
                    size: 22, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 6),
            Text("We'll match your face to your ID — live only",
                style: AppTheme.dm(size: 13, color: AppColors.muted)),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: _onOvalTap,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 252,
                height: 372,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(252, 372)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEEF1F5), Color(0xFFE2E8EF)],
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _c,
                      builder: (_, child) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.elliptical(252, 372)),
                          border: null,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold
                                  .withValues(alpha: 0.35 + 0.35 * _c.value),
                              blurRadius: 14 + 16 * _c.value,
                              spreadRadius: 2 + 7 * _c.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // The live front-camera feed, clipped to the oval.
                    if (_camera?.value.isInitialized ?? false)
                      Positioned.fill(
                          child: ClipOval(child: _preview(_camera!)))
                    else
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person,
                              size: 120, color: Color(0xFF9AA6B4)),
                          // Only after a refusal: tapping the oval asks again.
                          if (_cameraDenied)
                            Text('Tap to allow the camera',
                                style: AppTheme.dm(
                                    size: 12,
                                    weight: FontWeight.w600,
                                    color: AppColors.muted)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text('Hold still — capture happens automatically, live only',
                textAlign: TextAlign.center,
                style: AppTheme.dm(size: 13, color: AppColors.muted)),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _SelfieTip('Good lighting'),
                _SelfieTip('Look at the camera'),
                _SelfieTip('No glasses'),
                _SelfieTip('No hats'),
                _SelfieTip('No mask'),
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: GestureDetector(
                onTap: _skip,
                child: Text('Skip for now',
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.gold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelfieStepBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget done() => Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppColors.gold, shape: BoxShape.circle),
          child: const Icon(Icons.check, size: 11, color: AppColors.navy),
        );
    return Row(
      children: [
        done(),
        Expanded(
            child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: AppColors.gold)),
        done(),
        Expanded(
            child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: AppColors.gold)),
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppColors.navy, shape: BoxShape.circle),
          child:
              Text('3', style: AppTheme.dm(size: 11, color: AppColors.white)),
        ),
        const SizedBox(width: 6),
        Text('Selfie',
            style: AppTheme.dm(
                size: 12, weight: FontWeight.w600, color: AppColors.navy)),
      ],
    );
  }
}

class _SelfieTip extends StatelessWidget {
  const _SelfieTip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: null,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                  color: AppColors.gold, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.dm(size: 12, color: AppColors.ink)),
        ],
      ),
    );
  }
}

// ================================================= 12 · Verification Complete
class VerificationCompleteScreen extends StatelessWidget {
  const VerificationCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final roleStr = args?['role'] as String? ?? 'Renter';

    // Set the global role state
    RoleState().setRoleFromString(roleStr);

    String targetRoute = '/renter/home';
    if (roleStr == 'Property Owner') targetRoute = '/owner/home';
    if (roleStr == 'Broker') targetRoute = '/broker/home';

    return PhoneScaffold(
      child: FillViewport(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AuthSuccessBadge(navy: true),
            const SizedBox(height: 28),
            Text('Verified!',
                style: AppTheme.dm(
                    size: 26, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 10),
            Text('Your identity is confirmed.\nYou now have full access.',
                textAlign: TextAlign.center,
                style:
                    AppTheme.dm(size: 15, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20)),
              child: Text('You earned 5 Sahel Stars ★ on AL MAWSEM!',
                  style: AppTheme.dm(
                      size: 13,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
            ),
            const SizedBox(height: 34),
            GoldButton(
                label: 'Explore Properties',
                onTap: () => _enterApp(context, args, targetRoute)),
          ],
        ),
      ),
    );
  }

  /// Signs the new account in for real, then opens the app.
  ///
  /// The phone step already created a session if the account was active. If
  /// it was not (the backend creates the account only once identity
  /// verification is approved), sign in with the registration credentials
  /// now. If the server still refuses, the account is awaiting review, so the
  /// user goes to sign-in with a clear message - never into the app on a fake
  /// token, which made every API call fail.
  Future<void> _enterApp(
    BuildContext context,
    Map<String, dynamic>? args,
    String targetRoute,
  ) async {
    if (args?['signedIn'] != true) {
      try {
        final resp = await AuthApiService().login(
          '${args?['email'] ?? ''}',
          '${args?['password'] ?? ''}',
        );
        if (!context.mounted) return;
        await context.read<AuthProvider>().login(
              token: resp.token,
              role: resp.role,
            );
      } on AuthApiException {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account is being reviewed. You can sign in '
                'as soon as it is approved.'),
          ),
        );
        AppNavigation.goToSignIn(context);
        return;
      }
    }

    if (!context.mounted) return;
    context.read<ProfileProvider>().updateProfile(
          name: args?['name'] as String?,
          email: args?['email'] as String?,
          phone: args?['phone'] as String?,
        );

    // The verified badge now reflects the server's status instead of being
    // switched on locally.
    try {
      context.read<VerificationCubit>().loadVerificationStatus();
    } catch (_) {}

    context.go(targetRoute);
  }
}
