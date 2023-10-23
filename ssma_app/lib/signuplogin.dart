import 'package:flutter/material.dart';
import 'package:ssma_app/pb.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
              Icon(
              Icons.account_circle,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              _SignInForm(),
              const SizedBox(height: 18),
              GestureDetector(
                  onTap: widget.onTap,
                  child: Text('Sign Up?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold))),
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
              GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    Icon(Icons.account_circle,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Icon(Icons.add_circle,
                          size: 30,
                          color: Theme.of(context).colorScheme.secondary),
                    )
                  ],
                ),
              ),
              _SignUpForm(),
              GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Sign In?',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  signInMethod();
                }
              },
              child: const Text('Sign In'),
            ),
          )
        ],
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override
  State<_SignUpForm> createState() => __SignUpFormState();
}

class __SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final isBot = bool;
  File? _file;

  Future<void> signUpMethod() async {
    try {
      final user = await pb.collection('users').create(body: {
        'username': usernameController,
        'password': passwordController,
        'email': emailController,
        'avatar': _file,
        'name': nameController,
        'confirmPassword': passwordConfirmController,
        'isBot': isBot,
      });
      if (pb.authStore.isValid != false) {
        pb.authStore.save(pb.authStore.token, pb.authStore.model);
      }
      debugPrint(user.toString());
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              autocorrect: false,
              controller: nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              autocorrect: false,
              controller: emailController,
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Confirm Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                return null;
              },
              autocorrect: false,
              obscureText: true,
              controller: passwordConfirmController,
            ),
          ),
        ],
      ),
    );
  }
}
