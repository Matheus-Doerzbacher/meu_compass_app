import 'package:flutter/material.dart';
import 'package:meu_compass_app/ui/auth/login/view_models/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    required this.viewModel,
  });

  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
    );
  }
}
