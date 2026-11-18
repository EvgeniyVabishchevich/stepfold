// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Stepfold';

  @override
  String get tabToday => 'Сегодня';

  @override
  String get tabCatalog => 'Каталог';

  @override
  String get tabWorld => 'Мир';

  @override
  String get tabAlbum => 'Альбом';

  @override
  String get todaySteps => 'Шаги сегодня';

  @override
  String get todayUnknownSteps => '—';

  @override
  String get todayStreak => 'Серия';

  @override
  String todayStreakDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String todayStreakThreshold(int steps) {
    final intl.NumberFormat stepsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String stepsString = stepsNumberFormat.format(steps);

    return 'Дни с $stepsString+ шагов';
  }

  @override
  String todayStreakReached(String day) {
    return '$day, порог серии достигнут';
  }

  @override
  String todayStreakMissed(String day) {
    return '$day, порог серии ещё не достигнут';
  }

  @override
  String get todayChooseGoal => 'Выберите цель';

  @override
  String get todayToCatalog => 'В каталог';

  @override
  String todayReserve(String steps) {
    return 'В запасе $steps';
  }

  @override
  String todayDebt(String steps) {
    return 'Долг $steps';
  }

  @override
  String todayGoalPrice(String steps) {
    return 'Цена $steps';
  }

  @override
  String todayStepsLeft(String steps) {
    return 'Осталось $steps';
  }

  @override
  String stepCount(int steps) {
    final intl.NumberFormat stepsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String stepsString = stepsNumberFormat.format(steps);

    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$stepsString шага',
      many: '$stepsString шагов',
      few: '$stepsString шага',
      one: '$stepsString шаг',
    );
    return '$_temp0';
  }

  @override
  String get todayReady => 'Шагов хватает';

  @override
  String get todayOpenChapter => 'Открыть главу';

  @override
  String get todayBuyMedal => 'Купить медаль';

  @override
  String get todaySilverMedal => 'Серебряная медаль';

  @override
  String get todayGoldMedal => 'Золотая медаль';

  @override
  String get todayBronzeMedal => 'Бронзовая медаль';

  @override
  String get todayCatalogError => 'Не удалось загрузить каталог';

  @override
  String get todayGoalUnavailable => 'Цель недоступна';

  @override
  String get todayProgressError => 'Не удалось загрузить прогресс';

  @override
  String get todayProgressRetryMessage => 'Попробуйте загрузить его ещё раз.';

  @override
  String get todaySpendingFailed => 'Не удалось сохранить трату шагов.';

  @override
  String get todayReserveChanged =>
      'Запас изменился. Проверьте, сколько шагов осталось.';

  @override
  String get todayAllowSteps => 'Подключите подсчёт шагов';

  @override
  String get todayAllowStepsMessage =>
      'Так шаги будут добавляться автоматически.';

  @override
  String get todayAllow => 'Разрешить';

  @override
  String get todayStepsBlocked => 'Доступ к шагам выключен';

  @override
  String get todayStepsBlockedMessage =>
      'Разрешение можно дать в настройках телефона.';

  @override
  String get todayOpenSettings => 'Открыть настройки';

  @override
  String get todayStepsUnavailable => 'Счётчик недоступен';

  @override
  String get todayStepsUnavailableMessage =>
      'Сохранённые шаги остаются доступны.';

  @override
  String get todayStepSyncError => 'Не удалось обновить шаги';

  @override
  String get storageFull =>
      'Освободите место на устройстве и повторите попытку.';

  @override
  String get retry => 'Повторить';

  @override
  String get chapterReader => 'Чтение главы';

  @override
  String get chapterBack => 'Назад';

  @override
  String get chapterEmpty => 'В этой главе пока нет содержимого';

  @override
  String get chapterUnavailable => 'Глава недоступна';

  @override
  String get chapterReadError => 'Не удалось загрузить главу';

  @override
  String get chapterRetryMessage => 'Попробуйте загрузить её ещё раз.';

  @override
  String get chapterImageError => 'Изображение недоступно';
}
