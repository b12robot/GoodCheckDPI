# GoodCheckDPI
GoodbyeDPI with GoodCheck

# GoodbyeDPI Türkçe Kullanım Kılavuzu

goodbyedpi.exe [SEÇENEK...]

## Paket Gönderimi ve Parçalama

**-q**  
QUIC/HTTP3 trafiğini engeller, QUIC engellenirse HTTP/2’ye geri döner.  
GoodbyeDPI TCP tabanlı HTTP/1.1 ve HTTP/2 protokolleriyle daha iyi çalışır.

**-p**  
Pasif DPI sistemlerini kandırmak için bağlantının başında boş/anlamsız TCP paketi gönderir.

**-f \<sayı\>**  
HTTP paketlerini belirtilen boyutta parçalar halinde gönderir.  
`-f 2 → 2 baytlık parçalar halinde.`

**-k \<sayı\>**  
HTTP Keep-Alive paketlerini belirtilen boyutta parçalar halinde gönderir.
**-f** ile birlikte kullanılması önerilir.  
`-k 2 → 2 baytlık parçalar halinde.`

**-n**  
ACK (Onay) paketini beklemeden HTTP isteği gönderir. (Daha hızlı ama kararsız)  
Sadece **-k** parametresi ile birlikte kullanılabilir.

**-e \<sayı\>**  
HTTPS paketlerini belirtilen boyutta parçalar halinde gönderir.  
`-e 2 → 2 baytlık parçalar halinde.`

---

## HTTP Başlık ve İstek Modifikasyonları

**-r**  
Host başlığı adındaki harfleri rastgele büyük/küçük harfe çevirir.  
`Host: example.com → hoSt: example.com`

**-m**  
Host başlığının değerindeki harfleri rastgele büyük/küçük harfe çevirir.  
`Host: example.com → Host: eXaMpLe.CoM`

**-s**  
Host başlığı ile değeri arasındaki boşluğu kaldırır.  
`Host: example.com → Host:example.com`

**-a**  
Method ve URI arasında ekstra boşluk ekler.  
Otomatik **-s** parametresini etkinleştirir.  
`GET /index.html HTTP/1.1 → GET  /index.html HTTP/1.1`

---

## Anormal TCP Paketleri

**--wrong-chksum**  
TCP checksum’ı bilerek yanlış olan sahte HTTP paketi gönderir.

**--wrong-seq**  
TCP sıra numarası geçmişte olan sahte HTTP paketi gönderir.

**--native-frag**  
TCP paketlerini küçük parçalara bölerek gönderir.

**--reverse-frag**  
TCP paketlerini küçük parçalara bölerek ters sırayla gönderir.

---

## TTL ile Filtre Atlama Teknikleri

**--set-ttl \<sayı\>**  
Belirtilen TTL değeriyle sahte HTTP paketi gönderir.  
Siteleri bozabilir, **--blacklist** parametresi ile birlikte kullanılması önerilir.  
`--set-ttl 3`

**--auto-tt \<a1-a2-m\>** (varsayılan: 1-4-10)  
Hedef uzaklığına göre TTL hesaplayıp sahte paketi bu TTL ile gönderir.  

- **a1** →  Uzak hedefler için TTL değerinden en az ne kadar düşürüleceğini belirler.  
- **a2** → Yakın hedefler için TTL değerinden sabit olarak ne kadar düşürüleceğini belirler.  
- **m**  → TTL'nin ulaşabileceği maksimum değeri belirler; bu değerden büyük olamaz.  

Otomatik **--min-ttl 3** parametresini etkinleştirir.  
Siteleri bozabilir, **--blacklist** parametresi ile birlikte kullanılması önerilir.  
`--auto-tt 1-4-10`

**--min-ttl \<sayı\>**  
TTL mesafesi bu sayıdan küçükse sahte paket gönderilmez.  
Sadece **--set-ttl** ve **--auto-ttl** ile kullanılabilir.  
`--min-ttl 3`

---

## Sahte Paket Üretimi

**--fake-gen \<sayı\>**  
DPI’yı şaşırtmak için belirtilen sayıda rastgele sahte TCP paketi üretir.  
`--fake-gen 3`

**--fake-with-sni \<alan adı\>**  
Verilen alan adıyla Firefox 130 benzeri sahte TLS ClientHello paketi oluşturur.  
Bu seçenek birden fazla kez kullanılabilir.  
`--fake-with-sni example.com`

**--fake-from-hex \<hex\>**   
Sahte paketi doğrudan hexadecimal veriyle oluşturur.
Bu seçenek birden fazla kez kullanılabilir.  
`--fake-from-hex 1603030135010001310303424143facf5c983ac8ff20b819cfd634cbf4`

**--fake-resend \<sayı\>** (varsayılan: 1)  
Her sahte paketi belirtilen sayıda tekrar gönderir.  
Sadece **--fake-gen**, **--fake-with-sni** ve **--fake-from-hex** ile kullanılabilir.  
`--fake-gen 3 --fake-resend 4`

---

## DNS Yönlendirme

**--dns-addr \<dns\>**  
UDP üzerinden yapılan DNS isteklerini belirtilen IPv4 adresine yönlendirir. (deneysel)  
`--dns-addr 1.1.1.1`

**--dns-port \<port\>** (varsayılan: 53)  
DNS yönlendirmesi için kullanılacak IPv4 portunu belirtir.  
Sadece **--dns-addr** parametresi ile birlikte kullanılabilir.  
`--dns-addr 1.1.1.1 --dns-port 53`

**--dnsv6-addr \<dns\>**  
UDP üzerinden yapılan DNS isteklerini belirtilen IPv6 adresine yönlendirir. (deneysel)  
`--dnsv6-addr 2606:4700:4700::1111`

**--dnsv6-port \<port\>** (varsayılan: 53)  
DNS yönlendirmesi için kullanılacak IPv6 portunu belirtir.  
Sadece **--dnsv6-addr** parametresi ile birlikte kullanılabilir.  
`--dnsv6-addr 2606:4700:4700::1111 --dnsv6-port 53`

**--dns-verb**  
DNS işlemleri hakkında detaylı bilgi gösterir.  
Sadece **--dns-addr** ve **--dnsv6-addr** ile birlikte kullanılabilir.

---

## Alan Adı ve Port Filtreleme

**--blacklist \<dosya.txt\>**  
Sadece listedeki sitelerde DPI atlatması yapar.  
`--blacklist blacklist.txt`

**--ip-id \<id\>**  
Belirtilen IP-ID’ye sahip TCP RST/yönlendirmeyi engeller.  
`--ip-id 54321`

**--port \<port\>**  
Ek TCP portu ekler.  
`--port 8080`

**-w**  
Sadece 80 portu yerine tüm portlarda HTTP trafiği arar.  
**--port** parametresi ile aranacak portlar eklenebilir.

---

## Optimizasyon Parametreleri

**--max-payload** (varsayılan: 1200)  
TCP yükü bu değerden büyük paketleri analiz etmez.

---

## Uyumsuz Parametreler

- **--native-frag** ve **--reverse-frag**  
- **--set-ttl** ve **--auto-ttl**  

---

## Eski Önayarlar (Basit) - Pasif DPI için daha etkili.

- **-1** → `-p -r -s -f 2 -k 2 -n -e 2`
- **-2** → `-p -r -s -f 2 -k 2 -n -e 40`
- **-3** → `-p -r -s -e 40`
- **-4** → `-p -r -s`

---

## Modern Önayarlar (Önerilen) - Aktif DPI için daha etkili.

- **-5** → `-f 2 -e 2 --auto-ttl --reverse-frag --max-payload`
- **-6** → `-f 2 -e 2 --wrong-seq --reverse-frag --max-payload`
- **-7** → `-f 2 -e 2 --wrong-chksum --reverse-frag --max-payload`
- **-8** → `-f 2 -e 2 --wrong-seq --wrong-chksum --reverse-frag --max-payload`
- **-9** → `-f 2 -e 2 --wrong-seq --wrong-chksum --reverse-frag --max-payload -q`
