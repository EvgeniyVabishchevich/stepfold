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
  String get tabSettings => 'Настройки';

  @override
  String get todayMilestone => 'Веха пути';

  @override
  String get todayMilestoneUnder => 'Пройдено меньше 0,01% высоты Эвереста.';

  @override
  String todayMilestonePercent(String ratio) {
    return 'Пройдено примерно $ratio% высоты Эвереста.';
  }

  @override
  String todayMilestoneMultiple(String ratio) {
    return 'Пройдено примерно $ratio высоты Эвереста.';
  }

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

  @override
  String get journeyMap => 'Карта путешествия';

  @override
  String get journeyTilesUnavailable => 'Подложка недоступна';

  @override
  String journeyNextStop(String title) {
    return 'Следующая остановка — $title';
  }

  @override
  String get journeyReachedStop => 'Достигнутая остановка';

  @override
  String get journeyPreviewPosition => 'Предварительная позиция';

  @override
  String journeyProgress(int steps, String total) {
    final intl.NumberFormat stepsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String stepsString = stepsNumberFormat.format(steps);

    return '$stepsString из $total';
  }

  @override
  String get catalogReadError => 'Каталог недоступен';

  @override
  String get catalogRetryMessage => 'Попробуйте загрузить его ещё раз.';

  @override
  String get catalogEmpty => 'В каталоге пока пусто';

  @override
  String get catalogEmptyMessage =>
      'Прогрессии появятся здесь, когда будут доступны.';

  @override
  String get catalogFilterEmpty => 'Прогрессий такой длины пока нет';

  @override
  String get catalogFilterEmptyMessage => 'Попробуйте выбрать другую длину.';

  @override
  String get catalogChangeLength => 'Изменить длину';

  @override
  String get catalogProgressionUnavailable => 'Прогрессия недоступна';

  @override
  String get catalogStrictOrder => 'Главы открываются по порядку';

  @override
  String get catalogFreeOrder => 'Главы открываются в любом порядке';

  @override
  String get catalogChapterOpened => 'Открыта';

  @override
  String get catalogChapterLocked => 'По порядку';

  @override
  String get catalogChooseGoal => 'Выбрать цель';

  @override
  String get catalogCurrentGoal => 'Текущая цель';

  @override
  String get catalogGoalSaveError =>
      'Не удалось сохранить цель. Попробуйте ещё раз.';

  @override
  String get historyTitle => 'История шагов';

  @override
  String get historyPreview => 'История · 1 000 дней';

  @override
  String get historyThisWeek => 'На этой неделе';

  @override
  String get historyToday => 'Сегодня';

  @override
  String get historyByDay => 'По дням';

  @override
  String get historyReadError => 'История недоступна';

  @override
  String get historyEmpty => 'Шагов пока нет';

  @override
  String get historyEmptyMessage =>
      'Когда появятся шаги, здесь будет история по дням.';

  @override
  String get historyAddSteps => 'Добавить шаги';

  @override
  String get historyEditTitle => 'Исправить добавку';

  @override
  String get historyDateField => 'Дата';

  @override
  String get historyAmount => 'Количество шагов';

  @override
  String get historyInvalidAmount => 'Введите целое число шагов больше нуля.';

  @override
  String get historySave => 'Сохранить';

  @override
  String get historyRemove => 'Удалить добавку';

  @override
  String get historyCancel => 'Отмена';

  @override
  String get historyConfirmTitle => 'Подтвердить добавку';

  @override
  String historyConfirmMessage(String steps, String date) {
    return 'Добавить $steps за $date?';
  }

  @override
  String get historyLock => 'Запрет ручного ввода';

  @override
  String get historyLockOn => 'Ручной ввод запрещён.';

  @override
  String get historyLockOnSubtitle => 'Снятие запрета займёт 2 часа';

  @override
  String get historyLockOff => 'Запрет выключен';

  @override
  String historyLockUntil(String date) {
    return 'Ручной ввод откроется $date';
  }

  @override
  String get historyKeepLock => 'Оставить запрет';

  @override
  String get historyDateUnavailable =>
      'За этот день уже нельзя изменить ручные шаги.';

  @override
  String get historyWriteError => 'Не удалось сохранить. Повторите попытку.';

  @override
  String historyManualLabel(String auto, String manual) {
    return '$auto + $manual вручную';
  }

  @override
  String historyCountAndDistance(String steps, String distance) {
    return '$steps (≈$distance км)';
  }

  @override
  String historyBestDay(String date, String steps) {
    return 'Лучший день — $date, $steps';
  }

  @override
  String historyOpenedChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Открыто $count глав',
      few: 'Открыто $count главы',
      one: 'Открыта $count глава',
    );
    return '$_temp0';
  }

  @override
  String historyBoughtMedals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Куплено $count медалей',
      few: 'Куплено $count медали',
      one: 'Куплена $count медаль',
    );
    return '$_temp0';
  }

  @override
  String historyImprovement(String steps) {
    return 'На $steps больше, чем за те же дни прошлой недели';
  }

  @override
  String get historyNevsky => 'длины Невского проспекта';

  @override
  String historyOpenedTitle(String title) {
    return 'Открыта глава «$title»';
  }

  @override
  String historyBoughtTitle(String medal, String progression) {
    return 'Медаль «$medal» за «$progression»';
  }

  @override
  String get historyBronze => 'Бронза';

  @override
  String get historySilver => 'Серебро';

  @override
  String get historyGold => 'Золото';

  @override
  String get historyMarathon => 'марафонской дистанции';

  @override
  String get historyMkad => 'длины МКАД';

  @override
  String historyFactPercent(String ratio, String reference) {
    return 'Это примерно $ratio% $reference.';
  }

  @override
  String historyFactMultiple(String ratio, String reference) {
    return 'Это примерно $ratio от $reference.';
  }

  @override
  String historyFactUnder(String reference) {
    return 'Это меньше 0,01% $reference.';
  }
}
