#IP=135.227.232.98    # give your windows host ip
IP=ukwindows.ddns.net    # give your windows host ip
PORT=36000 # some port of your choice

echo $1 | nc -w1 -u $IP $PORT
