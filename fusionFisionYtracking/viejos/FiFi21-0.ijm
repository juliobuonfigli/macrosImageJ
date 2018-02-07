//cuatro rois, dos tiempos, funciones de peso
//puede hacerse sin hacer redes, clasifica evento y por otro lado si es fision o fusion, vuelven los no calificados, 3 neuronas de salida (una para evento o no evento)
//Respecto del anterior este no trata una segunda imagen con deteccion de velocidad 
//Ademas los cambios de intensidad en el roi1 para decretar evento estan relativizados a la desviacion estandar de todos los cambios de intensidad
//Tambien se decreta como evento un valor alto del valor absoluto de la suma de todas las entradas
//estos dos umbrales para decretar evento inician con valores relativamente bajos y despues son ajustados segun las clasificacion de eventos no calificados q hace la red neuronal 

macro "FuFi [f]" {

function sigAbs(value, bias) {
e=2.71828;
g=(value+bias);
r=1/(1+pow(e, -1*g));
return r;
}

function normalizacion(img) {
selectWindow(img);
w=getWidth;
h=getHeight;
frames=nSlices;
run("Set Measurements...", "mean min redirect=None decimal=2");
run("Select None");
run("Measure");
max=getResult("Max", 0);
min=getResult("Min", 0);
run("Clear Results");
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	p=getPixel(x, y);
	 	setPixel(x, y, round(((p-min)*255)/(max-min))+1);
	 	}	
	  }
	}
}

function poligono(esp, sep, CX, CY, t, dt, ow, oh, j, cond, DX, DY) {
xa=round(sep*(ow/2)*cos(t)+CX+DX);
ya=round(sep*(oh/2)*sin(t)+CY+DY);
xb=round(sep*(ow/2)*cos(t+dt)+CX+DX);
yb=round(sep*(oh/2)*sin(t+dt)+CY+DY);
xc=round(sep*(ow/2)*cos(t+2*dt)+CX+DX);
yc=round(sep*(oh/2)*sin(t+2*dt)+CY+DY);
XA=round(sep*esp*(ow/2)*cos(t)+CX+DX);
YA=round(sep*esp*(oh/2)*sin(t)+CY+DY);
XB=round(sep*esp*(ow/2)*cos(t+dt)+CX+DX);
YB=round(sep*esp*(oh/2)*sin(t+dt)+CY+DY);
XC=round(sep*esp*(ow/2)*cos(t+2*dt)+CX+DX);
YC=round(sep*esp*(oh/2)*sin(t+2*dt)+CY+DY);
if(cond==false)
makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
else
makePolygon(xa,ya,xc,yc,XC,YC,XA,YA);
}

function cbrt(w)      //raiz cubica               
{
   x = w;
   y = 1;
   e = 0.000001;
  while(x - y > e)
  {
    x = (2*x + y)/3;
    y = w/(x*x);
  }
return x;
}

function igualar(w, h, frames) {
selectWindow("Final");
size=1/(w*h);
ipp=newArray(frames+1);
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	ipp[i]=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			ipp[i]=ipp[i]+getPixel(x,y);
			}
		}
	ipp[i]=ipp[i]*size;
	}

ip=0;
for(i=1; i<frames+1; i++)
	ip=ip+ipp[i];
ip=ip/frames;

for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	fac=ip/ipp[i];
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pix=getPixel(x,y);
			setPixel(x, y, pix*fac+1); 
			}
		}
	updateDisplay();
	}
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

Dialog.create("Fusion-Fision");                                                          
 Dialog.addChoice("Stack:", figura); 
  Dialog.addNumber("Corrimiento en X:", 0); 
  Dialog.addNumber("Corrimiento en Y:", 0); 
  Dialog.addNumber("Diametro de vesicula (pixels):", 10);  
  Dialog.addCheckbox("Ecualizacion", false);  
  Dialog.addNumber("Dividir valores de pixel sobre: ", 1);
  Dialog.addCheckbox("Unsharp Mask", false); 
  Dialog.addCheckbox("Normalizacion", false);
  Dialog.addNumber("Retardo en lectura: ", 0);
  Dialog.addCheckbox("Mas opciones", false);  
  Dialog.addCheckbox("MODO DE ENTRENAMIENTO", true); 
  Dialog.show();
                                         
  img=Dialog.getChoice(); 
  dx=Dialog.getNumber();
  dy=Dialog.getNumber(); 
  vd=Dialog.getNumber(); 
  eq=Dialog.getCheckbox(); 
  div=Dialog.getNumber(); 
  um=Dialog.getCheckbox(); 
  norm=Dialog.getCheckbox(); 
  sd=Dialog.getNumber();
  MO=Dialog.getCheckbox();    
  TM=Dialog.getCheckbox();
  
run("ROI Manager...");
selectWindow("ROI Manager");
run("Close");
selectWindow(img);
roiManager("Add");
run("Select None");
run("Duplicate...", "duplicate");
rename("Final");
run("8-bit");
w=getWidth();                    
h=getHeight();
frames=nSlices();
roiManager("Select", 0);
run("Set Measurements...", "centroid bounding redirect=None decimal=0");
run("Measure");
cx=getResult("X", 0);
cy=getResult("Y", 0);
ow=getResult("Width", 0);
oh=getResult("Height", 0);
run("Clear Results"); 
run("Select None");

pi=3.141592653589793; 
perimetro=pi*(3*((ow+oh)/2)-sqrt((3*oh/2+ow/2)*(3*ow/2+oh/2)));  //perimetro de la elipse externa

radius=4;
mw=0.8;
frag=round(perimetro/vd);
esp=0.24; 
ra=1.4;
cua=true;
evaluarRI=true;
uri=2;
evaluarRG=true;
ug=4;
ESE=false;
ESO=true;
EAE=false;
EAO=true;
BM=false;

if(MO==true) {
Dialog.create("Fusion-Fision");                                                          
  Dialog.addMessage("TRATAMIENTOS");
  Dialog.addNumber("Radio unsharp mask:",  radius);  //ajustan el resizing espacial y temporal y numero de fragmentos
  Dialog.addNumber("Peso de mascara (0-1): ", mw);
  Dialog.addMessage("MUESTREO");
  Dialog.addNumber("Numero de cuadrantes:", frag); 
  Dialog.addNumber("Espesor de ROI interno (proporcion del radio):", esp); 
  Dialog.addNumber("Relacion de arco ROI interno y externos: ", ra);
  Dialog.addCheckbox("ROI interno rectangular", cua);
  Dialog.addMessage("EVALUACION");
  Dialog.addCheckbox("Evaluar ROI interno", evaluarRI);
  Dialog.addNumber("Umbral ROI interno: ", uri);
  Dialog.addCheckbox("Evaluar umbral general", evaluarRG);
  Dialog.addNumber("Umbral general: ", ug);
  Dialog.addCheckbox("Contar eventos sucesivos equivalentes", ESE);
  Dialog.addCheckbox("Contar eventos sucesivos opuestos", ESO);
  Dialog.addCheckbox("Contar eventos ayacentes equivalentes", EAE);
  Dialog.addCheckbox("Contar eventos ayacentes opuestos", EAO); 
  Dialog.addMessage("PROCESO");
  Dialog.addCheckbox("Ocultar imagenes de procesamiento", BM); 
 
 Dialog.show();
                                         
radius=Dialog.getNumber();
mw=Dialog.getNumber();
frag=Dialog.getNumber();
esp=Dialog.getNumber();
ra=Dialog.getNumber();
cua=Dialog.getCheckbox();
evaluarRI=Dialog.getCheckbox();
uri=Dialog.getNumber();
evaluarRG=Dialog.getCheckbox();
ug=Dialog.getNumber();
ESE=Dialog.getCheckbox();
ESO=Dialog.getCheckbox();
EAE=Dialog.getCheckbox();
EAO=Dialog.getCheckbox();
BM=Dialog.getCheckbox();   }

if(BM==true) setBatchMode(true);
selectWindow("Final");
if(eq==true) igualar(w, h, frames);
if(div!=1) run("Divide...", "value=div stack");
if(um==true) run("Unsharp Mask...", "radius=radius mask=mw stack");
if(norm==true) normalizacion("Final");

dx=dx/frames; dy=dy/frames; 
v1=newArray(frag*frames); v2=newArray(frag*frames); v3=newArray(frag*frames); v4=newArray(frag*frames); 
cont=0;  esp=esp+1;
run("Set Measurements...", "mean min redirect=None decimal=2");
t=0; dt=pi/frag;   
for(i=1; i<frag+1; i++)    
	{
	DX=0; DY=0;
	for(j=1; j<frames+1; j++)   
		{
		DX=DX+dx;  DY=DY-dy;
		setSlice(j);
		run("Select None");
		poligono(esp, 1, cx, cy, t, dt, ow, oh, j, cua, DX, DY); 
		run("Measure");
		if(j==1)
			roiManager("Add");
		v1[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); 	wait(sd); 	run("Select None");
		poligono(cbrt(esp), esp, cx, cy, t-(ra-1)*dt, ra*dt, ow, oh, j, false, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v3[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(cbrt(esp), esp*cbrt(esp), cx, cy, t-(ra-1)*dt, ra*dt, ow, oh, j, false, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v4[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd);  run("Select None");
		poligono(cbrt(esp), esp*pow(cbrt(esp), 2), cx, cy, t-(ra-1)*dt, ra*dt, ow, oh, j, false, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v2[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); 
		cont++;
		}	
	t=t+2*dt;
	}

e1=newArray(frames*frag); e2=newArray(frames*frag); e3=newArray(frames*frag); e4=newArray(frames*frag); 
e5=newArray(frames*frag); e6=newArray(frames*frag); e7=newArray(frames*frag); 
pv1=newArray(frag); pv2=newArray(frag); pv3=newArray(frag); pv4=newArray(frag); 
sal=newArray(frag*frames); UG=newArray(frag*frames);
ev=newArray(frames*frag); for(i=0; i<frag*frames; i++) {ev[i]=false; sal[i]=0;}
wNo1=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 11.6925194, 16.23000415, -1.495250616);
wNo2=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 11.6925194, 16.23000415, -1.495250616);
wNo3=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 11.6925194, 16.23000415, -1.495250616);
wNo4=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 11.6925194, 16.23000415, -1.495250616);
wNo5=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 11.6925194, 16.23000415, -1.495250616);
wNo6=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 11.6925194, 16.23000415, -1.495250616);
wNo7=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 11.6925194, 16.23000415, -1.495250616);
wNs1=newArray(-18.56066502, 9.40843666, -13.79261213, -9.80E-05, 23.60182028);
wNs2=newArray(-3.362178704, -11.2373124, 2.27163117, -10.3106268, -9.391666734);
wNs3=newArray(-3.362178704, -11.2373124, 2.27163117, -10.3106268, -9.391666734);
T=0;
v1de=0; v1p=0;
for(e=0; e<frag*frames-1; e++) {
	if((e+1)%frames==0) {} else
	v1p=v1p+log(v1[e]/v1[e+1]);
v1p=v1p/(frag*frames-frames);	
for(e=0; e<frag*frames-1; e++)
	if((e+1)%frames==0) {} else
	v1de=v1de+pow(log(v1[e]/v1[e+1])-v1p, 2);
v1de=sqrt(v1de/(frag*frames-frames));	
		
for(e=0; e<frag*frames-1; e++)
	{
	if(e%frames==0)
		{
		in=floor(e/frames);
		for(i=e; i<e+frames; i++)
			{
			pv1[in]=pv1[in]+v1[i];		
			pv2[in]=pv2[in]+v2[i];
			pv3[in]=pv1[in]+v3[i];		
			pv4[in]=pv2[in]+v4[i];		
			}
		pv1[in]=pv1[in]/frames; pv2[in]=pv2[in]/frames; pv3[in]=pv3[in]/frames; pv4[in]=pv4[in]/frames;
		}
	in=floor(e/frames);
	e1[e]=log(v1[e]/v1[e+1])/v1de;                      
	e2[e]=2*v1[e]/v1[e+1]+v2[e]/v2[e+1]-v3[e]/v3[e+1]-2*v4[e]/v4[e+1];                              
	e3[e]=2*(v1[e]-v1[e+1])+(v2[e]-v2[e+1])-(v3[e]-v3[e+1])-2*(v4[e]-v4[e+1]);                              
	e4[e]=2*(v1[e]-v1[e+1])/pv1[in]+(v2[e]-v2[e+1])/pv2[in]-(v3[e]-v3[e+1])/pv3[in]-2*(v4[e]-v4[e+1])/pv4[in];   
	e5[e]=v1[e]/v1[e+1]-(v2[e]+v3[e]+v4[e])/(v2[e+1]+v3[e+1]+v4[e+1]);   
	e6[e]=v1[e]/v1[e+1]-v4[e]/v4[e+1];      
	e7[e]=v2[e]/v2[e+1]-v4[e]/v4[e+1];   
	if(e1[e]>3) e1[e]=3; if(e1[e]<-3) e1[e]=-3;
	if(e2[e]>3) e2[e]=3; if(e2[e]<-3) e2[e]=-3;
	if(e3[e]>3) e3[e]=3; if(e3[e]<-3) e3[e]=-3;
	if(e4[e]>3) e4[e]=3; if(e4[e]<-3) e4[e]=-3;
	if(e5[e]>3) e5[e]=3; if(e5[e]<-3) e5[e]=-3;
	if(e6[e]>3) e6[e]=3; if(e6[e]<-3) e6[e]=-3;
	if(e7[e]>3) e7[e]=3; if(e7[e]<-3) e7[e]=-3;
	sNo1=sigAbs(wNo1[0]*e1[e]+wNo1[1]*e2[e]+wNo1[2]*e3[e]+wNo1[3]*e4[e]+wNo1[4]*e5[e]+wNo1[5]*e6[e]+wNo1[6]*e7[e], 3.567);
	sNo2=sigAbs(wNo2[0]*e1[e]+wNo2[1]*e2[e]+wNo2[2]*e3[e]+wNo2[3]*e4[e]+wNo2[4]*e5[e]+wNo2[5]*e6[e]+wNo2[6]*e7[e], 3.567);
    sNo3=sigAbs(wNo3[0]*e1[e]+wNo3[1]*e2[e]+wNo3[2]*e3[e]+wNo3[3]*e4[e]+wNo3[4]*e5[e]+wNo3[5]*e6[e]+wNo3[6]*e7[e], 3.567);
	sNo4=sigAbs(wNo4[0]*e1[e]+wNo4[1]*e2[e]+wNo4[2]*e3[e]+wNo4[3]*e4[e]+wNo4[4]*e5[e]+wNo4[5]*e6[e]+wNo4[6]*e7[e], 3.567);
	sNo5=sigAbs(wNo5[0]*e1[e]+wNo5[1]*e2[e]+wNo5[2]*e3[e]+wNo5[3]*e4[e]+wNo5[4]*e5[e]+wNo5[5]*e6[e]+wNo5[6]*e7[e], 3.567);
	sNo6=sigAbs(wNo6[0]*e1[e]+wNo6[1]*e2[e]+wNo6[2]*e3[e]+wNo6[3]*e4[e]+wNo6[4]*e5[e]+wNo6[5]*e6[e]+wNo6[6]*e7[e], 3.567);
	sNo7=sigAbs(wNo7[0]*e1[e]+wNo7[1]*e2[e]+wNo7[2]*e3[e]+wNo7[3]*e4[e]+wNo7[4]*e5[e]+wNo7[5]*e6[e]+wNo7[6]*e7[e], 3.567);
	sNs1=sigAbs(sNo1*wNs1[0]+sNo2*wNs1[1]+sNo3*wNs1[2]+sNo4*wNs1[3]+sNo5*wNs1[4], -0.131);
	sNs2=sigAbs(sNo1*wNs2[0]+sNo2*wNs2[1]+sNo3*wNs2[2]+sNo4*wNs2[3]+sNo5*wNs2[4], -0.297);
	sNs3=sigAbs(sNo1*wNs3[0]+sNo2*wNs3[1]+sNo3*wNs3[2]+sNo4*wNs3[3]+sNo5*wNs3[4], -0.297);
	if(sNs1<0.5 && sNs2<0.5)
		sal[e]=0;
		else {    T++; 
		if(sNs1>=0.5 && sNs2<0.5)
			sal[e]=1;
			else
			sal[e]=-1; 		}
	}
promUG=0; deUG=0;
for(i=0; i<frag*frames; i++) {
	UG[i]=abs(e1[i]+e2[i]+e3[i]+e4[i]+e5[i]+e6[i]+e7[i])/7;
	promUG=promUG+UG[i]; }
promUG=promUG/(frag*frames);
for(i=0; i<frag*frames; i++) 
	deUG=deUG+pow(UG[i]-promUG, 2); 
deUG=sqrt(deUG/(frag*frames));
for(i=0; i<frag*frames; i++) 
	UG[i]=UG[i]/deUG;

for(i=0; i<frag*frames; i++) {
if(evaluarRI==true) {
	if(abs(e1[i])>uri)
		ev[i]=true; }
if(evaluarRG==true) {
	if(abs(UG[i])>ug)
		ev[i]=true; }}

for(i=0; i<frag*frames; i++)  {
	if((i+1)%frames==0)
		ev[i]=false; }
	
if(ESE==true) {
for(i=1; i<frames*frag; i++) {      //resta eventos sucesivos de la misma naturaleza
	if(sal[i-1]==1 && sal[i]==1 && (i-1)%frames!=0)
		ev[i-1]=false;
	if(sal[i-1]==-1 && sal[i]==-1 && (i-1)%frames!=0)
		ev[i-1]=false; } }

if(ESO==true) {
for(i=1; i<frames*frag; i++) {      //resta eventos sucesivos opuestos
	if(sal[i-1]==-1 && sal[i]==1 && (i-1)%frames!=0)
		ev[i-1]=false;
	if(sal[i-1]==1 && sal[i]==-1 && (i-1)%frames!=0)
		ev[i-1]=false; } }

if(EAE==true) {
for(i=1; i<frames*frag-frames; i++) {    //resta eventos contados 2 veces en frags adyacentes
	if(sal[i]==1 && sal[i+frames]==1)
		ev[i]=false;
	if(sal[i]==-1 && sal[i+frames]==-1)
		ev[i]=false; } }

if(EAO==true) {
for(i=1; i<frames*frag-frames; i++) {    //resta eventos contados 2 veces en frags adyacentes
	if(sal[i]==-1 && sal[i+frames]==1)
		ev[i]=false;
	if(sal[i]==-1 && sal[i+frames]==1)
		ev[i]=false; } }

if(TM==false) {
titulo1 = "Resultados";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if(isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings: Cuadrante\t corte\t Evento\t Intensidad");

contador=1;
for(i=0; i<frag*frames; i++)
	{
	if(ev[e]==true)
	print(f, (floor(i/frames)+1)+"\t    "+contador+"\t    "+sal[i]+"\t    "+v1[i+1]/v1[i]);
	contador++;
	if(contador==frames)  contador=0;
	}

titulo3 = "Resumen";                                            
titulo4 = "["+titulo3+"]";
  b = titulo4;
 if(isOpen(titulo4))
    print(b, "\\Clear");
 else
run("Table...", "name="+titulo3+" width=250 height=600");
print(b, "\\Headings: Cuadrante\t Fusiones\t Fisiones\t Densidad de senal");

toti=newArray(frag);
totFus=0; totFis=0; totNocal=0;
for(i=0; i<frag; i++)
	{
	fusiones=0; fisiones=0; noCal=0; toti[i]=0; 
	for(j=i*frames+1; j<i*frames+frames; j++)
		{
		if(ev[j]==true) 
			{
			if(sal[j]==1) fusiones++;	
			if(sal[j]==-1) fisiones++;	
			if(sal[j]==0) noCal++;	
			}
		toti[i]=toti[i]+(v2[j]+v3[j]+v4[j])*255/frames/3;
		}
	totFus=totFus+fusiones;
	totFis=totFis+fisiones;
	totNocal=totNocal+noCal;
	print(b, i+1+"\t    "+fusiones+"\t    "+fisiones+"\t    "+noCal+"\t    "+toti[i]);
	}
print(b, "Total"+"\t    "+totFus+"\t    "+totFis+"\t    "+totNocal+"\t    "+T);
}
		
else {

titulo1 = "Resultados";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if(isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings: frag\t frame\t e1\t e2\t e3\t e4\t e5\t e6\t e7\t UG\t pv1\t pv2\t pv3\t pv4");

promUG=0; promE1=0; deE1=0; deUG=0;
contador=1;
for(e=0; e<frames*frag-1; e++)
	{
	in=floor(e/frames);
	if(ev[e]==true) {
	print(f, (in+1)+"\t    "+contador+"\t    "+e1[e]+"\t    "+e2[e]+"\t    "+e3[e]+"\t    "+e4[e]+"\t    "+e5[e]+"\t    "+e6[e]+"\t    "+e7[e]+"\t    "+UG[e]+"\t    "+pv1[in]+"\t    "+pv2[in]+"\t    "+pv3[in]+"\t    "+pv4[in]);
	print(f, (in+1)+"\t    "+contador+"\t    "+v1[e]+"\t    "+v2[e]+"\t    "+v3[e]+"\t    "+v4[e]+"\t    "+v1[e+1]+"\t    "+v2[e+1]+"\t    "+v3[e+1]+"\t    "+v4[e+1]); }
	contador++;
	if(contador==frames)  contador=0;
	promE1=promE1+e1[e];
	promUG=promUG+UG[e];
	}	
promE1=promE1/(frag*frames); promUG=promUG/(frag*frames);
pE1=0; apE1=0; pE2=0; apE2=0; pE3=0; apE3=0; pE4=0; apE4=0; pE5=0; apE5=0; pE6=0; apE6=0; pE7=0; apE7=0; 
for(e=0; e<frames*frag-1; e++) { 
	deE1=deE1+pow(e1[e]-promE1, 2);
	deUG=deUG+pow(UG[e]-promUG, 2);
	pE1=pE1+e1[e]; 	apE1=apE1+abs(e1[e]);
	pE2=pE2+e2[e]; 	apE2=apE2+abs(e2[e]);
	pE3=pE3+e3[e]; 	apE3=apE3+abs(e3[e]);
	pE4=pE4+e4[e]; 	apE4=apE4+abs(e4[e]);
	pE5=pE5+e5[e]; 	apE5=apE5+abs(e5[e]);
	pE6=pE6+e6[e]; 	apE6=apE6+abs(e6[e]);
	pE7=pE7+e7[e]; 	apE7=apE7+abs(e7[e]);
	}
deE1=sqrt(deE1/(frag*frames)); deUG=sqrt(deUG/(frag*frames));
print("Promedio e1: "+promE1+"    Desviacion e1: "+deE1);   
print("Promedio UG: "+promUG+"    Desviacion UG: "+deUG);
print("v1de: "+v1de);
print("pE1: "+pE1/(frag*frames)+"    pE1abs: "+apE1/(frag*frames));
print("pE2: "+pE2/(frag*frames)+"    pE2abs: "+apE2/(frag*frames));
print("pE3: "+pE3/(frag*frames)+"    pE3abs: "+apE3/(frag*frames));
print("pE4: "+pE4/(frag*frames)+"    pE4abs: "+apE4/(frag*frames));
print("pE5: "+pE5/(frag*frames)+"    pE5abs: "+apE5/(frag*frames));
print("pE6: "+pE6/(frag*frames)+"    pE6abs: "+apE6/(frag*frames));
print("pE7: "+pE7/(frag*frames)+"    pE7abs: "+apE7/(frag*frames));

uris=0; ugis=0; dos=0;
for(e=0; e<frames*frag-1; e++) {
	if(abs(e1[e])>uri)
		uris++;
	if(abs(UG[e])>ug)
		ugis++; 	
	if(abs(e1[e])>uri && abs(UG[e])>ug)
		dos++; 			}
print("Umbral ROI1: "+uris+"  Umbral general: "+ugis+"  Ambos: "+dos);   
}
if(BM==true) setBatchMode("exit and display");
}