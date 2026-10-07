import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:nexora/data/consts/app_colors.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;
  bool _googleInitialized = false;

  final String adminEmail = 'nexora@gmail.com';
  final String googleAdminEmail = 'bibka2601@gmail.com';

  @override
  void initState() {
    super.initState();
    _initializeGoogle();
  }

  Future<void> _initializeGoogle() async {
    if (kIsWeb) return;

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      try {
        await GoogleSignIn.instance.initialize();
        _googleInitialized = true;
      } catch (e) {
        _googleInitialized = false;
      }
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _loginWithPassword() async {
    final email = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Введите логин и пароль');
      return;
    }

    if (email.toLowerCase() != adminEmail) {
      _showMessage('Этот аккаунт не является администратором');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminPanelPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Ошибка входа';

      if (e.code == 'invalid-credential') {
        message = 'Неверный логин или пароль';
      } else if (e.code == 'user-not-found') {
        message = 'Пользователь не найден';
      } else if (e.code == 'wrong-password') {
        message = 'Неверный пароль';
      } else if (e.code == 'invalid-email') {
        message = 'Неверный email';
      } else if (e.code == 'too-many-requests') {
        message = 'Слишком много попыток. Попробуйте позже';
      }

      _showMessage(message);
    } catch (e) {
      _showMessage('Произошла ошибка');
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    // Windows не поддерживает google_sign_in
    if (!kIsWeb &&
        defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      _showMessage(
        'Google вход на Windows не поддерживается. Откройте Nexora в Chrome.',
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      UserCredential userCredential;

      // Вход через Google в браузере
      if (kIsWeb) {
        final provider = GoogleAuthProvider();

        userCredential = await FirebaseAuth.instance.signInWithPopup(
          provider,
        );
      } else {
        // Вход через Google на Android / iPhone / Mac
        if (!_googleInitialized) {
          _showMessage('Google авторизация не инициализирована');

          setState(() {
            _loading = false;
          });

          return;
        }

        final GoogleSignInAccount googleUser =
            await GoogleSignIn.instance.authenticate();

        final GoogleSignInAuthentication googleAuth =
            googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        userCredential =
            await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }

      final user = userCredential.user;

      if (user == null) {
        _showMessage('Не удалось получить данные пользователя');
        return;
      }

      // Разрешён только твой Google аккаунт
      if (user.email?.toLowerCase() != googleAdminEmail) {
        await FirebaseAuth.instance.signOut();

        _showMessage(
          'Этот Google-аккаунт не имеет доступа к админке',
        );

        return;
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminPanelPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(
        'Ошибка Google: ${e.message ?? e.code}',
      );
    } catch (e) {
      _showMessage('Не удалось войти через Google');
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF4412A7),
          ),
        ),

        title: const Text(
          'Администратор',
          style: TextStyle(
            color: Color(0xFF4412A7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Container(
            width: 430,
            padding: const EdgeInsets.all(32),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Nexora',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4412A7),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Панель администратора',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Войдите в аккаунт администратора',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: _loginController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    labelText: 'Логин',
                    hintText: 'Введите email',

                    prefixIcon: const Icon(
                      Icons.person_outline,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,

                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    hintText: 'Введите пароль',

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },

                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : _loginWithPassword,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4412A7),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Войти',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),

                      child: Text(
                        'или',

                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 52,

                  child: OutlinedButton(
                    onPressed: _loading
                        ? null
                        : _loginWithGoogle,

                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text(
                          'G',

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4412A7),
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          'Продолжить с Google',

                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Защищено Firebase Authentication',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// =====================================================
// ПАНЕЛЬ АДМИНИСТРАТОРА
// =====================================================

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Nexora Admin',

          style: TextStyle(
            color: Color(0xFF4412A7),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.pop(context);
              }
            },

            icon: const Icon(
              Icons.logout,
              color: Color(0xFF4412A7),
            ),
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.admin_panel_settings_outlined,
                size: 80,
                color: Color(0xFF4412A7),
              ),

              const SizedBox(height: 20),

              const Text(
                'Добро пожаловать!',

                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4412A7),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Панель администратора Nexora',

                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                user?.email ?? '',

                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Вы успешно вошли в систему.',

                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}