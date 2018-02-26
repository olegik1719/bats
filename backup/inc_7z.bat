set list4inc=%temp%\lst4inc.lst
dir /S /aa /b > %list4inc%
for /f %%i in ('findstr /B /V /C:# %list4inc%') do (
	C:\Share\scripts\7za.exe a -ssw -spf -mx9 -r0 test.7z %%i
	ATTRIB -A %%i
	rem echo %%i
)
