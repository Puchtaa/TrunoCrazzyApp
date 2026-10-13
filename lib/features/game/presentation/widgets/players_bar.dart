import 'package:flutter/material.dart';

import '../../domain/entities/game_player.dart';

class PlayersBar extends StatelessWidget {
  const PlayersBar({
    super.key,
    required this.players,
    required this.currentPlayerId,
    required this.myId,
  });

  final List<GamePlayer> players;
  final int? currentPlayerId;
  final int? myId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: players.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final p = players[index];
          final isCurrent = p.id == currentPlayerId;
          final isMe = p.id == myId;

          return SizedBox(
            width: 130,
            child: Card(
              color: isCurrent ? scheme.primaryContainer : null,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMe ? '${p.nickname} (você)' : p.nickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('🪙 ${p.matchCoins}'),
                    Text('🏆 ${p.trophies}'),
                    Text('🃏 ${p.handSize}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
