import 'package:flutter/material.dart';
import 'package:nexora/presentation/widgets/segment_info.dart';

class TechnologiesSection extends StatelessWidget {
  const TechnologiesSection({super.key});

  final List<Map<String, String>> technologies = const [
    {'name': 'Flutter', 'type': 'Framework'},
    {'name': 'Dart', 'type': 'Language'},
    {'name': 'Python', 'type': 'Language'},
    {'name': 'JavaScript', 'type': 'Language'},
    {'name': 'React', 'type': 'Framework'},
    {'name': 'HTML5', 'type': 'Technology'},
    {'name': 'CSS', 'type': 'Technology'},
    {'name': 'Firebase', 'type': 'Backend'},
    {'name': 'PostgreSQL', 'type': 'Database'},
    {'name': 'GitHub', 'type': 'Tools'},
    {'name': 'Figma', 'type': 'Design'},
    {'name': 'Unity', 'type': 'Game Engine'},
  ];

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 60,
        vertical: compact ? 40 : 80,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4412A7)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Фоновая картинка на всю секцию
            Positioned.fill(
              child: Image.asset(
                'assets/images/languege.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            // Тёмный оверлей
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFF0D0520).withValues(alpha: 0.50),
              ),
            ),
            // Контент
            Padding(
          padding: EdgeInsets.all(compact ? 20 : 50),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Языки и\nтехнологии',
              style: TextStyle(
                fontSize: compact ? 34 : 52,
                fontWeight: FontWeight.w500,
                height: 1.1,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Используем современные языки программирования, '
              'фреймворки и инструменты для создания '
              'быстрых и удобных цифровых продуктов.',
              style: TextStyle(
                fontSize: 19,
                height: 1.6,
                color: const Color(0xFFE8E8E8),
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
          ],
        ),
      ),
    );
  }
}

class TechnologyItem extends StatefulWidget {
  final String name;
  final String type;

  const TechnologyItem({super.key, required this.name, required this.type});

  @override
  State<TechnologyItem> createState() => _TechnologyItemState();
}

class _TechnologyItemState extends State<TechnologyItem> {
  static const _backgroundAssets = <String, String>{
    'Flutter': 'assets/images/image.png',
    'Dart': 'assets/images/dart.png',
    'Python': 'assets/images/pythonphoto.png',
    'JavaScript': 'assets/images/javascript.png',
    'React': 'assets/images/reactjs.png',
    'HTML5': 'assets/images/html5logo.png',
    'CSS': 'assets/images/csslogo.png',
    'Firebase': 'assets/images/firebaselogo.png',
    'PostgreSQL': 'assets/images/postgresqllogo.png',
    'GitHub': 'assets/images/githublogo.png',
    'Figma': 'assets/images/figmalogo.png',
    'Unity': 'assets/images/unitylogo.png',
  };

  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final backgroundAsset =
        _backgroundAssets[widget.name] ?? 'assets/images/image.png';

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
      child: Semantics(
        button: true,
        label: '${widget.name}, ${widget.type}',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showSegmentInfo(context, widget.name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, isHover ? -5 : 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(backgroundAsset),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: isHover ? 0.04 : 0),
                        Colors.black.withValues(alpha: isHover ? 0.58 : 0.42),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.type,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 12),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isHover ? 1 : 0,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
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
}


