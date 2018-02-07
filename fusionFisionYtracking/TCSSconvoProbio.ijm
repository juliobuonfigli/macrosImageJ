macro "TCSS [c]" 
{

function make16(vec, an, al) {
newImage("2", "16-bit black", an, al, 1);
i=0;
selectWindow("2");
for(y=0; y<al; y++)
	{
	for(x=0; x<an; x++)
		{
		 setPixel(x, y, vector[i]);
		i++; 
		}
	}
return "2";
}

function threshold(vector, unos) {
	for(i=0; i<unos; i++)
		{
		if(
		}
	
}

function TCSS_threshold(vector, unos)
{
umbral=65025;
do { 
	showStatus("Thresholding...");
	umbral=umbral-255;
	sR=0;
	for(i=0; i<unos; i++) 
		{
		if(vector[i]>=umbral)
			sR++;  
		}
	} while(sR<unos*0.49 && umbral>=1)
if(sR>unos*0.51){
do {
   showStatus("Thresholding...");
   umbral++;
   sR=0;
   for(i=0; i<unos; i++)
	    {
		if(vector[i]>=umbral)
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
	
function convo(img, fu, r, f) 
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
// r=11; 
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

selectWindow(img);
an = getWidth;               
al = getHeight;
AN=an+anP;
AL=al+alP;

H=newArray(anP*alP);
G=newArray(an*al);

H=PSF(r, e, f);

selectWindow(img);
run("Duplicate...", "title=img2 duplicate");
run("Canvas Size...", "width=AN height=AL position=Center zero");
frames=nSlices;

for(t=1; t<frames+1; t++)
{
selectWindow("img2");
setSlice(t);
N=0;
M=0;
j=0;
for(k=0; k<al*an; k++)
	{
	suma=0;
	i=0;
	for(n=N; n<N+alP; n++)
		{
		for(m=M; m<M+anP; m++)
			{
			suma=suma+H[i]*getPixel(m, n)/255;
			i++;
			}
		}
	M++;
	if(M>an-1)
		{M=0; N++;}
	G[j]=suma;
	j++;
	}
selectWindow(img);
setSlice(t);
i=0;
for (y=0; y<al; y++)
	{
	for (x=0; x<an; x++)
		{
		setPixel(x, y, G[i]);
		i++;
		}
	}                
updateDisplay();
selectWindow("img2"); close();
}}

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
	if(v1[i]*v2[i]*v3[i]!= 0)
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
  Dialog.addChoice("Primary mask:", figura2); 
  Dialog.addCheckbox("TCSS_threshold", false);
  Dialog.addNumber("Red threshold: ", 25);
  Dialog.addNumber("Green threshold: ", 25);
  Dialog.addNumber("Blue threshold: ", 25);
  Dialog.addCheckbox("TCSS_criterion", false);
  Dialog.addChoice("Dispersing function: ", newArray("Lineal", "Cuadratica", "Cubica", "Aritmetica", "Geometrica"));
  Dialog.addNumber("Radius: ", 25);
  Dialog.addCheckbox("Calculate Statistical significance", true); 
  Dialog.addNumber("Number of generated images", 30); 
  Dialog.addChoice("Significance level", newArray(0.01, 0.05)); 
  Dialog.addCheckbox("Randomize three channels", false);
  Dialog.addNumber("Random seed (positive integer): ", 1); 

       Dialog.show();
   	rojo=Dialog.getChoice();
   	verde=Dialog.getChoice();
   	azul=Dialog.getChoice();
   	mascara=Dialog.getChoice();
   	tcssT=Dialog.getCheckbox();
    RT=Dialog.getNumber();
    GT=Dialog.getNumber();
    BT=Dialog.getNumber();
    tcssC=Dialog.getCheckbox();
   	fu=Dialog.getChoice();
	ra=Dialog.getNumber();
	generadas=Dialog.getCheckbox();
	numGeneradas=Dialog.getNumber();
	nivel=Dialog.getChoice();
	bCriterion=Dialog.getCheckbox();
	semilla=Dialog.getNumber();

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
run("Duplicate...", "title=Red");   run("8-bit");
w = getWidth;               
h = getHeight;
selectWindow(verde); run("Select None");
run("Duplicate...", "title=Green");   run("8-bit");
if(azul!="none") {selectWindow(azul); run("Select None");
run("Duplicate...", "title=Blue");  run("8-bit"); }

R=newArray(w*h); R=VECTORIZAR(rojo, w, h);
V=newArray(w*h); V=VECTORIZAR(verde, w, h);
if(azul!="none") {A=newArray(w*h); A=VECTORIZAR(azul, w, h);}




if(mascara!="none") {
selectWindow(mascara); run("Select None");
run("Duplicate...", "title=MASK");   }
else {newImage("MASK", "8-bit black", w, h, 1);  run("Invert");}





convo("Red", fu, ra, 1); convo("Green", fu, ra, 1);

if(azul!="none")  convo("Blue", fu, ra, 1);  
                
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
		{vs=v; as=randomizar(a, unosMascara); 	}
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

setBatchMode("exit and display"); 
}
// fin
