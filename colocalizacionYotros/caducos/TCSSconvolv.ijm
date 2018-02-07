macro "TCSS [c]" 
{

/*
TCSS    
Julio Buonfigli    
*/

function TCSS_threshold(vector, unos, name)
{
umbral=255;
do { 
	showStatus("Thresholding "+name+"...");
	umbral--;
	sR=0;
	for(i=0; i<unos; i++) 
		{
		if(r[i]>=umbral)
			sR++;  
		}
	} while(sR<unos*0.48 && umbral>=1)
if(sR>unos*0.52){
do {
   showStatus("Thresholding "+name+"...");
   umbral++;
   sR=0;
   for(i=0; i<unos; i++)
	   {
		if(r[i]>=umbral)
			sR++;  
		}
	} while(sR>unos*0.52)
}
return umbral;
}


function elMenor(ventana)          //sobre ventana!!!!!!              
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		a[i] = getPixel(x,y);
		i++;
		}
	}
t=0;
while(a[t]==0 && t<w*h)
t++;
elmenor=a[t];
for(p=t+1; p<w*h; p++)
	{
	if(a[p]<elmenor && a[p]>0)
		elmenor=a[p];
	}
return elmenor;
}

function sumarPixInt(vector, unos)                     
{
suma=0;
for (y=0; y<unos; y++)
	suma=suma+vector[y];
return suma;
}

function VECTORIZAR(imagenAvectorizar, an, al)                     
{
selectWindow(imagenAvectorizar);
vector=newArray(an*al);
  i = 0;
  for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		{
		vector[i] = getPixel(x,y);
		i++; 
		}
	}
return vector;
}
	
function vectorizar(imagenAvectorizar, an, al, st, mask, unos)    // entran: imagen, w y h, el vector mascara y el umbral de senal                    
{
selectWindow(imagenAvectorizar);
vector=newArray(unos);
  i = 0;
  j=0;
  for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		{
		if(mask[i]==255) {
			vector[j] = getPixel(x,y);
			if(
vector[j]<st)
  				vector[j]=0;
			j++;
			}
		i++;
		}
	}
return vector;
}

function convolucionar(imagen)
{
selectWindow(imagen);
//run("Convolve...", "text1=[0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 0 0 0 0 0\n0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 \n0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0\n0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0\n0 0 3 3 3 3 3 3 3 4 4 4 3 3 3 3 3 3 3 0 0\n0 3 3 3 3 3 3 4 4 4 4 4 4 4 3 3 3 3 3 3 0\n0 3 3 3 3 3 4 4 5 5 5 5 5 4 4 3 3 3 3 3 0\n3 3 3 3 3 4 4 5 5 6 6 6 5 5 4 4 3 3 3 3 3\n3 3 3 3 3 4 5 5 6 7 7 7 6 5 5 4 3 3 3 3 3\n3 3 3 3 4 4 5 6 7 8 8 8 7 6 5 4 4 3 3 3 3\n3 3 3 3 4 4 5 6 7 8 9 8 7 6 5 4 4 3 3 3 3\n3 3 3 3 4 4 5 6 7 8 8 8 7 6 5 4 4 3 3 3 3\n3 3 3 3 3 4 5 5 6 7 7 7 6 5 5 4 3 3 3 3 3\n3 3 3 3 3 4 4 5 5 6 6 6 5 5 4 4 3 3 3 3 3\n0 3 3 3 3 3 4 5 5 5 5 5 5 4 4 3 3 3 3 3 3 \n0 3 3 3 3 3 3 4 4 4 4 4 4 4 3 3 3 3 3 3 0\n0 0 3 3 3 3 3 3 3 4 4 4 3 3 3 3 3 3 3 0 0\n0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0\n0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0\n0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0\n0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 0 0 0 0 0\n] normalize");
run("Convolve...", "text1=[0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 0 0 0 0 0\n0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0 \n0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0\n0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0\n0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0\n0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0\n0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0\n3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0\n0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0\n0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0\n0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0\n0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0\n0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 0 0 0 0 0\n0 0 0 0 0 0 0 3 3 3 3 3 3 3 0 0 0 0 0 0 0\n] normalize");
}
	
function normalizar(imagen, w, h, ai)
{
selectWindow(imagen);
  ip=0; 
  for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
 
		ip = ip+getPixel(x,y);
	}
ip=ip/(w*h);
  for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		e=getPixel(x, y);
		setPixel(x, y, e*ai/ip);
		}
	}
}

function ThresholdValue(imagen, intOR)
{ 
selectWindow(imagen);
run("Duplicate...", "title=rojoA");
selectWindow(imagen);
run("Duplicate...", "title=rojoB");
setAutoThreshold(intOR);
run("Convert to Mask");
run("Invert");
imageCalculator("AND create", "rojoA", "rojoB");                       
rename("rojoAB");
umbral=elMenor("rojoAB");
close();
selectWindow("rojoA"); close();
selectWindow("rojoB"); close();
return umbral;
}


function dobleColo(v1, v2, unos, sum1, sum2, unos1, unos2)
{
dc=newArray(4);
dc[0]=0;
dc[1]=0;
dc[2]=0;
dc[3]=0;
for(i=0; i<unos; i++)                                                                                               
	{
	if(v1[i]*v2[i] != 0)
		{
		dc[0]=dc[0]+v1[i];
		dc[1]=dc[1]+v2[i];
		dc[2]++;
		dc[3]++;
		}
	}
dc[0]=dc[0]/sum1;
dc[1]=dc[1]/sum2;
dc[2]=100*dc[2]/unos1;
dc[3]=100*dc[3]/unos2;
return dc;
}

function tripleColo(v1, v2, v3, unos, sum1, sum2, sum3, unos1, unos2, unos3)
{
dc=newArray(7);
dc[0]=0; dc[1]=0; dc[2]=0; dc[3]=0; dc[4]=0; dc[5]=0; dc[6]=0;
for(i=0; i<unos; i++)                                                                                               
	{
	if(v1[i]*v2[i]*v3[i] != 0)
		{
		dc[0]=dc[0]+v1[i];
		dc[1]=dc[1]+v2[i];
		dc[2]=dc[2]+v3[i];
		dc[6]++;
		}
	}
dc[0]=dc[0]/sum1;
dc[1]=dc[1]/sum2;
dc[2]=dc[2]/sum3;
dc[3]=dc[6]/unos1;
dc[4]=dc[6]/unos2;
dc[5]=dc[6]/unos3;
dc[6]=dc[6]/unos;

return dc;
}

function randomizar(vector, unos)
{
u=newArray(unos+1);                                                               
for(i=0; i<unos; i++)
	u[i]=true;
rd=newArray(unos);
i=0;	
while(i<unos)
	{
	e=round(random*unos);
	if(u[e]==true)
		{
		rd[i]=r[e];
		u[e]=false;
		i++;
		}
	}
return rd;
}	

function significancia(colo, der, iz)
{
if(colo<iz)
	sig="SE";
	else
	{
	if(colo>der)
		sig="SC";
		else
		sig="NS";
	}
return sig;
}


id1=getImageID();          
tamano=0;

figura=newArray(nImages);
for(i=id1-1000; i<id1+1000; i++)
	{
	showStatus("Loading images...");
	if(isOpen(i) && tamano<nImages)
		{
		selectImage(i);
		figura[tamano]=getTitle();
		tamano++;
		}		
	}
  
  figura2=newArray(nImages+1);
  figura2[0]="none";
  for(i=1; i<nImages+1; i++)
		figura2[i]=figura[i-1];
  
  
  Dialog.create("TCSS");                                                       
  Dialog.addChoice("Red:", figura);         
  Dialog.addChoice("Green:", figura);          
  Dialog.addChoice("Blue:", figura2);    
  Dialog.addMessage("MASK OPTIONS"); 
  Dialog.addChoice("Primary mask (binary 8-bit):", figura2); 
  Dialog.addChoice("Mask threshold", newArray("No_threshold", "User_threshold", "Default", "Huang", "Intermodes", "IsoData", "IJ_IsoData", "Li", "MaxEntropy", "Mean", "MinError", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen"));  
  Dialog.addChoice("Channel's mask operator", newArray("AND", "OR"));
  Dialog.addMessage("SIGNAL OPTIONS"); 
  Dialog.addChoice("Signal threshold", newArray("TCSS_threshold", "No_threshold", "User_threshold", "Default", "Huang", "Intermodes", "IsoData", "IJ_IsoData", "Li", "MaxEntropy", "Mean", "MinError", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen"));
  Dialog.addCheckbox("Average intensities", true);
  Dialog.addNumber("Intensity: ", 25);
  Dialog.addCheckbox("Convolve", true);
  Dialog.addMessage("STATISTICAL SIGNIFICANCE"); 
  Dialog.addCheckbox("Resize image according PSF", false);
  Dialog.addCheckbox("Calculate Statistical significance", true); 
  Dialog.addNumber("Number of generated images", 30); 
  Dialog.addChoice("Significance level", newArray(0.01, 0.05)); 
  Dialog.addCheckbox("Show examples of random images", false);
  Dialog.addCheckbox("Randomize three channels", false);
  Dialog.addNumber("Random seed (positive integer): ", 1); 

       Dialog.show();
   	rojo=Dialog.getChoice();
   	verde=Dialog.getChoice();
   	azul=Dialog.getChoice();
   	mascara=Dialog.getChoice();
   	intOR=Dialog.getChoice();
	operacion=Dialog.getChoice();
	signalThreshold=Dialog.getChoice();
	AI=Dialog.getCheckbox();
	ai=Dialog.getNumber();
	DS=Dialog.getCheckbox();
	RS=Dialog.getCheckbox();
	generadas=Dialog.getCheckbox();
	numGeneradas=Dialog.getNumber();
	nivel=Dialog.getChoice();
	imagenAleatoria=Dialog.getCheckbox();
	bCriterion=Dialog.getCheckbox();
	semilla=Dialog.getNumber();


if(numGeneradas>1000 || numGeneradas<1)
	exit("The number of generated images must be between 1 and 100");   

random("seed", semilla);

setBatchMode(true);

rviP=rviS=rvmP=rvmS=" ******";
vriP=vriS=vrmP=vrmS=" ******";
raiP=raiS=ramP=ramS=" ******";
ariP=ariS=armP=armS=" ******";
vaiP=vaiS=vamP=vamS=" ******";
aviP=aviS=avmP=avmS=" ******";
tiP=tiS=" ******";
tirP=tirS=tmrP=tmrS=" ******";
tivP=tivS=tmvP=tmvS=" ******";
tiaP=tiaS=tmaP=tmaS=" ******";

selectWindow(rojo); run("Select None"); 
run("Duplicate...", "title=Red");   
w = getWidth;               
h = getHeight;
selectWindow(verde); run("Select None");
run("Duplicate...", "title=Green");   
if(azul!="none"){selectWindow(azul); run("Select None");
run("Duplicate...", "title=Blue");   }

if(mascara!="none") {
selectWindow(mascara); run("Select None");
run("Duplicate...", "title=MASK");   }
else {newImage("MASK", "8-bit black", w, h, 1);  run("Invert");}

if(nivel==0.05)                                        
	zCola=-1.64486;
	else
	zCola=-2.32635;

if(RS==true)  //escalado
{
Dialog.create("Resizing parameters");      
                   
  Dialog.addNumber("Red channel emitting wavelength (nm)", 650); 
  Dialog.addNumber("Green channel emitting wavelength (nm)", 530); 
  if(azul!="none") {Dialog.addNumber("Blue channel emitting wavelength (nm)", 460);} 
  Dialog.addNumber("Objective numerical aperture", 1.42); 
  Dialog.addNumber("Image height (microns)", 200); 
  Dialog.addNumber("Image width (microns)", 200);
  Dialog.addCheckbox("Confocal", false);
   Dialog.show();
    rew=Dialog.getNumber(); 
    gew=Dialog.getNumber(); 
    if(azul!="none") {bew=Dialog.getNumber(); tete=1;} else { bew=0; tete=0;} 
    ona=Dialog.getNumber(); 
    ih=Dialog.getNumber(); 
    iw=Dialog.getNumber(); 
    confocal=Dialog.getCheckbox();

if(confocal==true){
nih=round(ih/((0.37*((rew+gew+bew)/(2+tete)))/(ona*1000)));
niw=round(iw/((0.37*((rew+gew+bew)/(2+tete)))/(ona*1000))); } else {
nih=round(ih/((0.61*((rew+gew+bew)/(2+tete)))/(ona*1000)));
niw=round(iw/((0.61*((rew+gew+bew)/(2+tete)))/(ona*1000))); } 

if(nih<h){
selectWindow("Red");
run("Size...", "width=niw height=nih interpolation=None");
selectWindow("Green");
run("Size...", "width=niw height=nih interpolation=None");
if(azul!="none") {selectWindow("Blue");
run("Size...", "width=niw height=nih interpolation=None");}
selectWindow("MASK");
run("Size...", "width=niw height=nih interpolation=None");
}

w = getWidth;               
h = getHeight;
}

R=newArray(w*h); R=VECTORIZAR(rojo, w, h);
V=newArray(w*h); V=VECTORIZAR(verde, w, h);
if(azul!="none") {A=newArray(w*h); A=VECTORIZAR(azul, w, h);}

if(AI==true)
{
normalizar("Red", w, h, ai);  
normalizar("Green", w, h, ai); 
if(azul!="none") { normalizar("Blue", w, h, ai); }
}

if(DS==true)
{
convolucionar("Red"); convolucionar("Green"); 
normalizar("Red", w, h, ai); normalizar("Green", w, h, ai); 
if(azul!="none") { convolucionar("Blue"); normalizar("Blue", w, h, ai); }
}
	
if(intOR=="User_threshold" || signalThreshold=="User_threshold")  //toma informacion de ventanas de dialogo de umbrales para generar la mascara
{
Dialog.create("Threshold");      
if(intOR=="User_threshold"){
 Dialog.addMessage("Mask Threshold");                               
 Dialog.addNumber("Red:", 1); 
  Dialog.addNumber("Green:", 1); 
  Dialog.addNumber("Blue:", 1); 
 	 }
if(signalThreshold=="User_threshold"){
                                                                                                                                 
 Dialog.addMessage("Signal Threshold");                               
 Dialog.addNumber("Red:", 20); 
  Dialog.addNumber("Green:", 20); 
  Dialog.addNumber("Blue:", 20); 
}

Dialog.show();
if(intOR=="User_threshold"){
	MMUR=Dialog.getNumber();
	MMUV=Dialog.getNumber();
	MMUA=Dialog.getNumber();}
if(signalThreshold=="User_threshold"){	
	MUR=Dialog.getNumber();
	MUV=Dialog.getNumber();
	MUA=Dialog.getNumber();}
}

if(intOR=="No_threshold") {MMUR=0; MMUA=0; MMUV=0; }

if(intOR!="No_threshold" && intOR!="User_threshold")  //genera imagenes para adquirir info para generar la mascara 
{ 
MMUR=ThresholdValue("Red", intOR);
MMUV=ThresholdValue("Green", intOR);
if(azul!="none"){MMUA=ThresholdValue("Blue", intOR);}  
}

if(intOR!="No_threshold")    //genera la mascara                          
	{
	selectWindow("Red");  run("Duplicate...", "title=rojoB");          
	setThreshold(MMUR, 255);
	run("Convert to Mask");
	selectWindow("Green");  run("Duplicate...", "title=verdeB"); 
	setThreshold(MMUV, 255);
	run("Convert to Mask");
	if(azul!="none") {selectWindow("Blue");  run("Duplicate...", "title=azulB");    
	setThreshold(MMUA, 255);
	run("Convert to Mask"); }
	if(operacion=="OR")
		{
		imageCalculator("OR", "rojoB", "verdeB"); 
	    rename("mascaraF"); selectWindow("verdeB"); close();
        if(azul!="none") {imageCalculator("OR", "mascaraF", "azulB");  selectWindow("azulB"); close(); }
		}
		else
		{
		imageCalculator("AND", "rojoB", "verdeB"); 
	    rename("mascaraF");
  selectWindow("verdeB"); close();
        if(azul!="none") {imageCalculator("AND", "mascaraF", "azulB"); selectWindow("azulB"); close(); }
		}
	selectWindow("mascaraF");
	setThreshold(1, 255);
	run("Convert to Mask");
	imageCalculator("AND", "MASK", "mascaraF");
	selectWindow("mascaraF"); close(); 
	}
                      
unosMascara=0;
         //vecotorizacion de la mascara
cerosMascara=0;
selectWindow("MASK");
mask=newArray(w*h);
  i = 0;
  for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		mask[i] = getPixel(x,y);
		if(mask[i]==0)
			cerosMascara++;
			else
			unosMascara++;
		i++;
		}
	}


if(signalThreshold=="No_threshold") {MUR=1; MUA=1; MUV=1; }

if(signalThreshold!="User_threshold" && signalThreshold!="TCSS_threshold" && signalThreshold!="No_threshold") //genera imagenes para adquirir info para encontrar el umbral
{
MUR=ThresholdValue("Red", signalThreshold);
MUV=ThresholdValue("Green", signalThreshold);
if(azul!="none"){MUA=ThresholdValue("Blue", signalThreshold); } 
}

r=newArray(unosMascara); r=vectorizar("Red", w, h, 0, mask, unosMascara);
v=newArray(unosMascara); v=vectorizar("Green", w, h, 0, mask, unosMascara);
if(azul!="none") { a=newArray(unosMascara); a=vectorizar("Blue", w, h, 0, mask, unosMascara); }

if(signalThreshold=="TCSS_threshold")
{
MUR=TCSS_threshold(r, unosMascara, "Red");
MUV=TCSS_threshold(v, unosMascara, "Green");
if(azul!="none") {MUA=TCSS_threshold(a, unosMascara, "Blue");}
}

//PEARSON

pr=sumarPixInt(r, unosMascara)/unosMascara;                                     
pv=sumarPixInt(v, unosMascara)/unosMascara;
if(azul!="none") {pa=sumarPixInt(a, unosMascara)/unosMascara;}

numVA=numRA=nunRV=denR=denV=denA=0;

for(i=0; i<unosMascara; i++)                                                                                                
	{
	denR=denR+(r[i]-pr)*(r[i]-pr);                                                                                                           
	denV=denV+(v[i]-pv)*(v[i]-pv);
	if(azul!="none") {denA=denA+(a[i]-pa)*(a[i]-pa);}
	if(azul!="none") {numVA=numVA+(v[i]-pv)*(a[i]-pa);}
	if(azul!="none") {numRA=numRA+(r[i]-pr)*(a[i]-pa);}
	numRV=numRV+(r[i]-pr)*(v[i]-pv);
	}

PrRV=numRV/sqrt(denR*denV);                                       
if(azul!="none") {PrRA=numRA/sqrt(denR*denA);}
if(azul!="none") {PrVA=numVA/sqrt(denA*denV);}


//MANDERS && INTERSECCION

r=newArray(unosMascara); r=vectorizar("Red", w, h, MUR, mask, unosMascara);
v=newArray(unosMascara); v=vectorizar("Green", w, h, MUV, mask, unosMascara);
if(azul!="none") { a=newArray(unosMascara); a=vectorizar("Blue", w, h, MUA, mask, unosMascara); }

sumRojo=sumVerde=unosRojo=unosVerde=sumAzul=unosAzul=0;
for(i=0; i<unosMascara; i++){
	if(r[i]>0)
{
		unosRojo++;
 sumRojo=sumRojo+r[i]; }
	if(v[i]>0)
 {
		unosVerde++; 
sumVerde=sumVerde+v[i]; }
	if(azul!="none") {
		if(a[i]>0)
 {
			unosAzul++; 
sumAzul=sumAzul+a[i]; }
 }
	}

rv=dobleColo(r, v, unosMascara, sumRojo, sumVerde, unosRojo, unosVerde);
if(azul!="none") {ra=dobleColo(r, a, unosMascara, sumRojo, sumAzul, unosRojo, unosAzul);
av=dobleColo(a, v, unosMascara, sumAzul, sumVerde, unosAzul, unosVerde);
rva=tripleColo(r, v, a, unosMascara, sumRojo, sumVerde, sumAzul, unosRojo, unosVerde, unosAzul);}
 
// SIGNIFICANCE

if(generadas==true)
{
rvm=newArray(numGeneradas);  
vrm=newArray(numGeneradas);  
rvi=newArray(numGeneradas);  
vri=newArray(numGeneradas);  
if(azul!="none") {
ram=newArray(numGeneradas);  
arm=newArray(numGeneradas);  
rai=newArray(numGeneradas);  
ari=newArray(numGeneradas);  
avm=newArray(numGeneradas);  
vam=newArray(numGeneradas);  
avi=newArray(numGeneradas);  
vai=newArray(numGeneradas);  
tmr=newArray(numGeneradas);  
tmv=newArray(numGeneradas);  
tma=newArray(numGeneradas);  
tir=newArray(numGeneradas);  
tiv=newArray(numGeneradas);  
tia=newArray(numGeneradas);  
ti=newArray(numGeneradas);  
rvvr=rv[0]+rv[1];                                                        
arra=ra[0]+ra[1];
vaav=av[0]+av[1];}

rs=newArray(unosMascara);  vs=newArray(unosMascara);  as=newArray(unosMascara); 

for(s=0; s<numGeneradas; s++)                                       
{
showStatus("Statistical significance: "+s); 
rs=randomizar(r, unosMascara);
if(azul!="none")
{
if(bCriterion==false)
{
if(rvvr==vaav && rvvr==arra)
	{ 	vs=v; 	as=randomizar(a, unosMascara); 	}
    else
	{
	if(rvvr>=vaav && rvvr>=arra)                               
		{vs=v; 	as=randomizar(a, unosMascara); 	}
	if(vaav>=rvvr && vaav>=arra)
		{ vs=v; as=randomizar(a, unosMascara); 	}
	if(arra>=vaav &&  arra>=rvvr)
		{ vs=randomizar(v, unosMascara); as=a; 	}
	}
}
else
{
rs=randomizar(r, unosMascara);
vs=randomizar(v, unosMascara);
as=randomizar(a, unosMascara); 
}}

if(azul=="none") vs=v;
doblesRV=newArray(4); doblesRA=newArray(4); doblesAV=newArray(4); triples=newArray(7);
doblesRV=dobleColo(rs, vs, unosMascara, sumRojo, sumVerde, unosRojo, unosVerde);
if(azul!="none") {doblesRA=dobleColo(rs, as, unosMascara, sumRojo, sumAzul, unosRojo, unosAzul);
doblesAV=dobleColo(as, vs, unosMascara, sumAzul, sumVerde, unosAzul, unosVerde);
triples=tripleColo(rs, vs, as, unosMascara, sumRojo, sumVerde, sumAzul, unosRojo, unosVerde, unosAzul);}

rvm[s]=doblesRV[0];  
vrm[s]=doblesRV[1]; 
rvi[s]=doblesRV[2]; 
vri[s]=doblesRV[3];  
if(azul!="none") {
ram[s]=doblesRA[0];
arm[s]=doblesRA[1]; 
rai[s]=doblesRA[2]; 
ari[s]=doblesRA[3];
avm[s]=doblesAV[0];
vam[s]=doblesAV[1];
avi[s]=doblesAV[2]; 
vai[s]=doblesAV[3];
tmr[s]=triples[0];  
tmv[s]=triples[1]; 
tma[s]=triples[2];   
tir[s]=triples[3];  
tiv[s]=triples[4]; 
tia[s]=triples[5];   
ti[s]=triples[6];  }
}

rvmP=vrmP=rviP=vriP=0; if(azul!="none") {ramP=armP=raiP=ariP=avmP=vamP=aviP=vaiP=tmrP=tmvP=tmaP=tirP=tivP=tiaP=tiP=0;} 

for(s=0; s<numGeneradas; s++)         
{	
rvmP=rvmP+rvm[s];  
vrmP=vrmP+vrm[s];
rviP=rviP+rvi[s];
vriP=vriP+vri[s];  
if(azul!="none") {
ramP=ramP+ram[s];
armP=armP+arm[s];
raiP=raiP+rai[s];
ariP=ariP+ari[s];
avmP=avmP+avm[s];
vamP=vamP+vam[s];
aviP=aviP+avi[s];
vaiP=vaiP+vai[s];
tmrP=tmrP+tmr[s];
tmvP=tmvP+tmv[s];
tmaP=tmaP+tma[s];
tirP=tirP+tir[s];
tivP=tivP+tiv[s];
tiaP=tiaP+tia[s];
tiP=tiP+ti[s];}
}  

rvmP=rvmP/numGeneradas;  
vrmP=vrmP/numGeneradas;  
rviP=rviP/numGeneradas;  
vriP=vriP/numGeneradas;  
ramP=ramP/numGeneradas;  
armP=armP/numGeneradas;  
raiP=raiP/numGeneradas;  
ariP=ariP/numGeneradas;  
avmP=avmP/numGeneradas;  
vamP=vamP/numGeneradas;  
aviP=aviP/numGeneradas;  
vaiP=vaiP/numGeneradas;  
tmrP=tmrP/numGeneradas;  
tmvP=tmvP/numGeneradas;  
tmaP=tmaP/numGeneradas;  
tirP=tirP/numGeneradas;  
tivP=tivP/numGeneradas;  
tiaP=tiaP/numGeneradas;  
tiP=tiP/numGeneradas;  

rvmD=vrmD=rviD=vriD=ramD=armD=raiD=ariD=avmD=vamD=aviD=vaiD=tmrD=tmvD=tmaD=tirD=tivD=tiaD=tiD=0; 
 
for(s=0; s<numGeneradas; s++)         
{	
rvmD=rvmD+(rvm[s]-rvmP)*(rvm[s]-rvmP);  
vrmD=vrmD+(vrm[s]-vrmP)*(vrm[s]-vrmP);
rviD=rviD+(rvi[s]-rviP)*(rvi[s]-rviP);
vriD=vriD+(vri[s]-vriP)*(vri[s]-vriP);  
if(azul!="none") {
ramD=ramD+(ram[s]-ramP)*(ram[s]-ramP);
armD=armD+(arm[s]-armP)*(arm[s]-armP);
raiD=raiD+(rai[s]-raiP)*(rai[s]-raiP);
ariD=ariD+(ari[s]-ariP)*(ari[s]-ariP);
avmD=avmD+(avm[s]-avmP)*(avm[s]-avmP);
vamD=vamD+(vam[s]-vamP)*(vam[s]-vamP);
aviD=aviD+(avi[s]-aviP)*(avi[s]-aviP);
vaiD=vaiD+(vai[s]-vaiP)*(vai[s]-vaiP);
tmrD=tmrD+(tmr[s]-tmrP)*(tmr[s]-tmrP);
tmvD=tmvD+(tmv[s]-tmvP)*(tmv[s]-tmvP);
tmaD=tmaD+(tma[s]-tmaP)*(tma[s]-tmaP);
tirD=tirD+(tir[s]-tirP)*(tir[s]-tirP);
tivD=tivD+(tiv[s]-tivP)*(tiv[s]-tivP);
tiaD=tiaD+(tia[s]-tiaP)*(tia[s]-tiaP);
tiD=tiD+(ti[s]-tiP)*(ti[s]-tiP);}
}  
numGeneradas=numGeneradas-1; 

rvmD=sqrt(rvmD/numGeneradas);
vrmD=sqrt(vrmD/numGeneradas);
rviD=sqrt(rviD/numGeneradas);
vriD=sqrt(vriD/numGeneradas);
if(azul!="none") {
ramD=sqrt(ramD/numGeneradas);
armD=sqrt(armD/numGeneradas);
raiD=sqrt(raiD/numGeneradas);
ariD=sqrt(ariD/numGeneradas);
avmD=sqrt(avmD/numGeneradas);
vamD=sqrt(vamD/numGeneradas);
aviD=sqrt(aviD/numGeneradas);
vaiD=sqrt(vaiD/numGeneradas);
tmrD=sqrt(tmrD/numGeneradas);
tmvD=sqrt(tmvD/numGeneradas);
tmaD=sqrt(tmaD/numGeneradas);
tirD=sqrt(tirD/numGeneradas);
tivD=sqrt(tivD/numGeneradas);
tiaD=sqrt(tiaD/numGeneradas);
tiD=sqrt(tiD/numGeneradas);}

numGeneradas=numGeneradas+1; 

rvmL=zCola*rvmD+rvmP;  
vrmL=zCola*vrmD+vrmP;
rviL=zCola*rviD+rviP;
vriL=zCola*vriD+vriP;  
if(azul!="none") {
ramL=zCola*ramD+ramP;
armL=zCola*armD+armP;
raiL=zCola*raiD+raiP;
ariL=zCola*ariD+ariP;
avmL=zCola*avmD+avmP;
vamL=zCola*vamD+vamP;
aviL=zCola*aviD+aviP;
vaiL=zCola*vaiD+vaiP;
tmrL=zCola*tmrD+tmrP;
tmvL=zCola*tmvD+tmvP;
tmaL=zCola*tmaD+tmaP;
tirL=zCola*tirD+tirP;
tivL=zCola*tivD+tivP;
tiaL=zCola*tiaD+tiaP;
tiL=zCola*tiD+tiP;}

rvmR=abs(zCola)*rvmD+rvmP;  
vrmR=abs(zCola)*vrmD+vrmP;
rviR=abs(zCola)*rviD+rviP;
vriR=abs(zCola)*vriD+vriP;  
if(azul!="none") {
ramR=abs(zCola)*ramD+ramP;
armR=abs(zCola)*armD+armP;
raiR=abs(zCola)*raiD+raiP;
ariR=abs(zCola)*ariD+ariP;
avmR=abs(zCola)*avmD+avmP;
vamR=abs(zCola)*vamD+vamP;
aviR=abs(zCola)*aviD+aviP;
vaiR=abs(zCola)*vaiD+vaiP;
tmrR=abs(zCola)*tmrD+tmrP;
tmvR=abs(zCola)*tmvD+tmvP;
tmaR=abs(zCola)*tmaD+tmaP;
tirR=abs(zCola)*tirD+tirP;
tivR=abs(zCola)*tivD+tivP;
tiaR=abs(zCola)*tiaD+tiaP;
tiR=abs(zCola)*tiD+tiP;}

rvmS=significancia(rv[0], rvmR, rvmL);  
vrmS=significancia(rv[1], vrmR, vrmL);
rviS=significancia(rv[2], rviR, rviL);
vriS=significancia(rv[3], vriR, vriL);  
if(azul!="none") {
ramS=significancia(ra[0], ramR, ramL);
armS=significancia(ra[1], armR, armL);
raiS=significancia(ra[2], raiR, raiL);
ariS=significancia(ra[3], ariR, ariL);
avmS=significancia(av[0], avmR, avmL);
vamS=significancia(av[1], vamR, vamL);
aviS=significancia(av[2], aviR, aviL);
vaiS=significancia(av[3], vaiR, vaiL);
tmrS=significancia(rva[0], tmrR, tmrL);
tmvS=significancia(rva[1], tmvR, tmvL);
tmaS=significancia(rva[2], tmaR, tmaL);
tirS=significancia(rva[3], tirR, tirL);
tivS=significancia(rva[4], tivR, tivL);
tiaS=significancia(rva[5], tiaR, tiaL);
tiS=significancia(rva[6], tiR, tiL);}
}

//RESULTS
if(intOR==false) { MMUR="  ******"; MMUV="  ******"; MMUA="  ******"; }
if(generadas==false) {numGeneradas=" ******"; nivel=" ******"; semilla=" ******";}
if(bCriterion==true) Criterion="false"; else Criterion="true";
if(RS==true) rs="true"; else rs="false";
//if(AI==true) AI="true"; else {AI="false"; ai=" ******";}
if(DS==true) DS="true"; else {DS="false"; Dai=" ******";}
if(azul=="none") {Criterion=" ******";}

titulo1 = "Results";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if (isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
//print(f, "\\Headings:for\t% intersection\t% random\t  Significance \tPearson\tManders\trandom\t  Significance\t ----\t ----\t ----");
print(f, "\\Headings:for\t% intersection\t% random\t  Significance \tPearson\tManders\trandom\t  Significance\t ----\t ----");
print(f, "Double colocalization");
print(f, " Red in green"+"\t  "+rv[2]+"\t  "+rviP+"\t  "+rviS+"\t  "+PrRV+"\t  "+rv[0]+"\t  "+rvmP+"\t  "+rvmS);
print(f, " Green in red"+"\t  "+rv[3]+"\t  "+vriP+"\t  "+vriS+"\t  "+PrRV+"\t  "+rv[1]+"\t  "+vrmP+"\t  "+vrmS);
if(azul!="none") {
print(f, " Red in blue"+"\t  "+ra[2]+"\t  "+raiP+"\t  "+raiS+"\t  "+PrRA+"\t  "+ra[0]+"\t  "+ramP+"\t  "+ramS);
print(f, " Blue in red"+"\t  "+ra[3]+"\t  "+ariP+"\t  "+ariS+"\t  "+PrRA+"\t  "+ra[1]+"\t  "+armP+"\t  "+armS);
print(f, " Green in blue"+"\t  "+av[2]+"\t  "+vaiP+"\t  "+vaiS+"\t  "+PrVA+"\t  "+av[0]+"\t  "+vamP+"\t  "+vamS);
print(f, " Blue in green"+"\t  "+av[3]+"\t  "+aviP+"\t  "+aviS+"\t  "+PrVA+"\t  "+av[1]+"\t  "+avmP+"\t  "+avmS);
print(f, "Triple colocalization");
print(f, " General"+"\t  "+rva[6]+"\t  "+tiP+"\t  "+tiS+"\t  ******"+"\t  ******"+ " \t   ******"+ " \t   ******"+ " \t   ******");
print(f, " By red"+"\t  "+rva[3]+"\t  "+tirP+"\t  "+tirS+"\t  ******"+"\t  "+rva[0]+"\t  "+tmrP+"\t  "+tmrS);
print(f, " By green"+"\t  "+rva[4]+"\t  "+tivP+"\t  "+tivS+"\t  ******"+"\t  "+rva[1]+"\t  "+tmvP+"\t  "+tmvS);
print(f, " By blue"+"\t  "+rva[5]+"\t  "+tiaP+"\t  "+tiaS+"\t  ******"+"\t  "+rva[2]+"\t  "+tmaP+"\t  "+tmaS); }
print(f, "");
print(f, "");
//print(f, "\t "+"Mask threshold"+"\t "+"Signal threshold"+"\t "+"Random images"+"\t "+"Sig. level"+"\t "+"Mask's operator"+"\t "+"Resize"+"\t "+"TCSS_rand"+"\t "+"Normalization"+"\t "+"Dispertion"+"\t "+"Seed");
print(f, "\t "+"Mask threshold"+"\t "+"Signal threshold"+"\t "+"Random images"+"\t "+"Sig. level"+"\t "+"Mask's operator"+"\t "+"Resize"+"\t "+"TCSS_rand"+"\t "+"Dispertion"+"\t "+"Seed");
print(f, "");
//print(f, "Algorithm"+"\t      "+intOR+"\t "+signalThreshold+"\t "+numGeneradas+"\t "+nivel+"\t "+operacion+"\t "+rs+"\t "+Criterion+"\t "+AI+" "+ai+"\t "+DS+" "+Dai+"\t "+semilla);
print(f, "Algorithm"+"\t      "+intOR+"\t "+signalThreshold+"\t "+numGeneradas+"\t "+nivel+"\t "+operacion+"\t "+rs+"\t "+Criterion+"\t "+DS+"\t "+semilla);
print(f, "Red channel"+"\t      "+MMUR+"\t "+MUR);
print(f, "Green channel"+"\t      "+MMUV+"\t "+MUV);
if(azul!="none") {
print(f, "Blue channel"+"\t      "+MMUA+"\t "+MUA); }
print(f, "");

selectWindow("Red");
run("Duplicate...", "title=rojoB");           
setThreshold(MUR, 255);
run("Convert to Mask");
imageCalculator("AND create", "rojoB", "MASK");   
rename("rojoAndMascara");
selectWindow("Green");  
run("Duplicate...", "title=verdeB");           
setThreshold(MUV, 255);
run("Convert to Mask");
imageCalculator("AND create", "verdeB", "MASK");  
rename("verdeAndMascara");
if(azul!="none") {selectWindow("Blue");  run("Duplicate...", "title=azulB");   
setThreshold(MUA, 255);
run("Convert to Mask");
imageCalculator("AND create", "azulB", "MASK");                       
rename("azulAndMascara");}

if(azul!="none")
	run("Merge Channels...", "c1=[rojoAndMascara] c2=[verdeAndMascara] c3=[azulAndMascara] create");    
	else
	run("Merge Channels...", "c1=[rojoAndMascara] c2=[verdeAndMascara] create");

selectWindow("Composite");
rename("Colocalization");
updateDisplay();

if(imagenAleatoria==true && generadas==true)
{      
rs=newArray(unosMascara); rs=randomizar(r, unosMascara);
selectWindow("MASK");
run("Duplicate...", "title=RandomManders");        
i=0;
mas=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		if(mask[mas]==255)
			{
			setPixel(x, y, rs[i]);
			i++;
			}
		mas++;
		}
	}                                      
run("Green");
updateDisplay();
}
if(mascara=="none" && intOR=="No_Threshold") {selectWindow("MASK"); close();}
//if(isOpen("Red")) {selectWindow("Red"); close();}
//if(isOpen("Green")) {selectWindow("Green"); close();}
//if(isOpen("Blue")) {selectWindow("Blue"); close();}
if(isOpen("rojoB")) {selectWindow("rojoB"); close();}
if(isOpen("verdeB")) {selectWindow("verdeB"); close();}
if(isOpen("azulB")) {selectWindow("azulB"); close();}
//
if(isOpen("mascaraF")) {selectWindow("mascaraF"); close();}
setBatchMode("exit and display"); 
}
// fin
