# EDNS0のバリデーションの比較(権威DNSサーバ)

EDNS0について調べたついでに、各DNS権威サーバにEDNS0の*ような*DNSクエリを送信した場合の応答について
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


## 調査内容

各DNSサーバへwww.example.comのAレコードを問い合わせました。
そのクエリには、NSID(https://tools.ietf.org/html/rfc5001)を
含んだOPT pseudo-RRを追加してあります。

正しいEDNS0では、ADDITIONAL SECTIONに一つだけOPT pseudo-RRが存在ますが、
ここでは、このルールに反したクエリを送信し、そのレスポンスを比較しました。



### ケース0: 通常のクエリに対するレスポンス

下記は、通常のクエリを送信した時にtcpdumpにて取得したパケットキャプチャのデータへのリンクです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_00_01.cap?raw=true)
* [NSDに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_00_02.cap?raw=true)
* [PowerDNS Authoritative Serverに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_00_03.cap?raw=true)
* [knotDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_00_04.cap?raw=true)


### ケース1: 2個のOPT pseudo-RRを含むクエリ

下記は、2個のOPT pseudo-RRを含むクエリを送信した時にtcpdumpにて取得したパケットキャプチャのデータへのリンクです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_01_01.cap?raw=true)

  `Format Error`を応答しました。

* [NSDに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_01_02.cap?raw=true)

  `Format Error`を応答しました。

* [PowerDNS Authoritative Serverに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_01_03.cap?raw=true)

  OPT pseudo-RRを一つ含む場合(通常のEDNS0)と同じ応答を返しました。

* [knotDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_01_04.cap?raw=true)

  OPT pseudo-RRを一つ含む場合(通常のEDNS0)と同じ応答を返しました。


### ケース2: ANSWER SECTIONにOPT pseudo-RRを含むクエリ

下記は、ANSWER SECTIONにOPT pseudo-RRを含むクエリを送信した時にtcpdumpにて取得したパケットキャプチャのデータへのリンクです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_02_01.cap?raw=true)

  OPT pseudo-RRをADDITIONAL SECTIONに含む場合(通常のEDNS0)と同じ応答を返しました。

* [NSDに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_02_02.cap?raw=true)

  `Format Error`を応答しました。

* [PowerDNS Authoritative Serverに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_02_03.cap?raw=true)

  OPT pseudo-RRを含まない場合(非EDNS0)と同じ応答を返しました。

* [knotDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_02_04.cap?raw=true)

  OPT pseudo-RRを含まない場合(非EDNS0)と同じ応答を返しました。


### ケース3: AUTHORITY SECTIONにOPT pseudo-RRを含むクエリ

下記は、AUTHORITY SECTIONにOPT pseudo-RRを含むクエリを送信した時にtcpdumpにて取得したパケットキャプチャのデータへのリンクです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_03_01.cap?raw=true)

  OPT pseudo-RRをADDITIONAL SECTIONに含む場合(通常のEDNS0)と同じ応答を返しました。

* [NSDに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_03_02.cap?raw=true)

  `Format Error`を応答しました。

* [PowerDNS Authoritative Serverに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_03_03.cap?raw=true)

  OPT pseudo-RRを含まない場合(非EDNS0)と同じ応答を返しました。

* [knotDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_03_04.cap?raw=true)

  OPT pseudo-RRを含まない場合(非EDNS0)と同じ応答を返しました。


### ケース4: OPT pseudo-RRのドメイン名をwww.example.comにしたクエリ

下記は、OPT pseudo-RRのドメイン名を*www.example.com*にしたクエリを送信した時にtcpdumpにて取得したパケットキャプチャのデータへのリンクです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_04_01.cap?raw=true)

  `Format Error`を応答しました。

* [NSDに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_04_02.cap?raw=true)

  `Format Error`を応答しました。

* [PowerDNS Authoritative Serverに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_04_03.cap?raw=true)

  通常のEDNS0と同じ応答を返しました。

* [knotDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_04_04.cap?raw=true)

  通常のEDNS0と同じ応答を返しました。


## 比較表

|                                        | Bind           | NSD        | PowerDNS           | knotDNS         |
|----------------------------------------|----------------|------------|--------------------|-----------------|
|ケース1:複数OPT pseudo-RR               | FormErr        | FormErr    | NoError(EDNS0)     |NoError(EDNS0)   |
|ケース2:OPT pseudo-RR in ANSWER         | NoError(EDNS0) | FormErr    | NoError(非EDNS0)   |NoError(非EDNS0) |
|ケース3:OPT pseudo-RR in AUTHORITY      | NoError(EDNS0) | FormErr    | NoError(非EDNS0)   |NoError(非EDNS0) |
|ケース4:OPT pseudo-RRのドメイン名を変更 | FormErr        | FormErr    | NoError(EDNS0)     |NoError(EDNS0)   |


