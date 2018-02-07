//vuelta a detector de movimiento, chau redes neuronales
//usado para resultados preliminares q ojala no sean los finales
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
  Dialog.addNumber("Corrimiento en X:", 7); 
  Dialog.addNumber("Corrimiento en Y:", -5); 
  Dialog.addNumber("Diametro de vesicula (pixels):", 12);  
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

if(isOpen("Final")) {
	selectWindow("Final");
	close(); }  
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
esp=0.26; 
ra=2;
cua=true;
evaluarRI=true;
uri=30;
evaluarRG=true;
ug=4;
ESE=true;
ESO=false;
EAE=true;
EAO=false;
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
  Dialog.addCheckbox("Restar eventos sucesivos equivalentes", ESE);
  Dialog.addCheckbox("Restar eventos sucesivos opuestos", ESO);
  Dialog.addCheckbox("Restar eventos ayacentes equivalentes", EAE);
  Dialog.addCheckbox("Restar eventos ayacentes opuestos", EAO); 
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
v1=newArray(frag*frames); v2=newArray(frag*frames); v3=newArray(frag*frames); v4=newArray(frag*frames); m1=newArray(frag*frames);
cont=0;  esp=esp+1;
esp=1.22;
esp2=1.23;
//frames=61;
setBatchMode(true);
run("Set Measurements...", "mean min redirect=None decimal=2");
t=0; dt=pi/frag;   
for(i=1; i<frag+1; i++)    
	{
	DX=0; DY=0;
	for(j=1; j<frames+1; j++)   
		{
		DX=DX+dx;  DY=DY-dy;
		selectWindow("Final");
		setSlice(j);
		if(j%6==0) {
		poligono(esp, 1, cx, cy, t, dt, ow, oh, j, cua, DX, DY); 
		run("Capture Image");
		rename(33333000+100*i+j); 
		}
		selectWindow("Final");
		if(j%6==1) {
		poligono(esp2, cbrt(esp)*esp, cx, cy, t-(ra-1)*dt, ra*dt, ow, oh, j, false, DX, DY);
		run("Capture Image");
		rename(33333000+100*i+j); 
		}		
		cont++;
		}	
	t=t+2*dt;
	}
run("Images to Stack", "name=movie title=3333 use");	
setBatchMode("exit and display");
}
/*
sal=newArray(frag*frames); 
ev=newArray(frames*frag); 
cond=newArray(frag*frames);
for(i=0; i<frag*frames; i++) {ev[i]=false; sal[i]=0; cond[i]=0;}

T=0;
//cdMAX=210;
cdMP=3;
cdMED=37;
//cdDOB=18;
cdMIN=0.22;
//cdREL=0.2;
densi=newArray(frag*frames);
pv1=newArray(frag);
//(v2[e+1]+v3[e+1]+v4[e+1]+v2[e]+v3[e]+v4[e])/6>cdREL*(v1[e]+v1[e+1])/2 && 
/*cd4=(v4[e]-v4[e+1])/(v4[e]+v4[e+1]);      
	cd3=v2[e+1]/(v2[e+1]+v2[e])-v4[e+1]/(v4[e+1]+v4[e]);      
	cd2=v3[e]/(v3[e+1]+v3[e])-v1[e]/(v1[e+1]+v1[e]);          
	cd1=(v1[e+1]-v1[e])/(v1[e+1]+v1[e]);
	
for(e=0; e<frag*frames-1; e++)
	{
	if(e%frames==0)
		{
		for(i=e; i<e+frames; i++) 
			pv1[floor(e/frames)]=pv1[floor(e/frames)]+v1[i];		
		pv1[floor(e/frames)]=pv1[floor(e/frames)]/frames; 
		}
	densi[e]=(v2[e+1]+v3[e+1]+v4[e+1]+v2[e]+v3[e]+v4[e])/6;
	cd4=2*(v4[e]-v4[e+1])/(v4[e+1]+v4[e]);      
	cd3=(v3[e]-v3[e+1])/(v3[e+1]+v3[e]);      
	cd2=(v2[e+1]-v2[e])/(v2[e+1]+v2[e]);          
	cd1=2*(v1[e+1]-v1[e])/(v1[e+1]+v1[e]);       
	cond[e]=(cd4+cd3+cd2+cd1)/(v4[e]+v4[e+1]+v3[e]+v3[e+1]+v2[e]+v2[e+1]+v1[e]+v1[e+1]);         
	if(v1[e]>cdMP*pv1[floor(e/frames)] || v1[e+1]>cdMP*pv1[floor(e/frames)]) 
		ev[e]=true;	
	if(v1[e]>cdMED || v1[e+1]>cdMED) 
		ev[e]=true;
	if(abs(cond[e])>cdMIN) 
		{
		if(cond[e]>0)
			sal[e]=1;
			else
			sal[e]=-1;
		}
		else
		{
		sal[e]=0;
		}
	}	
	 
for(i=0; i<frag*frames; i++)  {
	if((i+1)%frames==0)
		ev[i]=false; }

for(i=0; i<frag*frames; i++)  { //provisorio
	if(i%frames==0)
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
	if(ev[i]==true)
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
print(b, "\\Headings: Cuadrante\t Fusiones\t Fisiones\t NoCal\t Densidad de senal");

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
print(f, "\\Headings: frag\t frame\t cond\t sal\t densi\t pv1\t v1\t v1v2\t m1");

contador=1;
for(e=0; e<frames*frag-1; e++)
	{
	in=floor(e/frames);
	//if(ev[e]==true) 
	print(f, (in+1)+"\t    "+contador+"\t    "+cond[e]+"\t    "+sal[e]+"\t    "+densi[e]+"\t    "+pv1[in]+"\t    "+v1[e]+"\t    "+(v1[e]+v1[e+1])/2+"\t    "+m1[e]);
	contador++;
	if(contador==frames)  contador=0;	
	}	

}
if(BM==true) setBatchMode("exit and display");
}*/