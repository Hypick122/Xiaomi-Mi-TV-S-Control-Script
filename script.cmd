@Echo off
chcp 1251
cls

:: ������������� ���������� ���������
set "status_tv="


:start
echo [101;93m������ �����������...[0m
adb kill-server
adb start-server



:reply
echo.
echo [4m��������� ��������� ����������:[0m
echo.
echo 1. ����� � ��������� ���������� - [36m"Settings -> About -> Model" [0m
echo 2. ������ �� 7 ��� �� ������ [36m"��" [0m �� ������ �� ��������� ����������� ����� ������ [36m"You are already a developer" [0m
echo 3. ����� [36m"Settings -> Account & Security ->" [0m ���������� [36m "ADB Debugging -> Allow" [0m
echo 4. ��� �� ���������� ��������� ���������� �� ����������� ���������� [36m"Unkown sources -> Allow" [0m
echo 5. ���������� IP ����� ���������� - [36m"Settings -> About -> Network info" [0m(���������� ��� �������������)
echo.
goto :enter_ip



:enter_action
echo.
echo   [42;30m������ ���������� Xiaomi Mi TV S[0m
echo.
echo   [41;97m0. �����[0m
echo ����������������
if defined status_tv (
    echo   [42;30m1.[0m ������������ � �� [42;30m[����������][0m
) else (
    echo   [42;30m1.[0m ������������ � ��
)
echo ����������������
echo   [42;30m2.[0m ������ ������������� �������
echo ����������������
echo   [42;30m3.[0m ��������� ����������������� ��������� ����������
echo ����������������
echo   [42;30m4.[0m ���������� ����������� ��������� ����������
echo   [42;30m5.[0m ��������� ���������� � ������ ����������
echo ����������������
echo   [42;30m6.[0m ���������� ��������� ����������
echo   [42;30m7.[0m �������� TorrServe � ������ ����������� ������������
echo ����������������
echo   [42;30m8.[0m ���������� ��� ������������ �������
echo   [42;30m9.[0m ������� �� �� ���� ������ ��������
echo.
set /p ChoiceInput=������� ��� ����� [0-9]: 
if "%ChoiceInput%"=="0" goto :exit
if "%ChoiceInput%"=="1" goto :enter_ip
if "%ChoiceInput%"=="2" goto :view_apps
if "%ChoiceInput%"=="3" goto :disable_system_apps
if "%ChoiceInput%"=="4" goto :install_system_apps
if "%ChoiceInput%"=="5" goto :activate_services
if "%ChoiceInput%"=="6" goto :install_third_party_apps
if "%ChoiceInput%"=="7" goto :enable_accessibility_services_torrserve
if "%ChoiceInput%"=="8" goto :install_launcher
if "%ChoiceInput%"=="9" goto :menu_select
echo.
echo [41;97m������: ������� ���������� ����� �� 0 �� 9![0m
goto :enter_action



:enter_ip
echo.
set /p UserInput=������� IP-����� ���������� � ������� 0.0.0.0: 
adb connect %UserInput%



:not_connected
for /f "skip=1" %%i in ('adb devices') do set output=%%i
for /f "delims= " %%i in ("%output%") do (set device=%%i)
if "%device%" == "%UserInput%:5555" goto :connected
echo.
echo [1;31m������! ���������� ��� ���[0m
goto :enter_action



:connected
echo.
echo [102m���������� � %UserInput%[0m 
echo.
echo [31m�������� �������� �� ����� ����������![0m
echo �� ������ ��������� ���� [36m"Allow USB debugging?"[0m - ������ ������� �� [36m"Always allow from this computer"[0m � ��������� [36m"Allow"[0m
echo ���� �� ���������� � ���������� ����������, �� ���� �� ��������. 
echo ��� ����, ����� ��������� ���� ���������� ����� �� �������� �� ������� �����, ��� ����� ������� ����������� ���������� ��� �� ������ [36m"�����"[0m �� ������...

adb wait-for-device

echo.
set "status_tv=1"
echo [102m��������� ���������![0m
goto :enter_action



:view_apps
echo.
echo [4m������ ������������� �������:[0m
adb shell pm list packages
goto :enter_action



:disable_system_apps
echo.
echo [31m��������![0m ��� ����������� ��������� ���������� �� ������� ���� ������ ����������,
echo [36m������[0m, ������ ��������� ����� �������� �� ������ ��������� ����������!

echo.
choice /m "����������?"
if errorlevel 2 goto :NO
if errorlevel 1 goto :YES
:NO
goto :enter_action
:YES
echo [101;93m���������� ��������� ����������...[0m
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
echo [102m���������� ��������� ���������� ���������![0m
goto :enter_action



:install_system_apps
echo.
echo [101;93m��������� ��������� ����������...[0m

for %%f in (%~dp0system\*.apk) do (
echo ���������[36m %%~nxf [0m
adb install %%f
)

echo.
echo [102m��������� ��������� ���������� ���������![0m
choice /m "���������, ������������ ���������� � ������ ����������?"
if errorlevel 2 goto :NO
if errorlevel 1 goto :YES
:YES
goto :activate_services
:NO
goto :enter_action



:activate_services
echo.
echo [101;93m������������ ���������, ��������� ���������� � ����� ����������...[0m

echo ����� �������� ����� �� [36mEurope/Moscow [0m
adb shell service call alarm 3 s16 Europe/Moscow

echo ��������� [36mAppium[0m
adb install %~dp0lang/Appium.apk

echo �������������� ���� [36mAppium[0m �� ����� �����
adb shell pm grant io.appium.settings android.permission.CHANGE_CONFIGURATION

echo ��������� ����� �� �������
adb shell am broadcast -a io.appium.settings.locale -n io.appium.settings/.receivers.LocaleSettingReceiver --es lang ru --es country RU

echo �������� [36mAppium[0m
adb uninstall io.appium.settings

echo.
echo [102m���������,��������� ���������� � ����� ���������� ���������![0m
goto :enter_action



:install_third_party_apps
echo.
echo [31m��������![0m ��� ������ ������� ����������� �� ������ ����������������� ������������� ����� ��������� ���������� 
echo � ����������� [36m.apk[0m, ������� ������������ ����� � ����� [36m%~dp0app\[0m
echo.

choice /m "����������?"
if errorlevel 2 goto :NO
if errorlevel 1 goto :YES
:NO
goto :enter_action
:YES
echo [101;93m��������� ��������� ����������...[0m
for %%f in (%~dp0app\*.apk) do (
echo ���������[36m %%~nxf [0m
adb install %%f
)
echo.
echo [102m��������� ��������� ���������� ���������![0m
goto :enter_action



:enable_accessibility_services_torrserve
echo ��������� ������� ����������� ������������
adb shell settings put secure accessibility_enabled 1
adb shell settings put secure accessibility_services_state 1

set "new_service=ru.yourok.torrserve/ru.yourok.torrserve.server.local.services.GlobalTorrServeService"

for /f "delims=" %%A in ('adb shell settings get secure enabled_accessibility_services') do set "current_services=%%A"

echo %current_services% | find "%new_service%" >nul
if %errorlevel% equ 0 (
    echo [102mTorrServe ��� �������� � enabled_accessibility_services[0m
) else (
    if "%current_services%"=="" (
        set "updated_services=%new_service%"
    ) else (
        set "updated_services=%current_services%:%new_service%"
    )

    adb shell settings put secure enabled_accessibility_services "%updated_services%"
    echo [102mTorrServe �������� � enabled_accessibility_services[0m
)
goto :enter_action



:install_launcher
echo.
echo [42;30m�������� ������� ��� ���������:[0m
echo.
echo   [41;97m0. ����� � ����[0m
echo ����������������
echo   [42;30m1.[0m Projectivy Launcher
echo   [42;30m2.[0m Emotn UI launcher
echo   [42;30m3.[0m ATV Launcher
echo   [42;30m4.[0m ������� MI �������
echo.
set /p LauncherChoice=������� ��� ����� [0-4]: 
if "%LauncherChoice%"=="0" goto :enter_action
if "%LauncherChoice%"=="1" goto :set_launcher_projectivy
if "%LauncherChoice%"=="2" goto :set_launcher_emotn
if "%LauncherChoice%"=="3" goto :set_launcher_atv
if "%LauncherChoice%"=="4" goto :set_default_launcher
echo [41;97m������: ������� ���������� ����� �� 0 �� 4![0m
goto :install_launcher



:set_launcher_atv
echo.
echo [101;93m������ ��������[0m

echo ���������� ������������ ��������
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo ��������� [36mATVLauncher[0m
adb install %~dp0launcher/ATVLauncher.apk

echo ��������� [36mATVLauncher[0m �� ���������
adb shell pm set-home-activity ca.dstudio.atvlauncher.pro/ca.dstudio.atvlauncher.screens.launcher.LauncherActivity

echo ��������� ���������� ��� [36mATVLauncher[0m
adb shell appwidget grantbind --package ca.dstudio.atvlauncher.pro --user 0

echo.
echo [102m������ �������� ���������![0m
goto :menu_select



:set_launcher_emotn
echo.
echo [101;93m������ ��������[0m

echo ���������� ������������ ��������
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo ��������� [36mEmotn UI Launcher[0m
adb install %~dp0launcher/Emotn_UI_Launcher.apk

echo ��������� [36mEmotn UI Launcher[0m �� ���������
adb shell pm set-home-activity com.oversea.aslauncher/com.oversea.aslauncher.ui.main.Main.Activity

echo.
echo [102m������ �������� ���������![0m
goto :menu_select



:set_launcher_projectivy
echo.
echo [101;93m������ ��������[0m

echo ���������� ������������ ��������
adb shell pm disable-user --user 0 com.mitv.tvhome
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo ��������� [36mProjectivy Launcher[0m
adb install %~dp0launcher/ProjectivyLauncher.apk

echo ��������� ������� ����������� ������������
adb shell settings put secure accessibility_enabled 1
adb shell settings put secure accessibility_services_state 1


echo ���������� [36mProjectivy Launcher[0m � ������ ����������� ������������
set "new_service=com.spocky.projengmenu/com.spocky.projengmenu.services.ProjectivyAccessibilityService:com.spocky.projengmenu/.services.WindowChangeDetectingService"

for /f "delims=" %%A in ('adb shell settings get secure enabled_accessibility_services') do set "current_services=%%A"

if "%current_services%"=="" (
	set "updated_services=%new_service%"
) else (
	set "updated_services=%current_services%:%new_service%"
)

adb shell settings put secure enabled_accessibility_services "%updated_services%"
echo [36mProjectivy Launcher[0m �������� � enabled_accessibility_services

echo ��������� [36mProjectivy Launcher[0m �� ���������
adb shell pm set-home-activity com.spocky.projengmenu/com.spocky.projengmenu.ui.home.MainActivity

echo.
echo [102m������ �������� ���������![0m
goto :menu_select



:set_default_launcher
echo.
echo [101;93m�������������� MI ��������[0m

echo �������� ������ ���������
adb uninstall com.spocky.projengmenu
adb uninstall com.oversea.aslauncher
adb uninstall ca.dstudio.atvlauncher.pro

echo ��������� MI ��������
adb shell pm enable --user 0 com.mitv.tvhome

echo.
echo [102m������� ������� ������������![0m
goto :enter_action


:menu_select
echo.
echo ���������� ������� ������� �� ���������
echo � ����������� ���� ������� ������������� ������� � ������ [36m"Always"[0m
echo.
choice /m "������� �� �� ���� ������ ��������?"
if errorlevel 2 goto :NO
if errorlevel 1 goto :YES
:NO
goto :enter_action
:YES

echo.
echo [101;93m������ ���� ������ �� ����������[0m
adb shell am start -a android.intent.action.MAIN

echo.
echo [102m���� ��������! [0m
goto :enter_action



:exit
echo [41;97m����� �� �������...[0m
adb kill-server
exit