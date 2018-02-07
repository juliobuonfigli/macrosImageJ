//cuatro rois, dos tiempos, funciones de peso
//puede hacerse sin hacer redes, clasifica evento y por otro lado si es fisión o fusión, vuelven los no calificados, 3 neuronas de salida (una para evento o no evento)


macro "FuFi [f]" {

function mult(img, w, h, frames, coeficiente) {
MAX=60;
cond=true;
UM=3;
valor=6;
selectImage(img);
run("Duplicate...", "duplicate");
rename("inicial");
run("Set Measurements...", "mean min redirect=None decimal=2");
selectWindow("inicial");
run("Select None");
run("Measure");
max=getResult("Max", 0);
min=getResult("Min", 0);
for(i=1; i<frames+1; i++)
	{
	setSlice(i);
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	p=getPixel(x, y);
	 	setPixel(x, y, round(((p-min)*MAX)/(max-min))+1);
	 	}	
	  }
	}
newImage("multiplicador", "8-bit black", w, h, frames);
p1=newArray(w*h);
p2=newArray(w*h);
for(i=1; i<frames; i++)
	{
	selectWindow("inicial");
	j=0;
	setSlice(i);
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	p1[j]=getPixel(x, y);
	 	j++;
	 	}	
	  }
	 setSlice(i+1); j=0;
	 for(y=0; y<h; y++)
   	 	{
	 	 for(x=0; x<w; x++)
			{	 	
	 		p2[j]=getPixel(x, y);
	 		j++;
			}	
	  	}
	selectWindow("multiplicador");
	setSlice(i+1);
	j=0;
	for(y=0; y<h; y++)
   	 {
	 for(x=0; x<w; x++)
	 	{
	 	if(cond==true) {
	 		if(p2[j]/p1[j]>UM-1)
	 			setPixel(x, y, valor);
	 			else
	 			setPixel(x, y, 1);
	 			} else {
	 	setPixel(x, y, coeficiente*p2[j]/p1[j]+1); }
   	    j++;
   	    }
	}
}
selectWindow("multiplicador");
setSlice(1);
run("Add...", "value=1 slice");
imageCalculator("Multiply stack", "inicial","multiplicador");
selectWindow("multiplicador");
close();
}



function sigAbs(value, bias) {
e=2.71828;
g=(value+bias);
r=1/(1+pow(e, -1*g));
return r;
}

dd=0; //agrandamiento de ovalo
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

function cbrt(w)                     
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
 Dialog.addNumber("Vesicle velocity:", 1.2);
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
  coeficiente=Dialog.getNumber();
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


if(eq==true) igualar(w, h, frames);
//if(Thresholding==true) umbral(w, h, frames, threshold);
if(um==true) run("Unsharp Mask...", "radius=radius mask=mw stack");

pi=3.141592653589793; 
perimetro=pi*(3*((ow+oh)/2)-sqrt((3*oh/2+ow/2)*(3*ow/2+oh/2)));  //perimetro de la elipse externa
frag=round(perimetro/vd);
dt=pi/frag;                      //intervalo
esp=1.22;                            //espesor de anillo
umbEvento=60;
t=0;

mult(img, w, h, frames, coeficiente);
event=newArray(frag*frames); for(i=0; i<frames*frag; i++) event[i]=false;   
dx=dx/frames; dy=dy/frames; cont=0;
selectWindow("inicial");
for(i=1; i<frag+1; i++)     
	{
	DX=0; DY=0;
	for(j=1; j<frames+1; j++)   
		{
		DX=DX+dx;  DY=DY-dy;
		setSlice(j);
		run("Select None");
		poligono(esp, 1, cx, cy, t, dt, ow, oh, j, true, DX, DY); 
		run("Measure");
		sonda=getResult("Mean", 0);
		run("Clear Results"); 	
		if(sonda>umbEvento) { event[cont]=true; event[cont-1]=true; }
		cont++;
		}	
	t=t+2*dt;
	}	

v1=newArray(frag*frames); v2=newArray(frag*frames); v3=newArray(frag*frames); v4=newArray(frag*frames); 
cont=0;
run("Set Measurements...", "mean min redirect=None decimal=2");
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
		poligono(esp, 1, cx, cy, t, dt, ow, oh, j, true, DX, DY); 
		run("Measure");
		if(j==1)
			roiManager("Add");
		v1[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); 	wait(sd); 	run("Select None");
		poligono(cbrt(esp), esp, cx, cy, t-0.4*dt, 1.4*dt, ow, oh, j, false, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v3[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(cbrt(esp), esp*cbrt(esp), cx, cy, t-0.4*dt, 1.4*dt, ow, oh, j, false, DX, DY);
		run("Measure");
		if(j==1)
			roiManager("Add");
		v4[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd);  run("Select None");
		poligono(cbrt(esp), esp*cbrt(esp)*cbrt(esp), cx, cy, t-0.4*dt, 1.4*dt, ow, oh, j, false, DX, DY);
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
e5=newArray(frames*frag); e6=newArray(frames*frag); e7=newArray(frames*frag); e8=newArray(frames*frag); 
sal=newArray(frag*frames); ev=newArray(frames*frag); for(i=0; i<frag*frames; i++) {ev[i]=false; sal[i]=0;}
pv1=newArray(frag); pv2=newArray(frag); pv3=newArray(frag); pv4=newArray(frag); 

wNo1=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871);
wNo2=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871);
wNo3=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871);
wNo4=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871);
wNo5=newArray(11.6925194, 16.23000415, -1.495250616, -8.689340871);
wNs1=newArray(-18.56066502, 9.40843666, -13.79261213, -9.80E-05, 23.60182028, -17.09108371);
wNs2=newArray(-3.362178704, -11.2373124, 2.27163117, -10.3106268, -9.391666734, 16.18486692);
T=0;
contador=1;
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
	
	e1[e]=log(v1[e]/v1[e+1]);                      
	e2[e]=2*v1[e]/v1[e+1]+v2[e]/v2[e+1]-v3[e]/v3[e+1]-2*v4[e]/v4[e+1];                              
	e3[e]=2*(v1[e]-v1[e+1])+(v2[e]-v2[e+1])-(v3[e]-v3[e+1])-2*(v4[e]-v4[e+1]);                              
	e4[e]=2*(v1[e]-v1[e+1])/pv1[in]+(v2[e]-v2[e+1])/pv2[in]-(v3[e]-v3[e+1])/pv3[in]-2*(v4[e]-v4[e+1])/pv4[in];   
	e5[e]=v1[e]/v1[e+1]-(v2[e]+v3[e]+v4[e])/(v2[e+1]+v3[e+1]+v4[e+1]);   
	e6[e]=v1[e]/v1[e+1]-v4[e]/v4[e+1];      
	e7[e]=v2[e]/v2[e+1]-v4[e]/v4[e+1];   
	e8[e]=(v2[e]/v2[e+1])/pv2[in]-(v4[e]/v4[e+1])/pv4[in];               
	sNo1=sigAbs(wNo1[0]*e1[e]+wNo1[1]*e2[e]+wNo1[2]*e3[e]+wNo1[3]*e4[e], 3.567);
	sNo2=sigAbs(wNo2[0]*e1[e]+wNo2[1]*e2[e]+wNo2[2]*e3[e]+wNo2[3]*e4[e], 3.567);
    sNo3=sigAbs(wNo3[0]*e1[e]+wNo3[1]*e2[e]+wNo3[2]*e3[e]+wNo3[3]*e4[e], 3.567);
	sNo4=sigAbs(wNo4[0]*e1[e]+wNo4[1]*e2[e]+wNo4[2]*e3[e]+wNo4[3]*e4[e], 3.567);
	sNo5=sigAbs(wNo5[0]*e1[e]+wNo5[1]*e2[e]+wNo5[2]*e3[e]+wNo5[3]*e4[e], 3.567);
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
print(f, "\\Headings: frag\t frame\t e1\t e2\t e3\t e4\t e5\t e6\t e7\t e8");

contador=1;
for(e=0; e<frames*frag-1; e++)
	{
	in=floor(e/frames);
	if(event[e]==true)
	print(f, (in+1)+"\t    "+contador+"\t    "+e1[e]+"\t    "+e2[e]+"\t    "+e3[e]+"\t    "+e4[e]+"\t    "+e5[e]+"\t    "+e6[e]+"\t    "+e7[e]+"\t    "+e8[e]);
	
	//print(f, (in+1)+"\t    "+contador+"\t    "+v1[e]+"\t    "+v2[e]+"\t    "+v3[e]+"\t    "+v1[e+1]+"\t    "+v2[e+1]+"\t    "+v3[e+1]+"\t    "+m1[e]+"\t    "+m2[e]+"\t    "+m3[e]+"\t    "+m1[e+1]+"\t    "+m2[e+1]+"\t    "+m3[e+1]);
	//totos++;}
	contador++;
	if(contador==frames)  contador=0;
	}	
}

}