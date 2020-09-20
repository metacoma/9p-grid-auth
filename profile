load std
mkdir -p /mnt/keys
echo ----- /lib/sh/profile
for host_var in `{ os env } { '{'$host_var'}' }

test -f /keydb/keys || { 
	cp /dev/null /keydb/keys
	chmod 600 /keydb/keys
} 

test -f /keydb/signerkey || {
	echo 'Create signerkey@'^$AUTH_ADDR
	auth/createsignerkey $AUTH_ADDR
} 

load std
load file2chan 
dir := /tmp/cmdchan
output_file := $dir^/tmp/output_file
cmd_file := $dir^/tmp/cmd

test -d $dir/export || mkdir -p $dir/export
test -d $dir/tmp || mkdir -p $dir/tmp
              
  


or {ftest -e /net/dns} {ftest -e /env/emuhost} {ndb/dns}
or {ftest -e /net/cs} {ndb/cs}
or {ftest -f /keydb/signerkey} {echo 'auth: need to use createsignerkey(8)' >[1=2]; raise nosignerkey}
or {ftest -f /keydb/keys} {echo 'auth: need to create /keydb/keys' >[1=2]; raise nokeys}
and {auth/keyfs -n < { echo -n $KEYFS_PASS } } {

  file2chan $dir^/export/cmd {
      if {~ ${rget offset} 0} {
        cat $output_file | putrdata
      } {
        rread ''
      }
    } {
      sh -c ${rget data} > $output_file
    }
  listen -v -t -A 'tcp!*!1917' { export $dir^/export & } 
  listen -v -t -A 'tcp!*!inflogin' {auth/logind&}
  listen -v -t -A 'tcp!*!infkey' {auth/keysrv&}
  listen -v -t -A 'tcp!*!infsigner' {auth/signer&}
  listen -v -t -A 'tcp!*!infcsigner' {auth/countersigner&}
}
