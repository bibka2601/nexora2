# Nexora — Отчёт об исследовании проекта

## Краткое резюме

Nexora — это корпоративный сайт/лендинг IT-компании, написанный на Flutter. Приложение ориентировано на **Web и Desktop** платформы (есть поддержка Android/iOS, но основной фокус — веб). Цель: презентация услуг компании (веб-разработка, мобильная разработка, разработка игр, ML), сбор заявок от клиентов и их обработка через панель администратора. Бэкенд — Firebase (Auth + Firestore). Целевая аудитория: потенциальные клиенты бизнеса, ищущие digital-подрядчика.

---

## 1. Что делает приложение

Nexora — маркетинговый сайт IT-компании с тем же названием. Пользователь видит:

- Главную страницу с hero-секцией ("Цифровые решения для вашего бизнеса"), секцией услуг, технологий и кнопкой связи.
- Отдельные страницы для каждой из услуг: Web/Mobile разработка, Разработка игр, Машинное обучение.
- Страницу "О нас" с описанием команды (5 человек).
- Форму заявки (диалог), через которую клиент оставляет контактные данные и выбирает услугу — данные пишутся в Firestore.
- Диалог контактов: ссылки на Telegram-группу, WhatsApp-группу, телефон.
- Панель администратора: просмотр входящих заявок в реальном времени, возможность пометить заявку как "принятую".

---

## 2. Технологический стек

**Источник:** `pubspec.yaml`

| Категория | Библиотека / Инструмент | Версия |
|---|---|---|
| Платформа | Flutter | SDK ^3.12.0 |
| Язык | Dart | ^3.12.0 |
| Видео | `video_player` | ^2.10.0 |
| Firebase (инициализация) | `firebase_core` | ^4.15.0 |
| Firebase Auth | `firebase_auth` | ^6.7.0 |
| Google Sign-In | `google_sign_in` | ^7.2.0 |
| База данных | `cloud_firestore` | ^6.10.0 |
| Ссылки/телефон | `url_launcher` | ^6.3.3 |
| UI иконки | `cupertino_icons` | ^1.0.8 |

Никаких сторонних пакетов для управления состоянием (`provider`, `bloc`, `riverpod` и т.д.) нет — приложение использует только встроенный `setState`.

---

## 3. Структура проекта

```
lib/
├── main.dart                          # точка входа, маршруты, Firebase init
├── firebase_options.dart              # авто-сгенерированные конфиги Firebase
│
├── data/
│   ├── consts/app_colors.dart         # константы цветов (AppColors)
│   └── theme/app_theme.dart           # пустой файл (не использован)
│
└── presentation/
    ├── pages/
    │   ├── home_page.dart             # главная страница
    │   └── about_page.dart            # страница "О нас" с командой
    │
    ├── mobile_screen_folders/
    │   └── screens/
    │       ├── admin_login_page.dart  # логин + панель администратора
    │       ├── web_development_page.dart      # услуга: Web
    │       ├── mobile_development_page.dart   # услуга: Mobile/Web
    │       ├── game_development_page.dart     # услуга: Игры
    │       └── machine_learning.dart          # услуга: ML
    │
    └── widgets/
        ├── site_video_background.dart  # глобальный видео-фон
        ├── animated_menu.dart          # выпадающее меню (PopupMenu)
        ├── contacts_widget.dart        # диалог контактов + форма заявки
        ├── responsive_layout.dart      # утилиты адаптивных отступов
        ├── scroll_reveal.dart          # анимация появления при прокрутке
        ├── segment_info.dart           # всплывающий диалог описания технологии
        ├── service_page_header.dart    # шапка страниц услуг
        ├── services_section.dart       # секция услуг на главной
        └── technologies_section.dart  # секция технологий на главной
```

**Активы** (`assets/`):
- `assets/images/` — 19 логотипов технологий (Flutter, Dart, Python, React, Firebase, Unity, Kotlin, Swift и т.д.)
- `assets/videos/` — 2 видеофайла фона (`120172-720504774.mp4`, `MAIN.mp4`)

---

## 4. Экраны и навигация

Навигация реализована через именованные маршруты (`Navigator.pushNamed`) в `MaterialApp`.

```
/ (HomePage)
├── /about          → AboutPage
├── /admin          → AdminLoginPage → AdminPanelPage (pushReplacement)
├── /web-mobile     → MobileDevelopmentPage
├── /games          → GameDevelopmentPage
└── /machine-learning → MachineLearningPage
```

**Диалоги** (не маршруты, открываются через `showDialog`):
- `ContactsWidget` — контакты (Telegram, WhatsApp, телефон)
- `OrderRequestWidget` — форма заявки (определена в `contacts_widget.dart`, но на UI в `ContactsWidget` — именно ссылки, а не форма; форма — это отдельный класс `OrderRequestWidget` в том же файле, который не вызывается нигде напрямую из UI — см. раздел "Проблемы")
- `AlertDialog` из `showSegmentInfo` — описание технологии/услуги

**Шапка страниц услуг** (`ServicePageHeader`) содержит: кнопку "назад", название "Nexora", выпадающее меню услуг, кнопку "О нас", "Админ" и "Свяжитесь с нами".

---

## 5. Управление состоянием

Используется **исключительно `setState`** — никаких сторонних пакетов нет.

- Большинство экранов — `StatelessWidget`.
- `StatefulWidget` применяется там, где нужно локальное состояние:
  - `AdminLoginPage` / `AdminPanelPage` — управление загрузкой, обновление заказов
  - `OrderRequestWidget` — управление формой: submitting/submitted/pendingOrder
  - `_TeamCard`, `_ServiceItem`, `_GameTypeCard`, `_GameProjectCard`, `_ProjectCard` — hover-эффекты через `MouseRegion` + `setState`
  - `ScrollReveal` — анимация появления с `AnimationController`
  - `SiteVideoBackground` — управление состоянием `_videoReady`

Данные Firestore читаются через `StreamBuilder<QuerySnapshot>` напрямую в `AdminPanelPage` без дополнительной прослойки.

---

## 6. Бэкенд и интеграции

### Firebase Authentication
- **Email/Password**: логин только для `nexora@gmail.com`
- **Google Sign-In**: логин только для `kuakpai@gmail.com`
- Проверка email захардкожена в `_AdminLoginPageState` (строки `adminEmail` и `googleAdminEmail`)
- Google Sign-In на Windows не поддерживается, показывает SnackBar с предложением открыть в Chrome

### Cloud Firestore
**Коллекция `orders`:**

| Поле | Тип | Описание |
|---|---|---|
| `services` | string | выбранная услуга |
| `clientType` | 'company' / 'individual' | тип клиента |
| `clientName` | string | полное имя |
| `firstName` | string | имя |
| `lastName` | string | фамилия |
| `companyName` | string | название компании (если company) |
| `phone` | string | телефон |
| `message` | string | комментарий |
| `status` | 'new' / 'accepted' | статус заявки |
| `createdAt` | Timestamp | время создания |
| `acceptedAt` | Timestamp | время принятия (при обновлении) |
| `acceptedBy` | string | email админа |

**Правила Firestore** (`firestore.rules`):
- Клиент может только создавать заказы (`allow create`), строгая валидация полей
- Читать и обновлять могут только `nexora@gmail.com` и `bibka2601@gmail.com`

### url_launcher
Используется в `ContactsWidget` для открытия Telegram (`https://t.me/NexoraOrderGroup`), WhatsApp и tel: ссылок.

---

## 7. Примечательные паттерны и особенности

### Видео-фон (`SiteVideoBackground`)
Оборачивает всё приложение через `builder` в `MaterialApp`. Воспроизводит `assets/videos/120172-720504774.mp4` зациклено без звука. При ошибке инициализации показывает белый фон. Некоторые страницы услуг выставляют `Scaffold(backgroundColor: Colors.transparent)`, чтобы видео просвечивало.

### Scroll Reveal (`ScrollReveal`)
Кастомная анимация: при прокрутке до элемента запускается FadeTransition + SlideTransition (появление снизу). Подписывается на `ScrollPosition` из контекста, проверяет видимость через `RenderAbstractViewport`. Уважает `MediaQuery.disableAnimationsOf` — при отключённых анимациях показывает контент сразу.

### Hover-анимации
Используются `MouseRegion` + `AnimatedContainer` повсеместно: карточки команды, элементы услуг, карточки технологий, карточки проектов — подсветка при наведении на Desktop/Web.

### Адаптивность
Утилиты в `responsive_layout.dart` (функции `responsiveSectionInsets`, `responsiveCardPadding`, `responsiveHeadingSize`) используются на всех страницах услуг. Ломаются на 3 точках: <360px (мобиль), <600px (компакт), <900px (планшет), ≥900 (десктоп).

### Сегментные диалоги (`segment_info.dart`)
Статическая карта `_segmentDescriptions` с описаниями 30+ технологий/услуг. При нажатии на технологию (`TechnologyItem`) или услугу открывается `AlertDialog` с текстовым описанием.

### Форма заявки
`OrderRequestWidget` обрабатывает идемпотентность: хранит `_pendingOrder` как `Future<DocumentReference>` — повторное нажатие не создаёт новый документ, а ждёт результата первого запроса. Таймаут 12 секунд с информативным SnackBar.

---

## 8. Обнаруженные проблемы и TODO

### Критические / Функциональные

1. **`OrderRequestWidget` не используется в UI**
   - Файл `contacts_widget.dart` определяет два класса: `ContactsWidget` (показывает ссылки) и `OrderRequestWidget` (форма заявки). В реальном приложении `ContactsWidget` всегда открывается для "заявки" — пользователь видит только контакты, а не форму. `OrderRequestWidget` нигде не вызывается. Либо это незавершённая функциональность, либо баг.
   - **Файл:** `lib/presentation/widgets/contacts_widget.dart`

2. **Синтаксическая ошибка в `SiteVideoBackground`**
   - Строка `?widget.child,` — это не валидный Dart-синтаксис. Должно быть `if (widget.child != null) widget.child!` или просто `widget.child!` (раз тип `Widget?`, а не `Widget`).
   - **Файл:** `lib/presentation/widgets/site_video_background.dart`, строка `?widget.child,`

3. **`MobileDevelopmentPage` — неправильный маршрут**
   - Маршрут называется `/web-mobile`, но на экране написано `MOBILE DEVELOPMENT` (только mobile). В описании сервиса упоминается "Web и Mobile", но hero-заголовок — только `MOBILE DEVELOPMENT`. Небольшое несоответствие.

4. **Захардкоженные email-адреса администратора**
   - `adminEmail = 'nexora@gmail.com'` и `googleAdminEmail = 'kuakpai@gmail.com'` захардкожены прямо в `_AdminLoginPageState`. Нужно выносить в конфигурацию или хранить в переменных окружения.
   - В Firestore rules упоминается третий email `bibka2601@gmail.com`, которого нет в коде Flutter.

### Архитектурные / Качество кода

5. **`app_theme.dart` — пустой файл**
   - Создан, но пуст. Тема задаётся встроенными значениями Flutter везде по коду.

6. **`AppColors` не используется последовательно**
   - `AppColors` из `data/consts/app_colors.dart` используется только в `admin_login_page.dart` (`AppColors.white`). Все остальные файлы используют `Color(0xFF4412A7)`, `Colors.white` и т.д. напрямую — цвет бренда `0xFF4412A7` дублируется ~50 раз.

7. **Отсутствует маршрут `/web-development` для Web Development page**
   - `WebDevelopmentPage` импортирован в `main.dart` но для него нет именованного маршрута. Страница `MobileDevelopmentPage` зарегистрирована под `/web-mobile` и включает web-контент, а `WebDevelopmentPage` — отдельный файл, не подключённый ни к одному маршруту.

8. **`AnimatedMenu` не используется**
   - `lib/presentation/widgets/animated_menu.dart` определяет `AnimatedMenu`, но нигде не импортируется и не используется.

9. **Папка называется `mobile_screen_folders`**
   - Экраны в этой папке — это страницы услуг (Game, ML, Mobile, Web, Admin), которые используются на всех платформах, не только мобильных. Название вводит в заблуждение.

### Незавершённые / TODO

10. **Проекты — фиктивные данные**
    - Проекты в `MobileDevelopmentPage` ("Shop App", "Fit App", "Finance App", "Taxi App") и `GameDevelopmentPage` ("Brain Game", "Color World", "Sound Guess", "Space Quest") — заглушки с Material-иконками, без реальных ссылок или описаний реальных работ.

11. **Два видеофайла в assets, используется только один**
    - Есть `MAIN.mp4` и `120172-720504774.mp4`. `SiteVideoBackground` использует только второй. `MAIN.mp4` не используется.

---

## 9. Выводы и рекомендации

### Что хорошо сделано
- Грамотная адаптивность через утилиты в `responsive_layout.dart`
- Красивые hover-анимации и `ScrollReveal` анимации
- Строгие Firestore Rules с валидацией полей
- Идемпотентная отправка формы с таймаутом
- Поддержка Email/Password + Google Sign-In для авторизации

### Приоритетные исправления

| Приоритет | Проблема | Файл |
|---|---|---|
| Критический | Синтаксическая ошибка `?widget.child,` | `site_video_background.dart` |
| Высокий | `OrderRequestWidget` не подключён к UI | `contacts_widget.dart` |
| Высокий | `WebDevelopmentPage` не добавлен в маршруты | `main.dart` |
| Средний | Дублирование цвета `0xFF4412A7` по всему коду | Все файлы |
| Средний | Захардкоженные admin email в исходном коде | `admin_login_page.dart` |
| Низкий | `AnimatedMenu` не используется | `animated_menu.dart` |
| Низкий | `MAIN.mp4` не используется | `assets/videos/` |

---

*Отчёт подготовлен автоматически на основе анализа исходного кода проекта.*
