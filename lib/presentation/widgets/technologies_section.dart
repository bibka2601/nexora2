import 'package:flutter/material.dart';

class TechnologiesSection extends StatelessWidget {
  const TechnologiesSection({super.key});

  final List<Map<String, String>> technologies = const [
    {
      'name': 'Flutter',
      'type': 'Framework',
    },
    {
      'name': 'Dart',
      'type': 'Language',
    },
    {
      'name': 'Python',
      'type': 'Language',
    },
    {
      'name': 'JavaScript',
      'type': 'Language',
    },
    {
      'name': 'React',
      'type': 'Framework',
    },
    {
      'name': 'HTML5',
      'type': 'Technology',
    },
    {
      'name': 'CSS',
      'type': 'Technology',
    },
    {
      'name': 'Firebase',
      'type': 'Backend',
    },
    {
      'name': 'PostgreSQL',
      'type': 'Database',
    },
    {
      'name': 'GitHub',
      'type': 'Tools',
    },
    {
      'name': 'Figma',
      'type': 'Design',
    },
    {
      'name': 'Unity',
      'type': 'Game Engine',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F7F7),
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 80,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF4412A7),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '02',
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
                    border: Border.all(
                      color: const Color(0xFF4412A7),
                    ),
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

            const Text(
              'Языки и\nтехнологии',
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Используем современные языки программирования, '
              'фреймворки и инструменты для создания '
              'быстрых и удобных цифровых продуктов.',
              style: TextStyle(
                fontSize: 17,
                height: 1.6,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 60),

            LayoutBuilder(
              builder: (context, constraints) {
                int columns = 4;

                if (constraints.maxWidth < 900) {
                  columns = 2;
                }

                if (constraints.maxWidth < 600) {
                  columns = 1;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: technologies.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2.8,
                  ),
                  itemBuilder: (context, index) {
                    return TechnologyItem(
                      name: technologies[index]['name']!,
                      type: technologies[index]['type']!,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TechnologyItem extends StatefulWidget {
  final String name;
  final String type;

  const TechnologyItem({
    super.key,
    required this.name,
    required this.type,
  });

  @override
  State<TechnologyItem> createState() => _TechnologyItemState();
}

class _TechnologyItemState extends State<TechnologyItem> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          0,
          isHover ? -5 : 0,
          0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: isHover
              ? const Color(0xFF4412A7)
              : Colors.white,
          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isHover
                      ? Colors.white
                      : const Color(0xFF4412A7),
                ),
              ),
              child: Icon(
                Icons.code,
                size: 20,
                color: isHover
                    ? Colors.white
                    : const Color(0xFF4412A7),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isHover
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    widget.type,
                    style: TextStyle(
                      fontSize: 12,
                      color: isHover
                          ? Colors.white70
                          : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isHover ? 1 : 0,
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}