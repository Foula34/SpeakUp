import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/glass_card.dart';

class _MockComment {
  final String author;
  final String type;
  final String content;
  final String timeAgo;
  final String initials;

  _MockComment(this.author, this.type, this.content, this.timeAgo, this.initials);
}

/// Écran 8 : Commentaires Structurés (Version Premium)
class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  String _selectedFeedbackType = 'Liked';

  final List<_MockComment> _comments = [
    _MockComment('Amadou B.', 'Liked', 'Très bonne énergie au début, tu as capté mon attention directement !', 'Il y a 2h', 'A'),
    _MockComment('Fatou N.', 'Improve', 'Essaie de ralentir un peu vers la fin, on sentait de la précipitation.', 'Il y a 4h', 'F'),
    _MockComment('Moussa K.', 'Advice', 'N\'hésite pas à faire plus de pauses entre tes arguments pour nous laisser respirer.', 'Hier', 'M'),
  ];

  void _handleSendComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(0, _MockComment(
        'Vous (Mock)', 
        _selectedFeedbackType, 
        _commentController.text.trim(), 
        'À l\'instant', 
        'V'
      ));
    });
    
    _commentController.clear();
    FocusScope.of(context).unfocus(); // Fermer le clavier
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.pop()),
        title: const Text('Retours', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildPostHeader().animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 24),
                Text('Commentaires (${_comments.length})', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...List.generate(_comments.length, (index) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCommentItem(_comments[index]).animate().fadeIn(delay: (100).ms).slideX(begin: 0.1, end: 0),
                  )
                ),
              ],
            ),
          ),
          _buildInputArea().animate().slideY(begin: 1.0, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.3), child: const Text('D', style: TextStyle(color: Colors.white))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daniel M.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Hier • Pitch', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Entraînement pour le concours de pitch. Qu\'en pensez-vous ?', style: TextStyle(color: Colors.white, fontSize: 15)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.play_circle_fill, color: AppColors.accent, size: 36),
                const SizedBox(width: 12),
                Expanded(child: Container(height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(width: 12),
                const Text('02:15', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(_MockComment comment) {
    Color typeColor;
    IconData typeIcon;
    String typeLabel;

    switch (comment.type) {
      case 'Liked': typeColor = Colors.greenAccent; typeIcon = Icons.thumb_up_alt; typeLabel = 'J\'ai aimé'; break;
      case 'Improve': typeColor = Colors.orangeAccent; typeIcon = Icons.lightbulb; typeLabel = 'À améliorer'; break;
      case 'Advice': default: typeColor = AppColors.accent; typeIcon = Icons.auto_awesome; typeLabel = 'Conseil'; break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 18, backgroundColor: Colors.white10, child: Text(comment.initials, style: const TextStyle(color: Colors.white))),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(comment.author, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(width: 8),
                  Text(comment.timeAgo, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: typeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(typeIcon, size: 12, color: typeColor),
                    const SizedBox(width: 4),
                    Text(typeLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: typeColor)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(comment.content, style: const TextStyle(color: Colors.white, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: ['Liked', 'Improve', 'Advice'].map((type) {
                final isSelected = _selectedFeedbackType == type;
                String label = type == 'Liked' ? '👏 J\'ai aimé' : type == 'Improve' ? '💡 À améliorer' : '🎯 Conseil';
                Color chipColor = type == 'Liked' ? Colors.greenAccent : type == 'Improve' ? Colors.orangeAccent : AppColors.accent;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (val) { if (val) setState(() => _selectedFeedbackType = type); },
                    selectedColor: chipColor.withOpacity(0.2),
                    backgroundColor: Colors.white.withOpacity(0.05),
                    labelStyle: TextStyle(color: isSelected ? chipColor : Colors.white54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? chipColor : Colors.white10)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ajouter un feedback...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onSubmitted: (_) => _handleSendComment(),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColors.accent,
                radius: 24,
                child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: _handleSendComment),
              ),
            ],
          ),
        ],
      ),
    );
  }
}