%Upper lines in English
%Lower lines in Turkish 

%Adaptive median filter testing
%Adaptif medyan filtre denemeleri

g=imread('C:\Users\Emre Türkmen\Desktop\Görüntü Isleme Resimler\simpsons.jpg');
%Image reading by imread.
%Görüntü imread komutu ile okundu.

g_gray = rgb2gray(g);
%Image converted into grayscale image.
%3 kanalli görüntü gri seviyeli görüntüye dönüstürüldü.

g_noisy=imnoise(g_gray,'salt & pepper',.2);
%Added noise to image. We've other noise type like gaussian poisson etc. 
%But we must add salt & pepper noise because median filter and adaptive 
%median filter deals with that noise . Spatial filters deals with special 
%noises like geometric mean filter only deals with gaussian noise . If you 
%apply geometric mean filter to salt & pepper noisy image you'll get worse
%result. .2 parameter means the noise density. This affects approximately 
%.2*numel(I) pixels. numel command returns the number of elements I image
%for more information check https://www.mathworks.com/help/images/ref/imnoise.html
%and https://www.mathworks.com/help/matlab/ref/double.numel.html for
%imnoise and numel commands.

%Görüntüye gürültü eklendi.Tuz ve biber gurultusu disinda baska gurultu
%cesitleri de mevcut fakat medyan filtre ve adaptif medyan filtre sadece
%tuz ve biber gurultusunu iyi bir sekilde temizlemektedir. Her filtre her
%gurultu ile bas edemez. Ornegin geometrik ortalama filtresinin cevabi
%gaussian gurultuye karsi cok iyiyken tuz ve biber gurultusune karsi cok
%kotudur. .2 parametresi gurultu yogunlugunu belirtmektedir. numel komutu
%piksel sayisini döndürmektedir. I goruntusunde .2*numel(I)kadar pikselin
%bu gurultuden etkilenecegini ifade eder. Daha fazla bilgi icin 
%https://www.mathworks.com/help/images/ref/imnoise.html ve 
%https://www.mathworks.com/help/matlab/ref/double.numel.html sitelerine
%bakip imnoise ve numel komutunu detayli ogrenebilirsiniz.

imshow(g)
figure,imshow(g_gray)
figure,imshow(g_noisy)
%Showed 3 channel image , grayscale image and noisy image 
%Rgb 3 kanalli resim , griye dönüstürülmüs tek kanalli resim ve gürültülü
%resim gösterildi.
 
[adpmed_filter_result1,Smax_value_1] = adaptive_median(g_noisy,5);
[adpmed_filter_result2,Smax_value_2] = adaptive_median(g_noisy,21);
%Kernel size adjusted 5x5 and 21x21 and applied noisy image 
%Kernel boyutu yani goruntuye uygulanacak 2 boyutlu filtrenin boyutu 5x5 ve
%21x21 olmak uzere ayarlandi.

median_filter_result1 = medfilt2(g_noisy, [21 21],'symmetric');
median_filter_result2 = medfilt2(g_noisy, [7 7],'symmetric');
median_filter_result3 = medfilt2(g_noisy, [3 3],'symmetric');
%Median filters kernel sizes adjusted 21x21 , 7x7 and 3x3.
%'symetric' parameter means symmetrically extended image it's boundaries.
%If you can't give that parameter image padded zeros by default. We'must
%extend image boundaries because if we apply filters to pixels who close to the 
%image boundaries filter can't fit into the image and we can't apply filters
%to that pixels.For more information check 
%https://www.mathworks.com/help/images/ref/medfilt2.html#d122e199586
%for medfilt2 command.

%Kernel boyutu yani goruntuye uygulanacak 2 boyutlu filtrenin boyutu 21x21
%7x7 ve 5x5 olmak uzere ayarlandi. Burada 'symetric' parametresi goruntunun
%sinirlarindaki piksellerin kendi degerleri ile genisletildigini soyler. Bu
%parametre girilmezse sinirlar 0 ekleme islemi yapilarak genisletilir.
%Sinirlarin genisletilmesinin sebebi goruntunun sinirinda veya sinirlarina
%yakin yerlerdeki piksellere filtrenin tamaminin goruntuye sigmamasidir.
%Eger bu piksellere filtreleme yapilirken filtre goruntuye sigmazsa
%filtreleme islemi gerceklesmez.
%Daha detayli bilgi icin https://www.mathworks.com/help/images/ref/medfilt2.html#d122e199586
%medfilt2 komutu icin bakin.

figure,imshow(median_filter_result1)
figure,imshow(median_filter_result2)
figure,imshow(median_filter_result3)
figure,imshow(adpmed_filter_result1)
figure,imshow(adpmed_filter_result2)
%Show filters results.
%Filtrelerin sonuçlari gösteriliyor.

Smax_value_1
Smax_value_2
%Show necessary mask size for adaptive median filtering
%Adaptif medyyan filtreleme islemi icin gerekli maske boyutu gosteriliyor

%Note that blah blah --ekle-- neden grayscale image'a eklendi gurultu.
