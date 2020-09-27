function [f,mask_size] = adaptive_median( g_noisy,Smax )
%Upper lines in English
%Lower lines in Turkish 

%Adaptive median filter created as Matlab function.
%Adaptif medyan filtre Matlab fonksiyonu olarak tasarlandi.

%Smax means adaptive median filter's max mask size.I gave S parameter
%because S means a area in spatial domain.
%Smax adaptif medyan filtre maskesinin maksimum boyutunu belirtir.
%S parametresi verilmesinin sebebi S uzlamsal domende goruntu uzerinde
%bir bolgeyi belirtir. 
if(Smax <= 1) || (Smax/2 == round(Smax/2)) || (Smax ~= round(Smax))
    error('Smax 1 den buyuk tek integer degerli sayi olmali')
    %Gives error when Smax is not bigger than 1 and not integer in turkish
end

f=g_noisy;
f(:)=0;
%f takes noisy image size and all values are 0. (:) means vectorization.
%f fonksiyona giren gurultulu goruntunun boyutu ile ayni boyutta tum
%elemanlari 0 olan bir matris veya goruntu. (:) ifadesini matrisi vektörize
%etmek icin kulandim . Eger bunu kullanmasaydim matrisin tum elemanlarina 0
%atamak icin 2 tane for dongusu kullanmam gerekecekti ve bu da kodumu ciddi
%anlamda yavaslatacakti. Vektorizasyon mxn boyutunda bir matrisi (mxn)x1
%boyutunda bir sutun vektorune donusturmek demek. 3x4'luk bir matris 12
%satirli 1 sutunlu bir sutun vektorune donusturuluyor. Fakat sunu unutmamak
%gerek degerlerin atanmasi bittikten sonra f tekrar mxn boyutunda 0'lardan
%olusan bir matris oluyor. Bu tamamen Matlab'in bizi dongulerden kurtarmak
%icin yarattigi bir durum .

logical_array = false(size(g_noisy));
%created logical zeros array same size with noisy image
%Lojik 0'lardan olusan gurultulu goruntu ile ayni boyutta bir array
%olusturuldu.

for k=3:2:Smax
    zmin = ordfilt2(g_noisy, 1 , ones(k,k),'symmetric');
    %Please translate it by translator...
    
    %g_noisy'nin ilgili elemanini degeri maskenin kapsadigi komsu elemanlar 
    %içerisinde  en küçük degerde olanidir(order=1 oldugu için). Eger order
    %2 olsaydi maskeleme sonucu komsu elemanlar icerisinde ki en kucuk 2. 
    %elemani verirdi.Bu sekilde minimum filtreleme yapmis oluyoruz. ones(k,k)
    %ile filtreme isleminde kullandigim maskenin boyutunu belirliyorum.
    %minimum filtreleme gurultulu goruntude ki tum piksellerin
    %degerini olabildigince dusurup 0'a yakinlastirmaya calisir yani siyaha
    %karabiber gurultusune. Tum pikseller siyahtir yada siyaha cok
    %yakindir. ordfilt2 komutu hakkinda daha fazla bilgi icin 
    %http://matlab.izmiran.ru/help/toolbox/images/ordfilt2.html 'e bakin.
    zmax = ordfilt2(g_noisy,k*k, ones(k,k),'symmetric');
    %Please translate it by translator...
    
    %Maks.filtre maskenin kapsadigi elemanlar içindeki en büyük degerli
    %elemani yeni elemanla degistirmek olduguna göre, yeni filtrede
    %k*k degerini order kismina yazmak yeterlidir. Bu sekilde maksimum
    %filtreleme yapmis oluyoruz.maksimum filtreleme olabildigince yukseltip 
    %255'e(gorunyunuz uint8 bir goruntuyse eger) beyaza yani tuz gurultusune 
    %yakinlastirmaya calisir . Tum pikseller beyazdir veya beyaza cok
    %yakindir. 
    zmed = medfilt2(g_noisy,[k k],'symmetric');

    level_b = (zmed > zmin) & (zmax > zmed) & ~logical_array;
    %Please translate it by translator...
    
    %Eger bu sart saglanirsa seviye b'ye gurultulu goruntunun boyutunda
    %lojik 1'lerden olusan arraylar ataniyor. Saglanmazsa lojik 0'lardan
    %olusuyor array . Bu sekilde 2. asama olan seviye b'ye geciyorum.
    %Array'e lojik 0 atanmasi demek asagidaki hicbir sartin gerceklesmemesi
    %demek. Bu durumda for dongusu ile sadece adaptif medyan filtreleme de 
    %kullandigim maskenin boyutunu artirmis olacagim.Burada ki amac degisen
    %her pencere boyutunda medyan filtrenin sonucunda olusan goruntunun piksellerinin 
    %karabiber gurultusu ile tuz gurultusu arasinda olup olmadigini kontrol
    %etmektir. Bu kontrol goruntu icerisinde varligini surduren tum pikseller 
    %icin yapilir .Yap?lan filtrelemenin adaptif olmasinin sebebi budur.
    zb = (g_noisy > zmin) & (zmax > g_noisy);
    %Please translate it by translator...
    
    %Eger bu sart saglaniyorsa lojik 1'den olusan array asagidaki Zxy_output'a 
    %saglanmiyorsa Zmed_output'a atanacaktir. Tabiki yukarida bahsedildigi gibi 
    %eger level_b lojik 0'lardan olusuyorsa zaten hicbir sart saglanmayacaktir.
    %Burada ki  amac  sudur , gurultulu  goruntude ki piksellerin hepsi minimum
    %filtrelemeden buyuk mu , maksimum filtrelemeden kucuk mu diye kontrol
    %edilir cunku minimum filtreleme gurultulu goruntude ki tum piksellerin
    %degerini olabildigince dusurup 0'a yakinlastirmaya calisir yani siyaha
    %karabiber gurultusune olusan bu yeni goruntu zmin'e atanmisti, maksimum 
    %filtreleme olabildigince yukseltip 255'e(gorunyunuz uint8 bir goruntuyse eger) 
    %beyaza yani tuz gurultusune yakinlastirmaya calisir . Olusan bu yeni 
    %goruntude zmax'a atanmisti. Ve benim gurultulu goruntum bu 2 degerin 
    %arasindaysa eger zmin ve zmax parametreleri icin adaptif medyan filtrelemenin 
    %sartlari saglaniyor demektir.
    Zxy_output = level_b & zb;
    Zmed_output = level_b & ~zb;

    f(Zxy_output) = g_noisy(Zxy_output);
    f(Zmed_output) = zmed(Zmed_output);
    %Please translate it by translator...
    
    %Eger Zxy_output lojik 1'lerden olusuyorsa g_noisy tum degerlerini aynen
    %koruyup f'e atanacak . Ama eger Zmed_output lojik 1'lerden olusuyorsa 
    %onceki satirlarda yaptigimiz medyan filtrelemenin sonucu f'e atanacak.
    %Bu sekilde filtreleme icin kullandigim maskenin boyutu yetersiz olsa
    %bile bir cikis goruntusu elde ediyorum eksik de olsa goruntuye
    %filtreleme islemini uygulayip sonuc elde ediyorum. Bu da 
    %f(Zmed_output) = zmed(Zmed_output); satiri ile gerceklesiyor. Ama eger
    %maske boyutunu dogru veya dogru degerden buyuk girdiysem eger (dogru
    %degerden buyuk girilse bile level_b array'i lojik 1'lerden olustugu
    %icin donguden cikiliyor ve filtreleme islemi son kez dogru maske
    %boyutu icin yapiliyor) f(Zxy_output) = g_noisy(Zxy_output); satiri
    %uzerinden filtreleme sonucunu elde ediyorum.
    logical_array = logical_array | level_b;
    %If level_b array form logical 1's it means median filtering
    %happened.Thus loop is over and filtering process come to an end . 
    
    %Eger level_b array'i lojik 1'lerden olusuyorsa istenilen adaptif
    %medyan filtreleme gerceklesmis demektir. Bu durumda filtreleme
    %isleminin bitirilmesi icin donguden cikilmasi gerekmektedir.
    
    if all(logical_array(:))
    % returns logical 1 ( true ) if all the elements are nonzero
    %all komutu vektorun tum elemanlari 0'dan farkli ise lojik 1 yani True
    %deger dondurur.   
    
    mask_size = ['Filtreleme icin gereken dogru maske boyutu ',int2str(k),' degeridir']
    %If you put bigger parameter than true value of mask size it tells you
    %right value
    %Gereken filtre boyutunu fazla girseniz bile size dogru boyutu
    %soyleceyecek .
    break;
    end
end

if  not(all(logical_array(:)))
    mask_size = ['Filtreleme icin gereken dogru maske boyutu ',int2str(k),' degeri degildir!!! Lutfen maske boyutunu yukseltin.']
    %If you put less mask size it will warn you about it .
    
    %Eger girilen fitrenin boyutu yetersiz ise sonuc olarak logical_array
    %lojik 0'lardan olusacak ve adaptif medyan filtre gerceklestirilmeden 
    %donguden cikilacak.
end

end


