# Gist 1. 
# Concatinate multiple rotated log files for the service from different nodes, prefix with node's id and sort by timestamp and node id
# 1. concatinate needed log files for every node (rotated in the example), prefix with NUL and Node id (NUL used by sort in step 2)
cat ./node-1/svc.log.2 ./node-1/svc.log.1 ./node-1/svc.log | sed 's/^2022-10-31T/\x0node-1(node-id) &/' > ../node-1_svc-log
# NOTE: use smarter regex in sed to match generic timestamp field, then you can pipe result to grep to limit the time frame before
#       saving result to file. In the the example it is assumed that logs contain data only for given date, otherwise this won't work

# 2. concatinate logs from all nodes and sort by timestamp and node-id, then remove NUL and store into single file
sort -z -k2,2 -k1,1 pod-1_iamsvc-log pod-2_iamsvc-log pod-3_iamsvc-log | sed -e 's/\x0//' > svc.log
# NOTE: -z use NUL as line delimeter - this handles multiline log messages as we NUL-prefixed only records that start with timestamp
#       -k defines sorting keys, by default sorting key index correspond to word/field position separated by ' ' (controlled by -t),
#          and the default key length is till the end of the line. 
#          In the example we first sort by the key k2,2 - entire 2nd field that corresponds to the timestamp, and then sort by the
#          key k1,1 - entire 1st field that corresponds to the prefix '\x0node-1(node-id)'

