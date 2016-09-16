#!/bin/bash
# Scritto da Filippo Bonazzi <f.bonazzi@davide.it> 2014
# Lo script ritorna l'indirizzo mac dell'interfaccia su cui è invocato
# o di tutte le interfacce se invocato senza parametri

function usage {
  echo "Lo script ritorna l'indirizzo mac dell'interfaccia su cui è invocato"
  echo -e "o di tutte le interfacce se invocato senza parametri.\n"
  echo -e "Uso: $0 [interface]\n"
  echo -e "\t-h, --help\t			mostra l'uso\n"
}

if [ $# -eq 1 ]
then
  case "$1" in
    -h|--help)
      usage
      exit
    ;;
  esac
fi

ifconfig $1 &> /dev/null

if [ $? -ne 0 ]
then
  ifconfig $1
  exit
fi

line=`ifconfig $1 | grep -E '[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}'`
echo -e "$line\n"
