import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String googleAdminEmail = 'kuakpai@gmail.com';

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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
        MaterialPageRoute(builder: (context) => const AdminPanelPage()),
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

        userCredential = await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        // Вход через Google на Android / iPhone / Mac
        if (!_googleInitialized) {
          _showMessage('Google авторизация не инициализирована');

          setState(() {
            _loading = false;
          });

          return;
        }

        final GoogleSignInAccount googleUser = await GoogleSignIn.instance
            .authenticate();

        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
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

        _showMessage('Этот Google-аккаунт не имеет доступа к админке');

        return;
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminPanelPage()),
      );
    } on FirebaseAuthException catch (e) {
      _showMessage('Ошибка Google: ${e.message ?? e.code}');
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4412A7)),
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
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 430),
            padding: EdgeInsets.all(
              MediaQuery.sizeOf(context).width < 600 ? 20 : 32,
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
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

                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                Text(
                  'Войдите в аккаунт администратора',
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: _loginController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    labelText: 'Логин',
                    hintText: 'Введите email',

                    prefixIcon: const Icon(Icons.person_outline),

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

                    prefixIcon: const Icon(Icons.lock_outline),

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
                    onPressed: _loading ? null : _loginWithPassword,

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
                    Expanded(child: Divider(color: Colors.grey.shade300)),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),

                      child: Text(
                        'или',

                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),

                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 52,

                  child: OutlinedButton(
                    onPressed: _loading ? null : _loginWithGoogle,

                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),

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
                            fontSize: 17,
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

                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  static const Color _purple = Color(0xFF4412A7);
  static const Color _pageBackground = Color(0xFFF7F7FA);
  final Set<String> _updatingOrderIds = {};

  Stream<QuerySnapshot<Map<String, dynamic>>> get _ordersStream =>
      FirebaseFirestore.instance.collection('orders').snapshots();

  Future<void> _acceptOrder(String orderId) async {
    setState(() => _updatingOrderIds.add(orderId));

    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
            'status': 'accepted',
            'acceptedAt': FieldValue.serverTimestamp(),
            'acceptedBy': FirebaseAuth.instance.currentUser?.email,
          });
      _showMessage('Заказ принят');
    } catch (_) {
      _showMessage('Не удалось принять заказ');
    } finally {
      if (mounted) {
        setState(() => _updatingOrderIds.remove(orderId));
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _value(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return '';
  }

  DateTime _createdAt(Map<String, dynamic> data) {
    final value = data['createdAt'];
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _formatDate(DateTime date) {
    if (date.millisecondsSinceEpoch == 0) return 'Дата не указана';
    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$day.$month.${localDate.year}, $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Nexora Admin',
          style: TextStyle(color: _purple, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Выйти',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.logout, color: _purple),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _ordersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildState(
                      icon: Icons.cloud_off_outlined,
                      title: 'Не удалось загрузить заказы',
                      message:
                          'Проверьте подключение к Firebase и права доступа.',
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: _purple),
                    );
                  }

                  final orders = [...snapshot.data!.docs]
                    ..sort(
                      (first, second) => _createdAt(
                        second.data(),
                      ).compareTo(_createdAt(first.data())),
                    );
                  final pendingCount = orders
                      .where((order) => order.data()['status'] != 'accepted')
                      .length;
                  final acceptedCount = orders.length - pendingCount;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Заказы клиентов',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF201A29),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  FirebaseAuth.instance.currentUser?.email ??
                                      '',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Обновить список',
                            onPressed: () => setState(() {}),
                            icon: const Icon(Icons.refresh, color: _purple),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 520;
                          final cards = [
                            _buildSummaryCard(
                              label: 'Ожидают принятия',
                              count: pendingCount,
                              icon: Icons.pending_actions_outlined,
                              color: const Color(0xFFB36A00),
                            ),
                            _buildSummaryCard(
                              label: 'Приняты',
                              count: acceptedCount,
                              icon: Icons.check_circle_outline,
                              color: const Color(0xFF26734D),
                            ),
                          ];
                          if (compact) {
                            return Column(
                              children: [
                                cards[0],
                                const SizedBox(height: 12),
                                cards[1],
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(child: cards[0]),
                              const SizedBox(width: 14),
                              Expanded(child: cards[1]),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Все заказы',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: orders.isEmpty
                            ? _buildState(
                                icon: Icons.inbox_outlined,
                                title: 'Заказов пока нет',
                                message:
                                    'Новые заявки из коллекции orders появятся здесь.',
                              )
                            : ListView.separated(
                                itemCount: orders.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) =>
                                    _buildOrderCard(orders[index]),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8E5ED)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(QueryDocumentSnapshot<Map<String, dynamic>> order) {
    final data = order.data();
    final accepted = data['status'] == 'accepted';
    final name = _value(data, ['clientName', 'customerName', 'name']);
    final service = _value(data, ['services', 'service', 'serviceName', 'title']);
    final email = _value(data, ['email', 'clientEmail']);
    final phone = _value(data, ['phone', 'clientPhone']);
    final companyName = _value(data, ['companyName']);
    final message = _value(data, ['message', 'description', 'details']);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8E5ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name.isEmpty ? 'Клиент' : name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _statusLabel(accepted),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            service.isEmpty ? 'Услуга не указана' : service,
            style: const TextStyle(color: _purple, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          if (email.isNotEmpty) _orderDetail(Icons.email_outlined, email),
          if (phone.isNotEmpty) _orderDetail(Icons.phone_outlined, phone),
          if (companyName.isNotEmpty)
            _orderDetail(Icons.business_outlined, 'Компания: $companyName'),
          if (message.isNotEmpty) _orderDetail(Icons.notes_outlined, message),
          _orderDetail(Icons.schedule_outlined, _formatDate(_createdAt(data))),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                onPressed: accepted || _updatingOrderIds.contains(order.id)
                    ? null
                    : () => _acceptOrder(order.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: accepted
                      ? const Color(0xFFE9E5F0)
                      : _purple.withOpacity(0.65),
                  disabledForegroundColor: accepted ? _purple : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: _updatingOrderIds.contains(order.id)
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(accepted ? Icons.check : Icons.done, size: 18),
                label: Text(accepted ? 'Принят' : 'Принять заказ'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }

  Widget _statusLabel(bool accepted) {
    final color = accepted ? const Color(0xFF26734D) : const Color(0xFF9A5B00);
    final background = accepted
        ? const Color(0xFFE8F4ED)
        : const Color(0xFFFFF3DF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        accepted ? 'Принят' : 'Новый',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade500),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}


