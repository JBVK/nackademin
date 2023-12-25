# Access i verkligheten
Här är en liten historia för att förklara SSH och SSH-nycklar samt access.


## Servern
I AWS finns en server som hostar företagets hemsida. Servern är en virtuel maskin, en EC2 som kör AWS Linux 2023 som OS.

Hemsidan är skapad av företagets grymma utvecklare och skickar loggar till /var/site/. 

En av loggarna de loggar till är /var/site/unathorized.log för alla misslyckade inloggningar mot hemsidan.


## Bob
Företaget har anställt en ny tekniker för att ansvara för den dagliga IT-säkerheten. 
Han heter Bob.


## Bobs jobb
Bob ska som en del av sitt jobb kontrollera alla misslyckade inloggningar till hemsidan.

Bob behöver därför access till serven och loggarna.


## Beslut om access
Operations avdelningen som sköter om alla servrar får därför ett ärende att ge Bob access till servern och access till loggfilerna.

Företaget följer Principle of Least Privilege, en best practice för IT säkerhet där användaren får den access den behöver för att göra sitt jobb men inget mer.

Så operationsavdelningen beslutar att Bob ska bara få access att läsa /var/site/unathorized.log.

Företaget följer även en best practice för SSH och tillåter inte heller SSH med lösenord utan SSH-nycklar är ett krav för att få SSH:a.


## Operations ger access till servern
Operationsteknikern börjar med att skapa en användare åt bob.

Hon loggar in på EC2 och med sitt admin konto skapar de ett konto åt Bob. Hon döper kontot till bob_security.

```bash
sudo adduser bob_security
```

Hon sätter sedan ett lösenord på användaren bob

```bash
sudo passwd bob_security
```

Sedan kontaktar Operationsteknikern Bob och ber honom att skapa en SSH-nyckel och skicka den publika nyckeln till dem så att hon kan koppla den till Linux användaren bob_security.

Bob har en Windows laptop, han har WSL (Windows Subsystems for Linux) installerat så han går in i sin WSL, som kör Ubuntu och skapar en ny ssh-nyckel som han döper till webserveraccess och lägger i sin .ssh folder.

Då Bob jobbar med säkerhet så vet han att best practice är att alltid använda lösenord (passphrase) för sin SSH-nyckel så han lägger till ett lösenord.

```bash
ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/bob/.ssh/id_rsa): /home/bob/.ssh/webserveraccess
Enter passphrase (empty for no passphrase):
Your public key has been saved in /home/bob/.ssh/webserveraccess.pub
The key fingerprint is:
SHA256:0aLzmW2GYRo2FTArYPeOxPxgFdF8lXXExTs4Ta/VzXk bob@bobslaptop
The key's randomart image is:
+---[RSA 3072]----+
|  o . **.  ..o.+=|
| . = o ooo. .  oo|
|    B o +..   +.*|
|   o * o o   o =E|
|    . O S     .oo|
|     . B *    .  |
|      . = +      |
|         o       |
|                 |
+----[SHA256]-----+
```

Bob skickar sedan sin publika nycket, webserveraccess.pub, till Operationsteknikern.


## Operations kopplar Bobs nyckel till användaren bob_security
Efter att ha fått den publika ssh-nyckeln från Bob så börjar Operationsteknikern att koppla nyckeln mot det nya kontot bob_security.

Hon böjar med att bli använadern bob_security.

```bash
sudo su - bob_security
```

Som användare bob_security skapar hon sedan mappen .ssh i bob_security home folder.


```bash
mkdir .ssh
```

Sedan sätter hon rättigheten 700 på .ssh mappen

```bash
chmod 700 .ssh
```

Hon skapar sedan filen authorized_keys i .ssh mappen och lägger in den publika nyckeln i den. Hon använder sin favorittexteditor nano och kopierar in den publika nyckeln i filen.

```bash
nano .ssh/authorized_keys
```

Som sista steg med SSH-nyckeln sätter hon rättigheten 600 på authorized_keys i .ssh mappen.

```bash
chmod 600 .ssh/authoried_keys
```

## Operations ställer in så användaren bob_security måste byta sitt lösenord vid första inloggning.
För att bob_security ska behöva byta lösenordet vid första inloggningen så ändrar operationsteknikern lösenordsåldern till 0 (Lösenordsåldern är den tid (i dagar) som måste passera innan användaren blir ombedd att ändra sitt lösenord).

```bash
sudo chage -d 0 bob_security
```

## Operations ger access till loggfilen
När allt med användare bob_security och dess SSH-nyckel är klart är sista steget på servern att ge användaren bob_security access till loggfilen /var/site/unathorized.log.

Mappen /var/site har access 755 och ägare root:root

```bash
ls -al /var/
...
drwxr-xr-x.  2 root root    64 Dec 25 14:47 site
...
```

Användaren bob_security kommer kunna gå in i mappen /var/site och se filerna där med nuvarande access så inget behöver göras med mappaccessen.

Loggfilen /var/site/unathorized.log har access 600 och ägare root:root

```bash
ll /var/site/
total 0
-rw-------. 1 root root 0 Dec 25 14:47 access.log
-rw-------. 1 root root 0 Dec 25 14:47 error.log
-rw-------. 1 root root 0 Dec 25 14:47 unathorized.log
```

Användaren bob_security kommer inte kunna läsa den filen. Operationsteknikern vill inte ändra ägaren av filen, root användaren måste fortfarande ha skriv access till filen och alla ska inte kunna läsa den så för att ge bob_security access att läsa filen måste vi använda oss av gruppägaren till filen.

Operationsteknikern vill inte ge bob_security medlemskap i root gruppen för det skulle ge alldeles för mycket rättigheter.

Och att ge filen gruppägare bob_security skulle fungera men för att förbereda för eventuellt andra säkerhetstekniker som behöver access till den filen (och andra) så beslutar operationsteknikern att skapa en ny grupp, ge den läsrättigheter till loggfilen och sedan lägga till bob_security som medlem i gruppen.

Operationsteknikern skapar gruppen security_personel.

```bash
sudo groupadd security_personel
```

Sedan ändrar operationsteknikern gruppägaren för /var/site/unathorized.log till security_personel.

```bash
sudo chown :security_personel /var/site/unathorized.log
```

Sedan ger hon läsrättigheter för gruppägaren till filen /var/site/unathorized.log

```bash
sudo chmod 640 /var/site/unathorized.log
```

Sedan lägger hon till bob_security som medlem i gruppen security_personel.

```bash
sudo usermod -aG security_personel bob_security
```

## Operations skickar användanamn och lösenord till bob.
Operationsteknikern skickar användarnamnet och lösenordet till bob samt IP-addressen till EC2 instansen.

Användarnamnet och lösenordet skickas genom en krypterad säker tjänst för att dela känsliga uppgifter.

## Bob loggar in
Bob loggar in på servern genom att ssh:a till EC2 med användarnamn bob_security och SSH-nyckeln webserveraccess. Han behöver skriva i lösenordet (passphrase) till SSH-nyckeln.
```bash
ssh bob_security@13.49.225.14 -i .ssh/webserveraccess
Enter passphrase for key '.ssh/bobsecurity':
```

Efter bob har loggat in på servern så måste han byta lösenord.
```bash
You are required to change your password immediately (administrator enforced).
WARNING: Your password has expired.
You must change your password now and login again!
Changing password for user bob_security.
Current password:
```

Efter att ha bytt lösenord så loggas bob_security ut från servern och behöver logga in igen.

Bob ssh:ar igen till servern ( Bob behöver skrivit in lösenordet till SSH-nyckeln).

```bash
ssh bob_security@13.49.225.14 -i .ssh/webserveraccess
Enter passphrase for key '.ssh/bobsecurity':
```

Efter inloggningen får inte Bob något krav att byta lösenord utan kan testa att läsa loggfilen /var/site/unathorized.log vilket fungerar bra.

```bash
less /var/site/unathorized.log
```
