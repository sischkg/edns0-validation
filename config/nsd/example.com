$TTL 1D
@	IN SOA	@ rname.invalid. (
					0	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
	NS	ns1
	A	127.0.0.1
	AAAA	::1

www	IN A	127.0.0.1
ns1	IN A	127.0.0.1

