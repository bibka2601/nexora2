# Nexora — План реализации трёх задач

---

## Задача 1: iPhone / телефон в hero-секции главной страницы

### Анализ текущего состояния

- `home_page.dart` — класс `_HomeHero` содержит `Column` с текстом и кнопкой, но **нет никакого изображения или иллюстрации телефона**.
- В `assets/images/` нет файла с именем iphone, phone, или аналогичного. Список файлов:  
  `csslogo.png, dart.png, figmalogo.png, firebaselogo.png, githublogo.png, html5logo.png, image.png, It_project1.png, javascript.png, kotlinlogo.png, mobilelogo.jpeg, mobilelogo.png, postgresqllogo.png, pythonphoto.png, reactjs.jpeg, reactjs.png, restiplogo.png, swiftlogo.png, unitylogo.png`  
  → изображения айфона **нет в assets**.
- На странице услуг `mobile_development_page.dart` уже есть класс `_PhoneIllustration` — готовый Flutter-виджет, который рисует макет смартфона (чёрный корпус, скруглённые углы, динамик, кнопку START, надпись NEXORA). Это именно та иллюстрация, которую нужно добавить в hero главной страницы.

### Что делать

**1.1. Исправить синтаксическую ошибку в `site_video_background.dart`**

Файл: `lib/presentation/widgets/site_video_background.dart`

Текущий некорректный код (строка ~58 в методе `build`):
```dart
        else
          const ColoredBox(color: Colors.white),
            ?widget.child,   // ← невалидный Dart
```

Заменить на:
```dart
        else
          const ColoredBox(color: Colors.white),
        if (widget.child != null) widget.child!,
```

Это исправляет синтаксическую ошибку — проект перестанет падать при сборке.

---

**1.2. Добавить иллюстрацию телефона в hero главной страницы**

Файл: `lib/presentation/pages/home_page.dart`

Класс `_HomeHero`, метод `build`. Текущая логика:
```dart
return Container(
  ...
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 760),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Цифровые решения...',  ...),
        SizedBox(height: 28),
        Text('Разработка сайтов...', ...),
        SizedBox(height: 36),
        ElevatedButton(...),
      ],
    ),
  ),
);
```

**Изменение:** Заменить `ConstrainedBox` с `Column` на адаптивный `Row` / `Column` (как в `_HeroSection` страницы мобильной разработки). На широком экране (>850px) — Row с текстом слева и телефоном справа; на узком — Column с текстом сверху и телефоном снизу.

Новая структура `_HomeHero.build`:
```dart
@override
Widget build(BuildContext context) {
  final compact = MediaQuery.sizeOf(context).width < 850;
  return Container(
    width: double.infinity,
    constraints: BoxConstraints(
      minHeight: MediaQuery.sizeOf(context).height - 76,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 24 : 70,
      vertical: compact ? 56 : 80,
    ),
    alignment: Alignment.centerLeft,
    child: compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _heroText(compact),
              const SizedBox(height: 48),
              const _PhoneIllustration(),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _heroText(compact),
              ),
              const SizedBox(width: 50),
              const Expanded(child: _PhoneIllustration()),
            ],
          ),
  );
}
```

Вынести текст+кнопку в приватный метод `_heroText(bool compact)`:
```dart
Widget _heroText(bool compact) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Цифровые решения\nдля вашего бизнеса',
        style: TextStyle(
          fontSize: compact ? 38 : 54,
          fontWeight: FontWeight.w500,
          height: 1.12,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 28),
      const Text(
        'Разработка сайтов\n'
        'Разработка приложений\n'
        'Разработка игр',
        style: TextStyle(
          fontSize: 17,
          height: 1.8,
          color: Colors.white70,
        ),
      ),
      const SizedBox(height: 36),
      ElevatedButton(
        onPressed: onContact,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4412A7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text('Заявка на услуги'),
      ),
    ],
  );
}
```

**Добавить класс `_PhoneIllustration`** в конец файла `home_page.dart` (скопировать точно из `mobile_development_page.dart`):
```dart
class _PhoneIllustration extends StatelessWidget {
  const _PhoneIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(38),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 35,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 75,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'NEXORA',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4412A7),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Mobile App',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(25),
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF4412A7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'START',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Verify:** `flutter build web --no-pub` — должен завершиться без ошибок.

---

## Задача 2: Белые тексты на публичных страницах

### Принцип

- Страницы используют `Scaffold(backgroundColor: Colors.transparent)`, под которым видео-фон (тёмное видео).
- Тёмные тексты (`Colors.black54`, `Colors.black45`, без явного цвета, `TextStyle()` без `color`) невидимы на тёмном фоне.
- **Исключения (не трогать):** `admin_login_page.dart`, `contacts_widget.dart`, `web_development_page.dart` (у него `Scaffold(backgroundColor: Colors.white)` — белый фон, там чёрный текст правильный).

---

### 2.1. `home_page.dart` — `_HomeContactSection`

Файл: `lib/presentation/pages/home_page.dart`

Класс `_HomeContactSection`:

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Готовы создать\nчто-то новое?')` | цвет **не задан** (наследует белый из темы? — нет, тема не настроена, будет чёрным) | добавить `color: Colors.white` |
| `Text('Расскажите нам о вашей идее')` | `Colors.black54` | заменить на `Colors.white70` |

Текущий код:
```dart
Text(
  'Готовы создать\nчто-то новое?',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: compact ? 38 : 56,
    fontWeight: FontWeight.w500,
    height: 1.12,
    // ← нет color
  ),
),
...
const Text(
  'Расскажите нам о вашей идее',
  style: TextStyle(fontSize: 17, color: Colors.black54),  // ← чёрный
),
```

Изменения:
- В первом `TextStyle` добавить `color: Colors.white`
- Во втором `TextStyle` заменить `color: Colors.black54` на `color: Colors.white70`

> Примечание: цвет `ElevatedButton` менять не нужно — кнопка на фиолетовом фоне с `backgroundColor: Color(0xFF4412A7)` сольётся — это часть Задачи 3.

---

### 2.2. `about_page.dart`

Файл: `lib/presentation/pages/about_page.dart`

| Метод / Виджет | Текущий цвет | Что менять |
|---|---|---|
| `_buildAboutText` → десктопная ветка → inline `Text(...)` (описание компании) | `Colors.black54` | → `Colors.white70` |
| `_buildAboutText` → `_description()` → `Text(...)` | `Colors.black54` | → `Colors.white70` |
| `_sectionTitle()` → `Text('О компании')` | цвет **не задан** | добавить `color: Colors.white` |
| `_buildTeam()` → `Text('Наша команда')` | цвет **не задан** | добавить `color: Colors.white` |
| `_buildFooter()` → `Text('NEXORA')` | цвет **не задан** | добавить `color: Colors.white` |
| `_buildFooter()` → `Text('© 2026 Nexora')` | `Colors.black45` | → `Colors.white38` |

Дополнительно в `_buildAboutText` — десктопная ветка (Row) содержит `const Expanded(flex: 2, child: Text(..., style: TextStyle(... color: Colors.black54)))` — заменить на `Colors.white70`.

---

### 2.3. `services_section.dart`

Файл: `lib/presentation/widgets/services_section.dart`

Этот виджет отображается на главной странице поверх видео-фона (прозрачный контейнер).

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `_ProcessColumn` → `Text('Процесс')` | цвет **не задан** | добавить `color: Colors.white` |
| `_ProcessColumn` → описание `Text('Мы обеспечиваем...')` | `Colors.black54` | → `Colors.white70` |
| `_ProcessColumn` → `_ProcessItem` → `Text(title)` (каждый) | цвет **не задан** | добавить `color: Colors.white` |
| `_ServicesColumn` → `Text('Услуги')` | цвет **не задан** | добавить `color: Colors.white` |
| `_ServicesColumn` → описание `Text('Создаём цифровые...')` | `Colors.black54` | → `Colors.white70` |
| `_ServiceItem` → `Text(widget.title)` | цвет **не задан** (наследует тёмный) | добавить `color: isHover ? Colors.white : Colors.white` (всегда белый, т.к. фон везде тёмный/фиолетовый) |

В `_ProcessItem` в `TextStyle` внутри `Row`:
```dart
Text(title, style: const TextStyle(fontSize: 19)),  // ← нет color
```
Заменить на:
```dart
Text(title, style: const TextStyle(fontSize: 19, color: Colors.white)),
```

В `_ServiceItem` в `AnimatedContainer.child` → `Row` → `Expanded` → `Text`:
```dart
Text(
  widget.title,
  style: TextStyle(
    fontSize: 19,
    fontWeight: isHover ? FontWeight.w500 : FontWeight.w400,
    // ← нет color
  ),
),
```
Добавить `color: Colors.white`.

Разделители (border bottom) `Color(0xFFE0E0E0)` — заменить на `Color(0x33FFFFFF)` (светлый с прозрачностью на тёмном фоне).

---

### 2.4. `technologies_section.dart`

Файл: `lib/presentation/widgets/technologies_section.dart`

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Языки и\nтехнологии')` | цвет **не задан** | добавить `color: Colors.white` |
| `Text('Используем современные...')` | `Colors.black54` | → `Colors.white70` |

Карточки `TechnologyItem` уже имеют `Colors.white` для текстов (они поверх изображений с градиентом) — не менять.

---

### 2.5. `mobile_development_page.dart`

Файл: `lib/presentation/mobile_screen_folders/screens/mobile_development_page.dart`

У этой страницы `Scaffold(backgroundColor: Colors.transparent)` → видео-фон.

**Hero секция (`_HeroSection`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('WEB + MOBILE\nDEVELOPMENT')` (мобиль) | цвет **не задан** | добавить `color: Colors.white` |
| `Text('Создаём сайты...')` (мобиль) | `Colors.black54` | → `Colors.white70` |
| `Text('MOBILE\nDEVELOPMENT')` (десктоп) | цвет **не задан** | добавить `color: Colors.white` |
| `Text('Создаём сайты...')` (десктоп, `SizedBox(width:600)`) | `Colors.black54` | → `Colors.white70` |

**Services секция (`_ServicesSection`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Создаём удобные приложения...')` | `Colors.black54` | → `Colors.white70` |
| `_HoverServiceItem` → `Text(widget.title)` | цвет **не задан** | добавить `color: Colors.white` |
| Разделители `Color(0xFFE0E0E0)` в `_HoverServiceItem` | светло-серый | → `Color(0x33FFFFFF)` |

**Technologies секция (`_TechnologiesSection`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Технологии')` | цвет **не задан** | добавить `color: Colors.white` |
| `Text(technology)` (в текстовых плитках без картинки) | цвет **не задан** | добавить `color: Colors.white` |

**Process секция (`_ProcessSection`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Этапы разработки')` | цвет **не задан** | добавить `color: Colors.white` |
| `Text(steps[index])` (каждый шаг) | цвет **не задан** | добавить `color: Colors.white` |
| Разделители `Color(0xFFE0E0E0)` | светло-серый | → `Color(0x33FFFFFF)` |

**Projects секция (`_ProjectsSection`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Наши проекты')` | цвет **не задан** | добавить `color: Colors.white` |

Карточки `_ProjectCard` при `isHover=false` используют `color: Colors.black` и `color: Colors.black54` **на белом фоне карточки** — это правильно, не менять (карточки белые).

---

### 2.6. `game_development_page.dart`

Файл: `lib/presentation/mobile_screen_folders/screens/game_development_page.dart`

**Hero секция (`_GameHero`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('GAME\nDEVELOPMENT')` (мобиль) | цвет **не задан** | добавить `color: Colors.white` |
| `Text('Создаём игры...')` (мобиль) | `Colors.black54` | → `Colors.white70` |
| `Text('GAME\nDEVELOPMENT')` (десктоп) | цвет **не задан** | добавить `color: Colors.white` |
| `Text('Создаём игры...')` (десктоп, `SizedBox(width:600)`) | `Colors.black54` | → `Colors.white70` |

**Game Types (`_GameTypes`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Создаём игры')` | цвет **не задан** | добавить `color: Colors.white` |
| `Text('От идеи и концепции...')` | `Colors.black54` | → `Colors.white70` |

Карточки `_GameTypeCard` при `isHover=false` используют `color: Colors.white` для фона карточки — тексты в них не менять (карточки белые).

**Technologies (`_GameTechnologies`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Технологии')` | цвет **не задан** | добавить `color: Colors.white` |
| `Text(name)` внутри технологических карточек | цвет **не задан** | добавить `color: Colors.white` |

Карточки технологий в GameDevelopmentPage имеют `color: Colors.white` (белый фон) → там `Text(name)` с дефолтным чёрным правильно смотрится. **Не менять.**

**Projects (`_GameProjects`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Игровые проекты')` | цвет **не задан** | добавить `color: Colors.white` |

Карточки `_GameProjectCard` — белые при `isHover=false`, чёрный текст там правильный, не менять.

**Team (`_GameTeam`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Команда проекта')` | цвет **не задан** | добавить `color: Colors.white` |
| `Text(team[index])` (каждый) | цвет **не задан** | добавить `color: Colors.white` |
| Разделители `Color(0xFFE0E0E0)` | светло-серый | → `Color(0x33FFFFFF)` |

---

### 2.7. `machine_learning.dart`

Файл: `lib/presentation/mobile_screen_folders/screens/machine_learning.dart`

**Hero (`_buildDesktopHero` и `_buildMobileHero`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Машинное\nобучение')` (desktop) | цвет **не задан** | добавить `color: Colors.white` |
| `Text('Умные решения...')` (desktop) | `Colors.black54` | → `Colors.white70` |
| `Text('Машинное\nобучение')` (mobile) | цвет **не задан** | добавить `color: Colors.white` |
| `Text('Умные решения...')` (mobile) | `Colors.black54` | → `Colors.white70` |

**Services (`_buildServices`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Что мы делаем')` (оба layout) | цвет **не задан** | добавить `color: Colors.white` |

Карточки `_serviceCard` имеют `color: Colors.white` (белый фон) — тексты в них не менять.

**Process (`_buildProcess`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Как мы работаем')` | цвет **не задан** | добавить `color: Colors.white` |

Карточки `_processCard` имеют `color: Colors.transparent` → текст виден поверх видео только если он белый.

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `_processCard` → `Text(title)` | цвет **не задан** | добавить `color: Colors.white` |
| `_processCard` → `Text(text)` | `Colors.black54` | → `Colors.white70` |

**Contact (`_buildContact`):**

| Виджет | Текущий цвет | Что менять |
|---|---|---|
| `Text('Есть идея\nдля AI-проекта?')` | цвет **не задан** | добавить `color: Colors.white` |
| `Text('Расскажите нам...')` | `Colors.black54` | → `Colors.white70` |

---

## Задача 3: CTA-секция "Готовы создать что-то новое?" — переделать как на страницах услуг

### Анализ текущего состояния

Текущий `_HomeContactSection` в `home_page.dart`:
- Фон: `color: const Color(0xFF4412A7)` ✓ (фиолетовый — уже правильный)
- Заголовок `'Готовы создать\nчто-то новое?'`: цвет не задан — **нужно добавить `color: Colors.white`**
- Подзаголовок `'Расскажите нам о вашей идее'`: `color: Colors.black54` — **нужно заменить на `Colors.white70`**
- Кнопка: `backgroundColor: Color(0xFF4412A7)` — кнопка сливается с фоном, **нужно заменить**

### Эталон со страниц услуг

**`mobile_development_page.dart`** → `_ContactSection`:
```
Container(color: Color(0xFF4412A7), ...)
  Column(crossAxisAlignment: start)
    Text('05', color: Colors.white70)
    Text('Есть идея\nдля приложения?', color: Colors.white)
    Text('Расскажите нам...', color: Colors.white70)
    ElevatedButton(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF4412A7),
      child: Text('Связаться с нами')
    )
```

**`game_development_page.dart`** → `_GameContact` — идентичный паттерн.

### Точные изменения в `_HomeContactSection`

Файл: `lib/presentation/pages/home_page.dart`, класс `_HomeContactSection`

**До:**
```dart
child: Column(
  children: [
    Text(
      'Готовы создать\nчто-то новое?',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: compact ? 38 : 56,
        fontWeight: FontWeight.w500,
        height: 1.12,
        // ← нет color
      ),
    ),
    const SizedBox(height: 24),
    const Text(
      'Расскажите нам о вашей идее',
      style: TextStyle(fontSize: 17, color: Colors.black54),  // ← черный
    ),
    const SizedBox(height: 28),
    ElevatedButton(
      onPressed: onContact,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4412A7),  // ← сливается с фоном
        foregroundColor: Colors.white,
        ...
      ),
      child: const Text('Связаться с нами'),
    ),
  ],
),
```

**После:**
```dart
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,  // выровнять влево как на услугах
  children: [
    Text(
      'Готовы создать\nчто-то новое?',
      style: TextStyle(
        fontSize: compact ? 38 : 56,
        fontWeight: FontWeight.w500,
        height: 1.12,
        color: Colors.white,                      // ← добавить
      ),
    ),
    const SizedBox(height: 24),
    const Text(
      'Расскажите нам о вашей идее',
      style: TextStyle(
        fontSize: 17,
        color: Colors.white70,                    // ← заменить
      ),
    ),
    const SizedBox(height: 28),
    ElevatedButton(
      onPressed: onContact,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,            // ← белая кнопка
        foregroundColor: const Color(0xFF4412A7), // ← фиолетовый текст
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: const Text('Связаться с нами'),
    ),
  ],
),
```

Убрать `textAlign: TextAlign.center` у заголовка (выравнивание по левому краю как на услугах), и добавить `crossAxisAlignment: CrossAxisAlignment.start` в `Column`.

---

## Порядок выполнения (зависимости)

1. **Сначала** исправить `site_video_background.dart` (п.1.1) — это критическая синтаксическая ошибка, без которой проект не собирается.
2. **Затем** добавить `_PhoneIllustration` в `home_page.dart` (п.1.2) — нет зависимостей от других задач.
3. **Затем** исправить тексты во всех публичных страницах (Задача 2) — файлы независимы друг от друга, можно делать в любом порядке.
4. **Затем** переделать CTA-секцию (Задача 3) — это изменения в `home_page.dart`, который уже будет модифицирован в п.1.2.

**Verify все задачи:** `flutter build web --no-pub` — сборка завершается без ошибок и предупреждений.
