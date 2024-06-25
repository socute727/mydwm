ram() {
	mem=$(free -h | awk '/Mem:/ { print $3 }' | cut -f1 -d 'i')
	echo "  $mem"
}

cpu() {
	read -r cpu a b c previdle rest < /proc/stat
	prevtotal=$((a+b+c+previdle))
	sleep 0.5
	read -r cpu a b c idle rest < /proc/stat
	total=$((a+b+c+idle))
	cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
	echo "  $cpu"%
}

volume() {
	muted=$(pactl list sinks | awk '/Mute:/ { print $2 }')
	vol=$(pactl list sinks | grep Volume: | awk 'FNR == 1 { print $5 }' | cut -f1 -d '%')

	if [ "$muted" = "yes" ]; then
		echo "muted"
	else
		if [ "$vol" -ge 20 ]; then
			echo "  $vol%"
		elif [ "$vol" -ge 10 ]; then
			echo "  $vol%"
		elif [ "$vol" -ge 0 ]; then
			echo "  $vol%"	
		fi
	fi

}

layout(){
    t=$(xset -q | grep LED)
    code=${t##*mask:  }
    if [[ $code -eq "00000000" ]]; then
            result="EN"
    else
            result="RU"
    fi
    echo $result
}

clock() {
	time=$(date +"%H:%M")

	echo "$time"
}

main() {
	while true; do
		xsetroot -name "[ $(ram) ] [ $(cpu) ] [ $(layout) ] [ $(volume) ] [ $(clock) ]"
		sleep 1
	done
}

main
