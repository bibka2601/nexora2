import 'package:flutter/material.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
      color: const Color(0xFFF7F7F7),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4412A7), width: 1),
        ),
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ВЕРХНЯЯ СТРОКА
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '01',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4412A7),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF4412A7)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_downward,
                    color: Color(0xFF4412A7),
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            // ЗАГОЛОВОК
            const Text(
              'Какие услуги мы\nпредоставляем?',
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 70),

            // ДВЕ КОЛОНКИ
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ПРОЦЕСС
                Expanded(child: _ProcessColumn()),

                const SizedBox(width: 80),

                // УСЛУГИ
                Expanded(child: _ServicesColumn()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// ПРОЦЕСС
// ======================================================

class _ProcessColumn extends StatelessWidget {
  const _ProcessColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Процесс',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),

        SizedBox(height: 20),

        Text(
          'Мы обеспечиваем полный цикл цифрового '
          'производства — от анализа продукта до '
          'разработки и поддержки.',
          style: TextStyle(fontSize: 17, height: 1.6, color: Colors.black54),
        ),

        SizedBox(height: 35),

        _ProcessItem(number: '01', title: 'Аналитика'),

        _ProcessItem(number: '02', title: 'Разработка'),

        _ProcessItem(number: '03', title: 'Дизайн'),

        _ProcessItem(number: '04', title: 'Тестирование'),

        _ProcessItem(number: '05', title: 'Поддержка'),
      ],
    );
  }
}

// ======================================================
// УСЛУГИ
// ======================================================

class _ServicesColumn extends StatelessWidget {
  const _ServicesColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Услуги',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 20),

        const Text(
          'Создаём цифровые продукты и решения '
          'для развития современного бизнеса.',
          style: TextStyle(fontSize: 17, height: 1.6, color: Colors.black54),
        ),

        const SizedBox(height: 35),

        _ServiceItem(number: '01', title: 'Web-разработка'),

        _ServiceItem(number: '02', title: 'Mobile-разработка'),

        _ServiceItem(number: '03', title: 'Разработка игр'),
        _ServiceItem(number: '04', title: 'UI/UX дизайн'),
      ],
    );
  }
}

// ======================================================
// ПРОЦЕСС ITEM
// ======================================================

class _ProcessItem extends StatelessWidget {
  final String number;
  final String title;

  const _ProcessItem({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 13,
                color: const Color.fromARGB(255, 68, 18, 167),
              ),
            ),
          ),

          Text(title, style: const TextStyle(fontSize: 19)),
        ],
      ),
    );
  }
}

// ======================================================
// SERVICE ITEM
// ======================================================

class _ServiceItem extends StatefulWidget {
  final String number;
  final String title;

  const _ServiceItem({required this.number, required this.title});

  @override
  State<_ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<_ServiceItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(isHover ? 10 : 0, 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isHover
                  ? const Color.fromARGB(255, 68, 18, 167)
                  : const Color(0xFFE0E0E0),
              width: isHover ? 2 : 1,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 45,
              child: Text(
                widget.number,
                style: const TextStyle(fontSize: 13, color: const Color
                                          .fromARGB(
                                    255,
                                    68,
                                    18,
                                    167,
                                  ),),
              ),
            ),

            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: isHover ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isHover ? 1 : 0,
              child: const Icon(
                Icons.arrow_forward,
                color: const Color.fromARGB(255, 68, 18, 167),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
