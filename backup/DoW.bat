@rem @echo off
@set /a DoW= (10%DATE:~0,2% %% 100 + ((%DATE:~6,4%) - ((14 - (10%DATE:~3,2% %% 100)) / 12)) + ((%DATE:~6,4%) - ((14 - (10%DATE:~3,2% %% 100)) / 12)) / 4 - (%DATE:~6,4% - ((14 - 10%DATE:~3,2% %% 100) / 12)) / 100 + (%DATE:~6,4% - ((14 - 10%DATE:~3,2% %% 100) / 12)) / 400 + 31 * (10%DATE:~3,2% %% 100 + 12 * ((14 - 10%DATE:~3,2% %% 100) / 12) - 2) /12 ) %% 7

@goto day%DoW%

:day0
@echo Sunday
@goto finish

:day1
@echo Monday
@goto finish

:day2
@echo Tuesday
@goto finish

:day3
@echo Wednesday
@goto finish

:day4
@echo Thursday
@goto finish

:day5
@echo Friday
@goto finish

:day0
@echo Saturday
@goto finish

:finish
