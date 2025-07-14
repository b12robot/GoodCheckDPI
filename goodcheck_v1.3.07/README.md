# GoodCheck – GoodbyeDPI, Zapret ve ByeDPI için blok kontrol (blockcheck) betiği

**Yazar:**  
Ori

**Lisans:**  
Ticari olmayan kullanımda, kaynak belirtilmek şartıyla serbesttir.

---

## 🔧 Betiğin Çalışma Prensibi

- `Strategies` klasöründeki metin dosyasından stratejiler alınır.  
- `Checklists` klasöründeki metin dosyasından kontrol edilecek siteler alınır.  
- Seçilen engel aşma programı (GoodbyeDPI, Zapret veya ByeDPI) her stratejiyle sırayla çalıştırılır.  
- Her siteye paralel olarak `curl` ile istek gönderilir. Eğer yanıt alınırsa, siteye erişim vardır.  
- Sonuçlar analiz edilir ve sıralanır. Ayrıntılar `Logs` klasöründeki log dosyalarında görülebilir.

---

## ⚙️ Temel Kurulum Talimatları

1. Arşivi ayrı bir klasöre çıkarın.  
2. `Config.cmd` dosyasını Not Defteri ile açın.  
3. Programların klasör yollarını uygun değişkenlere girin. Örnek:

   ```cmd
   set "_gdpiFolderOverride=D:\Soft\GoodbyeDPI\"
   set "_zapretFolderOverride=D:\Soft\Zapret\"
   set "_ciaFolderOverride=D:\Soft\ByeDPI\"
