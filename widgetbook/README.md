# Stepfold Widgetbook

Каталог UI-кита: каждый компонент во всех состояниях, в светлой и тёмной теме, на разных экранах и с крупным шрифтом.

- Запуск: `fvm flutter run -d chrome` или `-d macos` из этой папки.
- Новый компонент: функция с `@widgetbook.UseCase` в `lib/kit/`, затем `fvm dart run build_runner build`. Дерево каталога собирается в `lib/main.directories.g.dart`.
