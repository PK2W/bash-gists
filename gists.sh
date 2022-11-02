# Gist 1. 
# Concatinate multiple rotated log files for the service from different nodes, prefix with node's id and sort by timestamp and node id
# 1. concatinate needed log files for every node (rotated in the example), prefix with NUL and Node id (NUL used by sort in step 2)
cat ./node-1/svc.log.2 ./node-1/svc.log.1 ./node-1/svc.log | sed 's/^2022-10-31T/\x0node-1(node-id) &/' > ../node-1_svc-log
# NOTE: 

# 2. concatinate logs from all nodes and sort by timestamp and node-id, then remove NUL and store into single file
cat node1_svc-log node-2_svc-log node-3_svc-log | sort -z -k2.1,3.1 -k1.1,2.1 | sed -e 's/\x0//' > svc.log
# NOTE: -z use NUL as line delimeter - this handles multiline log messages as we NUL-prefixed only records that start with timestamp
#       -k defines sorting keys, by default sorting key index correspond to word position (' ' is default word separator, can be
#          changed with -t option) and the key length by default is till the end of the line. In the example we sort by k2 - second 
#          word of every line, starting from 2st words 1st char and stoping at 3rd word 1st char (corresponds to the timestamp), and
#          then sort by k1 - first word of each line starting from 1st character and stopping at 2nd word (corresponds to the prefix
#          prefix '\x0node-1(node-id)' = 16)
