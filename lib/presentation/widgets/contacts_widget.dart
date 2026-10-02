import 'package:flutter/material.dart';

class ContactsWidget extends StatefulWidget {
  const ContactsWidget({super.key});

  @override
  State<ContactsWidget> createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  final Color purple = const Color(0xFF4412A7);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 30,
      ),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
          ),
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
            _buildHeader(),

            const SizedBox(height: 30),

            _buildContactCard(
              icon: Icons.telegram,
              title: 'Telegram',
              subtitle: 'Напишите нам в Telegram',
              onTap: () {
                // Сюда потом добавим ссылку на Telegram
              },
            ),

            const SizedBox(height: 12),

            _buildContactCard(
              icon: Icons.chat_bubble_outline,
              title: 'WhatsApp',
              subtitle: 'Свяжитесь с нами в WhatsApp',
              onTap: () {
                // Сюда потом добавим ссылку на WhatsApp
              },
            ),

            const SizedBox(height: 12),

            _buildContactCard(
              icon: Icons.phone_outlined,
              title: 'Телефон',
              subtitle: '+7 (___) ___-__-__',
              onTap: () {
                // Сюда потом добавим номер
              },
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: purple,
                    size: 21,
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Мы ответим на ваше сообщение\n'
                      'и обсудим ваш проект',
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

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Закрыть',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
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
          child: Icon(
            Icons.mail_outline,
            color: purple,
            size: 27,
          ),
        ),

        const SizedBox(width: 17),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Свяжитесь с нами',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Выберите удобный способ связи',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
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
            child: const Icon(
              Icons.close,
              size: 19,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // CONTACT CARD
  // =========================================================

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _HoverContactCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      purple: purple,
      onTap: onTap,
    );
  }
}

// =============================================================
// HOVER CARD
// =============================================================

class _HoverContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color purple;
  final VoidCallback onTap;

  const _HoverContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.purple,
    required this.onTap,
  });

  @override
  State<_HoverContactCard> createState() => _HoverContactCardState();
}

class _HoverContactCardState extends State<_HoverContactCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          isHover = true;
        });
      },

      onExit: (_) {
        setState(() {
          isHover = false;
        });
      },

      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: isHover
                ? const Color(0xFFF8F5FF)
                : Colors.white,
            border: Border.all(
              color: isHover
                  ? widget.purple
                  : const Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isHover
                      ? widget.purple
                      : const Color(0xFFF1EBFF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  widget.icon,
                  color: isHover
                      ? Colors.white
                      : widget.purple,
                  size: 23,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                transform: Matrix4.translationValues(
                  isHover ? 4 : 0,
                  0,
                  0,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  size: 19,
                  color: isHover
                      ? widget.purple
                      : Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}