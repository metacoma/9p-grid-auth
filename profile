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

env

or {ftest -e /net/dns} {ftest -e /env/emuhost} {ndb/dns}
or {ftest -e /net/cs} {ndb/cs}
or {ftest -f /keydb/signerkey} {echo 'auth: need to use createsignerkey(8)' >[1=2]; raise nosignerkey}
or {ftest -f /keydb/keys} {echo 'auth: need to create /keydb/keys' >[1=2]; raise nokeys}
and {auth/keyfs -n < { echo -n $KEYFS_PASS } } {
  listen -v -t -A 'tcp!*!inflogin' {auth/logind&}
  listen -v -t -A 'tcp!*!infkey' {auth/keysrv&}
  listen -v -t -A 'tcp!*!infsigner' {auth/signer&}
  listen -v -t -A 'tcp!*!infcsigner' {auth/countersigner&}
}
