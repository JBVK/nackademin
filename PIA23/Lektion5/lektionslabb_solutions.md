# Solutions Lektionslabb lektion 5

Här är lösningarna för alla lektionslabb för lektion 5.


## Python OS labb

### Labb 1

Skapa ett skript som skriver ut nuvarande mapp och listar alla filer

```python

#!/usr/bin/env python3

import os

my_dir = os.getcwd()
dir = os.listdir(my_dir)

print(f"Current folder: {my_dir}\nAll files: {dir}")

```


### Labb 2

Utveckla skript 1 att lista vad som är mappar/filer.

Jag har skrivit skriptet med en vanlig for loop men även skrivit med en lösning med list comprehension (kommenterad)

```python

#!/usr/bin/env python3
import os

my_dir = os.getcwd()
dir = os.listdir(my_dir)

print(f"Current folder: {my_dir}")

files = []
folders = []
for file in dir:
    if os.path.isfile(file):
        files.append(file)
    else:
        folders.append(file)

#files = [entry for entry in alla_filer if os.path.isfile(entry)]
#folders = [entry for entry in alla_filer if os.path.isdir(entry)]


print(f"Folders: {folders}")

print(f"Files: {files}")

```

### Labb 3

Svår. Visa storlek på en fil som anges som argument (antingen via sys arg eller input). Se till att skriptet kontrollerar att det är en fil innan du kollar storleken.

```python

#!/usr/bin/env python3

import os
import sys

file = sys.argv[1]

if not os.path.isfile(file):
    print(f"{file} is not a file. Exiting")
    exit(1)

file_byte = os.path.getsize(file)

print(f"File {os.path.basename(file)} is {file_byte} byte")

```

### Labb 4

Skapa en miljövariabel i Linux som du skriver ut med ditt Python skript.

Först skapar vi miljövariabeln

```bash

export TESTVARIABLE="Hej klassen"

```
Sen kan vi skapa skriptet

```python

#!/usr/bin/env python3

import os

my_env_variable = os.getenv('TESTVARIABLE')


print(f"My ENV variable is {my_env_variable}")

```

### Labb 5

Svår. Skapa ett skript som byter permission till 700 på filen som ges som argument.

```python

#!/usr/bin/env python3

import os
import sys

argument_variable = sys.argv[1]

if not os.path.isfile(argument_variable):
    print(f"{argument_variable} is not a file. Exiting")
    exit(1)

permission = 0o700
permission_string = int(oct(permission)[2:])

try:
    os.chmod(argument_variable, permission)
    print(f"File {os.path.basename(argument_variable)} permissions changed to {permission_string}")
except PermissionError as e:
    print(f"File {os.path.basename(argument_variable)} permissions could not be changed")

```


## Python os.system och subprocess.run labb

### Labb 1

Skapa skript med os.system() för att lista alla filer i /tmp

```python

#!/usr/bin/env python3

import os

os.system('ls -l /tmp')

```

### Labb 2

Skapa skript med os.system() för att köra skriptet från uppgift 1

```python

#!/usr/bin/env python3

import os

pwd = os.getcwd()

os.system(f"{pwd}/oslabb1.py")

```


### Labb 3

Skapa skript med subprocess.run() för att köra skriptet från uppgift 1 som sparar stdout i en variable och slänger stderr.

```python

#!/usr/bin/env python3

import subprocess

script_output = subprocess.run(['/home/ec2-user/pythonskript/oslabb1.py'], capture_output = True, text = True)

tmp_files = script_output.stdout

print(f"Script files: {tmp_files}")

```

### Labb 4

Svår: Skapa skript med subprocess.run() som kör cat /etc/*, stdout och stderr ska sparas i variable etc_files och etc_error

Vi får ett formatteringserror om vi väljer att formaterra stdout till text. Därav måste vi ha kvar det i byteformat.

```python

#!/usr/bin/env python3

import subprocess

etc_files = subprocess.run('cat /etc/*', shell = True, capture_output = True)

stdout = etc_files.stdout
stderr = etc_files.stderr

```
