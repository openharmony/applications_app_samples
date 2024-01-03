@echo off
set time0=%time: =0%
set aa=log_%Date:~2,2%%Date:~5,2%%Date:~8,2%_%time0:~0,2%%time0:~3,2%
echo print to hilog-%aa%.txt
hdc shell hilog > hilog-%aa%.txt
pause