import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import '../widgets/checklist_header_banner.dart';
import '../widgets/checklist_item.dart';
import '../widgets/report_issue_section.dart';
import '../widgets/submit_checklist_banner.dart';
import '../widgets/stars/stars_earned_dialog.dart';
import '../../mawsem/celebration/pages/level_up_celebration_screen.dart';

class ArrivalChecklistScreen extends StatefulWidget {
  final String bookingId;
  final DateTime checkInTime;
  final List<Map<String, dynamic>> checklistItems;

  const ArrivalChecklistScreen({
    super.key,
    required this.bookingId,
    required this.checkInTime,
    required this.checklistItems,
  });

  @override
  State<ArrivalChecklistScreen> createState() => _ArrivalChecklistScreenState();
}

class _ArrivalChecklistScreenState extends State<ArrivalChecklistScreen> {
  late List<Map<String, dynamic>> _checklistItems;
  final List<Map<String, dynamic>> _reportedIssues = [];
  final List<String> _uploadedPhotos = [];
  final TextEditingController _issueController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Use the passed items directly to maintain their saved state (completed/reported)
    _checklistItems = widget.checklistItems.map((item) => Map<String, dynamic>.from(item)).toList();
    
    // Re-populate reported issues if any exist in the initial data
    for (int i = 0; i < _checklistItems.length; i++) {
      if (_checklistItems[i]['issueReported'] == true) {
        _reportedIssues.add({
          'itemIndex': i,
          'itemName': _checklistItems[i]['label'],
          'issueText': _checklistItems[i]['issueText'] ?? '',
        });
        if (_checklistItems[i]['issueText'] != null && _checklistItems[i]['issueText'].isNotEmpty) {
           _issueController.text = _checklistItems[i]['issueText'];
        }
      }
    }
  }

  @override
  void dispose() {
    _issueController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleItem(int index) {
    setState(() {
      final bool currentlyCompleted = _checklistItems[index]['completed'] ?? false;
      _checklistItems[index]['completed'] = !currentlyCompleted;
      
      if (_checklistItems[index]['completed'] == true) {
        _checklistItems[index]['issueReported'] = false;
        _reportedIssues.removeWhere((issue) => issue['itemIndex'] == index);
      }
    });
  }

  void _onCameraTap(int index) {
    setState(() {
      _checklistItems[index]['issueReported'] = true;
      _checklistItems[index]['completed'] = false;
      
      if (!_reportedIssues.any((i) => i['itemIndex'] == index)) {
        _reportedIssues.add({
          'itemIndex': index,
          'itemName': _checklistItems[index]['label'],
          'issueText': '',
        });
      }
    });
    
    // Smooth scroll to show report area
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      
      if (image != null) {
        setState(() {
          _uploadedPhotos.add(image.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _submit() {
    // Update issueText in checklist items before returning
    for (var issue in _reportedIssues) {
      int idx = issue['itemIndex'];
      _checklistItems[idx]['issueText'] = _issueController.text;
    }
    
    final profile = context.read<ProfileProvider>();
    final int previousStars = profile.stars;
    final int? newLevel = profile.addStars(5);
    final nextLevel = profile.nextLevelData;

    // Show stars earned dialog
    showDialog(
      context: context,
      barrierColor: const Color(0xFF1B2744).withValues(alpha: 0.7),
      builder: (context) => StarsEarnedDialog(
        starsEarned: 5,
        reason: 'submitting arrival checklist for',
        propertyName: 'Lagoon Retreat',
        previousTotal: previousStars,
        newTotal: profile.stars,
        starsToNextLevel: nextLevel != null ? nextLevel['stars'] - profile.stars : 0,
        nextLevelName: nextLevel != null ? nextLevel['name'] : 'Max Level',
        onKeepEarning: () {
          Navigator.pop(context); // Close dialog
          
          if (newLevel != null) {
            _showLevelUpCelebration(context, newLevel);
          } else {
            Navigator.pop(context, _checklistItems); // Return to previous screen
          }
        },
      ),
    );
  }

  void _showLevelUpCelebration(BuildContext context, int level) {
    final profile = context.read<ProfileProvider>();
    final levelData = profile.levelData;
    final nextLevel = profile.nextLevelData;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelUpCelebrationScreen(
          newLevel: level,
          levelName: levelData['name'],
          levelIcon: levelData['icon'],
          levelColor: levelData['color'],
          unlockBenefit: _getUnlockBenefit(level),
          unlockRewardTitle: 'Level Reward',
          unlockRewardDescription: _getUnlockReward(level),
          currentSeasonStars: profile.stars,
          starsToNextLevel: nextLevel != null ? nextLevel['stars'] - profile.stars : 0,
          onShare: () {
            // Share achievement logic
          },
          onKeepExploring: () {
            Navigator.pop(context); // Close celebration
            Navigator.pop(context, _checklistItems); // Return to previous screen
          },
        ),
      ),
    );
  }

  String _getUnlockBenefit(int level) {
    switch (level) {
      case 2: return 'Basic perks and dashboard access unlocked.';
      case 3: return '15% off all concierge services is now active for the rest of this season.';
      case 4: return 'Priority support and welcome gifts are now available.';
      default: return 'Premium benefits and exclusive access are now yours.';
    }
  }

  String _getUnlockReward(int level) {
    switch (level) {
      case 3: return 'Priority WhatsApp Support';
      case 4: return '200 EGP Booking Credit';
      case 5: return 'Free Airport Pickup';
      default: return 'Exclusive Digital Badge';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ChecklistHeaderBanner(
                      timeRemaining: Duration(hours: 1, minutes: 24),
                      starsEarned: 5,
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Tick everything the host promised. Tap the camera on any item that\'s wrong.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF717171), fontFamily: 'DM Sans', height: 1.4),
                    ),

                    const SizedBox(height: 16),

                    // Checklist Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0D8CC)),
                      ),
                      child: Column(
                        children: _checklistItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final isLast = index == _checklistItems.length - 1;

                          return Column(
                            children: [
                              ChecklistItem(
                                label: item['label'],
                                isCompleted: item['completed'] ?? false,
                                issueReported: item['issueReported'] ?? false,
                                onTap: () => _toggleItem(index),
                                onReportIssue: () => _onCameraTap(index),
                              ),
                              if (!isLast)
                                const Divider(height: 1, color: Color(0xFFE0D8CC), indent: 16, endIndent: 16),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Report Section (Visible only if issues exist)
                    if (_reportedIssues.isNotEmpty) ...[
                      ReportIssueSection(
                        controller: _issueController,
                        photos: _uploadedPhotos,
                        onAddPhoto: _pickImage,
                      ),
                      const SizedBox(height: 24),
                    ],

                    const SubmitChecklistBanner(
                      starsEarned: 5,
                      collectionName: 'AL MAWSEM',
                    ),
                    
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B2744),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Submit & earn +5', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'DM Sans')),
                            SizedBox(width: 6),
                            Icon(Icons.star, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0D8CC)),
              ),
              child: const Icon(Icons.chevron_left, color: Color(0xFF1B2744), size: 24),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Arrival Checklist', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1B2744), fontFamily: 'DM Sans')),
        ],
      ),
    );
  }
}
