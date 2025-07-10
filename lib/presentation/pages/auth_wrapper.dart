import 'package:app_ventas/application/auth_provider.dart';
import 'package:app_ventas/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_ventas/auth/login_page.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    if (user != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
