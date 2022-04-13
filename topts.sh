#!/bin/bash


while getopts ":d:s:r:n:m:" opt; do
  case $opt in
    d)
      echo "-d device set to: $OPTARG" >&2
			DEVICE=$OPTARG
      ;;
    s)
      echo "-s source set to: $OPTARG" >&2
			SOURCE=$OPTARG
      ;;
    r)
      echo "-r  resolution set to : $OPTARG" >&2
			RES=$OPTARG
      ;;
    n)
      echo "-n  start numbering at: $OPTARG" >&2
			STARTNUM=$OPTARG
      ;;
    m)
      echo "-m  mode set to : $OPTARG" >&2
			MYMODE=$OPTARG
      ;;
    /?)
      echo "Invalid option: -$OPTARG" >&2
      echo "-d device (hp5590  epson2) " >&2
      echo "-s source (Flatbed, TMA Slides)" >&2
      echo "-r  resolution 100 ? " >&2
      echo "-n  start numbering " >&2
      echo "-m  mode Color, Gray" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
