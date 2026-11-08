# Практична робота №10: Журнал витрат (Hive NoSQL)

Повнофункціональний мобільний застосунок на Flutter для обліку особистих витрат із використанням локальної NoSQL бази даних **Hive**, кодогенерацією та реактивним оновленням UI.

---

##  Функціональні можливості

- **Повний цикл CRUD-операцій:**
  - Додавання нових витрат з назвою, сумою, категорією, датою та описом.
  - Отримання та відображення списку всіх витрат.
  - Редагування та видалення записів за допомогою методів `save()` та `delete()` від `HiveObject`.
- **Аналітика та статистика:**
  - Автоматичний розрахунок загальної суми витрат.
  - Підрахунок середньої суми витрат та пошук найбільшої витрати[cite: 1].
  - Групування витрат за категоріями (`Food`, `Transport`, `Entertainment`, `Shopping`, `Other`)[cite: 1].
- **Реактивний UI:**
  - Використання `ValueListenableBuilder` для миттєвого оновлення інтерфейсу без перезавантаження екрана при зміні даних у Hive[cite: 1].

---

##  Технології та пакети

- **Flutter / Dart**
- **[Hive](https://pub.dev/packages/hive)** & **[Hive Flutter](https://pub.dev/packages/hive_flutter)** — локальна NoSQL база даних
- **[hive_generator](https://pub.dev/packages/hive_generator)** & **[build_runner](https://pub.dev/packages/build_runner)** — кодогенерація `TypeAdapter`
- **[intl](https://pub.dev/packages/intl)** — форматування дат та часу

---

##  Структура проєкту

```text
lib/
├── models/
│   ├── expense.dart       # Модель даних з анотаціями @HiveType та @HiveField
│   └── expense.g.dart     # Згенерований TypeAdapter
├── repositories/
│   └── expense_repository.dart  # Логіка CRUD та аналітики Hive
├── screens/
│   └── expenses_screen.dart    # Реактивний UI (ValueListenableBuilder, форма, список)
└── main.dart              # Ініціалізація Hive, реєстрація адаптера та запуск
