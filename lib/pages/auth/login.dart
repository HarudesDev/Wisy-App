import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';
import 'package:wisy/shared/style.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key, required this.toggleView});

  final Function toggleView;

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false; 

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(firebaseAuthRepositoryProvider);
    
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Iniciar Sesión'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Registrar'),
            onPressed: () {
              widget.toggleView();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'email'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un email' : null,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'contraseña'),
                validator: (value) => value!.length < 6
                    ? 'Ingrese una contraseña de más de 6 caracteres'
                    : null,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.pink[400]),
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    dynamic result =
                        await authService.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() =>
                          error = 'Datos de ingreso inválidos o incorrectos');
                    }
                  }
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
