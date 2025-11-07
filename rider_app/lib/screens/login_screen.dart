import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import 'assignments_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rider Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            state.maybeWhen(
              authenticated: (_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AssignmentsScreen()),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final loading = state.maybeWhen(loading: () => true, orElse: () => false);
            final error = state.maybeWhen(failure: (m) => m, orElse: () => null);
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  if (error != null) Text(error, style: const TextStyle(color: Colors.red)),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthEvent.loginRequested(
                                    email: _email.text.trim(),
                                    password: _password.text,
                                  ));
                            }
                          },
                    child: loading ? const CircularProgressIndicator() : const Text('Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
