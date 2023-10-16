import 'package:flutter/material.dart';
import 'package:ssma_app/pb.dart';

class RegisterLoginToggle extends StatefulWidget {
  const RegisterLoginToggle({super.key});

  @override
  State<RegisterLoginToggle> createState() => _RegisterLoginToggleState();
}

class _RegisterLoginToggleState extends State<RegisterLoginToggle> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePage,
      );
    } else {
      return RegisterPage(
        onTap: togglePage,
      );
    }
  }
}

// Login and Register pages

// Login page. TODO: document login page in comments

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(Icons.account_circle_outlined,
                  size: 100, color: Colors.black),
              const SizedBox(height: 50),
              _SignInForm(),
              GestureDetector(
                  onTap: widget.onTap,
                  child: const Text('Sign Up?',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
    );
  }
}

// Register page. TODO: document register page in comments

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(Icons.add_circle_outline_outlined,
                  size: 100, color: Colors.black),
              const SizedBox(height: 50),
              GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Sign In?',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  State<_SignInForm> createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signInMethod() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final userAuth = await pb
          .collection('users')
          .authWithPassword(usernameController.text, passwordController.text);
      if (mounted) {
        pb.authStore.save(pb.authStore.token, pb.authStore.model);
        Navigator.of(context).pop();
      }
      debugPrint(userAuth.toString());
    } catch (error) {
      debugPrint('Error: $error');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
              autocorrect: false,
              controller: usernameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              autocorrect: false,
              obscureText: true,
              controller: passwordController,
            ),
          ),
          ElevatedButton(onPressed: signInMethod, child: const Text('Sign In'))
        ],
      ),
    );
  }
}
