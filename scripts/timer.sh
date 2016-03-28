#!/bin/sh

if (! [ -z "${1//[0-9:]*[0-9]/}" ]) || [ -z "$1" ]; then
	echo 'first argument must be a positive number or time on "dd:hh:mm:ss"'
	exit 1
fi

days=$((`expr "$1" : "^\([0-9]*\):[0-9]*:[0-9]*:[0-9]*"`))
hours=$((`expr "$1" : ".*:\([0-9]*\):[0-9]*:[0-9]*" || expr "$1" : "\([0-9]*\):[0-9]*:[0-9]*"`))
minutes=$((`expr "$1" : ".*:\([0-9]*\):[0-9]*" || expr "$1" : "\([0-9]*\):[0-9]*"`))
seconds=$((`expr "$1" : ".*:\([0-9]*\)" || expr "$1"`))

[ ${#minutes} -gt 0 ] && seconds=`expr "$seconds" + "$minutes" \* 60`
[ ${#hours} -gt 0 ] && seconds=`expr "$seconds" + "$hours" \* 3600`
[ ${#days} -gt 0 ] && seconds=`expr "$seconds" + "$days" \* 216000`

rmstring='\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b'
empty='                            '
begin=0
end=$seconds

for ((i=$end; i>=$begin; --i)); do
	printf "$rmstring" 
	printf "$empty" 
	printf "$rmstring" 
	days=`expr "$i" \/ 216000`
	[ ${#days} -eq 1 ] && days="0$days"
	[ $days -gt 0 ] && printf "$days:"
	hours=`expr "$i" \/ 3600 % 24`
	[ ${#hours} -eq 1 ] && hours="0$hours"
	[ $hours -gt 0 -o $days -gt 0 ] && printf "$hours:"
	minutes=`expr "$i" \/ 60 % 60`
	[ ${#minutes} -eq 1 ] && minutes="0$minutes"
	[ $minutes -gt 0 -o $hours -gt 0 -o $days -gt 0 ] && printf "$minutes:"
	seconds=`expr $i % 60`
	[ ${#seconds} -eq 1 ] && seconds="0$seconds"
	printf "$seconds"
	sleep 1
done

echo -en "\ndone!\n"

