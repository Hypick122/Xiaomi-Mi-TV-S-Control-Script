@echo off
chcp 65001 >nul
color 0F
cls

:: Инициализация переменной
set "status_tv="


:start
echo [101;93mЗапуск скрипта...[0m
adb kill-server
adb start-server

:initial_tv_setup
echo.
echo [4mНастройка телевизора: Первые шаги[0m
echo.
echo 1. Перейдите в настройки телевизора [36m"Settings -> About -> Model"[0m
echo 2. Нажмите 7 раз на кнопку [36m"ОК"[0m на пульте до появления уведомления [36m"You are already a developer"[0m
echo 3. Далее в настройках выберите [36m"Settings -> Account & Security ->"[0m и активируйте [36m"ADB Debugging -> Allow"[0m
echo 4. Включите установку приложений из неизвестных источников [36m"Unknown sources -> Allow"[0m
echo 5. Определите IP-адрес телевизора в [36m"Settings -> About -> Network info"[0m (Запомните или сфотографируйте его)
goto connect_to_tv



:main_menu
echo.
echo   [1;34mСкрипт управления ТВ Xiaomi Mi TV S[0m
echo.
echo   [31m0.[0m Завершить работу скрипта
echo ————————————————
if defined status_tv (
    echo   [1;32m1.[0m Подключиться к ТВ [1;32m[ПОДКЛЮЧЕНО к %UserInput%][0m
) else (
    echo   [1;32m1.[0m Подключиться к ТВ [1;31mНЕ ПОДКЛЮЧЕНО[0m
)
echo   [1;32m2.[0m Перезагрузить ТВ
echo ————————————————
echo   [1;32m3.[0m Установить или восстановить лаунчер
echo   [1;32m4.[0m Открыть меню выбора лаунчера на ТВ
echo ————————————————
echo   [1;32m5.[0m Отключить ненужные системные приложения
echo ————————————————
echo   [1;32m6.[0m Установить необходимые системные приложения
echo   [1;32m7.[0m Настроить разрешения и службы приложений
echo ————————————————
echo   [1;32m8.[0m Установить сторонние приложения
echo ————————————————
echo   [1;32m9.[0m Активировать сервис специальных возможностей
echo   [1;32m10.[0m Добавить приложение в сервис специальных возможностей
echo ————————————————
echo   [1;32m11.[0m Показать список установленных приложений
echo   [1;32m12.[0m Выполнить свои команды ADB
rem echo ————————————————
rem echo   [1;32m13.[0m Показать справку
echo.
set /p ChoiceInput=Введите ваш выбор [0-12]: 
if "%ChoiceInput%"=="0" goto exit
if "%ChoiceInput%"=="1" goto connect_to_tv
if "%ChoiceInput%"=="2" goto reboot_tv
if "%ChoiceInput%"=="3" goto setup_launcher
if "%ChoiceInput%"=="4" goto launcher_menu
if "%ChoiceInput%"=="5" goto disable_unnecessary_apps
if "%ChoiceInput%"=="6" goto install_system_apps
if "%ChoiceInput%"=="7" goto configure_permissions
if "%ChoiceInput%"=="8" goto install_third_party_apps
if "%ChoiceInput%"=="9" goto enable_a11y_service
if "%ChoiceInput%"=="10" goto add_to_a11y
if "%ChoiceInput%"=="11" goto view_installed_packages
if "%ChoiceInput%"=="12" goto adb_commands
rem if "%ChoiceInput%"=="13" goto show_help
echo [31mОшибка: введите корректное число от 0 до 12[0m
goto main_menu



:reboot_tv
echo [31mВНИМАНИЕ![0m После перезапуска нужно будет заново подключиться к ТВ
echo [101;93mПерезапускаю ТВ...[0m
set "status_tv="
adb reboot
goto connect_to_tv



:adb_commands
echo.
echo Теперь вы можете вводить команды ADB.
echo Для выхода введите [31mEXIT[0m.

:enter_command
set /p adb_cmd=[1;32madb@%status_tv%[0m: 
if /i "%adb_cmd%" == "EXIT" goto main_menu
%adb_cmd%
goto :enter_command



:connect_to_tv
echo.
set /p UserInput=Введите IP-адрес телевизора в формате 0.0.0.0: 
adb connect %UserInput%

:check_connection
for /f "skip=1" %%i in ('adb devices') do set output=%%i
for /f "delims= " %%i in ("%output%") do (set device=%%i)
if "%device%" == "%UserInput%:5555" goto connection_successful
echo.
echo [31mОшибка подключения: попробуйте подключиться повторно.[0m
goto connect_to_tv

:connection_successful
echo.
echo [1;92mПодключение успешно к устройству[0m [94m%UserInput%[0m.
echo.
echo [31mВажно! Обратите внимание на экран телевизора.[0m
echo На экране появится окно [36m"Allow USB debugging?"[0m.
echo Поставьте галочку [36m"Always allow from this computer"[0m и нажмите [36m"Allow"[0m.
echo [31mЕсли вы находитесь в меню настроек телевизора, окно не появится.[0m
echo Выйдите из настроек на главный экран, нажав несколько раз кнопку [36m"Назад"[0m на пульте.

adb wait-for-device

echo.
set status_tv=%UserInput%
echo [1;92mТелевизор успешно подключен![0m
goto main_menu



:view_installed_packages
echo.
echo [4;97mПросмотр списка установленных приложений:[0m
adb shell pm list packages
goto main_menu



:disable_unnecessary_apps
echo.
echo [31mВНИМАНИЕ![0m Отключение системных приложений не нанесёт вреда телевизору, 
echo [36mно[0m может повлиять на работу некоторых функций или приложений!
echo.

choice /m "Вы уверены, что хотите продолжить?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:NO
goto main_menu
:YES
echo [101;93mОтключение ненужных системных приложений...[0m
adb shell pm disable-user --user 0 com.xiaomi.voicecontrol
adb shell pm disable-user --user 0 com.xiaomi.tweather
adb shell pm disable-user --user 0 com.xiaomi.setupwizard
adb shell pm disable-user --user 0 com.xiaomi.mitv.upgrade
adb shell pm disable-user --user 0 com.xiaomi.mitv.shop
adb shell pm disable-user --user 0 com.xiaomi.mitv.handbook
adb shell pm disable-user --user 0 com.xiaomi.mitv.calendar
adb shell pm disable-user --user 0 com.xiaomi.mitv.appstore
adb shell pm disable-user --user 0 com.sohu.inputmethod.sogou.tv
adb shell pm disable-user --user 0 com.miui.tv.analytics
adb shell pm disable-user --user 0 com.mitv.cloudcontrol
adb shell pm disable-user --user 0 com.duokan.videodaily
adb shell pm disable-user --user 0 com.android.dynsystem
adb shell pm disable-user --user 0 com.android.companiondevicemanager
adb shell pm disable-user --user 0 com.xiaomi.mitv.karaoke.service
rem adb shell pm disable-user --user 0 com.duokan.airkan.tvbox
rem adb shell pm disable-user --user 0 com.xiaomi.mitv.payment
rem adb shell pm disable-user --user 0 com.xiaomi.mitv.pay
rem adb shell pm disable-user --user 0 com.xiaomi.statistic
rem adb shell pm disable-user --user 0 com.xiaomi.mitv.debug
rem adb shell pm disable-user --user 0 com.android.providers.calendar
echo.
echo [1;92mОтключение завершено! Ненужные системные приложения отключены![0m
goto main_menu



:install_system_apps
echo.
echo [101;93mУстановка необходимых системных приложений...[0m

for %%f in (%~dp0system\*.apk) do (
echo Установка[36m %%~nxf [0m
adb install %%f
)

echo.
echo [1;92mУстановка необходимых системных приложений завершена![0m
choice /m "Настроить разрешения и службы приложений?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:YES
goto configure_permissions
:NO
goto main_menu



:configure_permissions
echo.
echo [101;93mВыполняется настройка разрешений и служб приложений...[0m

echo Установка часового пояса на [36mEurope/Moscow[0m
adb shell service call alarm 3 s16 Europe/Moscow

echo Установка приложения [36mAppium[0m для настройки языка
adb install %~dp0lang/Appium.apk

echo Предоставление разрешений [36mAppium[0m для смены языка
adb shell pm grant io.appium.settings android.permission.CHANGE_CONFIGURATION

echo Смена языка системы на русский
adb shell am broadcast -a io.appium.settings.locale -n io.appium.settings/.receivers.LocaleSettingReceiver --es lang ru --es country RU

echo Удаление приложения [36mAppium[0m после завершения настройки
adb uninstall io.appium.settings

echo.
echo [1;92mНастройка разрешений и служб успешно завершена![0m
goto main_menu



:install_third_party_apps
echo.
echo [31mВНИМАНИЕ![0m Вы можете автоматически установить сторонние приложения с расширением 
echo [36m.apk[0m, добавив их в папку [36m%~dp0app\[0m.
echo.

choice /m "Продолжить установку сторонних приложений?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:NO
goto main_menu
:YES
echo [101;93mНачало установки сторонних приложений...[0m
for %%f in (%~dp0app\*.apk) do (
echo Установка[36m %%~nxf [0m
adb install %%f
)
echo.
echo [1;92mУстановка завершена! Все сторонние приложения установлены.[0m
goto main_menu



:enable_a11y_service
echo [101;93mАктивация сервиса специальных возможностей...[0m
adb shell settings put secure accessibility_enabled 1
adb shell settings put secure accessibility_services_state 1
echo.
echo [1;92mАктивация сервиса специальных возможностей завершена![0m
echo [31mВНИМАНИЕ![0m После перезагрузки ТВ сервис заново отключается.

choice /m "Вы хотите добавить приложения в сервис специальных возможностей?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:NO
goto main_menu
:YES
goto add_to_a11y



:add_to_a11y
echo.
echo [31mВНИМАНИЕ![0m При помощи данной функции Вы можете добавить приложение в [36mсервис специальных возможностей[0m
echo Введите название приложение (формат: [36mпакет/компонент[0m), или введите [31mEXIT[0m для выхода.
echo Например: ru.yourok.torrserve/ru.yourok.torrserve.server.local.services.GlobalTorrServeService - [36mTorrServe[0m
echo.

:input_service
set /p new_service=Введите приложение (или [31mEXIT[0m для выхода): 
if /i "%new_service%"=="EXIT" goto main_menu

for /f "delims=" %%A in ('adb shell settings get secure enabled_accessibility_services') do set current_services=%%A

set updated_services=%current_services%
if "%current_services%"=="" (
    set updated_services=%new_service%
) else (
    echo %current_services% | findstr /i /c:"%new_service%" >nul
    if errorlevel 1 (
        set updated_services=%current_services%:%new_service%
        echo [1;92mПриложение[0m [36m%new_service%[0m [1;92mдобавлен![0m
    ) else (
        echo [1;93mПриложение[0m [36m%new_service%[0m [1;93mуже добавлен![0m
    )
)

adb shell settings put secure enabled_accessibility_services "%updated_services%"
goto input_service



:setup_launcher
echo.
echo [1;32mМеню выбора лаунчера[0m
echo.
echo   [31m0.[0m Выйти назад в меню
echo ————————————————
echo   [1;32m1.[0m Установить Projectivy Launcher
echo   [1;32m2.[0m Установить Emotn UI launcher
echo   [1;32m3.[0m Установить ATV Launcher
echo   [1;32m4.[0m Восстановить стандартный MI лаунчер
echo.
set /p LauncherChoice=Введите ваш выбор [0-4]: 
if "%LauncherChoice%"=="0" goto main_menu
if "%LauncherChoice%"=="1" goto install_projectivy_launcher
if "%LauncherChoice%"=="2" goto install_emotn_launcher
if "%LauncherChoice%"=="3" goto install_atv_launcher
if "%LauncherChoice%"=="4" goto restore_mi_launcher
echo.
echo [31mОшибка: введите корректное число от 0 до 4[0m
goto setup_launcher



:install_atv_launcher
echo.
echo [101;93mЗамена лаунчера...[0m

echo Отключение других лаунчеров
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo Установка нового лаунчера: [36mATVLauncher[0m
adb install %~dp0launcher/ATVLauncher.apk

echo Назначение [36mATVLauncher[0m лаунчером по умолчанию
adb shell cmd package set-home-activity ca.dstudio.atvlauncher.pro/ca.dstudio.atvlauncher.screens.launcher.LauncherActivity

echo Настройка разрешений для [36mATVLauncher[0m
adb shell appwidget grantbind --package ca.dstudio.atvlauncher.pro --user 0

echo.
echo [1;92mЛаунчер успешно заменён на ATVLauncher![0m
goto launcher_menu



:install_emotn_launcher
echo.
echo [101;93mЗамена лаунчера...[0m

echo Отключение других лаунчеров
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo Установка нового лаунчера: [36mEmotn UI Launcher[0m
adb install %~dp0launcher/Emotn_UI_Launcher.apk

echo Назначение [36mEmotn UI Launcher[0m по умолчанию
adb shell cmd package set-home-activity com.oversea.aslauncher/com.oversea.aslauncher.ui.main.Main.Activity

echo.
echo [1;92mЛаунчер успешно заменён на Emotn UI Launcher![0m
goto launcher_menu



:install_projectivy_launcher
echo.
echo [101;93mЗамена лаунчера...[0m

echo Отключение других лаунчеров
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo Установка нового лаунчера: [36mProjectivy Launcher[0m
adb install %~dp0launcher/ProjectivyLauncher.apk

echo [101;93mВключение сервиса специальных возможностей...[0m
adb shell settings put secure accessibility_enabled 1
adb shell settings put secure accessibility_services_state 1

echo Включение [36mProjectivy Launcher[0m в сервисе специальных возможностей
set new_service=com.spocky.projengmenu/com.spocky.projengmenu.services.ProjectivyAccessibilityService:com.spocky.projengmenu/.services.WindowChangeDetectingService
for /f "delims=" %%A in ('adb shell settings get secure enabled_accessibility_services') do set current_services=%%A
if "%current_services%"=="" (
set updated_services=%new_service%
) else (
    set updated_services=%current_services%:%new_service%
)
adb shell settings put secure enabled_accessibility_services "%updated_services%"
echo [36mProjectivy Launcher[0m добавлен в enabled_accessibility_services

echo Назначение [36mProjectivy Launcher[0m по умолчанию
adb shell cmd package set-home-activity com.spocky.projengmenu

echo.
echo [1;92mЛаунчер успешно заменён на Projectivy Launcher![0m
goto launcher_menu



:restore_mi_launcher
echo.
echo [101;93mВосстановление стандартного MI лаунчера...[0m

rem echo Удаление сторонних лаунчеров
rem adb uninstall com.spocky.projengmenu
rem adb uninstall com.oversea.aslauncher
rem adb uninstall ca.dstudio.atvlauncher.pro

echo Активация MI лаунчера
adb shell pm enable --user 0 com.mitv.tvhome

echo.
echo [1;92mMI лаунчер успешно восстановлен![0m
goto main_menu



:launcher_menu
echo.
echo Выберите лаунчер по умолчанию.
echo В появившемся окне выберите нужный лаунчер и нажмите [36m"Always"[0m
echo.
choice /m "Открыть меню выбора лаунчера на ТВ?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:NO
goto main_menu
:YES

echo.
echo [101;93mЗапуск окна выбора лаунчера на телевизоре...[0m
adb shell am start -a android.intent.action.MAIN
rem adb shell am start -a android.intent.action.MAIN -c android.intent.category.HOME

echo.
echo [1;92mОкно выбора лаунчера успешно запущено![0m
goto main_menu



:exit
echo [31mЗавершение работы скрипта...[0m
adb kill-server
exit