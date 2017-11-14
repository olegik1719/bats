@rem @echo off
@rem Логика:
@rem Если Начало месяца -- делаем месячную копию и все.
@rem Если Воскресенье -- делаем недельную копию
@rem Иначе -- делаем ежедневную копию

@set inifile=&

@if "%DATE:~0,2%"=="01" (
	goto monthly
) 
@set /a DoW= (10%DATE:~0,2% %% 100 + ((%DATE:~6,4%) - ((14 - (10%DATE:~3,2% %% 100)) / 12)) + ((%DATE:~6,4%)^
		- ((14 - (10%DATE:~3,2% %% 100)) / 12)) / 4 - (%DATE:~6,4% - ((14 - 10%DATE:~3,2% %% 100) / 12)) / 100 ^
		+ (%DATE:~6,4% - ((14 - 10%DATE:~3,2% %% 100) / 12)) / 400 + 31 * (10%DATE:~3,2% %% 100 ^
		+ 12 * ((14 - 10%DATE:~3,2% %% 100) / 12) - 2) /12 ) %% 7

@if "%DoW%"=="0" (
		goto weekly
	)


%~dp0\backup.bat daily.ini
goto finish

:monthly 
%~dp0\backup.bat montly.ini
goto finish

:weekly
%~dp0\backup.bat weekly.ini
@goto finish



:finish
