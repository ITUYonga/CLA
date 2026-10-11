@echo off
rem Kartin IP'si ve Can'in vektor klasoru
set BOARD=192.168.137.92
set VEC=D:\github\CLA\cfar\golden_model\vectors\vec_flight_40s_nfft128

start "" http://localhost:8080
python "%~dp0radar_gui.py" --board %BOARD%:5001 --scenario "%VEC%"
pause
