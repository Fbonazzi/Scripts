#! /bin/bash
#
# Questo script rinomina tutti i file passati come parametro
# Richiede safe_regex.sh installato come safe_regex


for name in "$@"
do
  #rende minuscolo il nome
  filename=$(basename "$name" | tr "[:upper:]" "[:lower:]")

  #Nome del file
  newname="${filename%.*}"
  #Estensione, se presente
  safename=$(safe_regex "$newname" extended)
  safe_return=$?
  if [ $safe_return -ne 0 ]
  then
    exit $safe_return
  fi
  extn=$(echo "$filename" | sed -r "s/${safename}(\..*|)$/\1/") # doppi apici necessari per sostituzione variabile

  #rendi maiuscola la prima lettera di ogni parola del nome
  newname=$(echo "$newname" | sed -r 's/\<([a-z])/\u\1/g')

  #corregge le maiuscole dopo l'apostrofo ( "I'M" -> "I'm")
  newname=$(echo "$newname" | sed -r "s/'([A-Z])\>/'\L\1/g")

  #finalmente sposta
  mv "$name" "${newname}$extn"
done
