# edns0-validation

EDNS0について調べたついでに、各DNS権威サーバにEDN0の"ような"DNSクエリを送信した場合の応答について
比較してみました。

## 環境

### クライアント

* OS: Ubuntu Mate 14.04
* DNSクライアント: C++で作成した自作DNSクライアント

### サーバ

* OS: CentOS 6.6
* DNSサーバ
   - Bind: 9.10.2-P3
   - NSD: 4.1.3
   - PowerDNS Authoritative Server 3.4.5
   - knotDNS 1.6.4


## 送信したクエリ

各DNSサーバへwww.example.comのAレコードを問い合わせました。
そのクエリには、NSID(https://tools.ietf.org/html/rfc5001)を
含んだOPT pseudo-RRを追加してあります。

正しいEDNS0では、ADDITIONAL SECTIONに一つだけOPT pseudo-RRが存在ますが、
ここでは、このルールに反したクエリを送信し、そのレスポンスを比較します。

### 通常のクエリに対するレスポンス

* Bindに対するクエリとレスポンス

  https://github.com/sischkg/edns0-validation/blob/master/cap/test_00_01.cap?raw=true

* NSDに対するクエリとレスポンス

  https://github.com/sischkg/edns0-validation/blob/master/cap/test_00_02.cap?raw=true

* PowerDNS Authoritative Serverに対するクエリとレスポンス

  https://github.com/sischkg/edns0-validation/blob/master/cap/test_00_03.cap?raw=true

* knotDNSに対するクエリとレスポンス

  https://github.com/sischkg/edns0-validation/blob/master/cap/test_00_04.cap?raw=true



