import 'package:flutter/material.dart';
import 'package:ssma_app/pb.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surface),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Signing you in...',
                      )
                    ],
                  )),
            ));
    try {
      final userAuth = await pb
          .collection('users')
          .authWithPassword(usernameController.text, passwordController.text);
      pb.authStore.save(pb.authStore.token, pb.authStore.model);
      if (mounted) {
        Navigator.of(context).pop();
      }
      debugPrint(userAuth.toString());
    } catch (error) {
      debugPrint('Error: $error');
      if (mounted) {
        Navigator.of(context).pop();
      }
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
                hintText: 'Username/Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username/email';
                }
                return null;
              },
              autocorrect: false,
              controller: usernameController,
              textInputAction: TextInputAction.next,
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
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  signInMethod();
                }
              },
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _file = File(image!.path);
    });
  }

  Future<void> signUpMethod() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(
              child: Container(
                  margin: EdgeInsets.all(20),
                  color: Theme.of(context).colorScheme.primary,
                  child: CircularProgressIndicator()),
            ));
    try {
      final user = await pb.collection('users').create(body: {
        'username': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'name': nameController.text,
        'passwordConfirm': passwordConfirmController.text,
        'isBot': isBot,
      }, files: [
        http.MultipartFile.fromBytes(
          'avatar',
          _file!.readAsBytesSync(),
          filename: _file!.path.split('/').last,
        )
      ]);
      await pb.collection('users').authWithPassword(
            usernameController.text,
            passwordController.text,
          );
      pb.authStore.save(pb.authStore.token, pb.authStore.model);
      if (mounted) {
        Navigator.of(context).pop();
      }
      debugPrint(user.toString());
    } catch (error) {
      debugPrint('Error: $error');
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormField(
            validator: (value) {
              if (_file == null) {
                return 'Please enter an avatar';
              }
              return null;
            },
            builder: (field) => GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: Stack(
                children: [
                  _file != null
                      ? CircleAvatar(
                          radius: 45,
                          foregroundImage: FileImage(
                            _file!,
                          ))
                      : Icon(Icons.account_circle,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.add_circle,
                        size: 30,
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "Welcome!",
              style: TextStyle(fontSize: 30),
            ),
          ),
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
              textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.next,
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
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  signUpMethod();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
                onPressed: () {
                  signUpMethod();
                },
                child: const Text("Sign Up")),
          )
        ],
      ),
    );
  }
}
