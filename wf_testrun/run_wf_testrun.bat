ECHO DOE EEN WORKFLOWTESTRUN VAN DE SA MET DE KANDIDAAT CONFIGURATIE
ECHO DRAAI DAARBIJ ALS VOORBEELD DE TAAK ImportPvss


SET ROOT=D:/FEWSProjects/TEST_actions/TEST_ACTIONS-ontwikkel/wf_testrun
SET REGION_HOME=D:/FEWSProjects/TEST_actions/TEST_ACTIONS-ontwikkel
::SET REGION_HOME=../

CD /D %REGION_HOME%

:: KOPIEER DE CONFIG VAN DE APDATA EN GOOI DAAR DE LAATSTE SPOC-FILES OVERHEEN

ECHO START WORFLOW TESTRUN
SET WORKFLOWTESTRUN=%REGION_HOME%\Config\WorkflowTestRuns\wftr_EFCIS.xml
START /WAIT wf_testrun/bin/windows/Delft-FEWSc.exe -Djava.net.useSystemProxies=true -Djava.locale.providers=SPI,JRE -Dlog4j.configurationFile=%REGION_HOME%\log4j2.xml -Dsun.err.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dregion.home=%REGION_HOME% -DautoRollingBarrel=false -Xmx1024m -Djava.library.path=%ROOT%\bin\windows -Wclasspath.1=%REGION_HOME%\patch.jar -Wclasspath.2=%ROOT%\bin\*.jar -Wmain.class=nl.wldelft.fews.system.workflowtestrun.WorkflowTestRun -Warg.1=%REGION_HOME% -Warg.2=%WORKFLOWTESTRUN%

:: DE LOGFILE GAAT NAAR DE SpocScripting\logs FOLDER EN WORDT DAAR GECONTROLEEERD OP FOUTEN
::COPY /Y %REGION_HOME%\log.txt L:\SpocScripting\logs\runConfigTest.log

PAUSE
