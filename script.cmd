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



:reply
echo.
echo [4mНачальная настройка телевизора:[0m
echo.
echo 1. Зайти в Настройки телевизора - [36m"Settings -> About -> Model"[0m
echo 2. Нажать до 7 раз на кнопку [36m"ОК" [0m на пульте до появления уведомления внизу экрана [36m"You are already a developer" [0m
echo 3. Далее [36m"Settings -> Account & Security ->"[0m активируем [36m"ADB Debugging -> Allow"[0m
echo 4. Так же активируем установку приложений из неизвестных источников [36m"Unkown sources -> Allow"[0m
echo 5. Определяем IP адрес телевизора - [36m"Settings -> About -> Network info"[0m (Запоминаем или фотографируем)
echo.
goto enter_ip



:enter_action
echo.
echo   [1;34mСкрипт управления ТВ Xiaomi Mi TV S[0m
echo.
echo   [31m0.[0m Выйти из скрипта
echo ————————————————
if defined status_tv (
    echo   [1;32m1.[0m Подключиться к ТВ [1;32m[ПОДКЛЮЧЕНО к %UserInput%][0m
) else (
    echo   [1;32m1.[0m Подключиться к ТВ
)
echo   [1;32m2.[0m Перезагрузить ТВ
echo ————————————————
echo   [1;32m3.[0m Список установленных пакетов
echo ————————————————
echo   [1;32m4.[0m Отключить предустановленные системные приложения
echo ————————————————
echo   [1;32m5.[0m Установить необходимые системные приложения
echo   [1;32m6.[0m Настроить разрешения и службы приложений
echo ————————————————
echo   [1;32m7.[0m Установить сторонние приложения
echo ————————————————
echo   [1;32m8.[0m Включить сервис специальных возможностей (ССВ)
echo   [1;32m9.[0m Добавить пакет в ССВ
echo ————————————————
echo   [1;32m10.[0m Установить или восстановить лаунчер
echo   [1;32m11.[0m Открыть на ТВ окно выбора лаунчера
echo ————————————————
echo   [1;32m12.[0m Ввести свои команды ADB
echo.
set /p ChoiceInput=Введите ваш выбор [0-12]: 
if "%ChoiceInput%"=="0" goto exit
if "%ChoiceInput%"=="1" goto enter_ip
if "%ChoiceInput%"=="2" goto reboot
if "%ChoiceInput%"=="3" goto view_apps
if "%ChoiceInput%"=="4" goto disable_system_apps
if "%ChoiceInput%"=="5" goto install_system_apps
if "%ChoiceInput%"=="6" goto activate_services
if "%ChoiceInput%"=="7" goto install_third_party_apps
if "%ChoiceInput%"=="8" goto enable_accessibility_services
if "%ChoiceInput%"=="9" goto add_to_accessibility_services
if "%ChoiceInput%"=="10" goto install_launcher
if "%ChoiceInput%"=="11" goto menu_select
if "%ChoiceInput%"=="12" goto command_prompt
echo [31mОшибка: введите корректное число от 0 до 12[0m
goto enter_action


:reboot
echo [31mВНИМАНИЕ![0m После перезапуска нужно будет заново подключиться к ТВ
echo [101;93mПерезапускаю ТВ...[0m
set "status_tv="
adb reboot
goto enter_ip



:command_prompt
echo.
echo Теперь вы можете вводить команды ADB.
echo Для выхода введите [31mEXIT[0m.


:adb_command
set /p adb_cmd=[1;32madb@%status_tv%[0m: 
if /i "%adb_cmd%" == "EXIT" goto enter_action
%adb_cmd%
goto :adb_command


:enter_ip
echo.
set /p UserInput=Введите IP-адрес телевизора в формате 0.0.0.0: 
adb connect %UserInput%


:not_connected
for /f "skip=1" %%i in ('adb devices') do set output=%%i
for /f "delims= " %%i in ("%output%") do (set device=%%i)
if "%device%" == "%UserInput%:5555" goto connected
echo.
echo [31mОшибка: попробуйте подключиться к ТВ повторно[0m
goto enter_action


:connected
echo.
echo [1;92mПодключено к[0m [94m%UserInput%[0m
echo.
echo [31mОбратите внимание на экран телевизора![0m
echo На экране появилось окно [36m"Allow USB debugging?"[0m - Ставим галочку на [36m"Always allow from this computer"[0m и разрешаем [36m"Allow"[0m
echo [31mЕсли вы находитесь в настройках телевизора, то окно не появится.[0m
echo Для того, чтобы появилось окно необходимо выйти из настроек на главный экран, для этого нажмите необходимое количество раз на кнопку [36m"НАЗАД"[0m на пульте...

adb wait-for-device

echo.
set status_tv=%UserInput%
echo [1;92mТелевизор подключен![0m
goto enter_action



:view_apps
echo.
echo [4;97mСписок установленных пакетов:[0m
adb shell pm list packages
goto enter_action



:disable_system_apps
echo.
echo [31mВНИМАНИЕ![0m Все отключаемые системные приложения не нанесут вред вашему телевизору,
echo [36mоднако[0m, данные изменения могут повлиять на работу отдельных приложений!

echo.
choice /m "Продолжить?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:NO
goto enter_action
:YES
echo [101;93mОтключение системных приложений...[0m
adb shell pm disable-user --user 0 com.xiaomi.voicecontrol
adb shell pm disable-user --user 0 com.xiaomi.tweather
adb shell pm disable-user --user 0 com.xiaomi.statistic
adb shell pm disable-user --user 0 com.xiaomi.setupwizard
adb shell pm disable-user --user 0 com.xiaomi.mitv.upgrade
adb shell pm disable-user --user 0 com.xiaomi.mitv.shop
adb shell pm disable-user --user 0 com.xiaomi.mitv.payment
adb shell pm disable-user --user 0 com.xiaomi.mitv.pay
adb shell pm disable-user --user 0 com.xiaomi.mitv.karaoke.service
adb shell pm disable-user --user 0 com.xiaomi.mitv.handbook
adb shell pm disable-user --user 0 com.xiaomi.mitv.debug
adb shell pm disable-user --user 0 com.xiaomi.mitv.calendar
adb shell pm disable-user --user 0 com.xiaomi.mitv.appstore
adb shell pm disable-user --user 0 com.sohu.inputmethod.sogou.tv
adb shell pm disable-user --user 0 com.miui.tv.analytics
adb shell pm disable-user --user 0 com.mitv.cloudcontrol
adb shell pm disable-user --user 0 com.duokan.videodaily
adb shell pm disable-user --user 0 com.duokan.airkan.tvbox
adb shell pm disable-user --user 0 com.android.providers.calendar
adb shell pm disable-user --user 0 com.android.dynsystem
adb shell pm disable-user --user 0 com.android.companiondevicemanager
echo.
echo [1;92mОтключение системных приложений завершено![0m
goto enter_action



:install_system_apps
echo.
echo [101;93mУстановка системных приложений...[0m

for %%f in (%~dp0system\*.apk) do (
echo Установка[36m %%~nxf [0m
adb install %%f
)

echo.
echo [1;92mУстановка системных приложений завершена![0m
choice /m "Настроить, активировать разрешения и службы приложений?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:YES
goto activate_services
:NO
goto enter_action



:activate_services
echo.
echo [101;93mПроизводится настройка разрешений и служб приложений...[0m

echo Смена часового пояса на [36mEurope/Moscow[0m
adb shell service call alarm 3 s16 Europe/Moscow

echo Установка [36mAppium[0m
adb install %~dp0lang/Appium.apk

echo Предоставление прав [36mAppium[0m на смену языка
adb shell pm grant io.appium.settings android.permission.CHANGE_CONFIGURATION

echo Изменение языка на русский
adb shell am broadcast -a io.appium.settings.locale -n io.appium.settings/.receivers.LocaleSettingReceiver --es lang ru --es country RU

echo Удаление [36mAppium[0m
adb uninstall io.appium.settings

echo.
echo [1;92mНастройка разрешений и служб приложений завершена![0m
goto enter_action



:install_third_party_apps
echo.
echo [31mВНИМАНИЕ![0m При помощи данной функции Вы можете автоматизированно устанавливать любые сторонние приложения 
echo с расширением [36m.apk[0m, положив установочные файлы в папку [36m%~dp0app\[0m
echo.

choice /m "Продолжить?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:NO
goto enter_action
:YES
echo [101;93mУстановка сторонних приложений...[0m
for %%f in (%~dp0app\*.apk) do (
echo Установка[36m %%~nxf [0m
adb install %%f
)
echo.
echo [1;92mУстановка сторонних приложений завершена![0m
goto enter_action



:enable_accessibility_services
echo [101;93mВключение сервиса специальных возможностей...[0m
adb shell settings put secure accessibility_enabled 1
adb shell settings put secure accessibility_services_state 1
echo.
echo [1;92mСервис включен![0m

choice /m "Вы хотите добавить приложения в ССВ?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:NO
goto enter_action
:YES
goto add_to_accessibility_services



:add_to_accessibility_services
echo.
echo [31mВНИМАНИЕ![0m При помощи данной функции Вы можете включить приложение в [36mсервисе специальных возможностей[0m
echo Введите название сервиса (формат: [36mпакет/компонент[0m), или введите [31mEXIT[0m для выхода.
echo Например: ru.yourok.torrserve/ru.yourok.torrserve.server.local.services.GlobalTorrServeService - [36mTorrServe[0m
echo.

:input_service
set /p new_service=Введите сервис (или [31mEXIT[0m для выхода): 
if /i "%new_service%"=="EXIT" goto enter_action

for /f "delims=" %%A in ('adb shell settings get secure enabled_accessibility_services') do set current_services=%%A

set updated_services=%current_services%
if "%current_services%"=="" (
    set updated_services=%new_service%
) else (
    echo %current_services% | findstr /i /c:"%new_service%" >nul
    if errorlevel 1 (
        set updated_services=%current_services%:%new_service%
        echo [1;92mСервис[0m [36m%new_service%[0m [1;92mдобавлен![0m
    ) else (
        echo [1;93mСервис[0m [36m%new_service%[0m [1;93mуже добавлен![0m
    )
)

adb shell settings put secure enabled_accessibility_services "%updated_services%"
goto input_service



:install_launcher
echo.
echo [1;32mМеню выбора лаунчера[0m
echo.
echo   [31m0.[0m Назад в меню
echo ————————————————
echo   [1;32m1.[0m Projectivy Launcher
echo   [1;32m2.[0m Emotn UI launcher
echo   [1;32m3.[0m ATV Launcher
echo   [1;32m4.[0m Вернуть MI лаунчер
echo.
set /p LauncherChoice=Введите ваш выбор [0-4]: 
if "%LauncherChoice%"=="0" goto enter_action
if "%LauncherChoice%"=="1" goto set_launcher_projectivy
if "%LauncherChoice%"=="2" goto set_launcher_emotn
if "%LauncherChoice%"=="3" goto set_launcher_atv
if "%LauncherChoice%"=="4" goto set_default_launcher
echo.
echo [31mОшибка: введите корректное число от 0 до 4[0m
goto install_launcher



:set_launcher_atv
echo.
echo [101;93mЗамена лаунчера...[0m

echo Отключение других лаунчеров
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo Установка [36mATVLauncher[0m
adb install %~dp0launcher/ATVLauncher.apk

echo Установка [36mATVLauncher[0m по умолчанию
adb shell pm set-home-activity ca.dstudio.atvlauncher.pro/ca.dstudio.atvlauncher.screens.launcher.LauncherActivity

echo Активация разрешений для [36mATVLauncher[0m
adb shell appwidget grantbind --package ca.dstudio.atvlauncher.pro --user 0

echo.
echo [1;92mЗамена лаунчера завершена![0m
goto menu_select



:set_launcher_emotn
echo.
echo [101;93mЗамена лаунчера...[0m

echo Отключение других лаунчеров
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo Установка [36mEmotn UI Launcher[0m
adb install %~dp0launcher/Emotn_UI_Launcher.apk

echo Установка [36mEmotn UI Launcher[0m по умолчанию
adb shell pm set-home-activity com.oversea.aslauncher/com.oversea.aslauncher.ui.main.Main.Activity

echo.
echo [1;92mЗамена лаунчера завершена![0m
goto menu_select



:set_launcher_projectivy
echo.
echo [101;93mЗамена лаунчера...[0m

echo Отключение других лаунчеров
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo Установка [36mProjectivy Launcher[0m
adb install %~dp0launcher/ProjectivyLauncher.apk

echo [101;93mВключение сервиса специальных возможностей...[0m
adb shell settings put secure accessibility_enabled 1
adb shell settings put secure accessibility_services_state 1

echo Добавление [36mProjectivy Launcher[0m в сервис специальных возможностей
set new_service=com.spocky.projengmenu/com.spocky.projengmenu.services.ProjectivyAccessibilityService:com.spocky.projengmenu/.services.WindowChangeDetectingService
for /f "delims=" %%A in ('adb shell settings get secure enabled_accessibility_services') do set current_services=%%A
if "%current_services%"=="" (
set updated_services=%new_service%
) else (
    set updated_services=%current_services%:%new_service%
)
adb shell settings put secure enabled_accessibility_services "%updated_services%"
echo [36mProjectivy Launcher[0m добавлен в enabled_accessibility_services

echo Установка [36mProjectivy Launcher[0m по умолчанию
adb shell cmd package set-home-activity com.spocky.projengmenu

echo.
echo [1;92mЗамена лаунчера завершена![0m
goto menu_select



:set_default_launcher
echo.
echo [101;93mВосстановление MI лаунчера...[0m

echo Отключение других лаунчеров
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo Включение MI лаунчера
adb shell pm enable --user 0 com.mitv.tvhome

echo.
echo [1;92mЛаунчер успешно восстановлен![0m
goto enter_action



:menu_select
echo.
echo Необходимо выбрать лаунчер по умолчанию
echo в открывшемся окне выбрать установленный лаунчер и нажать [36m"Always"[0m
echo.
choice /m "Открыть на ТВ окно выбора лаунчера?"
if errorlevel 2 goto NO
if errorlevel 1 goto YES
:NO
goto enter_action
:YES

echo.
echo [101;93mЗапуск меню выбора на телевизоре...[0m
adb shell am start -a android.intent.action.MAIN

echo.
echo [1;92mМеню запущено![0m
goto enter_action



:exit
echo [31mВыход из скрипта...[0m
adb kill-server
exit