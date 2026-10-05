import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../game/domain/inputs/create_game_input.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _roundReward = TextEditingController(text: '10');
  final _emptyHandReward = TextEditingController(text: '5');
  final _trophyPrice = TextEditingController(text: '30');
  int _maxPlayers = 4;
  int _initialCards = 3;

  @override
  void dispose() {
    _name.dispose();
    _roundReward.dispose();
    _emptyHandReward.dispose();
    _trophyPrice.dispose();
    super.dispose();
  }

  String? _nonNegative(String? value) {
    final number = int.tryParse(value ?? '');
    return number == null || number < 0
        ? 'Informe um número maior ou igual a 0'
        : null;
  }

  String? _positive(String? value) {
    final number = int.tryParse(value ?? '');
    return number == null || number <= 0
        ? 'Informe um número maior que 0'
        : null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final input = CreateGameInput(
      name: _name.text.trim(),
      maxPlayers: _maxPlayers,
      initialCards: _initialCards,
      roundReward: int.parse(_roundReward.text),
      emptyHandReward: int.parse(_emptyHandReward.text),
      trophyPrice: int.parse(_trophyPrice.text),
    );
    Navigator.of(context).pop(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova partida')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _name,
                maxLength: 60,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome da partida',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final name = value?.trim() ?? '';
                  if (name.isEmpty) return 'Informe o nome da partida';
                  if (name.length > 60) {
                    return 'O nome deve ter no máximo 60 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _maxPlayers,
                decoration: const InputDecoration(
                  labelText: 'Máximo de jogadores',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final count in List.generate(5, (index) => index + 2))
                    DropdownMenuItem(value: count, child: Text('$count')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _maxPlayers = value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _initialCards,
                decoration: const InputDecoration(
                  labelText: 'Cartas iniciais',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final count in List.generate(10, (index) => index + 1))
                    DropdownMenuItem(value: count, child: Text('$count')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _initialCards = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roundReward,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Recompensa por rodada',
                  border: OutlineInputBorder(),
                ),
                validator: _nonNegative,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emptyHandReward,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Recompensa por mão vazia',
                  border: OutlineInputBorder(),
                ),
                validator: _nonNegative,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _trophyPrice,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Preço do troféu',
                  border: OutlineInputBorder(),
                ),
                validator: _positive,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _submit, child: const Text('Criar')),
            ],
          ),
        ),
      ),
    );
  }
}
