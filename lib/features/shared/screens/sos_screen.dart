import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/upload/file_upload_api.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/chat/data/chat_api_data_source.dart';

enum UserRole { renter, owner, broker }

/// Live support, backed by the real support inbox (`/chat/*`).
///
/// With a stay in progress the conversation is opened as an SOS
/// (`POST /chat/sos`), which the backend flags as urgent; otherwise it is an
/// ordinary support conversation. Nothing on this screen is simulated: a
/// reply appears only when Sahely support actually sends one.
class SosScreen extends StatefulWidget {
  const SosScreen({super.key, this.role = UserRole.renter, this.bookingId});

  final UserRole role;

  /// The stay this SOS is about, when it is raised from a booking.
  final String? bookingId;

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<_SosMessage> _messages = const [];
  String _conversationId = '';
  String _status = '';
  bool _busy = false;
  Timer? _poll;

  ChatApiDataSource get _chat => sl<ChatApiDataSource>();

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void dispose() {
    _poll?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Opens (or re-opens) the support conversation and starts listening.
  Future<void> _open() async {
    setState(() => _status = 'Connecting…');
    Map<String, dynamic> conversation = const {};
    try {
      final bookingId = widget.bookingId;
      if (bookingId != null && bookingId.isNotEmpty) {
        conversation = await _chat.raiseSos(bookingId);
      }
    } catch (_) {
      // SOS is only accepted around an active stay; fall back to support.
    }
    if (conversation.isEmpty) {
      try {
        conversation = await _chat.createConversation();
      } catch (_) {
        if (mounted) setState(() => _status = 'Support is unreachable');
        return;
      }
    }
    if (!mounted) return;
    setState(() {
      _conversationId = '${conversation['id'] ?? ''}';
      _status = _statusLabel(conversation);
    });
    await _refresh();
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => _refresh());
  }

  static String _statusLabel(Map<String, dynamic> conversation) {
    final status = '${conversation['status'] ?? ''}'.toUpperCase();
    if (status == 'RESOLVED' || status == 'CLOSED') {
      return 'Conversation closed';
    }
    return pick(conversation, 'assigned_admin') != null
        ? 'Agent connected'
        : 'Waiting for an agent';
  }

  Future<void> _refresh() async {
    if (_conversationId.isEmpty) return;
    try {
      final rows = await _chat.fetchMessages(_conversationId);
      if (!mounted) return;
      setState(() {
        // The API returns newest first; the thread reads oldest first.
        _messages = rows.reversed.map(_SosMessage.fromJson).toList();
      });
      await _chat.markAsRead(_conversationId);
    } catch (_) {
      // Keep what is on screen; the next tick tries again.
    }
  }

  Future<void> _send(String text) async {
    final body = text.trim();
    if (body.isEmpty || _conversationId.isEmpty || _busy) return;
    _controller.clear();
    setState(() => _busy = true);
    try {
      await _chat.sendMessage(conversationId: _conversationId, message: body);
      await _refresh();
    } catch (_) {
      if (mounted) _notify('Could not send. Check your connection.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Attaches a photo: uploaded to storage first, then sent as a message.
  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null || _conversationId.isEmpty) return;
    setState(() => _busy = true);
    try {
      final objectKey = await sl<FileUploadApi>().uploadFile(
        filePath: image.path,
        uploadType: UploadTypes.chatAttachment,
      );
      await _chat.sendMessage(
        conversationId: _conversationId,
        message: '',
        attachmentUrl: objectKey,
        attachmentType: 'image',
      );
      await _refresh();
    } catch (_) {
      if (mounted) _notify('Could not send the photo.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _notify(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  String _getTitle() {
    switch (widget.role) {
      case UserRole.owner:
        return 'SOS — Live Support';
      case UserRole.broker:
        return 'Broker Support — SOS';
      case UserRole.renter:
        return 'Sahely Support — SOS';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBroker = widget.role == UserRole.broker;
    return Scaffold(
      backgroundColor:
          isBroker ? const Color(0xFFEFEAE1) : const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: isBroker
                ? const EdgeInsets.fromLTRB(12, 10, 12, 12)
                : const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFFB22222),
            ),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: isBroker
                    ? const Icon(Icons.chevron_left, color: Colors.white)
                    : Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.chevron_left,
                            color: Colors.white, size: 24),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(_getTitle(),
                        style: AppTheme.dm(
                            size: isBroker ? 15 : 16,
                            weight: FontWeight.w700,
                            color: Colors.white)),
                    Row(children: [
                      Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                              color: _status == 'Agent connected'
                                  ? const Color(0xFF7BE0A0)
                                  : Colors.white54,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(_status,
                            overflow: TextOverflow.ellipsis,
                            style:
                                AppTheme.dm(size: 12, color: Colors.white70)),
                      ),
                    ]),
                  ])),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(isBroker ? 14 : 16),
              itemCount: _messages.length + (_busy ? 2 : 1),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24, top: 8),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E1D5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _messages.isEmpty
                              ? 'Tell us what is wrong — support will reply here'
                              : 'Emergency chat',
                          textAlign: TextAlign.center,
                          style: AppTheme.dm(
                              size: 12,
                              weight: FontWeight.w600,
                              color: AppColors.muted),
                        ),
                      ),
                    ),
                  );
                }
                final index = i - 1;
                if (index == _messages.length) return _sendingIndicator();
                final message = _messages[index];
                return message.fromSupport ? _agent(message) : _user(message);
              },
            ),
          ),
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(children: [
              GestureDetector(
                  onTap: _pickImage,
                  child: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.muted)),
              const SizedBox(width: 10),
              Expanded(
                  child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEFEAE1),
                          borderRadius: BorderRadius.circular(22)),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _send,
                        decoration: InputDecoration(
                          hintText: 'Message support...',
                          hintStyle: AppTheme.dm(
                              size: 13,
                              color: AppColors.navy.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ))),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _send(_controller.text),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xFFB22222), shape: BoxShape.circle),
                    child:
                        const Icon(Icons.send, size: 18, color: Colors.white)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _agent(_SosMessage message) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  color: Color(0xFFB22222), shape: BoxShape.circle),
              child: const Icon(Icons.headset_mic_outlined,
                  size: 16, color: Colors.white)),
          const SizedBox(width: 8),
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14)),
                  child: _body(message, color: AppColors.ink))),
        ]),
      );

  Widget _user(_SosMessage message) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Flexible(
              child: Container(
                  padding: EdgeInsets.all(message.hasAttachment ? 4 : 11),
                  decoration: BoxDecoration(
                    color: message.hasAttachment
                        ? AppColors.white
                        : AppColors.navy,
                    borderRadius: BorderRadius.circular(14),
                    border: message.hasAttachment
                        ? Border.all(color: AppColors.border)
                        : null,
                  ),
                  child: _body(message, color: Colors.white))),
        ]),
      );

  Widget _body(_SosMessage message, {required Color color}) {
    if (message.hasAttachment) {
      final url = message.attachmentUrl!;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: url.startsWith('http')
            ? Image.network(url, width: 200, fit: BoxFit.cover)
            : Image.file(File(url), width: 200, fit: BoxFit.cover),
      );
    }
    return Text(message.text,
        style: AppTheme.dm(size: 13, color: color, height: 1.4));
  }

  Widget _sendingIndicator() => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('Sending…',
              style:
                  AppTheme.dm(size: 12, color: AppColors.muted, italic: true)),
        ]),
      );
}

/// One message in the support thread.
class _SosMessage {
  const _SosMessage({
    required this.text,
    required this.fromSupport,
    this.attachmentUrl,
  });

  final String text;

  /// True for anything written by Sahely support, false for the user's own.
  final bool fromSupport;
  final String? attachmentUrl;

  bool get hasAttachment => (attachmentUrl ?? '').isNotEmpty;

  factory _SosMessage.fromJson(Map<String, dynamic> json) {
    final role =
        '${pick(json, 'sender_role') ?? json['role'] ?? ''}'.toUpperCase();
    return _SosMessage(
      text: '${json['message'] ?? ''}',
      fromSupport: role == 'ADMIN' || role == 'SUPPORT' || role == 'AGENT',
      attachmentUrl: pick(json, 'attachment_url') as String?,
    );
  }
}
