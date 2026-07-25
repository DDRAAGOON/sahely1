import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/features/owner/data/datasources/mock_owner_data_source.dart';
import 'package:sahely/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:sahely/features/owner/presentation/bloc/dispute_cubit.dart';
import 'package:sahely/features/owner/presentation/bloc/dispute_state.dart';

class DisputeViolationScreen extends StatefulWidget {
  const DisputeViolationScreen({super.key});

  @override
  State<DisputeViolationScreen> createState() => _DisputeViolationScreenState();
}

class _DisputeViolationScreenState extends State<DisputeViolationScreen> {
  final _caseController = TextEditingController();
  final List<File> _attachments = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _caseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _attachments.add(File(image.path));
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisputeCubit(
        repository: OwnerRepositoryImpl(
          remoteDataSource: MockOwnerDataSource(),
        ),
      ),
      child: BlocListener<DisputeCubit, DisputeState>(
        listener: (context, state) {
          if (state is DisputeSuccess) {
            _showSuccessDialog(context);
          } else if (state is DisputeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        child: PhoneScaffold(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  children: [
                    const TopBar(title: 'Dispute Violation'),
                    const SizedBox(height: 16),
                    WhiteCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Property damage — not reported',
                              style: AppTheme.dm(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                          const SizedBox(height: 4),
                          Text('Azure Beach Villa · SHLY-8842',
                              style: AppTheme.dm(size: 12, color: AppColors.muted)),
                          const SizedBox(height: 12),
                          const KeyValueRow('Deduction', '− EGP 1,500',
                              valueColor: Color(0xFFB22222)),
                          const KeyValueRow('Reported on', 'Jun 18, 2026'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Your Case',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _caseController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText:
                            'Explain why you are disputing this violation. Provide any context that might help our team review your case...',
                        hintStyle:
                            AppTheme.dm(size: 13, color: AppColors.placeholder),
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Supporting Evidence (Optional)',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _uploadBox(
                          Icons.add_a_photo_outlined,
                          'Add Photo',
                          onTap: _pickImage,
                        ),
                        const SizedBox(width: 12),
                        _uploadBox(
                          Icons.file_present_outlined,
                          'Attach PDF',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('PDF attachment coming soon')),
                            );
                          },
                        ),
                      ],
                    ),
                    if (_attachments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _attachments.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(_attachments[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeAttachment(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 14),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<DisputeCubit, DisputeState>(
                  builder: (context, state) {
                    return NavyButton(
                      label: state is DisputeSubmitting ? 'Submitting...' : 'Submit Dispute',
                      enabled: state is! DisputeSubmitting,
                      onTap: () {
                        context.read<DisputeCubit>().submitDispute(
                          reason: _caseController.text,
                          attachments: _attachments.map((e) => e.path).toList(),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadBox(IconData icon, String label, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: DottedBorder(
          color: AppColors.border,
          radius: 12,
          child: Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.muted, size: 28),
                const SizedBox(height: 8),
                Text(label, style: AppTheme.dm(size: 12, color: AppColors.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFD7EEDD),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.success, size: 30),
            ),
            const SizedBox(height: 20),
            Text('Dispute Submitted',
                style: AppTheme.dm(
                    size: 18, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 10),
            Text(
                'Our team will review your case and get back to you within 48 hours.',
                textAlign: TextAlign.center,
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
            const SizedBox(height: 24),
            NavyButton(
              label: 'Back to Violations',
              height: 44,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
