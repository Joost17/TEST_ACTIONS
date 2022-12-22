ECHO DOE EEN WORKFLOWTESTRUN VAN DE SA MET DE KANDIDAAT CONFIGURATIE
ECHO DRAAI DAARBIJ ALS VOORBEELD DE TAAK ImportPvss


SET ROOT=D:/FEWSProjects/TEST_actions/TEST_ACTIONS-ontwikkel/wf_testrun
::SET REGION_HOME=..

RMDIR /Q /S %CD%\Config
RMDIR /Q /S %CD%\localDataStore
RMDIR /Q /S %CD%\temp
DEL /Q %CD%\runConfigTest.log

XCOPY /E ..\Config %CD%\Config\

ECHO START WORFLOW TESTRUN
SET WORKFLOWTESTRUN=Config\WorkflowTestRuns\wftr_EFCIS.xml
START /WAIT bin/windows/Delft-FEWSc.exe -Djava.net.useSystemProxies=true -Djava.locale.providers=SPI,JRE -Dlog4j.configurationFile=log4j2.xml -Dsun.err.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dregion.home=%CD% -DautoRollingBarrel=false -Xmx1024m -Djava.library.path=%ROOT%\bin\windows -Wclasspath.1=%CD%\patch.jar -Wclasspath.2=%ROOT%\bin\*.jar -Wmain.class=nl.wldelft.fews.system.workflowtestrun.WorkflowTestRun -Warg.1=%CD% -Warg.2=%WORKFLOWTESTRUN%

:: DE LOGFILE GAAT NAAR DE SpocScripting\logs FOLDER EN WORDT DAAR GECONTROLEEERD OP FOUTEN
::COPY /Y %REGION_HOME%\log.txt L:\SpocScripting\logs\runConfigTest.log

PAUSE
