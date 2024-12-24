@Echo off
chcp 1251
cls

:: Инициализация переменной состояния
set "status_tv="


:start
echo [101;93mЗапуск сервера ADB...[0m
adb kill-server
adb start-server



:reply
echo.
echo [4mНачальная настройка телевизора:[0m
echo.
echo 1. Зайти в Настройки телевизора - [36m"Settings -> About -> Model" [0m
echo 2. Нажать до 7 раз на кнопку [36m"ОК" [0m на пульте до появления уведомления внизу экрана [36m"You are already a developer" [0m
echo 3. Далее [36m"Settings -> Account & Security ->" [0m активируем [36m "ADB Debugging -> Allow" [0m
echo 4. Так же активируем установку приложений из неизвестных источников [36m"Unkown sources -> Allow" [0m
echo 5. Определяем IP адрес телевизора - [36m"Settings -> About -> Network info" [0m(Запоминаем или фотографируем)
echo.
goto :enter_ip



:enter_ip
echo.
set /p UserInput=Введите IP-адрес телевизора в формате 0.0.0.0: 
adb connect %UserInput%



:not_connected
for /f "skip=1" %%i in ('adb devices') do set output=%%i
for /f "delims= " %%i in ("%output%") do (set device=%%i)
if "%device%" == "%UserInput%:5555" goto :connected
echo.
echo [1;31mОШИБКА! Попробуйте ещё раз[0m
goto :enter_ip



:connected
echo.
echo [102mПодключено к %UserInput%[0m 
echo.
echo [31mОбратите внимание на экран телевизора![0m
echo На экране появилось окно [36m"Allow USB debugging?"[0m - Ставим галочку на [36m"Always allow from this computer"[0m и разрешаем [36m"Allow"[0m
echo Если вы находитесь в настройках телевизора, то окно не появится. 
echo Для того, чтобы появилось окно необходимо выйти из настроек на главный экран, для этого нажмите необходимое количество раз на кнопку [36m"НАЗАД"[0m на пульте...

adb wait-for-device

echo.
set "status_tv=1"
echo [102mТелевизор подключен![0m



:command_prompt
echo.
echo [96mТеперь вы можете вводить команды ADB.[0m
echo Для выхода введите [31mEXIT[0m.



:adb_command
echo.
set /p adb_cmd=
if /i "%adb_cmd%" == "EXIT" goto :exit
%adb_cmd%
goto :adb_command



:exit
echo [41;97mВыход из скрипта...[0m
adb kill-server
exit