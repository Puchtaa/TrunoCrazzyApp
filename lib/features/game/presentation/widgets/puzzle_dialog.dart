import 'package:flutter/material.dart';

import '../../domain/entities/pending_puzzle.dart';
import '../controllers/game_controller.dart';

Future<void> showPuzzleDialog(
  BuildContext context,
  PendingPuzzle puzzle,
  GameController controller,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => SimpleDialog(
      title: Text(puzzle.question),
      children: [
        for (var i = 0; i < puzzle.alternatives.length; i++)
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              controller.answerPuzzle(puzzle.challengeId, i);
            },
            child: Text(puzzle.alternatives[i]),
          ),
      ],
    ),
  );
}
