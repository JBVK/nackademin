# Labb från lektion 4

## Crontab lab
1. Skapa en crontab som ec2-user. Schemalägg ett skript som skiver ut datumet (date) som körs varje minut och skriver till en fil i er homefolder som heter time

2. Skapa ett skript som läser alla filer i /etc. Skriptet ska köras varje fredag 03:30 och alla stderr ska skickas till etc_errors i er homefolder och stdout ska slängas bort.

3. Installera programmet nginx. Enable programmet och försök starta det.


## Lösningar

I detta fall har jag inte skapat skript utan kör kommandot direkt i crontab filen.

### Labb 1

crontab -e

```bash
* * * * * date >> /home/ec2-user/time
```

### Labb 2

```bash
30 3 * * 5 cat /etc/* 2> /home/ec2-user/etc_errors > /dev/null
```

### Labb 3

sudo dnf install nginx

sudo systemctl enable nginx

sudo systemctl start nginx
