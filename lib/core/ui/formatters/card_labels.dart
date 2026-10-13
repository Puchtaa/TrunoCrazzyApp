import 'package:flutter/material.dart';

import '../../../features/game/domain/enums/card_suit.dart';
import '../../../features/game/domain/enums/card_value.dart';

extension CardSuitLabel on CardSuit {
  String get symbol => switch (this) {
        CardSuit.ouros => '♦',
        CardSuit.espadas => '♠',
        CardSuit.copas => '♥',
        CardSuit.paus => '♣',
      };

  String get label => switch (this) {
        CardSuit.ouros => 'Ouros',
        CardSuit.espadas => 'Espadas',
        CardSuit.copas => 'Copas',
        CardSuit.paus => 'Paus',
      };

  Color get color =>
      (this == CardSuit.ouros || this == CardSuit.copas) ? Colors.red : Colors.black;
}

extension CardValueLabel on CardValue {
  String get symbol => switch (this) {
        CardValue.as => 'A',
        CardValue.dois => '2',
        CardValue.tres => '3',
        CardValue.quatro => '4',
        CardValue.cinco => '5',
        CardValue.seis => '6',
        CardValue.sete => '7',
        CardValue.dama => 'Q',
        CardValue.valete => 'J',
        CardValue.rei => 'K',
      };
}
