# Lektionlabb solutions lektion 6


## Användare labb

1. Skapa användarna dave och charlotte

2. Ge varje användare ett bra lösenord

3. Skapa gruppen audit_member

4. Lägg till dave & charlotte i gruppen audit_members

5. Ta bort dave från gruppen

6. Ta bort användaren Dave men spara hemkatalogen för användaren



```bash

sudo useradd dave
sudo useradd charlotte

sudo passwd dave
sudo passwd charlotte

sudo groupadd audit_member

sudo usermod -aG audit_member dave
sudo usermod -aG audit_member charlotte

sudo gpasswd -d dave audit_members

sudo useradd -r -s /bin/false scriptreader

```

## SystemD labb

1. Skapa en systemanvändare som heter timechecker utan inloggningshell

2. Skapa mappen /var/timechecker där användaren timechecker äger mappen

3. Skapa ett pythonskript, /var/timechecker.py som fortsätter köra efter det blivit kallat på skriver ut tiden till en /tmp/timecheck.log. Skriptfilen ska ägas av systemanvändaren.

4. Skapa en systemd fil som kör ditt pythonskript som systemanvändaren.

5. Enable servicen

6. Starta servicen

7. Starta om servern och se att din service den startar upp igen

Skapa systemanvändare och mappen
```bash

sudo useradd -r -s /bin/false timechecker

sudo mkdir /var/timechecker

sudo chown timechecker:timechecker /var/timechecker

sudo touch /var/timechecker/timechecker.py

sudo chown timechecker:timechecker /var/timechecker/timechecker.py

```

Pythonskript

```python

import time
from datetime import datetime

fil_sokvag = "/tmp/timecheck.log"

while True:
    nu = datetime.now()
    aktuell_tid = nu.strftime("%Y-%m-%d %H:%M:%S")

    with open(fil_sokvag, 'a') as fil:
        fil.write(f"{aktuell_tid}\n")

    time.sleep(25)

```

Skapa systemdfil /etc/systemd/system/timechecker.service

```bash

sudo touch /etc/systemd/system/timechecker.service

```

service file /etc/systemd/system/timechecker.service

```bash

[Unit]
Description=Timechecker service
After=network.target

[Service]
Type=simple
User=timechecker
Group=timechecker
ExecStart=/usr/bin/python3 /var/timechecker/timechecker.py
Restart=on-failure

[Install]
WantedBy=multi-user.target

```

Reload daemon, enabla, starta och reboot

```bash

sudo systemctl daemon-reload

sudo systemctl enable timechecker.service

sudo systemctl start timececker.service

tail -f /tmp/timecheck.log

sudo reboot

```

## Backup labb

Skapa bash skript som tar en backup på alla homefolders förutom ec2-user och sparar den i /tmp.

Filen ska heta home_backup med dagens datum (date +%Y%m%d) plus eventuella filändelser.

Filen ska vara en tarboll och vara comprimerad.

```bash

#!/bin/bash

backup_mal="/tmp/home_backup_$(date +%Y%m%d).tar.gz"

tar -czvf "$backup_mal" --exclude=/home/ec2-user /home

echo "Backup av home-kataloger har slutförts och sparats som $backup_mal."

```

## Övervakning labb

Skapa python skript som med subprocess.run() kontrollerar om crond körs.

Om processen inte körs ska False skrivas i /tmp/crond_check och om den körs ska det skrivas True i filen.

Schemalägg sedan skriptet att köras varje minut.

```python

#!/usr/bin/env python3

import subprocess

result = subprocess.run(['pgrep', '-c', 'crond'], capture_output=True, text=True)

if int(result.stdout) > 0:
  print_result = True
else:
  print_result = False

with open('/tmp/crond_check', 'w') as file:
  file.write(str(print_result))

```

crontab

```bash

* * * * * /home/ec2-user/crond_check.py

```

## Loggning labb

Med python och subprocess.

Kontrollera /var/log/audit/audit.log och ta ut alla rader med USER_LOGIN. 

Skicka raderna (append) till filen /tmp/user_login.

Om du får några errors så ska de skickas till /tmp/user_login_error.

```python

#!/usr/bin/env python3

import subprocess

file_path = '/tmp/user_login'

audit = subprocess.run('cat /var/log/audit/audit.log | grep USER_LOGIN', shell=True, capture_output=True, text=True)

with open(file_path, 'a') as file:
  file.write(audit.stdout)

```


## Logging modulen labb

Skapa python skript som kollar tiden och skriver ut den.

Lägg till lite loggningar med logging modulen med debug och info nivå.

Loggarna ska skickas till /tmp/timelog.log

Om ett av argumenten givna till skriptet är DEBUG så ska loggning leveln ändras till DEBUG. Annars ska den vara INFO.

```python

#!/usr/bin/env python3

import sys
import logging
import datetime

if "DEBUG" in sys.argv:
    log_lvl = logging.DEBUG
else:
    log_lvl = logging.INFO

logname = '/tmp/timelog.log'

logging.basicConfig(filename=logname, level=log_lvl, format='%(asctime)s - %(levelname)s - %(message)s')

time_now = datetime.datetime.now()
print(time_now)
logging.debug(f"Date is {time_now}")
logging.info("Script has run")

```