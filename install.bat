@echo off
chcp 65001 >nul
setlocal

set "INSTALL_DIR=C:\Daribar\standartn-offline"
set "EXE_URL=https://raw.githubusercontent.com/daribar-http-whxyan/standart-offline-test-loader/main/standartn-offline.exe"
set "CONFIG_URL=https://raw.githubusercontent.com/daribar-http-whxyan/standart-offline-test-loader/main/config.examle.toml"
set "EXE_PATH=%INSTALL_DIR%\standartn-offline.exe"
set "CONFIG_PATH=%INSTALL_DIR%\config.toml"
set "REG_KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
set "REG_NAME=StandartnOffline"

echo [1/4] Создаю папку %INSTALL_DIR% ...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo [2/4] Скачиваю standartn-offline.exe ...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%EXE_URL%' -OutFile '%EXE_PATH%' -UseBasicParsing"
if %errorlevel% neq 0 (
    echo ОШИБКА: не удалось скачать exe
    pause
    exit /b 1
)

echo [3/4] Скачиваю config.toml ...
if exist "%CONFIG_PATH%" (
    echo config.toml уже существует, пропускаю чтобы не затереть настройки
    goto step4
)
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%CONFIG_URL%' -OutFile '%CONFIG_PATH%' -UseBasicParsing"
if %errorlevel% neq 0 (
    echo ОШИБКА: не удалось скачать config
    pause
    exit /b 1
)

:step4
echo [4/4] Добавляю в автозапуск ...
reg add "%REG_KEY%" /v "%REG_NAME%" /t REG_SZ /d "\"%EXE_PATH%\"" /f >nul 2>&1

echo.
echo Готово!
echo   Путь: %EXE_PATH%
echo   Конфиг: %CONFIG_PATH%
echo   Автозапуск: %REG_KEY%\%REG_NAME%
echo.
echo Не забудьте отредактировать config.toml — указать token и pharmacy_code.
pause
