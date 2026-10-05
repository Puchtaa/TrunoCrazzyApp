import 'package:flutter/material.dart';

import '../controllers/profile_controller.dart';
import '../state/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.controller,
    required this.onLogout,
  });

  final ProfileController controller;
  final Future<void> Function() onLogout;

  @override
  State<ProfilePage> createState() => _ProfilePageState(); 
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    widget.controller.refresh();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final state = widget.controller.state;
          return RefreshIndicator(
            onRefresh: widget.controller.refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(state.session.user.nickname),
                    subtitle: Text('ID ${state.session.user.id}'),
                  ),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            '${state.points} pontos',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(state.hasPosition
                              ? '${state.position}º no ranking'
                              : 'Posição indisponível'),
                        ],
                      ),
                    ),
                  ),

                  if (state.isLoading) const LinearProgressIndicator(),
                  if (state.status == ProfileStatus.failure) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.error?.message ?? '',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    TextButton(
                      onPressed: widget.controller.refresh,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
              ],
            ),
          );

        },
      ),
    );
  }

}