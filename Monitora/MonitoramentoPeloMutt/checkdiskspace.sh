# set alert level 85% is default
ALERT=$2
ADMIN="$1"
df -H | grep -vE '^Filesystem|tmpfs|cdrom|loop' | awk '{ print $5 " " $1 }' | while read output;
do
  #echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $ALERT ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" | 
      echo "Body Message" | mutt -s "Alert: Almost out of disk space $usep" andre.rocha@techmaxconsultoria.com.br
  fi
done