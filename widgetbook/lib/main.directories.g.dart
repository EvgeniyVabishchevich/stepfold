// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:walks_widgetbook/kit/bottom_navigation.dart'
    as _walks_widgetbook_kit_bottom_navigation;
import 'package:walks_widgetbook/kit/button.dart'
    as _walks_widgetbook_kit_button;
import 'package:walks_widgetbook/kit/icon.dart' as _walks_widgetbook_kit_icon;
import 'package:walks_widgetbook/kit/progress_bar.dart'
    as _walks_widgetbook_kit_progress_bar;
import 'package:walks_widgetbook/kit/state_placeholder.dart'
    as _walks_widgetbook_kit_state_placeholder;
import 'package:walks_widgetbook/kit/top_bar.dart'
    as _walks_widgetbook_kit_top_bar;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'ui',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'kit',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'KitBottomNavigation',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Вкладки',
                builder:
                    _walks_widgetbook_kit_bottom_navigation.bottomNavigation,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'KitButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Второстепенная',
                builder: _walks_widgetbook_kit_button.secondaryButton,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Основная',
                builder: _walks_widgetbook_kit_button.primaryButton,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Текстовая',
                builder: _walks_widgetbook_kit_button.textButton,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'KitIcon',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Все иконки',
                builder: _walks_widgetbook_kit_icon.allIcons,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'KitProgressBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Полоса',
                builder: _walks_widgetbook_kit_progress_bar.progressBar,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'KitStatePlaceholder',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Загрузка',
                builder: _walks_widgetbook_kit_state_placeholder.loadingState,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Ошибка',
                builder: _walks_widgetbook_kit_state_placeholder.errorState,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Пусто',
                builder: _walks_widgetbook_kit_state_placeholder.emptyState,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'KitTopBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Панель',
                builder: _walks_widgetbook_kit_top_bar.topBar,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
