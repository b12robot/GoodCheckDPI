# GoodCheck Türkçe Kullanım Kılavuzu

GoodbyeDPI, Zapret ve ByeDPI gibi engel aşma araçlarının farklı ayarlarla ne kadar etkili çalıştığını test eden bir engel tespit (blockcheck) betiğidir.

---

## Betiğin Çalışma Prensibi

- Kullanılacak engel aşma programı (GoodbyeDPI, Zapret veya ByeDPI) seçilir. Gerekirse **Config.cmd** dosyasından bu programın klasör yolu belirtilmelidir.

- **Strategies** klasöründeki seçilen metin dosyasından parametre kombinasyonları alınır.

- **Checklists** klasöründeki seçilen metin dosyasından kontrol edilecek siteler alınır.

- Seçilen strateji dosyasındaki parametreler sırayla seçilen engel aşma programı ile çalıştırılır ve seçilen kontrol listesindeki her siteye **Curl** ile istek gönderilir. Eğer yanıt alınırsa, siteye erişim vardır.

- Sonuçlar analiz edilir ve en çok sitede işe yarayan kombinasyonlar sıralanır. Ayrıntılar **Logs** klasöründeki log dosyalarında görülebilir.

---

## Temel Kurulum Talimatları

`Config.cmd` dosyasını Not Defteri ile açın.  
Kullanmak istediğiniz programların klasör yollarını uygun değişkenlere girin.
   ```cmd
   set "_gdpiFolderOverride=C:\Soft\GoodbyeDPI\"
   set "_zapretFolderOverride=C:\Soft\Zapret\"
   set "_ciaFolderOverride=C:\Soft\ByeDPI\"
