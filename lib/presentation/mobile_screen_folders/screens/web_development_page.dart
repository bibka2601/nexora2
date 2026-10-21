import 'package:flutter/material.dart';
import 'package:nexora/presentation/widgets/contacts_widget.dart';
import 'package:nexora/presentation/widgets/keyboard_scrollable.dart';
import 'package:nexora/presentation/widgets/service_page_header.dart';
import 'package:nexora/presentation/widgets/segment_info.dart';

class WebDevelopmentPage extends StatelessWidget {
  const WebDevelopmentPage({super.key});

  static const _purple = Color(0xFF4412A7);
  static const _technologies = [
    'React',
    'JavaScript',
    'HTML5',
    'CSS',
    'Firebase',
    'PostgreSQL',
  ];

  void _showContacts(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const ContactsWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ServicePageHeader(),
          Expanded(
            child: KeyboardScrollable(
              builder: (context, controller) => SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 20 : 72,
                      vertical: compact ? 58 : 100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WEB\nDEVELOPMENT',
                          style: TextStyle(
                            fontSize: compact ? 44 : 68,
                            fontWeight: FontWeight.w500,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 28),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 680),
                          child: const Text(
                            'Создаём сайты и веб-приложения для бизнеса: '
                            'продумываем структуру, разрабатываем интерфейс, '
                            'подключаем серверные сервисы и готовим продукт к запуску.',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                        ElevatedButton.icon(
                          onPressed: () => _showContacts(context),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Обсудить веб-проект'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _purple,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(220, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xFFF7F7F7),
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 16 : 60,
                      vertical: compact ? 40 : 72,
                    ),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(compact ? 20 : 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '01  /  НАПРАВЛЕНИЯ',
                            style: TextStyle(
                              color: _purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            'Что создаём',
                            style: TextStyle(
                              fontSize: compact ? 34 : 48,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 30),
                          for (final segment in const [
                            'Корпоративные сайты',
                            'Веб-приложения',
                            'Интернет-сервисы и личные кабинеты',
                            'Интеграции с API и базами данных',
                          ])
                            _WebSegmentRow(title: segment),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 20 : 72,
                      vertical: compact ? 44 : 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '02  /  ТЕХНОЛОГИИ',
                          style: TextStyle(
                            color: _purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Инструменты веб-разработки',
                          style: TextStyle(
                            fontSize: compact ? 32 : 44,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 30),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = constraints.maxWidth < 650 ? 1 : 2;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _technologies.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: columns == 1 ? 5 : 3.5,
                                  ),
                              itemBuilder: (context, index) {
                                final name = _technologies[index];
                                return _WebTechnologyTile(name: name);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class _WebSegmentRow extends StatelessWidget {
  final String title;

  const _WebSegmentRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showSegmentInfo(context, title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
            const Icon(Icons.arrow_forward, color: Color(0xFF4412A7)),
          ],
        ),
      ),
    );
  }
}

class _WebTechnologyTile extends StatelessWidget {
  final String name;

  const _WebTechnologyTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showSegmentInfo(context, name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            const Icon(Icons.code, color: Color(0xFF4412A7)),
            const SizedBox(width: 14),
            Expanded(child: Text(name, style: const TextStyle(fontSize: 19))),
            const Icon(Icons.arrow_forward, color: Color(0xFF4412A7), size: 20),
          ],
        ),
      ),
    );
  }
}


