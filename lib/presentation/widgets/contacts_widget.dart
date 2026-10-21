import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderRequestWidget extends StatefulWidget {
  const OrderRequestWidget({super.key});

  @override
  State<OrderRequestWidget> createState() => _OrderRequestWidgetState();
}

class _OrderRequestWidgetState extends State<OrderRequestWidget> {
  final Color purple = const Color(0xFF4412A7);
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final List<String> _services = const [
    'Web-разработка',
    'Mobile-разработка',
    'Разработка игр',
    'Машинное обучение',
  ];
  String? _selectedService;
  bool _isCompany = false;
  bool _submitting = false;
  bool _submitted = false;
  Future<DocumentReference<Map<String, dynamic>>>? _pendingOrder;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (_submitted) return;
    if (_pendingOrder == null && !_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      _pendingOrder ??= FirebaseFirestore.instance.collection('orders').add({
        'services': _selectedService,
        'clientType': _isCompany ? 'company' : 'individual',
        'clientName':
            '${_nameController.text.trim()} ${_lastNameController.text.trim()}',
        'firstName': _nameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'companyName': _isCompany ? _companyNameController.text.trim() : '',
        'phone': _phoneController.text.trim(),
        'message': _messageController.text.trim(),
        'status': 'new',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _pendingOrder!.timeout(const Duration(seconds: 12));

      if (!mounted) return;
      _pendingOrder = null;
      _formKey.currentState!.reset();
      _nameController.clear();
      _lastNameController.clear();
      _companyNameController.clear();
      _phoneController.clear();
      _messageController.clear();
      setState(() {
        _selectedService = null;
        _isCompany = false;
        _submitted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заявка отправлена. Мы скоро свяжемся с вами.'),
        ),
      );
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Сервер пока не ответил. Проверьте соединение и нажмите '
            '«Проверить отправку»; повторный заказ не создаётся.',
          ),
          duration: Duration(seconds: 6),
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ошибка Firebase (${error.code}): '
            '${error.message ?? 'не удалось отправить заявку.'}',
          ),
          duration: const Duration(seconds: 10),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      _pendingOrder = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Не удалось отправить заявку. Проверьте интернет и настройки Firebase.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 35,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: _selectedService,
                    decoration: _inputDecoration(
                      'Нужная услуга',
                      Icons.work_outline,
                    ),
                    items: _services
                        .map(
                          (service) => DropdownMenuItem(
                            value: service,
                            child: Text(service),
                          ),
                        )
                        .toList(),
                    onChanged: _submitting || _submitted || _pendingOrder != null
                        ? null
                        : (value) => setState(() => _selectedService = value),
                    validator: (value) =>
                        value == null ? 'Выберите услугу' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    enabled: !_submitting && !_submitted && _pendingOrder == null,
                    decoration: _inputDecoration(
                      'Номер телефона',
                      Icons.phone_outlined,
                    ).copyWith(hintText: '+7 900 000-00-00'),
                    validator: (value) {
                      final digits = (value ?? '').replaceAll(
                        RegExp(r'\D'),
                        '',
                      );
                      if (digits.length < 10 || digits.length > 15) {
                        return 'Введите корректный номер телефона';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _nameController,
                    enabled: !_submitting && !_submitted && _pendingOrder == null,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration('Имя *', Icons.person_outline),
                    validator: (value) =>
                        (value ?? '').trim().isEmpty ? 'Укажите имя' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _lastNameController,
                    enabled: !_submitting && !_submitted && _pendingOrder == null,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration(
                      'Фамилия *',
                      Icons.person_outline,
                    ),
                    validator: (value) =>
                        (value ?? '').trim().isEmpty ? 'Укажите фамилию' : null,
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Представляю компанию'),
                    value: _isCompany,
                    activeColor: purple,
                    onChanged: _submitting || _submitted || _pendingOrder != null
                        ? null
                        : (value) =>
                              setState(() => _isCompany = value ?? false),
                  ),
                  if (_isCompany) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _companyNameController,
                      enabled: !_submitting && !_submitted && _pendingOrder == null,
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration(
                        'Название компании *',
                        Icons.business_outlined,
                      ),
                      validator: (value) =>
                          _isCompany && (value ?? '').trim().isEmpty
                          ? 'Укажите название компании'
                          : null,
                    ),
                  ],
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _messageController,
                    enabled: !_submitting && !_submitted && _pendingOrder == null,
                    maxLines: 3,
                    decoration: _inputDecoration(
                      'Комментарий',
                      Icons.notes_outlined,
                    ).copyWith(hintText: 'Расскажите немного о проекте'),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _submitting || _submitted ? null : _submitOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: purple.withOpacity(0.65),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      icon: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              _submitted
                                  ? Icons.check_circle_outline
                                  : Icons.send_outlined,
                              size: 18,
                            ),
                      label: Text(
                        _submitting
                            ? 'Проверяем...'
                            : _submitted
                            ? 'Заявка отправлена'
                            : _pendingOrder != null
                            ? 'Проверить отправку'
                            : 'Отправить заявку',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: purple),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFE5E1EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF4412A7), width: 1.5),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF1EBFF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.mail_outline, color: purple, size: 27),
        ),

        const SizedBox(width: 17),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Оставить заявку',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Выберите услугу и укажите контактные данные',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.close, size: 19, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class ContactsWidget extends StatelessWidget {
  const ContactsWidget({super.key});

  static const Color _purple = Color(0xFF4412A7);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 35,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Свяжитесь с нами',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Выберите удобный способ связи',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Закрыть',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _contactMethod(
                  icon: Icons.send_outlined,
                  title: 'Telegram',
                  subtitle: 'Открыть группу в Telegram',
                  onTap: () {
                    _openContact(
                      context,
                      'https://t.me/NexoraOrderGroup',
                    );
                  },
                ),
                const SizedBox(height: 10),
                _contactMethod(
                  icon: Icons.chat_bubble_outline,
                  title: 'WhatsApp',
                  subtitle: 'Вступить в группу WhatsApp',
                  onTap: () {
                    _openContact(
                      context,
                      'https://chat.whatsapp.com/CX0VNSLpBwuDzWIfK8E32o?s=sh&p=a&mlu=4&ilr=4',
                    );
                  },
                ),
                const SizedBox(height: 10),
                _contactMethod(
                  icon: Icons.phone_outlined,
                  title: 'Телефон',
                  subtitle: '+77004168500',
                  onTap: () => _openContact(context, 'tel:+77004168500'),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Мы ответим на ваше сообщение и обсудим ваш проект',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openContact(BuildContext context, String url) async {
    try {
      final opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку.')),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку.')),
      );
    }
  }

  Widget _contactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: _purple, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


