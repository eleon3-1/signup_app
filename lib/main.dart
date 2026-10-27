import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 🧓 Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const _tipCategory = 'password_help';

  static const _presetTips = <String, String>{
    'password_help': 'Use a ling and unique password for the account',
    'account_help': 'Dont lose your email for recovery',
    'privacy_help': 'Dont share your password',
  };

  bool _loadingTip = false;
  bool _failNextTip = false;
  String? _tipText;
  String? _tipError;

  Future<void> _getSignupTip() async {
    if (_loadingTip) return;

    final shouldFail = _failNextTip;

    setState(() {
      _loadingTip = true;
      _tipText = null;
      _tipError = null;
      _failNextTip = false;
    });

    await Future<void>.delayed(const Duration(seconds: 1), () {});

    if (!mounted) return;

    final tip = _presetTips[_tipCategory];

    setState(() {
      _loadingTip = false;

      if (shouldFail) {
        _tipError = 'Simulated tip error. Tap Retry.';
      } else if (tip == null || tip.trim().isEmpty || tip.length > 240) {
        _tipError = 'No valid preset tip is available.';
      } else {
        _tipText = tip;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👨 Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // 👶 Child
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 🚀 Sign Up Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Demo signup complete — your form passed validation!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 24),
              const Divider(),

              const Text(
                'Preset demo tip—not live AI.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Simulate next tip error'),
                value: _failNextTip,
                onChanged: _loadingTip
                    ? null
                    : (value) {
                        setState(() {
                          _failNextTip = value;
                        });
                      },
              ),

              OutlinedButton(
                onPressed: _loadingTip ? null : _getSignupTip,
                child: Text(
                  _loadingTip ? 'Loading tip.' : 'Get a signup tip',
                ),
              ),

              if (_loadingTip)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),

              if (_tipText != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(_tipText!),
                ),

              if (_tipError != null) ...[
                Text(_tipError!, style: const TextStyle(color: Colors.red)),
                TextButton(
                  onPressed: _loadingTip ? null : _getSignupTip,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
