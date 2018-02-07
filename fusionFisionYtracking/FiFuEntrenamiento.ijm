
run("Set Measurements...", "centroid bounding redirect=None decimal=0");
run("Measure");
cx=getResult("X", 0);
cy=getResult("Y", 0);
ow=getResult("Width", 0);
oh=getResult("Height", 0);
run("Clear Results"); 
run("Select None");
run("8-bit");
w=getWidth();          //Cuidado!!! la pise mas abajo           
h=getHeight();

wai=true;
wai=false;
movimiento=true;
frames=61;
pi=3.141592653589793; 
frag=24;                      //fragmentación de anillos. 
dt=pi/frag;                //intervalo
fA=1.10;                     //espesor de anillo
fA2=1.06;                  //separacion entre anillos internos y externo
sepin=0;
//sepin=0.05;               //separacion entre segmentos de anillo interno
sepex=0;
//sepex=0.4;               //separación entre vertices externos del anillo externo
Fagran=1.12;            //Factor de agrandamiento de ovalo para encerrar inclusion con membrana

t=0;
rename("Final");

// Centroide de inclusion  una serie de tratamientos y measurements buscan el centro de la inclusion para que los cuadrantes se muevan coordinadamente con la membrana de la inclusion
CX=newArray(frames+1);
CY=newArray(frames+1);
if(movimiento==true)
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
for(i=1; i<frames+1; i++)
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
for(i=1; i<frames+1; i++)
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
for(i=1; i<frames+1; i++)
	{
	CX[i]=cx;
	CY[i]=cy;
	}
}
//Fin de centroide de inclusion

//Tratamiento final de la imagen
//selectWindow("Final");
//run("Unsharp Mask...", "radius=4 mask=0.82 stack");

//Perfiles
//en sentido horario desde las 3
//run("Plots...", "width=450 height=200 font=12 draw draw_ticks auto-close fixed minimum=0 maximum=3");
run("Set Measurements...", "mean redirect=None decimal=2");
run("ROI Manager...");
selectWindow("ROI Manager");
run("Close");
run("ROI Manager...");

v1=newArray(frag*frames);
v2=newArray(frag*frames);
v3=newArray(frag*frames);
v4=newArray(frag*frames);
v5=newArray(frag*frames);
cont=0;

selectWindow("Final");
for(i=1; i<frag+1; i++)     // lazo principal
	{
	run("Select None");
	for(j=1; j<frames+1; j++)   //lazo de cuadrante interno
		{
		//selectWindow("Final");
		setSlice(j);
		run("Select None");
		xa=(ow/2)*cos(t+sepin*dt)+CX[j];
		ya=(oh/2)*sin(t+sepin*dt)+CY[j];
		xb=(ow/2)*cos(t+dt)+CX[j];
		yb=(oh/2)*sin(t+dt)+CY[j];
		xc=(ow/2)*cos(t+(2-sepin)*dt)+CX[j];
		yc=(oh/2)*sin(t+(2-sepin)*dt)+CY[j];
		XA=fA*(ow/2)*cos(t+sepin*dt)+CX[j];
		YA=fA*(oh/2)*sin(t+sepin*dt)+CY[j];
		XB=fA*(ow/2)*cos(t+dt)+CX[j];
		YB=fA*(oh/2)*sin(t+dt)+CY[j];
		XC=fA*(ow/2)*cos(t+(2-sepin)*dt)+CX[j];
		YC=fA*(oh/2)*sin(t+(2-sepin)*dt)+CY[j];
		makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
		if(j==1)
			roiManager("Add");
		run("Measure");   
		v1[cont]=getResult("Mean", 0)/255;
		run("Clear Results");
		if(wai==true)
			wait(30);
		run("Select None");
		//selectWindow("Final");
		xa=fA2*(ow/2)*cos(t+sepin*dt)+CX[j];
		ya=fA2*(oh/2)*sin(t+sepin*dt)+CY[j];
		xb=fA2*(ow/2)*cos(t+dt)+CX[j];
		yb=fA2*(oh/2)*sin(t+dt)+CY[j];
		xc=fA2*(ow/2)*cos(t+(2-sepin)*dt)+CX[j];
		yc=fA2*(oh/2)*sin(t+(2-sepin)*dt)+CY[j];
		XA=fA2*fA*(ow/2)*cos(t+sepex*dt)+CX[j];
		YA=fA2*fA*(oh/2)*sin(t+sepex*dt)+CY[j];
		XB=fA2*fA*(ow/2)*cos(t+dt)+CX[j];
		YB=fA2*fA*(oh/2)*sin(t+dt)+CY[j];
		XC=fA2*fA*(ow/2)*cos(t+(2-sepex)*dt)+CX[j];
		YC=fA2*fA*(oh/2)*sin(t+(2-sepex)*dt)+CY[j];
		makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v2[cont]=getResult("Mean", 0)/255;
		run("Clear Results");
		if(wai==true)
			wait(30);
		run("Select None");
		//selectWindow("Final");
		xa=fA2*fA2*(ow/2)*cos(t+sepin*dt)+CX[j];
		ya=fA2*fA2*(oh/2)*sin(t+sepin*dt)+CY[j];
		xb=fA2*fA2*(ow/2)*cos(t+dt)+CX[j];
		yb=fA2*fA2*(oh/2)*sin(t+dt)+CY[j];
		xc=fA2*fA2*(ow/2)*cos(t+(2-sepin)*dt)+CX[j];
		yc=fA2*fA2*(oh/2)*sin(t+(2-sepin)*dt)+CY[j];
		XA=fA2*fA2*fA*(ow/2)*cos(t+sepex*dt)+CX[j];
		YA=fA2*fA2*fA*(oh/2)*sin(t+sepex*dt)+CY[j];
		XB=fA2*fA2*fA*(ow/2)*cos(t+dt)+CX[j];
		YB=fA2*fA2*fA*(oh/2)*sin(t+dt)+CY[j];
		XC=fA2*fA2*fA*(ow/2)*cos(t+(2-sepex)*dt)+CX[j];
		YC=fA2*fA2*fA*(oh/2)*sin(t+(2-sepex)*dt)+CY[j];
		makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v3[cont]=getResult("Mean", 0)/255;
		run("Clear Results");
		if(wai==true)
			wait(30);
		//run("Select None");
		run("Select None");
		//selectWindow("Final");
		xa=fA2*fA2*fA2*(ow/2)*cos(t+sepin*dt)+CX[j];
		ya=fA2*fA2*fA2*(oh/2)*sin(t+sepin*dt)+CY[j];
		xb=fA2*fA2*fA2*(ow/2)*cos(t+dt)+CX[j];
		yb=fA2*fA2*fA2*(oh/2)*sin(t+dt)+CY[j];
		xc=fA2*fA2*fA2*(ow/2)*cos(t+(2-sepin)*dt)+CX[j];
		yc=fA2*fA2*fA2*(oh/2)*sin(t+(2-sepin)*dt)+CY[j];
		XA=fA2*fA2*fA2*fA*(ow/2)*cos(t+sepex*dt)+CX[j];
		YA=fA2*fA2*fA2*fA*(oh/2)*sin(t+sepex*dt)+CY[j];
		XB=fA2*fA2*fA2*fA*(ow/2)*cos(t+dt)+CX[j];
		YB=fA2*fA2*fA2*fA*(oh/2)*sin(t+dt)+CY[j];
		XC=fA2*fA2*fA2*fA*(ow/2)*cos(t+(2-sepex)*dt)+CX[j];
		YC=fA2*fA2*fA2*fA*(oh/2)*sin(t+(2-sepex)*dt)+CY[j];
		makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v4[cont]=getResult("Mean", 0)/255;
		run("Clear Results");
		if(wai==true)
			wait(30);
		run("Select None");
		//selectWindow("Final");
		xa=fA2*fA2*fA2*fA2*(ow/2)*cos(t+sepin*dt)+CX[j];
		ya=fA2*fA2*fA2*fA2*(oh/2)*sin(t+sepin*dt)+CY[j];
		xb=fA2*fA2*fA2*fA2*(ow/2)*cos(t+dt)+CX[j];
		yb=fA2*fA2*fA2*fA2*(oh/2)*sin(t+dt)+CY[j];
		xc=fA2*fA2*fA2*fA2*(ow/2)*cos(t+(2-sepin)*dt)+CX[j];
		yc=fA2*fA2*fA2*fA2*(oh/2)*sin(t+(2-sepin)*dt)+CY[j];
		XA=fA2*fA2*fA2*fA2*fA*(ow/2)*cos(t+sepex*dt)+CX[j];
		YA=fA2*fA2*fA2*fA2*fA*(oh/2)*sin(t+sepex*dt)+CY[j];
		XB=fA2*fA2*fA2*fA2*fA*(ow/2)*cos(t+dt)+CX[j];
		YB=fA2*fA2*fA2*fA2*fA*(oh/2)*sin(t+dt)+CY[j];
		XC=fA2*fA2*fA2*fA2*fA*(ow/2)*cos(t+(2-sepex)*dt)+CX[j];
		YC=fA2*fA2*fA2*fA2*fA*(oh/2)*sin(t+(2-sepex)*dt)+CY[j];
		makePolygon(xa,ya,xb,yb,xc,yc,XC,YC,XB,YB,XA,YA);
		if(j==1)
			roiManager("Add");
		run("Measure");
		v5[cont]=getResult("Mean", 0)/255;
		run("Clear Results");
		if(wai==true)
			wait(30);
			
		cont++;
	}	
	t=t+2*dt;
}

c=1;

titulo1 = "Results";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if (isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");

print(f, "\\Headings: n1\t n2\t n3\t n4\t n5");

for(r=0; r<frag*frames-1; r++) {
		if(r%frames==0) {
			//print("--------------"+((r/frames)+1)+"--------------");
			pv1=0; 	pv2=0; 	pv3=0; pv4=0; pv5=0;
			for(i=r; i<r+frames; i++) {
				pv1=pv1+v1[i]; 	pv2=pv2+v2[i]; 	pv3=pv3+v3[i]; pv4=pv4+v4[i]; 	pv5=pv5+v5[i];   }
			pv1=pv1/frames;	pv2=pv2/frames; pv3=pv3/frames;	pv4=pv4/frames; pv5=pv5/frames;	
		//print(pvi+"       "+pvm+"      "+pve);	
		if(pv1==0){pv1=1;}
		if(pv2==0){pv2=1;}
		if(pv3==0){pv3=1;}
		if(pv4==0){pv4=1;}
		if(pv5==0){pv5=1;}
		c++;
		}	
		else {	
		//print(f, pvi+"\t    "+pvm+"\t    "+pve);
		/*en1=(vi[r]/pvi)-(vi[r-1]/pvi);
		en2=(vm[r]/pvm)-(vm[r-1]/pvm);
		en3=(ve[r-1]/pve)-(ve[r]/pve);*/
		/*en5=(v5[r]/pv5-v5[r-1]/pv5);//+(v5[r-1]/pv5-v5[r]/pv5)+(v5[r]/pv5-v5[r+1]/pv5);
		en4=(v4[r]/pv4-v4[r-1]/pv4);//+(v4[r-1]/pv4-v4[r]/pv4)+(v5[r]/pv4-v4[r+1]/pv4);
		en3=(v3[r]/pv3-v3[r-1]/pv3);//+(v3[r-1]/pv3-v3[r]/pv3)+(v3[r]/pv3-v3[r+1]/pv3);
		en2=(v2[r]/pv2-v2[r-1]/pv2);//+(v2[r-1]/pv2-v2[r]/pv2)+(v2[r]/pv2-v2[r+1]/pv2);
		en1=(v1[r]/pv1-v1[r-1]/pv1);//+(v1[r-1]/pv1-v1[r]/pv1)+(v1[r]/pv1-v1[r+1]/pv1);*/
		en5=(v5[r]-v5[r-1]);//+(v5[r-1]/pv5-v5[r]/pv5)+(v5[r]/pv5-v5[r+1]/pv5);
		en4=(v4[r]-v4[r-1]);//+(v4[r-1]/pv4-v4[r]/pv4)+(v5[r]/pv4-v4[r+1]/pv4);
		en3=(v3[r]-v3[r-1]);//+(v3[r-1]/pv3-v3[r]/pv3)+(v3[r]/pv3-v3[r+1]/pv3);
		en2=(v2[r]-v2[r-1]);//+(v2[r-1]/pv2-v2[r]/pv2)+(v2[r]/pv2-v2[r+1]/pv2);
		en1=(v1[r]-v1[r-1]);//+(v1[r-1]/pv1-v1[r]/pv1)+(v1[r]/pv1-v1[r+1]/pv1);
		//en3=(ve[r-1])-(ve[r]);
		//en4=(vi[r]/pve)-(ve[r]/pve);
		pelo=newArray(en1, en2, en3, en4, en5);
		cond1=false; cond2=false; cond=false;
		for(uu=0; uu<5; uu++) {
			if(pelo[uu]>0.18) cond1=true;
			if(pelo[uu]<-0.18) cond2=true; }
		if(cond1==true || cond2==true) cond=true;
		if(cond==true) {
			print(f, floor((r/frames)+1)+"\t  "+c);//+"\t  "+"-------"); //+"\t  "+"-------");
			print(f, en1+"\t    "+en2+"\t    "+en3+"\t    "+en4+"\t    "+en5); }
 	if(c>frames-1) 
 		c=1;
 		else
 		c++;
 	}}
	