import 'package:flutter/material.dart';
import 'package:nexora/data/consts/app_colors.dart';
import 'package:nexora/presentation/widgets/contacts_widget.dart';

class MachineLearningPage extends StatelessWidget {
  const MachineLearningPage({super.key});

  final Color purple = const Color(0xFF4412A7);

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const ContactsWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHero(context),
                  _buildServices(),
                  _buildProcess(),
                  _buildContact(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 35),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEAEAEA),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Nexora',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
          ),

          const Spacer(),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Назад',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(width: 25),

          ElevatedButton(
            onPressed: () => _showContactDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              foregroundColor: Colors.white,
              minimumSize: const Size(190, 45),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              'Свяжитесь с нами',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 100,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 850) {
            return _buildMobileHero(context);
          }

          return _buildDesktopHero(context);
        },
      ),
    );
  }

  Widget _buildDesktopHero(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '01',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: purple,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Машинное\nобучение',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w500,
                  height: 1.05,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Умные решения для анализа данных,\n'
                'автоматизации процессов и развития бизнеса.',
                style: TextStyle(
                  fontSize: 19,
                  height: 1.7,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => _showContactDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(210, 55),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Обсудить проект',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 70),

        Expanded(
          flex: 4,
          child: Container(
            height: 420,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              border: Border.all(
                color: const Color(0xFFE5E5E5),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.auto_awesome,
                size: 150,
                color: purple,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '01',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: purple,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Машинное\nобучение',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w500,
            height: 1.05,
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Умные решения для анализа данных,\n'
          'автоматизации процессов и развития бизнеса.',
          style: TextStyle(
            fontSize: 17,
            height: 1.7,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 30),

        ElevatedButton(
          onPressed: () => _showContactDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: purple,
            foregroundColor: Colors.white,
            minimumSize: const Size(190, 52),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            'Обсудить проект',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),

        const SizedBox(height: 45),

        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.auto_awesome,
              size: 100,
              color: purple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServices() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 100,
      ),
      color: const Color(0xFFF7F7F7),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _number('02'),

                const SizedBox(height: 20),

                const Text(
                  'Что мы делаем',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 40),

                _serviceCard(
                  Icons.analytics_outlined,
                  'Анализ данных',
                  'Находим закономерности и полезную информацию в больших объёмах данных.',
                ),

                _serviceCard(
                  Icons.psychology_outlined,
                  'AI-модели',
                  'Создаём модели машинного обучения под конкретные задачи бизнеса.',
                ),

                _serviceCard(
                  Icons.auto_graph,
                  'Прогнозирование',
                  'Помогаем прогнозировать продажи, спрос и другие важные показатели.',
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: _number('02'),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Что мы делаем',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 45),

                    Row(
                      children: [
                        Expanded(
                          child: _serviceCard(
                            Icons.analytics_outlined,
                            'Анализ данных',
                            'Находим закономерности и полезную информацию в больших объёмах данных.',
                          ),
                        ),

                        const SizedBox(width: 25),

                        Expanded(
                          child: _serviceCard(
                            Icons.psychology_outlined,
                            'AI-модели',
                            'Создаём модели машинного обучения под конкретные задачи бизнеса.',
                          ),
                        ),

                        const SizedBox(width: 25),

                        Expanded(
                          child: _serviceCard(
                            Icons.auto_graph,
                            'Прогнозирование',
                            'Помогаем прогнозировать продажи, спрос и другие важные показатели.',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _serviceCard(
    IconData icon,
    String title,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 42,
            color: purple,
          ),

          const SizedBox(height: 25),

          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcess() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 100,
      ),
      child: Column(
        children: [
          _number('03'),

          const SizedBox(height: 20),

          const Text(
            'Как мы работаем',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 60),

          Wrap(
            spacing: 25,
            runSpacing: 25,
            alignment: WrapAlignment.center,
            children: [
              _processCard(
                '01',
                'Задача',
                'Изучаем бизнес-задачу и определяем, где машинное обучение принесёт пользу.',
              ),

              _processCard(
                '02',
                'Данные',
                'Собираем, очищаем и подготавливаем данные для обучения модели.',
              ),

              _processCard(
                '03',
                'Модель',
                'Обучаем и тестируем модель, после чего внедряем её в проект.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _processCard(
    String number,
    String title,
    String text,
  ) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: purple,
            ),
          ),

          const SizedBox(height: 25),

          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _number(String number) {
    return Text(
      number,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: purple,
      ),
    );
  }

  Widget _buildContact(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 100,
      ),
      child: Column(
        children: [
          const Text(
            'Есть идея\nдля AI-проекта?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 55,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Расскажите нам о вашей задаче',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 35),

          ElevatedButton(
            onPressed: () => _showContactDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              foregroundColor: Colors.white,
              minimumSize: const Size(210, 58),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              'Связаться с нами',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}