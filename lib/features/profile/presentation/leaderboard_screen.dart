import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/glass_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top3 = [
      {'name': 'Fatou C.', 'xp': 2450, 'level': 24, 'color': const Color(0xFFC0C0C0)}, // 2nd (Silver)
      {'name': 'Amadou B.', 'xp': 3100, 'level': 31, 'color': const Color(0xFFFFD700)}, // 1st (Gold)
      {'name': 'Mariam S.', 'xp': 2100, 'level': 21, 'color': const Color(0xFFCD7F32)}, // 3rd (Bronze)
    ];

    final others = [
      {'rank': 4, 'name': 'Oumar J.', 'xp': 1950, 'level': 19},
      {'rank': 5, 'name': 'Aïssatou T.', 'xp': 1800, 'level': 18},
      {'rank': 6, 'name': 'Moussa F.', 'xp': 1650, 'level': 16},
      {'rank': 7, 'name': 'Vous', 'xp': 1500, 'level': 15, 'isMe': true},
      {'rank': 8, 'name': 'Hawa K.', 'xp': 1420, 'level': 14},
      {'rank': 9, 'name': 'Ibrahim D.', 'xp': 1200, 'level': 12},
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.pop()),
        title: const Text('Classement', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -50, left: 0, right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [AppColors.accent.withOpacity(0.2), Colors.transparent],
                  radius: 0.8,
                ),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 2.seconds),

          Column(
            children: [
              // Podium
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildPodiumUser(top3[0], 2, 110).animate().slideY(begin: 1.0, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
                    const SizedBox(width: 16),
                    _buildPodiumUser(top3[1], 1, 150).animate().slideY(begin: 1.0, end: 0, duration: 500.ms, curve: Curves.easeOutBack),
                    const SizedBox(width: 16),
                    _buildPodiumUser(top3[2], 3, 90).animate().slideY(begin: 1.0, end: 0, duration: 700.ms, curve: Curves.easeOutBack),
                  ],
                ),
              ),
              
              // List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: others.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildLeaderboardRow(others[index]).animate().fadeIn(delay: (200 + index * 50).ms).slideX(begin: 0.1, end: 0);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumUser(Map<String, dynamic> user, int rank, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [user['color'] as Color, (user['color'] as Color).withOpacity(0.5)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  boxShadow: [BoxShadow(color: (user['color'] as Color).withOpacity(0.5), blurRadius: 15)],
                ),
                child: CircleAvatar(
                  radius: rank == 1 ? 40 : 32,
                  backgroundColor: AppColors.surfaceDark,
                  child: Text(
                    (user['name'] as String)[0],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: rank == 1 ? 24 : 18),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: user['color'] as Color,
              child: Text('$rank', style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(user['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Text('${user['xp']} XP', style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildLeaderboardRow(Map<String, dynamic> user) {
    final bool isMe = user['isMe'] == true;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: isMe ? AppColors.accent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
      borderColor: isMe ? AppColors.accent.withOpacity(0.5) : Colors.transparent,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text('${user['rank']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isMe ? Colors.white : Colors.white54)),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: isMe ? AppColors.accent : Colors.white.withOpacity(0.1),
            child: Text((user['name'] as String)[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'] as String, style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.w600, color: Colors.white)),
                Text('Niveau ${user['level']}', style: const TextStyle(fontSize: 12, color: Colors.white54)),
              ],
            ),
          ),
          Text('${user['xp']} XP', style: TextStyle(fontWeight: FontWeight.bold, color: isMe ? AppColors.accent : Colors.white70)),
        ],
      ),
    );
  }
}