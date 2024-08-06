import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/pages/auth/authenticate.dart';
import 'package:wisy/pages/home/home.dart';
import 'package:wisy/providers/auth_provider.dart';
import 'package:wisy/shared/loading.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return authState.when(
        data: (user) {
          return user != null ? const Home() : const Authenticate();
        },
        error: (error, stack) => Text('Error:$error'),
        loading: () => const Loading());
  }
}
