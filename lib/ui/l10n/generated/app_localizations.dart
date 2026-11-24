import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// App name in the task switcher. Not translated.
  ///
  /// In ru, this message translates to:
  /// **'Stepfold'**
  String get appTitle;

  /// Bottom bar tab: today's goal and steps.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get tabToday;

  /// Bottom bar tab: kinds and progressions to choose from.
  ///
  /// In ru, this message translates to:
  /// **'Каталог'**
  String get tabCatalog;

  /// Bottom bar tab: the world the user has unfolded.
  ///
  /// In ru, this message translates to:
  /// **'Мир'**
  String get tabWorld;

  /// Bottom bar tab: rewards by kind.
  ///
  /// In ru, this message translates to:
  /// **'Альбом'**
  String get tabAlbum;

  /// No description provided for @todaySteps.
  ///
  /// In ru, this message translates to:
  /// **'Шаги сегодня'**
  String get todaySteps;

  /// No description provided for @todayUnknownSteps.
  ///
  /// In ru, this message translates to:
  /// **'—'**
  String get todayUnknownSteps;

  /// No description provided for @todayStreak.
  ///
  /// In ru, this message translates to:
  /// **'Серия'**
  String get todayStreak;

  /// No description provided for @todayStreakDays.
  ///
  /// In ru, this message translates to:
  /// **'{days, plural, one{{days} день} few{{days} дня} many{{days} дней} other{{days} дня}}'**
  String todayStreakDays(int days);

  /// No description provided for @todayStreakThreshold.
  ///
  /// In ru, this message translates to:
  /// **'Дни с {steps}+ шагов'**
  String todayStreakThreshold(int steps);

  /// No description provided for @todayStreakReached.
  ///
  /// In ru, this message translates to:
  /// **'{day}, порог серии достигнут'**
  String todayStreakReached(String day);

  /// No description provided for @todayStreakMissed.
  ///
  /// In ru, this message translates to:
  /// **'{day}, порог серии ещё не достигнут'**
  String todayStreakMissed(String day);

  /// No description provided for @todayChooseGoal.
  ///
  /// In ru, this message translates to:
  /// **'Выберите цель'**
  String get todayChooseGoal;

  /// No description provided for @todayToCatalog.
  ///
  /// In ru, this message translates to:
  /// **'В каталог'**
  String get todayToCatalog;

  /// No description provided for @todayReserve.
  ///
  /// In ru, this message translates to:
  /// **'В запасе {steps}'**
  String todayReserve(String steps);

  /// No description provided for @todayDebt.
  ///
  /// In ru, this message translates to:
  /// **'Долг {steps}'**
  String todayDebt(String steps);

  /// No description provided for @todayGoalPrice.
  ///
  /// In ru, this message translates to:
  /// **'Цена {steps}'**
  String todayGoalPrice(String steps);

  /// No description provided for @todayStepsLeft.
  ///
  /// In ru, this message translates to:
  /// **'Осталось {steps}'**
  String todayStepsLeft(String steps);

  /// No description provided for @stepCount.
  ///
  /// In ru, this message translates to:
  /// **'{steps, plural, one{{steps} шаг} few{{steps} шага} many{{steps} шагов} other{{steps} шага}}'**
  String stepCount(int steps);

  /// No description provided for @todayReady.
  ///
  /// In ru, this message translates to:
  /// **'Шагов хватает'**
  String get todayReady;

  /// No description provided for @todayOpenChapter.
  ///
  /// In ru, this message translates to:
  /// **'Открыть главу'**
  String get todayOpenChapter;

  /// No description provided for @todayBuyMedal.
  ///
  /// In ru, this message translates to:
  /// **'Купить медаль'**
  String get todayBuyMedal;

  /// No description provided for @todaySilverMedal.
  ///
  /// In ru, this message translates to:
  /// **'Серебряная медаль'**
  String get todaySilverMedal;

  /// No description provided for @todayGoldMedal.
  ///
  /// In ru, this message translates to:
  /// **'Золотая медаль'**
  String get todayGoldMedal;

  /// No description provided for @todayBronzeMedal.
  ///
  /// In ru, this message translates to:
  /// **'Бронзовая медаль'**
  String get todayBronzeMedal;

  /// No description provided for @todayCatalogError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить каталог'**
  String get todayCatalogError;

  /// No description provided for @todayGoalUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Цель недоступна'**
  String get todayGoalUnavailable;

  /// No description provided for @todayProgressError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить прогресс'**
  String get todayProgressError;

  /// No description provided for @todayProgressRetryMessage.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте загрузить его ещё раз.'**
  String get todayProgressRetryMessage;

  /// No description provided for @todaySpendingFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить трату шагов.'**
  String get todaySpendingFailed;

  /// No description provided for @todayReserveChanged.
  ///
  /// In ru, this message translates to:
  /// **'Запас изменился. Проверьте, сколько шагов осталось.'**
  String get todayReserveChanged;

  /// No description provided for @todayAllowSteps.
  ///
  /// In ru, this message translates to:
  /// **'Подключите подсчёт шагов'**
  String get todayAllowSteps;

  /// No description provided for @todayAllowStepsMessage.
  ///
  /// In ru, this message translates to:
  /// **'Так шаги будут добавляться автоматически.'**
  String get todayAllowStepsMessage;

  /// No description provided for @todayAllow.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить'**
  String get todayAllow;

  /// No description provided for @todayStepsBlocked.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к шагам выключен'**
  String get todayStepsBlocked;

  /// No description provided for @todayStepsBlockedMessage.
  ///
  /// In ru, this message translates to:
  /// **'Разрешение можно дать в настройках телефона.'**
  String get todayStepsBlockedMessage;

  /// No description provided for @todayOpenSettings.
  ///
  /// In ru, this message translates to:
  /// **'Открыть настройки'**
  String get todayOpenSettings;

  /// No description provided for @todayStepsUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Счётчик недоступен'**
  String get todayStepsUnavailable;

  /// No description provided for @todayStepsUnavailableMessage.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённые шаги остаются доступны.'**
  String get todayStepsUnavailableMessage;

  /// No description provided for @todayStepSyncError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить шаги'**
  String get todayStepSyncError;

  /// No description provided for @storageFull.
  ///
  /// In ru, this message translates to:
  /// **'Освободите место на устройстве и повторите попытку.'**
  String get storageFull;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @chapterReader.
  ///
  /// In ru, this message translates to:
  /// **'Чтение главы'**
  String get chapterReader;

  /// No description provided for @chapterBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get chapterBack;

  /// No description provided for @chapterEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В этой главе пока нет содержимого'**
  String get chapterEmpty;

  /// No description provided for @chapterUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Глава недоступна'**
  String get chapterUnavailable;

  /// No description provided for @chapterReadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить главу'**
  String get chapterReadError;

  /// No description provided for @chapterRetryMessage.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте загрузить её ещё раз.'**
  String get chapterRetryMessage;

  /// No description provided for @chapterImageError.
  ///
  /// In ru, this message translates to:
  /// **'Изображение недоступно'**
  String get chapterImageError;

  /// No description provided for @journeyMap.
  ///
  /// In ru, this message translates to:
  /// **'Карта путешествия'**
  String get journeyMap;

  /// No description provided for @journeyTilesUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Подложка недоступна'**
  String get journeyTilesUnavailable;

  /// No description provided for @journeyNextStop.
  ///
  /// In ru, this message translates to:
  /// **'Следующая остановка — {title}'**
  String journeyNextStop(String title);

  /// No description provided for @journeyReachedStop.
  ///
  /// In ru, this message translates to:
  /// **'Достигнутая остановка'**
  String get journeyReachedStop;

  /// No description provided for @journeyPreviewPosition.
  ///
  /// In ru, this message translates to:
  /// **'Предварительная позиция'**
  String get journeyPreviewPosition;

  /// No description provided for @journeyProgress.
  ///
  /// In ru, this message translates to:
  /// **'{steps} из {total}'**
  String journeyProgress(int steps, String total);

  /// No description provided for @catalogReadError.
  ///
  /// In ru, this message translates to:
  /// **'Каталог недоступен'**
  String get catalogReadError;

  /// No description provided for @catalogRetryMessage.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте загрузить его ещё раз.'**
  String get catalogRetryMessage;

  /// No description provided for @catalogEmpty.
  ///
  /// In ru, this message translates to:
  /// **'В каталоге пока пусто'**
  String get catalogEmpty;

  /// No description provided for @catalogEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Прогрессии появятся здесь, когда будут доступны.'**
  String get catalogEmptyMessage;

  /// No description provided for @catalogFilterEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Прогрессий такой длины пока нет'**
  String get catalogFilterEmpty;

  /// No description provided for @catalogFilterEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте выбрать другую длину.'**
  String get catalogFilterEmptyMessage;

  /// No description provided for @catalogChangeLength.
  ///
  /// In ru, this message translates to:
  /// **'Изменить длину'**
  String get catalogChangeLength;

  /// No description provided for @catalogProgressionUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Прогрессия недоступна'**
  String get catalogProgressionUnavailable;

  /// No description provided for @catalogStrictOrder.
  ///
  /// In ru, this message translates to:
  /// **'Главы открываются по порядку'**
  String get catalogStrictOrder;

  /// No description provided for @catalogFreeOrder.
  ///
  /// In ru, this message translates to:
  /// **'Главы открываются в любом порядке'**
  String get catalogFreeOrder;

  /// No description provided for @catalogChapterOpened.
  ///
  /// In ru, this message translates to:
  /// **'Открыта'**
  String get catalogChapterOpened;

  /// No description provided for @catalogChapterLocked.
  ///
  /// In ru, this message translates to:
  /// **'По порядку'**
  String get catalogChapterLocked;

  /// No description provided for @catalogChooseGoal.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать цель'**
  String get catalogChooseGoal;

  /// No description provided for @catalogCurrentGoal.
  ///
  /// In ru, this message translates to:
  /// **'Текущая цель'**
  String get catalogCurrentGoal;

  /// No description provided for @catalogGoalSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить цель. Попробуйте ещё раз.'**
  String get catalogGoalSaveError;

  /// No description provided for @historyTitle.
  ///
  /// In ru, this message translates to:
  /// **'История шагов'**
  String get historyTitle;

  /// No description provided for @historyPreview.
  ///
  /// In ru, this message translates to:
  /// **'История · 1 000 дней'**
  String get historyPreview;

  /// No description provided for @historyThisWeek.
  ///
  /// In ru, this message translates to:
  /// **'На этой неделе'**
  String get historyThisWeek;

  /// No description provided for @historyToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get historyToday;

  /// No description provided for @historyByDay.
  ///
  /// In ru, this message translates to:
  /// **'По дням'**
  String get historyByDay;

  /// No description provided for @historyReadError.
  ///
  /// In ru, this message translates to:
  /// **'История недоступна'**
  String get historyReadError;

  /// No description provided for @historyEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Шагов пока нет'**
  String get historyEmpty;

  /// No description provided for @historyEmptyMessage.
  ///
  /// In ru, this message translates to:
  /// **'Когда появятся шаги, здесь будет история по дням.'**
  String get historyEmptyMessage;

  /// No description provided for @historyAddSteps.
  ///
  /// In ru, this message translates to:
  /// **'Добавить шаги'**
  String get historyAddSteps;

  /// No description provided for @historyEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Исправить добавку'**
  String get historyEditTitle;

  /// No description provided for @historyDateField.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get historyDateField;

  /// No description provided for @historyAmount.
  ///
  /// In ru, this message translates to:
  /// **'Количество шагов'**
  String get historyAmount;

  /// No description provided for @historyInvalidAmount.
  ///
  /// In ru, this message translates to:
  /// **'Введите целое число шагов больше нуля.'**
  String get historyInvalidAmount;

  /// No description provided for @historySave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get historySave;

  /// No description provided for @historyRemove.
  ///
  /// In ru, this message translates to:
  /// **'Удалить добавку'**
  String get historyRemove;

  /// No description provided for @historyCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get historyCancel;

  /// No description provided for @historyConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить добавку'**
  String get historyConfirmTitle;

  /// No description provided for @historyConfirmMessage.
  ///
  /// In ru, this message translates to:
  /// **'Добавить {steps} за {date}?'**
  String historyConfirmMessage(String steps, String date);

  /// No description provided for @historyLock.
  ///
  /// In ru, this message translates to:
  /// **'Запрет ручного ввода'**
  String get historyLock;

  /// No description provided for @historyLockOn.
  ///
  /// In ru, this message translates to:
  /// **'Ручной ввод запрещён.'**
  String get historyLockOn;

  /// No description provided for @historyLockOnSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Снятие запрета займёт 2 часа'**
  String get historyLockOnSubtitle;

  /// No description provided for @historyLockOff.
  ///
  /// In ru, this message translates to:
  /// **'Запрет выключен'**
  String get historyLockOff;

  /// No description provided for @historyLockUntil.
  ///
  /// In ru, this message translates to:
  /// **'Ручной ввод откроется {date}'**
  String historyLockUntil(String date);

  /// No description provided for @historyKeepLock.
  ///
  /// In ru, this message translates to:
  /// **'Оставить запрет'**
  String get historyKeepLock;

  /// No description provided for @historyDateUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'За этот день уже нельзя изменить ручные шаги.'**
  String get historyDateUnavailable;

  /// No description provided for @historyWriteError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить. Повторите попытку.'**
  String get historyWriteError;

  /// No description provided for @historyManualLabel.
  ///
  /// In ru, this message translates to:
  /// **'{auto} + {manual} вручную'**
  String historyManualLabel(String auto, String manual);

  /// No description provided for @historyCountAndDistance.
  ///
  /// In ru, this message translates to:
  /// **'{steps} (≈{distance} км)'**
  String historyCountAndDistance(String steps, String distance);

  /// No description provided for @historyBestDay.
  ///
  /// In ru, this message translates to:
  /// **'Лучший день — {date}, {steps}'**
  String historyBestDay(String date, String steps);

  /// No description provided for @historyOpenedChapters.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Открыта {count} глава} few{Открыто {count} главы} other{Открыто {count} глав}}'**
  String historyOpenedChapters(int count);

  /// No description provided for @historyBoughtMedals.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{Куплена {count} медаль} few{Куплено {count} медали} other{Куплено {count} медалей}}'**
  String historyBoughtMedals(int count);

  /// No description provided for @historyImprovement.
  ///
  /// In ru, this message translates to:
  /// **'На {steps} больше, чем за те же дни прошлой недели'**
  String historyImprovement(String steps);

  /// No description provided for @historyNevsky.
  ///
  /// In ru, this message translates to:
  /// **'длины Невского проспекта'**
  String get historyNevsky;

  /// No description provided for @historyOpenedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Открыта глава «{title}»'**
  String historyOpenedTitle(String title);

  /// No description provided for @historyBoughtTitle.
  ///
  /// In ru, this message translates to:
  /// **'Медаль «{medal}» за «{progression}»'**
  String historyBoughtTitle(String medal, String progression);

  /// No description provided for @historyBronze.
  ///
  /// In ru, this message translates to:
  /// **'Бронза'**
  String get historyBronze;

  /// No description provided for @historySilver.
  ///
  /// In ru, this message translates to:
  /// **'Серебро'**
  String get historySilver;

  /// No description provided for @historyGold.
  ///
  /// In ru, this message translates to:
  /// **'Золото'**
  String get historyGold;

  /// No description provided for @historyMarathon.
  ///
  /// In ru, this message translates to:
  /// **'марафонской дистанции'**
  String get historyMarathon;

  /// No description provided for @historyMkad.
  ///
  /// In ru, this message translates to:
  /// **'длины МКАД'**
  String get historyMkad;

  /// No description provided for @historyFactPercent.
  ///
  /// In ru, this message translates to:
  /// **'Это примерно {ratio}% {reference}.'**
  String historyFactPercent(String ratio, String reference);

  /// No description provided for @historyFactMultiple.
  ///
  /// In ru, this message translates to:
  /// **'Это примерно {ratio} от {reference}.'**
  String historyFactMultiple(String ratio, String reference);

  /// No description provided for @historyFactUnder.
  ///
  /// In ru, this message translates to:
  /// **'Это меньше 0,01% {reference}.'**
  String historyFactUnder(String reference);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
