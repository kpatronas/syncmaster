# syncmaster
rsync with tricks!

Do you want to sync data from / to servers but you miss the following features?

* Parallelization 
* Resume file sync from where stopped
* Limit bandwidth per rsync job
* Append only new files
* Ensure that another syncmaster rsync will not start until current has completed

You can use this super easy bash script that wraps rsync

Usage:
* -t: transfers space separated
    each transfer is delimited by ";" first  column: source
                                      second column: destination
                                      third  column: bandwidth
* -p: concurrent parallel transfers

Example: local dir sync
```
syncmaster.sh -t "/home/user/src/*;/home/user/dst/;10000" -p 3
```

Example: Remote dir to local sync
```
syncmaster.sh -t "user@server1:/home/user/src/*;/home/user/dst/;10000" -p 3
```
Example: Local dir to remote sync
```
syncmaster.sh -t "/home/user/src/*;user@server1:/home/user/dst/;10000" -p 3
```
Example: Local dir to many remote servers ync
```
syncmaster.sh -t "/home/user/src/*;user@server1:/home/user/dst/;10000 /home/user/src/*;user@server2:/home/user/dst/;10000 /home/user/src/*;user@server3:/home/user/dst/;10000 /home/user/src/*;user@server4:/home/user/dst/;10000" -p 3
```
