@echo off
setlocal enabledelayedexpansion

set inputfolder=.
set inputinstaller=..\EasyController_Installer\scripts\com\brockw\stickwar\campaign\controllers
set outputfile=%inputfolder%\Other\CampaignController.as
set outputinstaller=%inputinstaller%\CampaignController.as
set filelist=CampaignController.as Data.as Debug.as Util.as ProjectilePlus.as CutScene.as Draw.as StringMap.as Loader.as

type nul > %outputfile%
type nul > %outputinstaller%

for %%f in (%filelist%) do (
    set filename=%%f
    if exist "%inputfolder%\!filename!" (
        type "%inputfolder%\!filename!" >> %outputfile%
        echo. >> %outputfile%
    ) else (
        echo File not found: %inputfolder%\!filename!
    )
)