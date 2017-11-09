@rem @echo off
@set test=%1
@echo start
@echo %test%

@if "%test%"=="" (
@	set pTest=%test%
@	echo Empty %pTest%
) else (
	@set pTest=-p%test%
	@echo Non-empty %pTest%
)

@echo %pTest%
