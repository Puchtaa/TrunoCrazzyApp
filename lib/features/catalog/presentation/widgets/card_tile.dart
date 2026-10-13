import 'package:flutter/material.dart';

import '../../../../core/ui/formatters/card_labels.dart';
import '../../../game/domain/enums/card_suit.dart';
import '../../../game/domain/enums/card_value.dart';

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.valor,
    required this.naipe,
    this.onTap,
  });

  final CardValue valor;
  final CardSuit naipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = naipe.color;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(valor.symbol, style: TextStyle(fontSize: 22, color: color)),
              const Spacer(),
              Center(
                child: Text(
                  naipe.symbol,
                  style: TextStyle(fontSize: 32, color: color),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
