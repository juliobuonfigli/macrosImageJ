macro "TCSS [c]" 
{

/*
TCSS    
Julio Buonfigli    
*/

function rendirize(vec, img)
{
selectWindow(img);
w=getWidth; h=getHeight; 
mayor=0;
for(i=0; i<w*h; i++) {
	if(vec[i]>mayor)
		mayor=vec[i]; }
div=mayor/255; 
i=0;
for(y=0; y<h; y++)
	{
	for(x=0; x<w; x++) {
		setPixel(x, y, vec[i]/div); i++; }
	}
return div;
}

function TCSS_threshold(vector, unos, rango)
{
if(rango==8) {
umbral=255; resta=1; suma=1;}
else {
umbral=65025; resta=255; suma=20;}
do { 
	showStatus("Thresholding...");
	umbral=umbral-resta;
	sR=0;
	for(i=0; i<unos; i++) 
		{
		if(r[i]>=umbral)
			sR++;  
		}
	} while(sR<unos*0.49 && umbral>=1)
if(sR>unos*0.51){
do {
   showStatus("Thresholding...");
   umbral=umbral+suma;
   sR=0;
   for(i=0; i<unos; i++)
	   {
		if(r[i]>=umbral)
			sR++;  
		}
	} while(sR>unos*0.51)
}
return umbral;
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

function umbralizar(vec, um, unos) {
	ar=newArray(unos);
	for(i=0; i<unos; i++) {
		if(vec[i]>um)
			ar[i]=vec[i];
			else
			ar[i]=0;
	}
return ar;	
}
	
function recortar(vec, mas, an, al, unos)    // entran: imagen, w y h, el vector mascara y el umbral de senal                    
{
  j=0;
  ar=newArray(unos);
  for(i=0; i<an*al; i++)
	{
	if(mas[i]==255) {
		ar[j]=vec[i];
		j++;	
		}
	}
return ar;
}

function convo(array, an, al, fu, r, f) 
{
if(fu=="Lineal") {e=1;}
if(fu=="Cuadratica") {e=2;}
if(fu=="Cubica") {e=3;}
if(fu=="Geometrica") {e=4;}
if(fu=="Aritmetica") {e=5;}

function PSF(r, e, f)
	{
 	w=2*r-1;
 	h=2*r-1;
 	vec=newArray(w*h);
 	function func(r, d, e, f) 
 		{
 		if(e==1)
 			v=255/(d+1);
 		if(e==2)
 			v=255/(d*d+1);
 		if(e==3)
 			v=255/(d*d*d+1);
 		if(e==4)
 			v=255/pow(2, d);
 		if(e==5)
 			v=255-255*f*(d+1)/r;
 		return v;
 		}
    
 cx= floor(w/2);
 cy= floor(h/2);
 v=0;
 cont=0;
 for (y = 0; y < h; y++) {
    for (x = 0; x < w; x++) {
       d = sqrt(pow(cx - x, 2) + pow(cy - y, 2));
		if (d >= r) 
        	v=0;
    	else 
        	v=func(r, d, e, f);       
       	vec[cont]=v;
       	cont++;
    }
}
return vec;
}
          
alP=2*r-1;
anP=2*r-1;
AN=an+anP;
AL=al+alP;

H=newArray(anP*alP);
G=newArray(an*al);
R=newArray(AN*AL);

i=0; j=0;
for(y=0; y<AL; y++) {
	for(x=0; x<AN; x++) {
		if(x<anP/2 || x>an+anP/2 || y<alP/2 || y>al+alP/2) {
			R[i]=0; i++; }
			else {
			R[i]=array[j]; i++; j++; } 
		}
	}

H=PSF(r, e, f);

N=0;
M=0;
j=0;
for(k=0; k<al*an; k++)
	{
	showStatus("Dispersing...");
	suma=0;
	i=0;
	for(n=N; n<N+alP; n++)
		{
		for(m=M; m<M+anP; m++)
			{
			pos=AN*n+m;
			suma=suma+H[i]*R[pos];
			i++;
			}
		}
	M++;
	if(M>an-1)
		{M=0; N++;}
	G[j]=suma;
	j++;
	}
return G;
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
dc[3]=100*dc[6]/unos1;
dc[4]=100*dc[6]/unos2;
dc[5]=100*dc[6]/unos3;
dc[6]=100*dc[6]/unos;

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
  Dialog.addCheckbox("Disperse signal", true);
  Dialog.addChoice("Dispersing function: ", newArray("Lineal", "Cuadratica", "Cubica", "Aritmetica", "Geometrica"));
  Dialog.addNumber("Radius: ", 25);
  Dialog.addMessage("STATISTICAL SIGNIFICANCE"); 
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
	DS=Dialog.getCheckbox();
	fu=Dialog.getChoice();
	ra=Dialog.getNumber();
	generadas=Dialog.getCheckbox();
	numGeneradas=Dialog.getNumber();
	nivel=Dialog.getChoice();
	imagenAleatoria=Dialog.getCheckbox();
	bCriterion=Dialog.getCheckbox();
	semilla=Dialog.getNumber();

if(numGeneradas>100 || numGeneradas<1)
	exit("The number of generated images must be between 1 and 100");   

if(nivel==0.05)                                        
	zCola=-1.64486;
	else
	zCola=-2.32635; 

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
run("Duplicate...", "title=Red"); run("8-bit"); 
w = getWidth;               
h = getHeight;
selectWindow(verde); run("Select None");
run("Duplicate...", "title=Green");  run("8-bit"); 
if(azul!="none"){selectWindow(azul); run("Select None");
run("Duplicate...", "title=Blue");   run("8-bit"); }

R=newArray(w*h); R=VECTORIZAR(rojo, w, h);
V=newArray(w*h); V=VECTORIZAR(verde, w, h);
A=newArray(w*h);
if(azul!="none")  A=VECTORIZAR(azul, w, h);

M=newArray(w*h); m=newArray(w*h);
if(mascara!="none") {
selectWindow(mascara); run("Select None");
run("Duplicate...", "title=Mask");  M=VECTORIZAR("Mask", w, h); }
else { newImage("Mask", "8-bit black", w, h, 1);  run("Invert"); M=VECTORIZAR("Mask", w, h); }

if(intOR=="User_threshold" || signalThreshold=="User_threshold")  
{
Dialog.create("Threshold");      
if(intOR=="User_threshold")
  {
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
selectWindow("Red");
setAutoThreshold(intOR+" dark");
getThreshold(MMUR, nada);
resetThreshold();
selectWindow("Green");
setAutoThreshold(intOR+" dark");
getThreshold(MMUV, nada);
resetThreshold();
if(azul!="none"){
selectWindow("Blue");
setAutoThreshold(intOR+" dark");
getThreshold(MMUA, nada);
resetThreshold();	}  
}

if(intOR!="No_threshold")    //genera la mascara                          
	{
	if(operacion=="OR")
		{
		if(azul=="none") { 
			for(i=0; i<w*h; i++)
				A[i]=0; }
		for(i=0; i<w*h; i++)
			{
			if(R[i]>MMUR || V[i]>MMUV || A[i]>MMUA)
				m[i]=255;
				else
				m[i]=0; 
	    	}
		}
		else
		{
		if(azul=="none") { 
			for(i=0; i<w*h; i++)
				A[i]=255; }
		for(i=0; i<w*h; i++)
			{
			if(R[i]>MMUR && V[i]>MMUV && A[i]>MMUA)
				m[i]=255;
				else
				m[i]=0; 
	    	}
		}
	if(mascara!="none") { 
		for(i=0; i<w*h; i++) {
			if(m[i]==255 && M[i]==255)
				 M[i]=255;
				 else
				 M[i]=0; }
		}
		else {
		for(i=0; i<w*h; i++)
			M[i]=m[i]; }
	}
                      
unosMascara=0;  
cerosMascara=0;
selectWindow("Mask");
  i = 0;
  for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		if(M[i]==255) {
			setPixel(x, y, 255); unosMascara++; }
			else {
			setPixel(x, y, 0); cerosMascara++; }
		i++;
		}
	}

r=newArray(unosMascara); v=newArray(unosMascara); a=newArray(unosMascara);
if(DS==true) {
R=convo(R, w, h, fu, ra, 1);  V=convo(V, w, h, fu, ra, 1); 
if(azul!="none")  A=convo(A, w, h, fu, ra, 1);  }

r=recortar(R, M, w, h, unosMascara);
v=recortar(V, M, w, h, unosMascara);
if(azul!="none") a=recortar(A, M, w, h, unosMascara);

if(signalThreshold=="No_threshold") {MUR=1; MUA=1; MUV=1; }

if(signalThreshold!="User_threshold" && signalThreshold!="TCSS_threshold" && signalThreshold!="No_threshold") 
{
selectWindow("Red");
setAutoThreshold(signalThreshold+" dark");
getThreshold(MUR, nada);
resetThreshold();
selectWindow("Green");
setAutoThreshold(signalThreshold+" dark");
getThreshold(MUV, nada);
resetThreshold();
if(azul!="none") {
selectWindow("Blue");
setAutoThreshold(signalThreshold+" dark");
getThreshold(MUA, nada);
resetThreshold();	}  
}

if(signalThreshold=="TCSS_threshold")  
{
if(DS==true) ran=16; else ran=8;	
MUR=TCSS_threshold(r, unosMascara, ran);
MUV=TCSS_threshold(v, unosMascara, ran);
if(azul!="none") { MUA=TCSS_threshold(a, unosMascara, ran); }
}

//PEARSON

pr=sumarPixInt(r, unosMascara)/unosMascara;                                     
pv=sumarPixInt(v, unosMascara)/unosMascara;
if(azul!="none") {pa=sumarPixInt(a, unosMascara)/unosMascara;}

numVA=numRA=numRV=denR=denV=denA=0;

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

r=umbralizar(r, MUR, unosMascara); R=umbralizar(R, MUR, w*h); 
v=umbralizar(v, MUV, unosMascara); V=umbralizar(V, MUV, w*h); 
if(azul!="none") { a=umbralizar(a, MUA, unosMascara); A=umbralizar(A, MUA, w*h);  }

divR=rendirize(R, "Red"); divV=rendirize(V, "Green");
if(azul!="none") divA=rendirize(A, "Blue"); 

sumRojo=sumVerde=unosRojo=unosVerde=sumAzul=unosAzul=0;
for(i=0; i<unosMascara; i++) {
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
print(f, "\t "+"Mask threshold"+"\t "+"Signal threshold"+"\t "+"Random images"+"\t "+"Sig. level"+"\t "+"Mask's operator"+"\t "+"TCSS_rand"+"\t "+"Dispertion"+"\t "+"Seed");
print(f, "");
//print(f, "Algorithm"+"\t      "+intOR+"\t "+signalThreshold+"\t "+numGeneradas+"\t "+nivel+"\t "+operacion+"\t "+rs+"\t "+Criterion+"\t "+AI+" "+ai+"\t "+DS+" "+Dai+"\t "+semilla);
print(f, "Algorithm"+"\t      "+intOR+"\t "+signalThreshold+"\t "+numGeneradas+"\t "+nivel+"\t "+operacion+"\t "+Criterion+"\t "+DS+"\t "+semilla);
print(f, "Red channel"+"\t      "+MMUR+"\t "+MUR);
print(f, "Green channel"+"\t      "+MMUV+"\t "+MUV);
if(azul!="none") {
print(f, "Blue channel"+"\t      "+MMUA+"\t "+MUA); }
print(f, "");

selectWindow("Red");
run("Duplicate...", "title=rojoB");           
setThreshold(round(MUR/divR), 255);
run("Convert to Mask");
imageCalculator("AND create", "rojoB", "Mask");   
rename("rojoAndMascara");
selectWindow("Green");  
run("Duplicate...", "title=verdeB");           
setThreshold(round(MUV/divV), 255);
run("Convert to Mask");
imageCalculator("AND create", "verdeB", "Mask");  
rename("verdeAndMascara");
if(azul!="none") {selectWindow("Blue");  run("Duplicate...", "title=azulB");   
setThreshold(round(MUA/divA), 255);
run("Convert to Mask");
imageCalculator("AND create", "azulB", "Mask");                       
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
selectWindow("Mask");
run("Duplicate...", "title=RandomManders");        
i=0;
mas=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		if(M[mas]==255)
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
if(mascara=="none" && intOR=="No_Threshold") {selectWindow("Mask"); close();}
if(isOpen("rojoB")) {selectWindow("rojoB"); close();}
if(isOpen("verdeB")) {selectWindow("verdeB"); close();}
if(isOpen("azulB")) {selectWindow("azulB"); close();}
//if(isOpen("Red")) {selectWindow("Red"); close();}
//if(isOpen("Green")) {selectWindow("Green"); close();}
//if(isOpen("Blue")) {selectWindow("Blue"); close();}
setBatchMode("exit and display"); 
}
// fin