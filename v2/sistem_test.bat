@echo off
rem sistem_test.bat - karttaki sistemi (bitstream + radar_server) tek tikla test eder.
rem
rem Repo kokune koy (pc , gui , sw klasorlerinin oldugu yer). Kartta radar_server calisiyor olmali.
rem   sistem_test.bat                 -> kart IP'si ayarlar.ps1'den ya da 192.168.1.50
rem   sistem_test.bat 192.168.1.60    -> baska IP
rem
rem Sirasiyla:
rem   1) drone_uret.py + derle.py : drone.casm , drone_l3.hex , drone_cla.h guncel mi
rem   2) kart_test.py             : baglanti , CLA KIMLIK , program CRC ,
rem                                 FPGA CLA'yi adim adim golden ile karsilastirma ,
rem                                 kartta 12 s drone simulasyonu (kalkis , hedef , ruzgar , darbe)
setlocal
cd /d "%~dp0"

rem ---- python
set PY=
where python >nul 2>nul && set PY=python
if not defined PY ( where py >nul 2>nul && set PY=py -3 )
if not defined PY ( echo HATA: python bulunamadi & goto hata )

rem ---- klasorler (yeni duzen: pc\cla_gui + cla_program\drone ; eski duzen: pc + cla)
set PCDIR=
set DRONE=
for %%K in ("." "..") do (
    if not defined PCDIR if exist "%%~K\pc\cla_gui\kart_test.py" set PCDIR=%%~fK\pc\cla_gui
    if not defined PCDIR if exist "%%~K\pc\kart_test.py"         set PCDIR=%%~fK\pc
    if not defined DRONE if exist "%%~K\cla_program\drone\drone_uret.py" set DRONE=%%~fK\cla_program\drone
    if not defined DRONE if exist "%%~K\gui\drone_uret.py"               set DRONE=%%~fK\gui
    if not defined DRONE if exist "%%~K\cla\drone_uret.py"               set DRONE=%%~fK\cla
)
if not defined PCDIR ( echo HATA: kart_test.py bulunamadi ^(pc\cla_gui ya da pc^) & goto hata )
if not defined DRONE ( echo HATA: drone_uret.py bulunamadi ^(gui , cla ya da cla_program\drone^) & goto hata )
set PYTHONPATH=%PCDIR%;%PYTHONPATH%

rem ---- core.py (golden model)
if defined CLA_CORE if exist "%CLA_CORE%\core.py" goto core_tamam
set CLA_CORE=
for %%D in ("cla_program\golden" "CLA_Proje\golden_model" "..\cla_program\golden" "..\CLA_Proje\golden_model" "%DRONE%" "%PCDIR%") do (
    if not defined CLA_CORE if exist "%%~D\core.py" set CLA_CORE=%%~fD
)
rem yukaridakilerde yoksa repo icinde ara (icinde "class ClaCore" olan core.py)
if not defined CLA_CORE for /f "delims=" %%F in ('dir /s /b core.py 2^>nul') do (
    if not defined CLA_CORE findstr /m /c:"class ClaCore" "%%F" >nul 2>nul && set CLA_CORE=%%~dpF
)
if defined CLA_CORE if "%CLA_CORE:~-1%"=="\" set CLA_CORE=%CLA_CORE:~0,-1%
if not defined CLA_CORE ( echo HATA: core.py bulunamadi. CLA_CORE ortam degiskenine core.py klasorunu yaz. & goto hata )
:core_tamam

rem ---- kart IP
set KART=%1
if not defined KART if exist "ayarlar.ps1" (
    for /f "usebackq delims=" %%A in (`powershell -NoProfile -ExecutionPolicy Bypass -Command ". .\ayarlar.ps1; $KartIP"`) do set KART=%%A
)
if not defined KART set KART=192.168.137.92

echo python   : %PY%
echo pc       : %PCDIR%
echo drone    : %DRONE%
echo CLA_CORE : %CLA_CORE%
echo kart     : %KART%

echo.
echo ===== 1/2 CLA programi uretiliyor (drone_uret.py + derle.py)
if exist "%DRONE%\..\pc\sim_baglanti.py" if not exist "%DRONE%\..\sw" mkdir "%DRONE%\..\sw"
pushd "%DRONE%"
%PY% drone_uret.py || ( popd & goto hata )
%PY% derle.py || ( popd & goto hata )
popd

echo.
echo ===== 2/2 kart testi (yaklasik 40 s)
%PY% "%PCDIR%\kart_test.py" --kart %KART%
if errorlevel 1 goto hata

echo.
pause
exit /b 0

:hata
echo.
echo ===== HATA: yukaridaki mesaja bak
pause
exit /b 1
