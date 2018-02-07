
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
perimetro=pi*(3*((ow+oh)/2)-sqrt((3*oh/2+ow/2)*(3*ow/2+oh/2)));  //perimetro de la elipse externa
frag=round(perimetro/14);


/*if(tr!=0) {
selectWindow("Final");  TR=round(nSlices*tr);
run("Size...", "width=w height=h depth=TR average interpolation=Bicubic"); }*/
selectWindow("Final");  
frames=nSlices;


dt=pi/frag;                      //intervalo
fA=1.10;                            //espesor de anillo
fA2=1+pow(vd/((ow/2+oh/2)/2), 2)+0.02;                 //separacion entre anillos internos y externo
sepin=0;                        //separacion entre segmentos de anillo interno
sepex=0;                           //separación entre vertices externos del anillo externo
t=0;
cuadrado=false;
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
		poligono(fA, 1, sepin, sepex, cx, cy, t, dt, ow, oh, j, 0, cuadrado, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v1[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); 	wait(sd); 	run("Select None");
		poligono(fA2, fA, sepin, sepex, cx, cy, t, dt, ow, oh, j, 1, cuadrado, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v2[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(0.96*fA2, fA2*fA, sepin, sepex, cx, cy, t, dt, ow, oh, j, 1, cuadrado, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v3[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); 	
		cont++;
		}	
	t=t+2*dt;
}

e1=newArray(frames*frag); e2=newArray(frames*frag); e3=newArray(frames*frag); e4=newArray(frames*frag); e5=newArray(frames*frag); e6=newArray(frames*frag);
e7=newArray(frames*frag); e8=newArray(frames*frag);  e9=newArray(frames*frag); e10=newArray(frames*frag); e11=newArray(frames*frag); e12=newArray(frames*frag);

sal=newArray(frag*frames); ev=newArray(frames*frag); for(i=0; i<frag*frames; i++) {ev[i]=false; sal[i]=0;}
pv1=newArray(frag); pv2=newArray(frag); pv3=newArray(frag); ipr=newArray(frames*frag);

wNo1=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 1.41048489, 11.6925194, 16.23000415, -1.495250616, -8.689340871, -1.495250616, -8.689340871, -8.689340871);
wNo2=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 1.41048489, 11.6925194, 16.23000415, -1.495250616, -8.689340871, -1.495250616, -8.689340871, -8.689340871);
wNo3=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 1.41048489, 11.6925194, 16.23000415, -1.495250616, -8.689340871, -1.495250616, -8.689340871, -8.689340871);
wNo4=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 1.41048489, 11.6925194, 16.23000415, -1.495250616, -8.689340871, -1.495250616, -8.689340871, -8.689340871);
wNo5=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 1.41048489, 11.6925194, 16.23000415, -1.495250616, -8.689340871, -1.495250616, -8.689340871, -8.689340871);
wNo6=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871, 1.41048489, 11.6925194, 16.23000415, -1.495250616, -8.689340871, -1.495250616, -8.689340871, -8.689340871);
wNs1=newArray(-18.56066502, 9.40843666, -13.79261213, -9.80E-05, 23.60182028, -17.09108371);
wNs2=newArray(-3.362178704, -11.2373124, 2.27163117, -10.3106268, -9.391666734, 16.18486692);
T=0;
contador=1;
for(e=0; e<frag*frames-1; e++)
	{
	if(e%frames==0)
		{
		for(i=e; i<e+frames; i++)
			{
			in=floor(e/frames);
			pv1[in]=pv1[in]+v1[i];		
			pv2[in]=pv2[in]+v2[i];	
			pv3[in]=pv3[in]+v3[i];	
			}
		pv1[in]=pv1[in]/frames; pv2[in]=pv2[in]/frames; pv3[in]=pv3[in]/frames;
		}
	PV1=(v1[e]+v1[e+1])/2; PV2=(v2[e]+v2[e+1])/2; PV3=(v3[e]+v3[e+1])/2;
	if(PV1==0) PV1=1; if(PV2==0) PV2=1; if(PV3==0) PV3=1;
	ipr[e]=255*(v3[e]+v3[e+1]+v2[e]+v2[e+1])/2;
	e1[e]=(v1[e]+v1[e+1])/2-pv1[floor(e/frames)];      //aumento de intensidad relativa al promedio en roi1
	e2[e]=(v2[e]+v2[e+1])/2-pv2[floor(e/frames)];      //aumento de intensidad relativa al promedio en roi2
	e3[e]=(v3[e]+v3[e+1])/2-pv3[floor(e/frames)];      //aumento de intensidad relativa al promedio en roi3
	e4[e]=v1[e]-v1[e+1];                       //aumento de intensidad en t2 respecto de t1 roi1
	e5[e]=v2[e+1]-v2[e];                        //aumento de intensidad en t2 respecto de t1 roi2
	e6[e]=v3[e+1]-v3[e];                        //aumento de intensidad en t2 respecto de t1 roi3
	e7[e]=v1[e]/PV2-v2[e]/PV1;                       //diferencia de intensidad en v1 respecto de v2 en t1
	e8[e]=v2[e]/PV2-v3[e]/PV3;                       //diferencia de intensidad en v2 respecto de v3 en t1
	e9[e]=v3[e]/PV3-v1[e]/PV1;                       //diferencia de intensidad en v1 respecto de v3 en t1
	e10[e]=v2[e+1]/PV1-v1[e+1]/PV2;                    //diferencia de intensidad en v1 respecto de v2 en t2
	e11[e]=v3[e+1]/PV2-v2[e+1]/PV3;                    //diferencia de intensidad en v2 respecto de v3 en t2
	e12[e]=v3[e+1]/PV1-v1[e+1]/PV3;                    //diferencia de intensidad en v1 respecto de v3 en t2
	sNo1=sigAbs(wNo1[0]*e1[e]+wNo1[1]*e2[e]+wNo1[2]*e3[e]+wNo1[3]*e4[e]+wNo1[4]*e5[e]+wNo1[5]*e6[e]+wNo1[6]*e7[e]+wNo1[7]*e8[e]+wNo1[8]*e9[e]+wNo1[9]*e10[e]+wNo1[10]*e11[e]+wNo1[11]*e12[e], 3.567);
	sNo2=sigAbs(wNo2[0]*e1[e]+wNo2[1]*e2[e]+wNo2[2]*e3[e]+wNo2[3]*e4[e]+wNo2[4]*e5[e]+wNo2[5]*e6[e]+wNo2[6]*e7[e]+wNo2[7]*e8[e]+wNo2[8]*e9[e]+wNo2[9]*e10[e]+wNo2[10]*e11[e]+wNo2[11]*e12[e], 3.567);
    sNo3=sigAbs(wNo3[0]*e1[e]+wNo3[1]*e2[e]+wNo3[2]*e3[e]+wNo3[3]*e4[e]+wNo3[4]*e5[e]+wNo3[5]*e6[e]+wNo3[6]*e7[e]+wNo3[7]*e8[e]+wNo3[8]*e9[e]+wNo3[9]*e10[e]+wNo3[10]*e11[e]+wNo3[11]*e12[e], 3.567);
	sNo4=sigAbs(wNo4[0]*e1[e]+wNo4[1]*e2[e]+wNo4[2]*e3[e]+wNo4[3]*e4[e]+wNo4[4]*e5[e]+wNo4[5]*e6[e]+wNo4[6]*e7[e]+wNo4[7]*e8[e]+wNo4[8]*e9[e]+wNo4[9]*e10[e]+wNo4[10]*e11[e]+wNo4[11]*e12[e], 3.567);
	sNo5=sigAbs(wNo5[0]*e1[e]+wNo5[1]*e2[e]+wNo5[2]*e3[e]+wNo5[3]*e4[e]+wNo5[4]*e5[e]+wNo5[5]*e6[e]+wNo5[6]*e7[e]+wNo5[7]*e8[e]+wNo5[8]*e9[e]+wNo5[9]*e10[e]+wNo5[10]*e11[e]+wNo5[11]*e12[e], 3.567);
    sNo6=sigAbs(wNo6[0]*e1[e]+wNo6[1]*e2[e]+wNo6[2]*e3[e]+wNo6[3]*e4[e]+wNo6[4]*e5[e]+wNo6[5]*e6[e]+wNo6[6]*e7[e]+wNo6[7]*e8[e]+wNo6[8]*e9[e]+wNo6[9]*e10[e]+wNo6[10]*e11[e]+wNo6[11]*e12[e], 3.567);
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
	//if(contador==frames-1) {e++; contador=1;}
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
	print(f, (floor(i/frames)+1)+"\t    "+contador+"\t    "+sal[i]+"\t    "+ipr[i]);
	contador++;
	if(contador==frames)  contador=0;
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
		toti[i]=toti[i]+(v2[j]+v3[j])*255/frames/2;
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
print(f, "\\Headings: frag\t frame\t e1\t e2\t e3\t e4\t e5\t e6\t e7\t e8\t e9\t e10\t e11\t e12");

contador=1;
for(e=0; e<frames*frag-1; e++)
	{
	in=floor(e/frames);
	print(f, (in+1)+"\t    "+contador+"\t    "+e1[e]+"\t    "+e2[e]+"\t    "+e3[e]+"\t    "+e4[e]+"\t   "+e5[e]+"\t    "+e6[e]+"\t    "+e7[e]+"\t    "+e8[e]+"\t   "+e9[e]+"\t    "+e10[e]+"\t    "+e11[e]+"\t   "+e12[e]);
	print(f, (in+1)+"\t    "+contador+"\t    "+v1[e]+"\t    "+v2[e]+"\t    "+v3[e]+"\t    "+v1[e+1]+"\t    "+v2[e+1]+"\t    "+v3[e+1]+"\t    "+pv1[in]+"\t    "+pv2[in]+"\t    "+pv3[in]);
	contador++;
	if(contador==frames)  contador=0;
	}	
}
}

/*
r4[e]=2*v4[e+3]+v4[e+2]-v4[e+1]-2*v4[e];   //no divido por proi xq comparo intensidades dentro del mismo roi
r3[e]=2*v3[e+3]+v3[e+2]-v3[e+1]-2*v3[e];
r2[e]=2*v2[e+3]+v2[e+2]-v2[e+1]-2*v2[e];
r1[e]=2*v1[e+3]+v1[e+2]-v1[e+1]-2*v1[e];*/
