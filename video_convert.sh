#!/bin/bash
INPUT_FILE=$1
RESOLUTION=$2
FRAMERATE=$3

CRF=23
PRESET=veryfast

case "$RESOLUTION" in
	"1080" )
		echo "1080 ok"
		;;
	"720" )
		echo "720 ok"
		;;
	* )
		echo "invalid resolution (1080/720 only)"
		exit
		;;
esac

case "$FRAMERATE" in
	"60" )
		;;
	"30" )
		;;
	* )
		echo "invalid framerate (30/60 only)"
		exit
		;;
esac

EXTENSION="${INPUT_FILE##*.}"
OUTPUT_FILE=$(basename "$INPUT_FILE" | sed "s/\.$EXTENSION/ "$RESOLUTION"p$FRAMERATE.$EXTENSION/")

if [ -f "$INPUT_FILE" ] && [ ! -f "$OUTPUT_FILE" ]; then
	ffmpeg -i "$INPUT_FILE" -vf scale=-1:$RESOLUTION -c:v libx264 -r $FRAMERATE -crf $CRF -preset $PRESET -c:a copy "$OUTPUT_FILE"
	if [ $? -eq 0 ]; then
		notify-send "Video erfolgreich konvertiert: $OUTPUT_FILE"
	else
		notify-send "Video konnte nicht konveritert werden"
		rm "$OUTPUT_FILE"
	fi
else
	notify-send "Fehler, wurde das Video schon konvertiert?"
fi

