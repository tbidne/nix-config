get_time () {
  echo $(date +%s)
}

seconds_to_clock () {
  echo "$(date --date=@$1 -u +%H:%M:%S)"
}

start_time=$(get_time)

pid=$1
period=30

if [[ ! -z $2 ]]; then
  period=$2
fi

running=1

while [[ $running == 1 ]]; do
  if [ -n "${pid}" -a -d "/proc/${pid}" ]; then
    curr_time=$(get_time)
    diff=$(($curr_time - $start_time))
    diff_clock=$(seconds_to_clock $diff)
    echo -ne "\r$pid is running: $diff_clock"
    sleep $period
  else
    running=0
    echo -e "\n$pid is not running."
  fi
done
