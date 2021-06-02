# totalLines=$(wc -l $file | awk '{print $1}')  # num. lines in file
totalLines=100
barLen=30
BAR='##############################'
FILL='------------------------------'

count=0
while [ ${count} -lt ${totalLines} ]; do
  # update progress bar
  count=$(( ${count}+ 1 ))
  percent=$(( (${count} * 100 / ${totalLines} * 100)/ 100 ))
  i=$(( ${percent} * ${barLen} / 100 ))
  echo -ne "\r[${BAR:0:$i}${FILL:$i:barLen}] ${count}/${totalLines} (${percent}%)"
  sleep .1
done
