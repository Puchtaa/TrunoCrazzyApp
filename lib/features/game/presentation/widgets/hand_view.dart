import 'package:flutter/material.dart';

import '../../../../core/ui/formatters/card_labels.dart';
import '../../domain/entities/game_card.dart';

class HandView extends StatelessWidget {
  const HandView({
    super.key,
    required this.hand,
    required this.enabled,
    required this.onPlay,
  });

  final List<GameCard> hand;
  final bool enabled;
  final void Function(int handCardId) onPlay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: hand.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final card = hand[index];
          final canPlay = enabled && card.handCardId != null;

          return SizedBox(
            width: 82,
            child: Opacity(
              opacity: canPlay ? 1 : 0.55,
              child: Card(
                child: InkWell(
                  onTap: canPlay ? () => onPlay(card.handCardId!) : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.valor.symbol,
                          style: TextStyle(
                            fontSize: 20,
                            color: card.naipe.color,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Text(
                            card.naipe.symbol,
                            style: TextStyle(
                              fontSize: 30,
                              color: card.naipe.color,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
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
