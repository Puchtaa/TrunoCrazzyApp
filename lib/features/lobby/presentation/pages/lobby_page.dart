import 'package:flutter/material.dart';

import '../../../game/domain/entities/game_state.dart';
import '../../../game/domain/inputs/create_game_input.dart';
import '../controllers/lobby_controller.dart';
import '../states/lobby_state.dart';
import 'create_game_page.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({
    super.key,
    required this.controller,
    required this.onGameReady,
  });

  final LobbyController controller;
  final void Function(GameState game) onGameReady;

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final _code = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void didUpdateWidget(covariant LobbyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller
        ..removeListener(_onChange)
        ..dispose();
      widget.controller.addListener(_onChange);
    }
  }

  @override
  void dispose() {
    widget.controller
      ..removeListener(_onChange)
      ..dispose();
    _code.dispose();
    super.dispose();
  }

  void _onChange() {
    final state = widget.controller.state;
    if (state.status == LobbyStatus.success && state.game != null) {
      widget.onGameReady(state.game!);
      widget.controller.reset();
    }
  }

  void _join() {
    widget.controller.access(_code.text);
  }

  Future<void> _create() async {
    final input = await Navigator.of(context).push<CreateGameInput>(
      MaterialPageRoute(builder: (_) => const CreateGamePage()),
    );
    if (input == null || !mounted) return;
    widget.controller.create(input);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final state = widget.controller.state;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FilledButton(
                onPressed: state.isLoading ? null : _create,
                child: const Text('Criar partida'),
              ),
              const Divider(height: 32),
              TextField(
                controller: _code,
                enabled: !state.isLoading,
                maxLength: 6,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _join(),
                decoration: const InputDecoration(
                  labelText: 'Código da partida',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: state.isLoading ? null : _join,
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Entrar'),
              ),
              if (state.status == LobbyStatus.failure) ...[
                const SizedBox(height: 12),
                Text(
                  state.error?.message ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
