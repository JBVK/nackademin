# Solutions lektionslabb lektion 3

Lösningar för lektionslabb för lektion 3.

De flesta labb säger ju att räkna antalet filer men räknar man både mappar och filer så är det okej då dela upp mellan mappar och filer är lite överkurs för denna nivå.

## Stream labb

### Labb 1

Läs alla filer i /etc med cat och skicka alla errors (stderr) till etc_errors i er homefolder

```bash
#!/bin/bash

cat /etc/* 2> ~/etc_errors

```

### Labb 2

Läs alla filer i /etc med cat och räkna hur många rader det är i alla filer du får läsa med kommadot wc -l

```bash
#!/bin/bash

number_of_lines=$(cat /etc/* 2>/dev/null | wc -l)

echo "Number of lines is $number_of_lines"

```

### Labb 3

Svår! Läs alla filer i /proc med cat men skriv bara ut errors (stderr) till terminalen

```bash
#!/bin/bash

cat /proc/*

```

### Labb 4

Svår! Läs alla filer i /etc med cat och skicka stdout till etc_files i er homefolder och alla errors till new_etc_errors i er homefolder

```bash
#!/bin/bash

cat /etc/* 2> ~/new_etc_errors > ~/etc_errors

```

Eller en mer fin lösning som en i klassen kom på för att bara läsa filer (och inte försöka läsa mappar). Den använder kommandot find tillsammans med -exec för att utföra ett kommando på varje fil (då vi söker på -type f) som hittas. Vi använder -maxdepth 1 för att den inte ska gå vidare ner i mapparna utan bara läsa filerna i /etc/.

```bash
#!/bin/bash

find /etc/ -maxdepth 1 -type f -exec cat {} \; 2> ~/new_etc_errors > ~/etc_errors

```

## Bash labb

### Labb 1

Skapa skript som adderar två siffror som ges till skriptet och skriver ut svaret.

```bash
#!/bin/bash

result=$(($1+$2))

echo "Result of adding $1 and $2 is $result"
```

### Labb 2

Skapa skript som skriver antalet argument gett till skriptet.

```bash
#!/bin/bash

echo "Number of arguments given to script is $#"

```

### Labb 3

Skapa skript som skriver antalet argument gett till skriptet och sedan skriver ut varje argument på varsin rad.

```bash
#!/bin/bash

echo "Number of arguments given to script is $#"

num=1
for arg in "$@"
do
  echo "Argument $num: $arg"
  ((num++))
done

```

### Labb 4

Skapa skript som skriver ut filnamnet på filerna i mappen du är i med format "File: $filename"

```bash
#!/bin/bash

my_folder=$(pwd)

for file in $my_folder/*
do
  echo "File: $file"
done

```

### Labb 5

Svår: Skapa skript som räknar antalet filer i mappen du anger som argument


```bash
#!/bin/bash

num_files=$(ls -l $1 | wc -l)

echo "Number of files in $1 is $num_files"

```

### Labb 6

Skapa ett skript som räknar ner från 25 och skriver ut varje nummer.


```bash
#!/bin/bash
number=25

while [[ $number -gt 0 ]]
do
  echo $number
  ((number--))
done

```

### Labb 7

Utveckla skript 6 så att det inte skriver ut 19 och 16.


```bash
#!/bin/bash
number=25

while [[ $number -gt 0 ]]
do
  if [[ $number -eq 16 || $number -eq 19 ]]
  then
		((number--))
	else
		echo $number
		((number--))
	fi
done

```

### Labb 8

Skapa ett skript som skriver ut det största av de två argument som ges till skriptet.

```bash
#!/bin/bash

if [[ $1 -gt $2 ]]
then
  echo $1
elif [[ $2 -gt $1 ]]
then
  echo $2
else
  echo "Argument are equal"
fi

```

### Labb 9

Svår: Skapa ett skript som skriver ut varje rad i filen som ges som argument till skriptet.

```bash
#!/bin/bash

my_file=$1

while read -r line
do
  echo "Rad från filen: $line"
done < "$my_file"

echo "Reading $my_file done"
```

### Labb 10

Skapa ett skript som adderar två tal som ges som argument till skriptet men använd en funktion för det.

```bash
#!/bin/bash

function add {
	local num=$(($1 + $2))
	echo $num
}

result=$(add $1 $2)

echo "Resultatet är: $result"

```


### Labb 11

Skapa ett skript som använder en funktion för att jämföra om två strängar som ges som argument till skriptet är likadana.

```bash
#!/bin/bash
function match {
  if [[ $1 == $2 ]]
  then
    return 0 #true
  else
    return 1 #false
  fi
}

match $1 $2
match_strings=$?

if [[ $match_strings -eq 0 ]]
then
  echo "Strängarna matchar"
else
  echo "Strängarna matchar inte"
fi

```

I detta fall använde jag mig av return som istället för att returnera ett värde som ni säkert är vana vid från Python returnar en exitkod för funktionen istället.