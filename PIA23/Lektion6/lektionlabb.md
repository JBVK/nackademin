# Lektionlabb lektion 6

Lösningar till labben finns i filen lektionslabb_solutions.md

## Användare labb

1. Skapa användarna dave och charlotte

2. Ge varje användare ett bra lösenord

3. Skapa gruppen audit_member

4. Lägg till dave & charlotte i gruppen audit_members

5. Ta bort dave från gruppen

6. Ta bort användaren Dave men spara hemkatalogen för användaren

## SystemD labb

1. Skapa ett pythonskript som fortsätter köra efter det blivit kallat på och gör någonting som går att se. T.ex. skriver ut en loggrad till en fil.

2. Skapa en systemanvändare utan inloggningshell

3. Skapa en mapp i /var där användaren kan läsa och köra skriptet som du lägger i mappen.

4. Skapa en systemd fil som kör ditt pythonskript som systemanvändaren.

5. Enable servicen6. Starta servicen7. Starta om servern och se att din service den startar upp igen


## Backup labb

Skapa bash skript som tar en backup på alla homefolders förutom ec2-user och sparar den i /tmp.

Filen ska heta home_backup med dagens datum (date +%Y%m%d) plus eventuella filändelser.

Filen ska vara en tarboll och vara comprimerad.


## Övervakning labb

Skapa python skript som med subprocess.run() kontrollerar om crond körs.

Om processen inte körs ska False skrivas i /tmp/crond_check och om den körs ska det skrivas True i filen.

Schemalägg sedan skriptet att köras varje minut.

## Loggning labb

Med python och subprocess.

Kontrollera /var/log/audit/audit.log och ta ut alla rader med USER_LOGIN. 

Skicka raderna till filen /tmp/user_login.

Om du får några errors så ska de skickas till /tmp/user_login_error.

## Logging modulen labb

Skapa python skript som kollar tiden och skriver ut den.

Lägg till lite loggningar med logging modulen med debug och info nivå.

Loggarna ska skickas till /tmp/timelog.log

Om ett av argumenten givna till skriptet är DEBUG så ska loggning leveln ändras till DEBUG. Annars ska den vara INFO.