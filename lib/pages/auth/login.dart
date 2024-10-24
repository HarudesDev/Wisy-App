import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';
import 'package:wisy/shared/exceptions.dart';
import 'package:wisy/shared/style.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_button/sign_in_button.dart';

part 'login.g.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key, required this.toggleView});

  final Function toggleView;

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      loginControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, _) {
          if (error is GenericException) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.message)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Sucedió un error durante el proceso')),
            );
          }
        },
        data: (data) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ingreso Exitoso")),
          );
        },
      ),
    );

    final AsyncValue<void> state = ref.watch(loginControllerProvider);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Registrar'),
            onPressed: () {
              widget.toggleView();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Wisy",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 50.0,
            ),
            decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'email'),
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
                        decoration: textInputDecoration.copyWith(
                          hintText: 'contraseña',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _visiblePassword = !_visiblePassword;
                              });
                            },
                            icon: Icon(_visiblePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        validator: (value) => value!.length < 6
                            ? 'Ingrese una contraseña de más de 6 caracteres'
                            : null,
                        obscureText: !_visiblePassword,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(buttonColor),
                          minimumSize: MaterialStatePropertyAll(Size(350, 50)),
                        ),
                        child: state.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Ingresar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(loginControllerProvider.notifier)
                                .signInWithEmailAndPassword(email, password);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      const Text(
                        "Olvidaste tu contraseña?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 94, 94, 94),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      SignInButton(
                        Buttons.google,
                        text: "Ingresar con Google",
                        onPressed: () async {
                          ref
                              .read(loginControllerProvider.notifier)
                              .signInWithGoogle();
                        },
                      ),
                      Text(
                        state.error != null ? state.error.toString() : "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(
        () => authRepository.signInWithEmailAndPassword(email, password));
  }

  Future<void> signInWithGoogle() async {
    final authRepository = ref.read(firebaseAuthRepositoryProvider);

    final userCredential =
        await AsyncValue.guard(() => authRepository.signInWithGoogle());

    log(userCredential.toString());
  }
}
