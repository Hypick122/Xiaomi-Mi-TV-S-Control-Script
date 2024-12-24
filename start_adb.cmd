@Echo off
chcp 1251
cls

:: ������������� ���������� ���������
set "status_tv="


:start
echo [101;93m������ ������� ADB...[0m
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
goto :enter_ip



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



:command_prompt
echo.
echo [96m������ �� ������ ������� ������� ADB.[0m
echo ��� ������ ������� [31mEXIT[0m.



:adb_command
echo.
set /p adb_cmd=
if /i "%adb_cmd%" == "EXIT" goto :exit
%adb_cmd%
goto :adb_command



:exit
echo [41;97m����� �� �������...[0m
adb kill-server
exit