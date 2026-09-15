@echo off
set /p commit_msg="Commit mesaji girin: "

git add .
git commit -m "%commit_msg%"
git push origin Oguzhan

echo.
echo Islem tamamlandi!
pause