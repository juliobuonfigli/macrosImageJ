
macro "FuFi [f]" {

function sigAbs(value, bias) {
e=2.71828;
g=(value+bias);
r=1/(1+pow(e, -1*g));
return r;
}

function poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, pot) {
xa=pow(fA2, pot)*(ow/2)*cos(t+sepin*dt)+CX[j];
ya=pow(fA2, pot)*(oh/2)*sin(t+sepin*dt)+CY[j];
xb=pow(fA2, pot)*(ow/2)*cos(t+dt)+CX[j];
yb=pow(fA2, pot)*(oh/2)*sin(t+dt)+CY[j];
xc=pow(fA2, pot)*(ow/2)*cos(t+(2-sepin)*dt)+CX[j];
yc=pow(fA2, pot)*(oh/2)*sin(t+(2-sepin)*dt)+CY[j];
XA=pow(fA2, pot)*fA*(ow/2)*cos(t+sepex*dt)+CX[j];
YA=pow(fA2, pot)*fA*(oh/2)*sin(t+sepex*dt)+CY[j];
XB=pow(fA2, pot)*fA*(ow/2)*cos(t+dt)+CX[j];
YB=pow(fA2, pot)*fA*(oh/2)*sin(t+dt)+CY[j];
XC=pow(fA2, pot)*fA*(ow/2)*cos(t+(2-sepex)*dt)+CX[j];
YC=pow(fA2, pot)*fA*(oh/2)*sin(t+(2-sepex)*dt)+CY[j];
makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
}

function igualar(w, h, frames) {
selectWindow("Final");
size=1/(w*h);
ipp=newArray(frames);
for(i=1; i<frames; i++)
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
for(i=1; i<frames; i++)
	ip=ip+ipp[i];
ip=ip/frames;

for(i=1; i<frames; i++)
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
for(i=1; i<frames; i++)
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
  Dialog.addCheckbox("Cell drift", true); 
    //Dialog.addNumber("Origin: ", 0);
  Dialog.addCheckbox("Equalization", true); 
  Dialog.addCheckbox("Thresholding", true); 
  Dialog.addNumber("Threshold: ", 0);  
  Dialog.addCheckbox("Unsharp Mask", true); 
  Dialog.addNumber("radius: ", 4);
  Dialog.addNumber("mask weight (0-1): ", 0.8);
  Dialog.addNumber("Step delay: ", 0);
  Dialog.addCheckbox("More options", true);  //fragmentacion y demás y opciones de drift
 Dialog.show();

                                               
  img=Dialog.getChoice(); 
  drift=Dialog.getCheckbox(); 
    //Dialog.addNumber("Origin: ", 0);
  eq=Dialog.getCheckbox(); 
  Thresholding=Dialog.getCheckbox(); 
  threshold=Dialog.getNumber();  
  um=Dialog.getCheckbox(); 
  radius=Dialog.getNumber();
  mw=Dialog.getNumber();
  sd=Dialog.getNumber();
  mo=Dialog.getCheckbox();  //fragmentacion y demás y opciones de drift

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
frag=24;                      //fragmentación de anillos. 
dt=pi/frag;                //intervalo
fA=1.10;                     //espesor de anillo
fA2=1.06;                  //separacion entre anillos internos y externo
sepin=0;               //separacion entre segmentos de anillo interno
sepex=0;               //separación entre vertices externos del anillo externo
t=0;

if(eq==true) igualar(w, h, frames);
if(Thresholding==true) umbral(w, h, frames, threshold);
if(um==true) run("Unsharp Mask...", "radius=radius mask=mw stack");

CX=newArray(frames+1);
CY=newArray(frames+1);
if(drift==true)
{
selectWindow("Final");                 
run("Select None");
run("Duplicate...", "title=Nodo duplicate");
run("Unsharp Mask...", "radius=12 mask=0.99 stack");
setAutoThreshold("Minimum dark");
setOption("BlackBackground", false);
run("Convert to Mask", "method=Minimum background=Dark calculate");
ZZ=1.15;
makeOval(cx-ZZ*ow/2, cy-ZZ*oh/2, ZZ*ow, ZZ*oh);
run("Make Inverse");
setForegroundColor(0, 0, 0);
for(i=1; i<frames; i++)
	{
	setSlice(i);
	run("Fill", "slice");
	}
run("Select None");
run("Median...", "radius=1 stack");
run("Invert", "stack");
//run("Close-", "stack");
run("Fill Holes", "stack");
run("Watershed", "stack");
run("Invert", "stack");
run("Set Measurements...", "centroid redirect=None decimal=2");
for(i=1; i<frames; i++)
	{
	setSlice(i);
	//doWand(CX[i-1], CY[i-1]);
	doWand(cx, cy);
	run("Measure");
	CX[i]=getResult("X", i-1);
	CX[i]=round(CX[i]);
	CY[i]=getResult("Y", i-1);
	CY[i]=round(CY[i]);
	//wait(60);
	}
selectWindow("Nodo");
//close();
run("Clear Results");
}
else
{
for(i=1; i<frames; i++)
	{
	CX[i]=cx;
	CY[i]=cy;
	}
}
v1=newArray(frag*frames);
v2=newArray(frag*frames);
v3=newArray(frag*frames);
v4=newArray(frag*frames);
v5=newArray(frag*frames);
cont=0;
run("Set Measurements...", "mean redirect=None decimal=2");
selectWindow("Final");
for(i=1; i<frag+1; i++)     // lazo principal
	{
	run("Select None");
	for(j=1; j<frames+1; j++)   //lazo de cuadrante interno
		{
		setSlice(j);
		run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, 0);
		if(j==1)
			roiManager("Add");
		run("Measure");   
		v1[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); 	wait(sd); 	run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, 1);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v2[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, 2);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v3[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY, t, dt, ow, oh, j, 3);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v4[cont]=getResult("Mean", 0)/255;
		run("Clear Results"); wait(sd); run("Select None");
		poligono(fA, fA2, sepin, sepex, CX, CY,  t, dt, ow, oh, j, 4);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v5[cont]=getResult("Mean", 0)/255;
		run("Clear Results");  	wait(sd);
			
		cont++;
	}	
	t=t+2*dt;
}


c=1; fra=0; ev=newArray(frag*frames); ev2=newArray(frag*frames); intensity=newArray(frag*frames);
for(u=0; u<frag*frames; u++) {ev[u]=" "; ev2[u]=false;}
pv1=newArray(frag); pv2=newArray(frag); pv3=newArray(frag); pv4=newArray(frag); pv5=newArray(frag); 
e1=newArray(frames*frag); e2=newArray(frames*frag); e3=newArray(frames*frag); e4=newArray(frames*frag); e5=newArray(frames*frag);
sNs1=newArray(frag*frames); sNs2=newArray(frag*frames);
wNo1=newArray(1.41048489, 11.6925194, 16.23000415, -1.495250616, -8.689340871);
wNo2=newArray(2.401749739, 0.650716212, -5.243532395, 0.140313413, -8.513481183);
wNo3=newArray(-9.779507179, -7.589617905, 0.894865575, -1.389431689, 5.582333642);
wNo4=newArray(-0.16805141, 0.423205808, -1.891469006, -2.908314165, -7.859153891);
wNo5=newArray(11.94699294, 12.15373475, -0.695677487, 0.474109979, -8.041466367);
wNo6=newArray(7.295568068, 2.529261972, 3.344605181, 15.10882652, 24.52248083);
wNs1=newArray(-18.56066502, 9.40843666, -13.79261213, -9.80E-05, 23.60182028, -17.09108371);
wNs2=newArray(-3.362178704, -11.2373124, 2.27163117, -10.3106268, -9.391666734, 16.18486692);

titulo1 = "Results";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if(isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings: Quadrant\t Frame\t Event\t Intensity");

for(e=0; e<frames*frag; e++)
	{
	if(e%frames==0) 
		{
		/*pv1[fra]=0; pv2[fra]=0; pv3[fra]=0; pv4[fra]=0; pv5[fra]=0;
			for(i=e; i<e+frames; i++) {
				pv1[fra]=pv1[fra]+v1[i]; pv2[fra]=pv2[fra]+v2[i]; pv3[fra]=pv3[fra]+v3[i]; pv4[fra]=pv4[fra]+v4[i]; pv5[fra]=pv5[fra]+v5[i];   }
			pv1[fra]=pv1[fra]/frames; pv2[fra]=pv2[fra]/frames; pv3[fra]=pv3[fra]/frames; pv4[fra]=pv4[fra]/frames; pv5[fra]=pv5[fra]/frames;	
		print(pv1[fra]+"   "+pv2[fra]+"   "+pv3[fra]+"   "+pv4[fra]+"   "+pv5[fra]);
		fra++;*/		c++;
		}
		else 
		{		
		intensity[e]=(v2[e]+v3[e]+v4[e]+v5[e])*255/4;
		e5[e]=(v5[e]-v5[e-1]);
		e4[e]=(v4[e]-v4[e-1]);
		e3[e]=(v3[e]-v3[e-1]);
		e2[e]=(v2[e]-v2[e-1]);
		e1[e]=(v1[e]-v1[e-1]);
		sNo1=sigAbs(wNo1[0]*e1[e]+wNo1[1]*e2[e]+wNo1[2]*e3[e]+wNo1[3]*e4[e]+wNo1[4]*e5[e], 3.567);
		sNo2=sigAbs(wNo2[0]*e1[e]+wNo2[1]*e2[e]+wNo2[2]*e3[e]+wNo2[3]*e4[e]+wNo2[4]*e5[e], 1.089);
		sNo3=sigAbs(wNo3[0]*e1[e]+wNo3[1]*e2[e]+wNo3[2]*e3[e]+wNo3[3]*e4[e]+wNo3[4]*e5[e], -0.24);
		sNo4=sigAbs(wNo4[0]*e1[e]+wNo4[1]*e2[e]+wNo4[2]*e3[e]+wNo4[3]*e4[e]+wNo4[4]*e5[e], 0.843);
		sNo5=sigAbs(wNo5[0]*e1[e]+wNo5[1]*e2[e]+wNo5[2]*e3[e]+wNo5[3]*e4[e]+wNo5[4]*e5[e], 0.509);
		sNo6=sigAbs(wNo6[0]*e1[e]+wNo6[1]*e2[e]+wNo6[2]*e3[e]+wNo6[3]*e4[e]+wNo6[4]*e5[e], 1.497);
		sNs1[e]=sigAbs(sNo1*wNs1[0]+sNo2*wNs1[1]+sNo3*wNs1[2]+sNo4*wNs1[3]+sNo5*wNs1[4]+sNo6*wNs1[5], -0.131);
		sNs2[e]=sigAbs(sNo1*wNs2[0]+sNo2*wNs2[1]+sNo3*wNs2[2]+sNo4*wNs2[3]+sNo5*wNs2[4]+sNo6*wNs2[5], -0.297);
		
		if(sNs1[e]>0.5 || sNs2[e]>0.5) {
			ev2[e]=true;
			if(sNs1[e]>0.5 && sNs2[e]<0.5) {
				ev[e]="fU";}
				else {
				if(sNs1[e]<0.5 && sNs2[e]>0.5) {
					ev[e]="fI"; }
					else {
					ev[e]="NC"; }}
			print(f, (floor(e/frames)+1)+"\t    "+c+"\t    "+ev[e]+"\t    "+intensity[e]);
			}
			else {ev[e]=" "; }
		if(c>frames-1)  c=1; 	else 	c++; 	
		}
	}	

titulo3 = "Summary";                                            
titulo4 = "["+titulo3+"]";
  b = titulo4;
 if(isOpen(titulo4))
    print(b, "\\Clear");
 else
run("Table...", "name="+titulo3+" width=250 height=600");
print(b, "\\Headings: Quadrant\t Fusions\t Fisions\t Signal Density");

for(i=1; i<frames*frag; i++) {
	if(ev2[i-1]==true && ev2[i]==true && (i-1)%frames!=0)
		ev2[i-1]=false; }

toti=newArray(frag*frames);
/*for(fra=0; fra<frag; fra++)
	{
	//pv1[fra]=0; pv2[fra]=0; pv3[fra]=0; pv4[fra]=0; pv5[fra]=0;	
	toti[fra]=0;
	for(i=fra*frames; i<fra*frames+frames; i++)
		{
		/*pv1[fra]=pv1[fra]+v1[i]; 
		pv2[fra]=pv2[fra]+v2[i]; 
		pv3[fra]=pv3[fra]+v3[i];
		pv4[fra]=pv4[fra]+v4[i]; 
		pv5[fra]=pv5[fra]+v5[i];
		toti[fra]=toti[fra]+v2[i];//+v3[i]+v4[i]+v5[i];
		}
	//toti[fra]=toti[fra]/(frames*4);
	print(toti[fra]);
	//pv1[fra]=pv1[fra]/frames; pv2[fra]=pv2[fra]/frames; pv3[fra]=pv3[fra]/frames; pv4[fra]=pv4[fra]/frames; pv5[fra]=pv5[fra]/frames;	
	//fra++;
	}*/


totFus=0; totFis=0;
for(i=0; i<frag; i++)
	{
	fusiones=0; fisiones=0; toti[i]=0; 
	for(j=i*frames+1; j<i*frames+frames; j++)
		{
		if(ev2[j]==true) 
			{
			if(ev[j]=="fU") fusiones++;	
			if(ev[j]=="fI") fisiones++;	
			}
		toti[i]=toti[i]+v2[j];
		}
	totFus=totFus+fusiones;
	totFis=totFis+fisiones;
	print(b, i+1+"\t    "+fusiones+"\t    "+fisiones+"\t    "+toti[i]);
	}
print(b, "Total"+"\t    "+totFus+"\t    "+totFis+"\t    "+"*********");
}


