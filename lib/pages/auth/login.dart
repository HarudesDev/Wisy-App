import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/repositories/firebase_auth_repository.dart';
import 'package:wisy/shared/style.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
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
                            : Icons.visibility))),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.pink[400]),
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
                height: 12.0,
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
        ),
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
}
