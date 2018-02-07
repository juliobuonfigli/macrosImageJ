//4 tiempos, 4 rois, ve si los cambios en la intensidad son en una direccion o en otra  
//Primer entrenamiento encuentra de mas

macro "FuFi [f]" {

function sigAbs(value, bias) {
e=2.71828;
g=(value+bias);
r=1/(1+pow(e, -1*g));
return r;
}

function poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, pot, cond, DX, DY) {
dd=0; //agrandamiento de ovalo
xa=round(pow(fA2, pot)*(ow/2+dd)*cos(t+sepin*dt)+CX+DX);
ya=round(pow(fA2, pot)*(oh/2+dd)*sin(t+sepin*dt)+CY+DY);
xb=round(pow(fA2, pot)*(ow/2+dd)*cos(t+dt)+CX+DX);
yb=round(pow(fA2, pot)*(oh/2+dd)*sin(t+dt)+CY+DY);
xc=round(pow(fA2, pot)*(ow/2+dd)*cos(t+(2-sepin)*dt)+CX+DX);
yc=round(pow(fA2, pot)*(oh/2+dd)*sin(t+(2-sepin)*dt)+CY+DY);
XA=round(pow(fA2, pot)*fA*(ow/2+dd)*cos(t+sepex*dt)+CX+DX);
YA=round(pow(fA2, pot)*fA*(oh/2+dd)*sin(t+sepex*dt)+CY+DY);
XB=round(pow(fA2, pot)*fA*(ow/2+dd)*cos(t+dt)+CX+DX);
YB=round(pow(fA2, pot)*fA*(oh/2+dd)*sin(t+dt)+CY+DY);
XC=round(pow(fA2, pot)*fA*(ow/2+dd)*cos(t+(2-sepex)*dt)+CX+DX);
YC=round(pow(fA2, pot)*fA*(oh/2+dd)*sin(t+(2-sepex)*dt)+CY+DY);
if(cond==false)
makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
else
makePolygon(xa,ya,xc,yc,XC,YC,XA,YA);
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
			setPixel(x, y, pix*fac); 
			}
		}
	updateDisplay();
	}
}

function umbral(w, h, frames, umb) {
selectWindow("Final");
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
			pix=getPixel(x,y);
			if(pix<umb)
				setPixel(x, y, 0); 
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
 Dialog.addChoice("Load stack:", figura); 
  Dialog.addNumber("Cell drift X:", 0); 
  Dialog.addNumber("Cell drift Y:", 0); 
  Dialog.addNumber("Vesicle diameter (pixels):", 13);  //ajustan el resizing espacial y temporal y numero de fragmentos
  Dialog.addNumber("Vesicle velocity:", 3);   //desde unsharp mask hasta step delay se va a procesar todo automaticamente sino se entra en mas opciones
  Dialog.addCheckbox("Equalization", false);  //los valores calculados entran en la segunada ventana como valores por defecto
 // Dialog.addCheckbox("Thresholding", false); 
  //Dialog.addNumber("Threshold: ", 0);  
  Dialog.addCheckbox("Unsharp Mask", false); 
  Dialog.addNumber("Radius: ", 4);
   Dialog.addNumber("Mask weight (0-1): ", 0.65);
   Dialog.addCheckbox("Median Filter", false);
     Dialog.addNumber("Radius: ", 4);
  Dialog.addNumber("Step delay: ", 0);
  Dialog.addCheckbox("Training mode", false); 
  //Dialog.addCheckbox("More options", true);  //fragmentacion, demás, mas de una velocidad 
   //Dialog.addCheckbox("Use row movie", true);
   
 Dialog.show();

                                               
  img=Dialog.getChoice(); 
  dx=Dialog.getNumber();
  dy=Dialog.getNumber(); 
  vd=Dialog.getNumber(); 
  tr=Dialog.getNumber(); 
  eq=Dialog.getCheckbox(); 
 // Thresholding=Dialog.getCheckbox(); 
  //threshold=Dialog.getNumber();  
  um=Dialog.getCheckbox(); 
  radius=Dialog.getNumber();
  mw=Dialog.getNumber();
  mf=Dialog.getCheckbox();
    MR= Dialog.getNumber();
    sd=Dialog.getNumber();
  TM=Dialog.getCheckbox();
  //mo=Dialog.getCheckbox();  //fragmentacion y demás y opciones de drift

//if(sd==0) setBatchMode(true);
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
frames2=nSlices();
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
perimetro=pi*(3*(ow+oh)-sqrt((3*oh+ow)*(3*ow+oh)));  //perimetro de la elipse
frag=round(perimetro/(1.5*vd));

if(tr!=0) {
selectWindow("Final");  TR=round(nSlices*tr);
run("Size...", "width=w height=h depth=TR average interpolation=Bicubic"); }
frames=nSlices;

frag=19;                      //fragmentación de anillos. 
dt=pi/frag;                //intervalo
fA=1.10;                     //espesor de anillo
fA2=1.05;                  //separacion entre anillos internos y externo
sepin=0;               //separacion entre segmentos de anillo interno
sepex=0;               //separación entre vertices externos del anillo externo
t=0;
cuadrado=true;
//dd=0;


if(eq==true) igualar(w, h, frames);
//if(Thresholding==true) umbral(w, h, frames, threshold);
if(um==true) run("Unsharp Mask...", "radius=radius mask=mw stack");

dx=dx/frames;
dy=dy/frames;
v1=newArray(frag*frames);
v2=newArray(frag*frames);
v3=newArray(frag*frames);
v4=newArray(frag*frames);
v5=newArray(frag*frames);
v6=newArray(frag*frames);
cont=0;

run("Set Measurements...", "mean redirect=None decimal=2");
selectWindow("Final");
for(i=1; i<frag+1; i++)     // lazo principal
	{
	//run("Select None");
	DX=0; DY=0;
	for(j=1; j<frames+1; j++)   
		{
		DX=DX+dx;  DY=DY-dy;
		setSlice(j);
		run("Select None");
		poligono(fA, fA2, sepin, sepex, cx, cy, t, dt, ow, oh, j, 0, cuadrado, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v1[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); 	wait(sd); 	run("Select None");
		poligono(fA, fA2, sepin, sepex, cx, cy, t, dt, ow, oh, j, 1, cuadrado, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v2[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(fA, fA2, sepin, sepex, cx, cy, t, dt, ow, oh, j, 2, cuadrado, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v3[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(fA, fA2, sepin, sepex, cx, cy, t, dt, ow, oh, j, 3, cuadrado, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v4[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); 		
		cont++;
		}	
	t=t+2*dt;
}

t1=newArray(frames*frag); t2=newArray(frames*frag); t3=newArray(frames*frag); t4=newArray(frames*frag); 
r1=newArray(frames*frag); r2=newArray(frames*frag); r3=newArray(frames*frag); r4=newArray(frames*frag);  e9=newArray(frames*frag);
sal=newArray(frag*frames); ev=newArray(frames*frag); for(i=0; i<frag*frames; i++) {ev[i]=false; sal[i]=0;}
wNo1=newArray(1.41048489, 11.6925194, 16.23000415, -1.495250616, -8.689340871);
wNo2=newArray(2.401749739, 0.650716212, -5.243532395, 0.140313413, -8.513481183);
wNo3=newArray(-9.779507179, -7.589617905, 0.894865575, -1.389431689, 5.582333642);
wNo4=newArray(-0.16805141, 0.423205808, -1.891469006, -2.908314165, -7.859153891);
wNo5=newArray(11.94699294, 12.15373475, -0.695677487, 0.474109979, -8.041466367);
wNs1=newArray(-18.56066502, 9.40843666, -13.79261213, -9.80E-05, 23.60182028, -17.09108371);
wNs2=newArray(-3.362178704, -11.2373124, 2.27163117, -10.3106268, -9.391666734, 16.18486692);
T=0;
contador=1;
for(e=0; e<frag*frames-4; e++)
	{
	Proi1=(v1[e]+v1[e+1]+v1[e+2]+v1[e+3])/4; if(Proi1==0) Proi1=1;
	Proi2=(v2[e]+v2[e+1]+v2[e+2]+v2[e+3])/4; if(Proi2==0) Proi2=1;
	Proi3=(v3[e]+v3[e+1]+v3[e+2]+v3[e+3])/4; if(Proi3==0) Proi3=1;
	Proi4=(v4[e]+v4[e+1]+v4[e+2]+v4[e+3])/4; if(Proi4==0) Proi4=1;
	t4[e]=v4[e+3]/Proi4+0.5*v3[e+3]/Proi3-0.5*v2[e+3]/Proi2-v1[e+3]/Proi1;   // divido por proi xq sino siempre tiende a ser mayor la zona de la membrana y me complica
	t3[e]=v4[e+2]/Proi4+0.5*v3[e+2]/Proi3-0.5*v2[e+2]/Proi2-v1[e+2]/Proi1;
	t2[e]=v4[e+1]/Proi4+0.5*v3[e+1]/Proi3-0.5*v2[e+1]/Proi2-v1[e+1]/Proi1;
	t1[e]=v4[e]/Proi4+0.5*v3[e]/Proi3-0.5*v2[e]/Proi2-v1[e]/Proi1;
	e9[e]=(Proi2+Proi3+Proi4)/3;
	sNo1=sigAbs(wNo1[0]*t1[e]+wNo1[1]*t2[e]+wNo1[2]*t3[e]+wNo1[3]*t4[e], 3.567);
	sNo2=sigAbs(wNo2[0]*t1[e]+wNo2[1]*t2[e]+wNo2[2]*t3[e]+wNo2[3]*t4[e], 1.089);
	sNo3=sigAbs(wNo3[0]*t1[e]+wNo3[1]*t2[e]+wNo3[2]*t3[e]+wNo3[3]*t4[e], -0.24);
	sNo4=sigAbs(wNo4[0]*t1[e]+wNo4[1]*t2[e]+wNo4[2]*t3[e]+wNo4[3]*t4[e], 0.843);
	sNo5=sigAbs(wNo5[0]*t1[e]+wNo5[1]*t2[e]+wNo5[2]*t3[e]+wNo5[3]*t4[e], 0.509);
	sNs1=sigAbs(sNo1*wNs1[0]+sNo2*wNs1[1]+sNo3*wNs1[2]+sNo4*wNs1[3]+sNo5*wNs1[4], -0.131);
	sNs2=sigAbs(sNo1*wNs2[0]+sNo2*wNs2[1]+sNo3*wNs2[2]+sNo4*wNs2[3]+sNo5*wNs2[4], -0.297);
	if(sNs1<0.5 && sNs2<0.5)
		sal[e]=0;
		else {   ev[e]=true;  T++; 
		if(sNs1>=0.5 && sNs2<0.5)
			sal[e]=1;
			else
			sal[e]=-1; 		}
	contador++;
	if(contador==frames-3) {e=e+4; contador=1;}
	}

for(i=1; i<frames*frag; i++) {      //resta eventos sucesivos de la misma naturaleza
	if(sal[i-1]==1 && sal[i]==1 && (i-1)%frames!=0)
		ev[i-1]=false;
	if(sal[i-1]==-1 && sal[i]==-1 && (i-1)%frames!=0)
		ev[i-1]=false; }

for(i=1; i<frames*frag-frames; i++) {    //resta eventos contados 2 veces en frags adyacentes
	if(sal[i]==1 && sal[i+frames]==1)
		ev[i]=false;
	if(sal[i]==-1 && sal[i+frames]==-1)
		ev[i]=false; }

if(TM==false) {
titulo1 = "Results";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if(isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings: Quadrant\t Frame\t Event\t Intensity");

contador=1;
for(i=0; i<frag*frames; i++)
	{
	print(f, (floor(i/frames)+1)+"\t    "+contador+"\t    "+sal[i]+"\t    "+e9[i]);
	contador++;
	if(contador==frames-3) {e=e+4; contador=1;}
	}

titulo3 = "Summary";                                            
titulo4 = "["+titulo3+"]";
  b = titulo4;
 if(isOpen(titulo4))
    print(b, "\\Clear");
 else
run("Table...", "name="+titulo3+" width=250 height=600");
print(b, "\\Headings: Quadrant\t Fusions\t Fisions\t Signal Density");


toti=newArray(frag);
totFus=0; totFis=0;
for(i=0; i<frag; i++)
	{
	fusiones=0; fisiones=0; toti[i]=0; 
	for(j=i*frames+1; j<i*frames+frames; j++)
		{
		if(ev[j]==true) 
			{
			if(sal[j]==1) fusiones++;	
			if(sal[j]==-1) fisiones++;	
			}
		toti[i]=toti[i]+(v2[j]+v3[j]+v4[j])*255/frames/3;
		}
	totFus=totFus+fusiones;
	totFis=totFis+fisiones;
	print(b, i+1+"\t    "+fusiones+"\t    "+fisiones+"\t    "+toti[i]);
	}
print(b, "Total"+"\t    "+totFus+"\t    "+totFis+"\t    "+T);

}
		
else {

titulo1 = "Results";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if(isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings: frag\t frame\t t1\t t2\t t3\t  t4\t  e9");

contador=1;
for(e=0; e<frames*frag-4; e++)
	{
	print(f, (floor(e/frames)+1)+"\t    "+contador+"\t    "+t1[e]+"\t    "+t2[e]+"\t    "+t3[e]+"\t    "+t4[e]+"\t   "+e9[e]);
	contador++;
	if(contador==frames-3) {e=e+4; contador=1;}
	}	
}
}

/*
r4[e]=2*v4[e+3]+v4[e+2]-v4[e+1]-2*v4[e];   //no divido por proi xq comparo intensidades dentro del mismo roi
r3[e]=2*v3[e+3]+v3[e+2]-v3[e+1]-2*v3[e];
r2[e]=2*v2[e+3]+v2[e+2]-v2[e+1]-2*v2[e];
r1[e]=2*v1[e+3]+v1[e+2]-v1[e+1]-2*v1[e];*/

