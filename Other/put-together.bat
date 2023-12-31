@echo off
setlocal enabledelayedexpansion

set inputfolder=D:\Portable\Projects\Jpexs\EasyController
set inputinstaller=%inputfolder%\EasyController_Installer\scripts\com\brockw\stickwar\campaign\controllers
set outputfile=%inputfolder%\Other\CampaignController.as
set outputinstaller=%inputinstaller%\CampaignController.as
set filelist=CampaignController.as Data.as Debug.as Util.as CutScene.as Draw.as StringMap.as Loader.as

type nul > %outputfile%

for %%f in (%filelist%) do (
    set filename=%%f
    type "%inputfolder%\!filename!" >> %outputfile%
    echo. >> %outputfile%
)

type nul > %outputinstaller%

for %%f in (%filelist%) do (
    set filename=%%f
    type "%inputfolder%\!filename!" >> %outputinstaller%
    echo. >> %outputinstaller%
)
