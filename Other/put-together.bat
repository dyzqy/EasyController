@echo off
setlocal enabledelayedexpansion

set inputfolder=D:\Portable\Projects\Jpexs\EasyController
set outputfolder=D:\Portable\Projects\Jpexs\EasyController\Other
set outputfile=%outputfolder%\CampaignController.as
set filelist=CampaignController.as Data.as Util.as Extra.as Draw.as StringMap.as Loader.as

type nul > %outputfile%

for %%f in (%filelist%) do (
    set filename=%%f
    type "%inputfolder%\!filename!" >> %outputfile%
    echo. >> %outputfile%
)

echo All files have been concatenated to %outputfile%
pause
