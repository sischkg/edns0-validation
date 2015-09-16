# EDNS0のバリデーションの比較(キャッシュDNSサーバ)

各DNSキャッシュサーバへクエリパケット(a)を送信し、キャッシュサーバから権威サーバへDNSクエリパケット(b)を送信させます。
その応答としてEDNS0の*ような*DNSレスポンスパケット(c)をキャッシュサーバへ応答した場合、
キャッシュサーバがDNSクライアントへ応答するDNSレスポンスパケット(d)を比較してみました。

    +--------+ (a)www.example.com. IN A ? +-------+  (b)www.example.com. IN A ?   +------+
    |        |--------------------------->|       |------------------------------>|      |
    | client |                            | cache |                               | auth |
    |        |<---------------------------|       |<------------------------------|      |
    +--------+       (d)?????             +-------+     (c)crafted response       +------+

   
## 環境

### クライアント

* OS: CentOS 6.6 on VirtualBox
* DNSクライアント: DiG 9.10.2-P3
* IPアドレス: 192.168.33.103

### キャッシュサーバ

* OS: CentOS 6.6 on VirtualBox
* DNSサーバ
   - Bind: 9.10.2-P3
   - Unbound: 1.5.4
   - PowerDNS Recursor: 3.7.3
* IPアドレス:
   - Bind: 192.168.33.101
   - Unbound: IPアドレス: 192.168.33.102
   - PowerDNS: IPアドレス: 192.168.33.104

### 権威サーバ

* OS: Ubuntu Mate 14.04
* DNSサーバ: C++で作成したDNSパケットを応答するサーバ
* IPアドレス: 192.168.33.1

## 調査内容

DNSクライアントから各キャッシュサーバへwww.example.comのAレコードを問い合わせました(a)。
キャッシュサーバは権威サーバへ問い合わせを行い(b)、その応答を受信します(c)。
正しいEDNS0では、ADDITIONAL SECTIONに一つだけOPT pseudo-RRが存在ますが、
ここでは、このルールに反したDNSレスポンスを権威サーバからキャッシュサーバへ応答し(c)、
そのキャッシュサーバがDNSクライアントへ応答するDNSレスポンス(d)を比較しました。

動作を比較するために、キャッシュサーバ上でパケットキャプチャを取得しました。

### ケース0: 通常のレスポンスパケット

下記は、通常のレスポンスパケットを応答した時にtcpdumpにて取得したパケットキャプチャのデータへのリンクです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_10_01.cap?raw=true)
* [Unboundに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_10_02.cap?raw=true)
* [PowerNDSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_10_03.cap?raw=true)


### ケース1: 2個のOPT pseudo-RRを含むレスポンスパケット

下記は、2個のOPT pseudo-RRを含むレスポンスパケットを応答した時の、パケットキャプチャのデータです。
このとき、2個のOPT pseudo-RRのペイロードサイズ(CLASS値)は同じ値1280を使用しました。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_11_01.cap?raw=true)

  `SERVFAIL`を応答しました。

* [Unboundに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_11_02.cap?raw=true)

  `NoError`を応答しました。

* [PowerDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_11_03.cap?raw=true)

  `NoError`を応答しました。

### ケース2: 2個のOPT pseudo-RRを含むレスポンスパケット

下記は、2個のOPT pseudo-RRを含むレスポンスパケットを応答した時の、パケットキャプチャのデータです。
このとき、2個のOPT pseudo-RRのペイロードサイズ(CLASS値)は異なる値1280,1500を使用しました。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_12_01.cap?raw=true)

  `ServFail`を応答しました。

* [Unboundに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_12_02.cap?raw=true)

  `ServFail`を応答しました。

* [PowerDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_12_03.cap?raw=true)

  `NoError`を応答しました。

### ケース3: ANSWER SECTIONにOPT pseudo-RRを含むレスポンスパケット

下記は、ANSWER SECTIONにOPT pseudo-RRを含むレスポンスパケットを応答した時の、パケットキャプチャのデータです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_13_01.cap?raw=true)

  `NoError`を応答しました。

* [Unboundに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_13_02.cap?raw=true)

  `ServFail`を応答しました。

* [PowerDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_13_03.cap?raw=true)

  `NoError`を応答しました。

### ケース4: AUTHORITY SECTIONにOPT pseudo-RRを含むレスポンス

下記は、AUTHORITY SECTIONにOPT pseudo-RRを含むレスポンスパケットを応答した時の、パケットキャプチャのデータです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_14_01.cap?raw=true)

  `NoError`を応答しました。

* [Unboundに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_14_02.cap?raw=true)

  `ServFail`を応答しました。

* [PowerDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_14_03.cap?raw=true)

  `NoError`を応答しました。

### ケース5: OPT pseudo-RRのドメイン名をwww.example.comにしたレスポンス

下記は、OPT pseudo-RRのドメイン名を*www.example.com*にしたレスポンスパケットを応答した時の、パケットキャプチャのデータです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_15_01.cap?raw=true)

  `ServFail`を応答しました。

* [Unboundに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_15_02.cap?raw=true)

  `ServFail`を応答しました。

* [PowerDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_15_03.cap?raw=true)

  `NoError`を応答しました。

### ケース6: OPT pseudo-RRのextend-rcodeを常にBADVERSにしたレスポンス

下記は、OPT pseudo-RRをextend-rcodeを常にBADVERSにしたレスポンスパケットを応答した時の、パケットキャプチャのデータです。

* [Bindに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_16_01.cap.gz?raw=true)

  `ServFail`を応答しました。

* [Unboundに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_16_02.cap?raw=true)

  `NoError`を応答しました。

* [PowerDNSに対するクエリとレスポンス](https://github.com/sischkg/edns0-validation/blob/master/cap/test_16_03.cap?raw=true)

  `NoError`を応答しました。

## 比較表

|                                             | Bind      | Unbound    | PowerDNS |
|---------------------------------------------|-----------|------------|----------|
|ケース1:OPT pseudo-RR x 2(同じCLASS)          | ServFail  | NoError    | NoError  |
|ケース2:OPT pseudo-RR x 2(異なるCLASS)        | ServFail  | ServFail   | NoError  |
|ケース3:OPT pseudo-RR in ANSWER               | NoError   | ServFail   | NoError  |
|ケース4:OPT pseudo-RR in AUTHORITY            | NoError   | ServFail   | NoError  |
|ケース5:OPT pseudo-RRのドメイン名を変更        | ServFail  | ServFail   | NoError  |
|ケース6:OPT pseudo-RRのextend-rcodeをBADVERS  | ServFail  | NoError    | NoError  |


## ケース6のBindの動作について

権威サーバが常にextend-rcode = BADVERSを返す場合、キャッシュサーバのBind 9.10.2-P3は何度も権威サーバへ
問い合わせを行います。そのため、権威サーバとキャッシュサーバ間でクエリ/レスポンスが往復し続けます。
ただし、このクエリ/レスポンスは、無限に継続することはなくresolver-query-time（デフォルト10秒)で止まります。

この現象は、[Bind 9.10.3rc1](https://kb.isc.org/article/AA-01303)で修正されています。

> BADVERS responses from broken authoritative name servers were not handled correctly. [RT #40427]


