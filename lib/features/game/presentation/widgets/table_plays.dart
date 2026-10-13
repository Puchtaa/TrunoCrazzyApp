import 'package:flutter/material.dart';

import '../../../../core/ui/formatters/card_labels.dart';
import '../../domain/entities/game_play.dart';

class TablePlays extends StatelessWidget {
  const TablePlays({super.key, required this.plays});

  final List<GamePlay> plays;

  @override
  Widget build(BuildContext context) {
    final sorted = [...plays]..sort((a, b) => a.order.compareTo(b.order));

    if (sorted.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Ainda não houve jogadas nesta rodada.'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          for (final play in sorted)
            SizedBox(
              width: 88,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    play.nickname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 70,
                    height: 100,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              play.card.valor.symbol,
                              style: TextStyle(
                                fontSize: 20,
                                color: play.card.naipe.color,
                              ),
                            ),
                            const Spacer(),
                            Center(
                              child: Text(
                                play.card.naipe.symbol,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: play.card.naipe.color,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (play.card.skill != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        play.card.skill!.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
