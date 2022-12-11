:: Script dat de volgende stappen doorloopt:
:: 1. Log de verschillen in commits zijn tussen de ontwikkel en test branch.
:: 2. Log eventueel (vraag aan gebruiker) voor een overzicht aanpassingen in files
:: 3. Vraag de gebruiker of de merge van ontwikkel naar test mag plaatsvinden
:: 4. Voer eventueel de merge uit.

@ECHO OFF
:start
ECHO.
ECHO Script dat de volgende stappen doorloopt:
ECHO 1. Log de verschillen in commits tussen de ontwikkel en test branch.
ECHO 2. Vraag de gebruiker of de merge van ontwikkel naar test mag plaatsvinden
ECHO 3. Doe een merge op een tijdelijke branch om het resultaat te bekijken
ECHO 4. Indien akkoord, voer een daadwerkelijke merge+push uit van de ontwikkel branch naar de test branch 
ECHO.
ECHO.

git checkout ontwikkel
git pull
git checkout test
git pull

ECHO.
ECHO Commits that are in ontwikkel but not in test
git log test..ontwikkel --no-decorate
ECHO.
ECHO Commits that are in test but not in ontwikkel
git log ontwikkel..test --no-decorate
ECHO.



SET choice1=
SET /p choice1=Wil je een overzicht van de bestanden die verschillen tussen ontwikkel en test ? [Y/N]: 
IF '%choice1%'=='Y' GOTO yes
IF '%choice1%'=='y' GOTO yes
IF '%choice1%'=='N' GOTO no
IF '%choice1%'=='n' GOTO no
IF '%choice1%'=='' GOTO no
ECHO "%choice1%" is not valid
ECHO.
GOTO start

:yes
ECHO.
ECHO.
ECHO Aanpassingen in ontwikkel ten opzichte van test:
git diff test..ontwikkel
ECHO.
ECHO.

:no
ECHO.

SET choice2=
SET /p choice2=Do you want to merge ontwikkel into test (we voeren eerst een dummy merge uit op een tijdelijke branch) ? [Y/N]: 
IF '%choice2%'=='Y' GOTO yes
IF '%choice2%'=='y' GOTO yes
IF '%choice2%'=='N' GOTO no
IF '%choice2%'=='n' GOTO no
IF '%choice2%'=='' GOTO no
ECHO "%choice2%" is not valid
ECHO.
GOTO start

:no
ECHO We voeren geen merge uit, einde script
PAUSE
EXIT

:yes

ECHO We maken een tijdelijke branch "test_temp" om de merge uit te voeren en het resultaat te bekijken
ECHO.

:: Doe een merge op een tijdelijke branch (identiek aan test) om te aanpassingen te testen
git checkout -b test_temp test
git merge ontwikkel
git checkout test
git branch -D test_temp

ECHO.
SET choice3=
SET /p choice3= Wil je nu de daadwerkelijke merge+push uitvoeren van ontwikkel naar test? [Y/N]: 
IF '%choice3%'=='Y' GOTO yes
IF '%choice3%'=='y' GOTO yes
IF '%choice3%'=='N' GOTO no
IF '%choice3%'=='n' GOTO no
IF '%choice3%'=='' GOTO no
ECHO "%choice3%" is not valid
ECHO.
GOTO start

:no
ECHO We voeren geen merge uit, einde script
PAUSE
EXIT

:yes

ECHO We voeren een merge+push uit van de ontwikkel branch naar de test branch
ECHO.

git merge ontwikkel
git push
ECHO.
ECHO EINDE SCRIPT

PAUSE
EXIT
