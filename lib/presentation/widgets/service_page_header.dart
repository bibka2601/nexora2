import 'package:flutter/material.dart';
import 'package:nexora/presentation/widgets/contacts_widget.dart';

class ServicePageHeader extends StatelessWidget {
  const ServicePageHeader({super.key});

  static const _purple = Color(0xFF4412A7);

  void _openRoute(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  void _openContacts(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.white,
      builder: (context) => const ContactsWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;

    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          if (Navigator.of(context).canPop())
            IconButton(
              tooltip: 'На главную',
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              icon: const Icon(Icons.arrow_back, color: _purple),
            ),
          Text(
            'Nexora',
            style: TextStyle(
              fontSize: compact ? 21 : 27,
              fontWeight: FontWeight.bold,
              color: _purple,
            ),
          ),
          const Spacer(),
          if (compact)
            PopupMenuButton<String>(
              tooltip: 'Навигация',
              icon: const Icon(Icons.more_vert, color: _purple),
              onSelected: (value) {
                if (value == 'contact') {
                  _openContacts(context);
                } else {
                  _openRoute(context, value);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: '/web-mobile', child: Text('Web и Mobile разработка')),
                PopupMenuItem(value: '/games', child: Text('Разработка игр')),
                PopupMenuItem(value: '/machine-learning', child: Text('Машинное обучение')),
                PopupMenuItem(value: '/about', child: Text('О нас')),
                PopupMenuItem(value: '/admin', child: Text('Админ')),
                PopupMenuItem(value: 'contact', child: Text('Свяжитесь с нами')),
              ],
            )
          else ...[
            PopupMenuButton<String>(
              tooltip: '',
              offset: const Offset(0, 48),
              onSelected: (route) => _openRoute(context, route),
              itemBuilder: (context) => const [
                PopupMenuItem(value: '/web-mobile', child: Text('Web и Mobile разработка')),
                PopupMenuItem(value: '/games', child: Text('Разработка игр')),
                PopupMenuItem(value: '/machine-learning', child: Text('Машинное обучение')),
              ],
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Text('Услуги', style: TextStyle(color: _purple)),
              ),
            ),
            TextButton(
              onPressed: () => _openRoute(context, '/about'),
              child: const Text('О нас', style: TextStyle(color: Color(0xFF333333))),
            ),
            TextButton(
              onPressed: () => _openRoute(context, '/admin'),
              child: const Text('Админ', style: TextStyle(color: Color(0xFF333333))),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _openContacts(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('Свяжитесь с нами'),
            ),
          ],
        ],
      ),
    );
  }
}


