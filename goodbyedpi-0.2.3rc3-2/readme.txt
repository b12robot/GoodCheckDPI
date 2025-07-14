GoodbyeDPI Kullanım Kılavuzu

goodbyedpi.exe [SEÇENEK...]

----------------------------------------------------------------------------------------------

Protokol Seçimi ve Trafik Türü Ayarı

-q
QUIC/HTTP3 trafiğini engeller, QUIC engellenirse HTTP/2’ye geri döner.
GoodbyeDPI TCP tabanlı HTTP/1.1 ve HTTP/2 protokolleriyle daha iyi çalışır.

----------------------------------------------------------------------------------------------

HTTP Başlığı ve İstek Yapısı Manipülasyonu

-r
Host başlığı adındaki harfleri rastgele büyük/küçük harfe çevirir.
(Host: example.com → hoSt: example.com)

-m
Host başlığının değerindeki harfleri rastgele büyük/küçük harfe çevirir.
(Host: example.com → Host: eXaMpLe.CoM)

-s
Host başlığı ile değeri arasındaki boşluğu kaldırır.
(Host: example.com → Host:example.com)

-a
Method ve URI arasında extra boşluk ekler.
Otomatik -s parametresini etkinleştirir.
(GET /index.html HTTP/1.1 → GET  /index.html HTTP/1.1)

----------------------------------------------------------------------------------------------

Paket Gönderim Şekli ve Parçalama

-p
Pasif DPI sistemlerini kandırmak için bağlantının başında boş/anlamsız TCP paketi gönderir.

-f <sayı>
HTTP paketlerini belirtilen boyutta parçalar halinde gönderir.
(-f 2 → 2 baytlık parçalar halinde.)

-k <sayı>
HTTP Keep-Alive bağlantılarda paketleri belirtilen boyutta parçalar halinde gönderir.
(-f parametresi ile kullanılması önerilir.)

-n
ACK (Acknowledgment) paketi gelmeden HTTP isteği gönderilir.
Sadece -k parametresiyle birlikte kullanılabilir. 

-e <sayı>
HTTPS paketlerini belirtilen boyutta parçalar halinde gönderir.
(-e 2 → 2 baytlık parçalar halinde.)

----------------------------------------------------------------------------------------------

Sahte ve Anormal TCP Paketleri

--wrong-chksum
TCP checksum’ı bilerek yanlış olan sahte bir HTTP paketi gönderir.

--wrong-seq
TCP sıra numarası geçmişte olan sahte bir HTTP paketi gönderir.

--native-frag
TCP paketlerini küçük parçalara bölerek gönderir

--reverse-frag
TCP paketlerini küçük parçalara böler ve ters sırayla gönderir.

----------------------------------------------------------------------------------------------

TTL Tabanlı Filtre Atlama Teknikleri

--set-ttl <sayı>
Belirtilen TTL (Time To Live) değeriyle sahte HTTP paketi gönderir.
Siteleri bozabilir, blacklist ile kullanılması önerilir.
(tracert <domein> komutu ile uygun TTL değeri ölçülebilir.)

--auto-ttl <a1-a2-m> (varsayılan: 1-4-10)
Hedef uzaklığına göre TTL değerini otomatik hesaplayıp, sahte HTTP paketini bu TTL ile gönderir.
Siteleri bozabilir, blacklist ile kullanılması önerilir.
Otomatik --min-ttl 3 parametresini etkinleştirir.

Hedef yakınsa (hop ≤ a2) → TTL, a2 kadar düşürülür.
Hedef uzaksa (hop > a2)	 → TTL, a1–a2 arasında azaltılır.
TTL sonucu m'den büyükse → TTL = m yapılır.

--min-ttl <sayı>
TTL mesafesi bu sayıdan küçükse sahte paket gönderilmez. 
Sadece --set-ttl ve --auto-ttl ile birlikte kullanılabilir.

----------------------------------------------------------------------------------------------

Sahte Paket Üretimi 

--fake-from-hex <hex>
Sahte paketi doğrudan hexadecimal veriyle oluşturur.
Bu seçenek birden fazla kez kullanılabilir.

--fake-with-sni <domain>
Verilen alan adıyla sahte Firefox benzeri TLS ClientHello paketi oluşturur.
Bu seçenek birden fazla kez kullanılabilir.

--fake-gen <n>
DPI’yı şaşırtmak için n adet rastgele içerikli sahte TCP paketi üretir, gerçek protokol taklidi yapmaz.
Genelde --fake-resend ile birlikte kullanılır.

--fake-resend <sayı> (varsayılan: 1)
Her sahte paketi belirtilen sayı kadar gönderir.
Sadece --fake-gen, --fake-with-sni, --fake-from-hex ile kullanılabilir.

----------------------------------------------------------------------------------------------

DNS Yönlendirme ve Denetleme

--dns-addr <ip>
UDP üzerinden yapılan DNS isteklerini belirtilen IPv4 adresine yönlendirir. (deneysel)

--dns-port <port> (varsayılan: 53)
DNS yönlendirmesi için kullanılacak IPv4 portunu belirtir.

--dnsv6-addr <ip>
UDPv6 üzerinden yapılan DNS isteklerini belirtilen IPv6 adresine yönlendirir. (deneysel)

--dnsv6-port <port> (varsayılan: 53)
DNS yönlendirmesi için kullanılacak IPv6 portunu belirtir.

--dns-verb
DNS işlemleri hakkında detaylı bilgi gösterir.

----------------------------------------------------------------------------------------------

Alan Adı ve Paket Filtreleme

--blacklist <dosya.txt>
Sadece dosyada belirtilen sitelerde DPI atlatması uygular.
Bu seçenek birden fazla kez kullanılabilir.

--ip-id <id>
Belitilen IP-ID'nin TCP RST/yönlendirme paketlerini engeller.
Bu seçenek birden fazla kez kullanılabilir.

--port <port>
Ek TCP portu ekler.

-w
Sadece varsayılan 80 portunda değil, tüm portlarda HTTP trafiği arar.
--port parametresi ile aranacak portlar eklenebilir.

----------------------------------------------------------------------------------------------

Optimizasyon parametreleri:

--max-payload <bayt> (varsayılan: 1200)
TCP yükü bu değerden büyük olan paketleri analiz etmez.

----------------------------------------------------------------------------------------------

Birlikte kullanılamayan parametreler:

--native-frag ve --reverse-frag
--set-ttl ve --auto-ttl

----------------------------------------------------------------------------------------------

Eski Önayarlar (Basit) - Pasif DPI için daha etkili.
 -1  →  -p -r -s -f 2 -k 2 -n -e 2
 -2  →  -p -r -s -f 2 -k 2 -n -e 40
 -3  →  -p -r -s -e 40
 -4  →  -p -r -s

Modern Önayarlar (Önerilen) - Aktif DPI için daha etkili.
 -5  →  -f 2 -e 2 --auto-ttl --reverse-frag --max-payload
 -6  →  -f 2 -e 2 --wrong-seq --reverse-frag --max-payload
 -7  →  -f 2 -e 2 --wrong-chksum --reverse-frag --max-payload
 -8  →  -f 2 -e 2 --wrong-seq --wrong-chksum --reverse-frag --max-payload
 -9  →  -f 2 -e 2 --wrong-seq --wrong-chksum --reverse-frag --max-payload -q
