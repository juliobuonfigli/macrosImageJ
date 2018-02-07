//falsos positivos de fusiones: cuando las vesiculas pasan tangenciales a la membrana de la inclusion (no tendría solucion en este modelo)
//falsos negativos fusiones: si una vesicula pasa entremedio de dos cuadrantes (solucionable)
//falsos negativo fisiones: a veces no se registra un disminicion considerable de la intensidad de la membrana y este evento se toma como fusion

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
//wai=false;
movimiento=true;
frames=62;
pi=3.141592653589793; 
frag=12;                      //fragmentación de anillos. 
dt=pi/frag;                //intervalo
fA=1.115;                     //espesor de anillo
fA2=1.2;                  //separacion entre anillos internos y externo
sepin=0.05;               //separacion entre segmentos de anillo interno
sepex=0.4;               //separación entre vertices externos del anillo externo
Fagran=1.12;            //Factor de agrandamiento de ovalo para encerrar inclusion con membrana
//movimiento=false;        //calculo de coordenadas del centro de la inclusion

umbral=2.3;            //umbral general rojo (aceptación negra)
//umbralPR=2;            //multiplica el promedio general (aceptacion negra)  
umbralDVA=0.7;           //multiplica el promedio (aceptacion verde). 
umbralDRA=1.7;              //multiplica el promedio (aceptacion rojo)
umbralDVR=0.85;              //multiplica el promedio (rechazo verde)

//umbralDVA=1.2;           //multiplica la desviacion estandar (aceptacion verde). 
//umbralDRA=1.3;              //multiplica la desviacion estandar (aceptacion rojo)
//umbralDVR=0.9;              //multiplica la desviacion estandar (rechazo verde)
t=0;
rename("Final");

/*
//Normalizacion        normaliza la intensidadpromedio para que todos los frames tengan mas o menos la misma intensidad promedio
run("8-bit");
frames=62;
w=getWidth;              
h=getHeight;
size=1/(w*h);
ipp=newArray(frames);
rename("Final");
//rename("blanco");
//run("Duplicate...", "title=masc duplicate");
//run("Duplicate...", "title=Final duplicate");
//selectWindow("masc");
//setAutoThreshold("Default dark");
//setOption("BlackBackground", false);
//run("Convert to Mask", "method=Default background=Dark calculate black");
//imageCalculator("AND create stack", "blanco","masc");
//selectWindow("blanco");
//close();
//selectWindow("masc");
//close();


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

//selectWindow("Result of blanco");
//close();
selectWindow("Final");

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
// fin de normalizacion
*/



//calculo de la intesnidad promedio de todo el stack
umbralPrin=0;                                                     
run("Set Measurements...", "mean redirect=None decimal=3");
selectWindow("Final");
for(i=1; i<frames; i++)
	{
	setSlice(i);
	run("Measure");
	umbralPrin=umbralPrin+getResult("Mean", i-1)/255;
	}
run("Clear Results");
umbralPrin=(umbralPrin/(frames-1))*umbral;

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
//Fin de centroide de inclusion



//Tratamiento final de la imagen
selectWindow("Final");
//run("Mean...", "radius=2 stack");
//run("Maximum...", "radius=1 stack");
//run("Bandpass Filter...", "filter_large=10000 filter_small=8 suppress=None tolerance=5 process");
run("Unsharp Mask...", "radius=4 mask=0.82 stack");
/*  //tratamientos difereciados en la membrana y afuera de ella
for(i=1; i<frames; i++)
{
setSlice(i);
run("Select None");
makeOval(CX[i]-Fagran*ow/2, CY[i]-Fagran*oh/2, Fagran*ow, Fagran*oh);
run("Make Inverse");
run("Unsharp Mask...", "radius=2 mask=0.93");
//run("Make Inverse");
//run("Unsharp Mask...", "radius=0.5 mask=0.9");
}*/



//Perfiles
//en sentido horario desde las 3
//run("Plots...", "width=450 height=200 font=12 draw draw_ticks auto-close fixed minimum=0 maximum=3");
run("Set Measurements...", "mean redirect=None decimal=3");
run("ROI Manager...");
selectWindow("ROI Manager");
run("Close");
run("ROI Manager...");
evento=newArray(frag+1);
fision=newArray(frag+1);
fusion=newArray(frag+1);
noCal=newArray(frag+1);
fuerza=newArray(frag+1);
intensidad=newArray(frag+1);
longitud=newArray(frag+1);
intensidadTotal=newArray(frag+1);

 // funciones paramétricas dibujan ROIs y miden intensidad de fluorescencia usando las coordenadas de centro de la inclusión, las cargadas al principio y las del ovalo dibujado

/*promExt=0;
for(i=1; i<frag+1; i++)     //lazo de promedio de intensidad de anillo externo
	{
	selectWindow("Final");
	run("Select None");
	for(j=1; j<frames; j++)    
		{
		selectWindow("Final");
		setSlice(j);
		run("Select None");
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
		//wait(10);
		run("Measure");
		run("Select None");
		}
		
	for(k=0; k<frames-1; k++)
		promExt=promExt+getResult("Mean", k)/255;	
	 
	t=t+2*dt;
	}

run("Clear Results"); 
promExt=promExt/(frag*frames);	
t=0;
*/

for(i=1; i<frag+1; i++)     // lazo principal
	{
	selectWindow("Final");
	run("Select None");
	for(j=1; j<frames; j++)   //lazo de cuadrante interno
		{
		selectWindow("Final");
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
			{
			roiManager("Add");
			roiManager("Select", i-1);
			roiManager("Rename", i);
			}
		run("Measure");    //aca va una variable que sume todos las pasadas
		//run("Capture Image");
		//rename(33333000+100*i+j);
		if(wai==true)
			wait(30);
		run("Select None");
		}
	for(j=1; j<frames; j++)    //lazo de cuadrante externo
		{
		selectWindow("Final");
		setSlice(j);
		run("Select None");
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
		run("Measure");
		if(wai==true)
			wait(30);
		//run("Capture Image");
		//rename(33333000+100*i+j);
		run("Select None");
		}
		
	s=frames-1;
	q=newArray(frames-1);
	w=newArray(frames-1);     //Cuidado!!! pise w de ancho de la imagen
	e=newArray(frames-1);
	INTENSIDADTOTAL=0;
	INTENSIDAD=0;
	FUERZA=0;
	EVENTO=0;
	FUSION=0;
	FISION=0;
	NOCAL=0;

	/*
	for(k=0; k<frames-1; k++)      //vamos a generar vectores para despues comparar
		{
		q[k]=getResult("Mean", s)/getResult("Mean", k);	
		s++;
		}    */
	for(k=0; k<frames-1; k++)
		w[k]=getResult("Mean", k)/255;	             
	s=frames-1;	
	for(k=0; k<frames-1; k++)
		{
		e[k]=getResult("Mean", s)/255;	
		s++;
		} 
		
	pq=0; 	pw=0; 	pe=0;   deq=0;   dew=0;    dee=0;
	

for(k=0; k<frames-1; k++)         
	{	
	//pq=pq+q[k];
	pw=pw+w[k];
	pe=pe+e[k];
	}
	
//pq=pq/frames;
pw=pw/frames;
pe=pe/frames;

/*
for(k=0; k<frames-1; k++)                                                  
	{	
	deq=deq+(q[k]-pq)*(q[k]-pq);
	dew=dew+(w[k]-pw)*(w[k]-pw);
	dee=dee+(e[k]-pe)*(e[k]-pe);
	}

deq=sqrt(deq/frames);
dew=sqrt(deq/frames);
dee=sqrt(deq/frames);
*/

event=newArray(frames);       //genera un vector que registra eventos fusion=3, fision=1, nocalificados=2
for(k=0; k<frames-1; k++)
	{
	event[k]=0;
	INTENSIDADTOTAL=INTENSIDADTOTAL+e[k];
	}
for(k=0; k<frames-1; k++)
	{
	//if(e[k]>umbralDRA*dee+pe && e[k]>umbralPR*promExt)
	//if(e[k]>umbralDRA*pe && e[k]>umbralPR*promExt)
	if(e[k]>umbralDRA*pe && e[k]>umbralPrin) 	
	 	{
		EVENTO++;
		INTENSIDAD=INTENSIDAD+e[k];
		//if(w[k]<pw-umbralDVA*dew)
		if(w[k]<umbralDVA*pw)
			event[k]=1;
			else
			{
			//if(w[k]>pw-umbralDVA*dew && w[k]<pw-umbralDVR*dew)
			if(w[k]>umbralDVA*pw && w[k]<umbralDVR*pw)
				event[k]=2;
				else
				event[k]=3;
			}		
		}
	}
if(EVENTO>0)
	FUERZA=INTENSIDAD/EVENTO;

EVENTO=0;
g=0;
LONGITUD=0;
while(g<frames)       //cuenta eventos, mide duracion promdeio de eventos por cuadrante (LONGITUD), impide que se cuente un evento que dura mas de un frame como varios eventos 
	{
	if(event[g]!=0)
		{
		rr=0; EVENTO++; sumeven=0; 
		do
			{
			sumeven=sumeven+event[g]; g++; rr++;    	
			}while(event[g]!=0)
		LONGITUD=LONGITUD+rr;
		if(sumeven/rr>2)
			FUSION++;
			else
			{
			if(sumeven/rr<2)
				FISION++;
				else
				NOCAL++;
			}
		}
		else    
		g++;
	}

if(EVENTO>0)
	longitud[i]=LONGITUD/EVENTO;
	else
	longitud[i]=0;
evento[i]=EVENTO;
fision[i]=FISION;
fusion[i]=FUSION;
noCal[i]=NOCAL;
intensidad[i]=INTENSIDAD;
fuerza[i]=FUERZA;
intensidadTotal[i]=INTENSIDADTOTAL/(frames-1);	
 	 
	 a=newArray(61);
	 promMA=newArray(61);
	 promMR=newArray(61);
	 promE=newArray(61);
	 promG=newArray(61);
	 URV=newArray(61);
	 for(f=0; f<61; f++)     //creacion del plot
	 	{
	 	a[f]=f+1;
	 	//promMA[f]=pw-umbralDVA*dew;
		//promE[f]=umbralDRA*dee+pe;
	 	//promMR[f]=pw-umbralDVR*dew;
	 	//promG[f]=umbralPR*promExt;
	 	promMA[f]=umbralDVA*pw;
		promE[f]=umbralDRA*pe;
	 	promMR[f]=umbralDVR*pw;
	 	URV[f]=umbralPrin;
	 	}
	 n = e.length;
 	 //a = Array.getSequence(n);
	Plot.create("Plot", "Frame", "Intensity"); 
	Plot.setLimits(0, n, 0, 0.8);  
	Plot.setColor("black", "black");           
    Plot.add("line", a, URV);
    //Plot.add("line", a, promG);            
	Plot.setColor("green", "green");           
    Plot.add("line", a, w);
    Plot.setColor("green", "green");           
    Plot.add("line", a, promMA);
    Plot.setColor("yellow", "yellow");           
    Plot.add("line", a, promMR);
	Plot.setColor("red", "red");
    Plot.add("line", a, e);
    Plot.setColor("red", "red");
    Plot.add("line", a, promE);
	Plot.makeHighResolution("Plot",1.0,"disable");
    rename(frag*1000+i);
	run("Clear Results"); 
	t=t+2*dt;
	}  //fin for principal
//IIDD=getImageID();

//run("Images to Stack", "name=movie title=3333 use");	
run("Images to Stack", "name=Stack title=12 use");

EVENTO=0;
FISION=0;
FUSION=0;
NOCAL=0;
FUERZA=0;
INTENSIDAD=0;
INTENSIDADTOTAL=0;

for(i=1; i<frag+1; i++)
{
EVENTO=EVENTO+evento[i];
FISION=FISION+fision[i];
FUSION=FUSION+fusion[i];
NOCAL=NOCAL+noCal[i];
FUERZA=FUERZA+fuerza[i];
INTENSIDAD=INTENSIDAD+intensidad[i];
LONGITUD=LONGITUD+longitud[i];
INTENSIDADTOTAL=INTENSIDADTOTAL+intensidadTotal[i];
}
FUERZA=2*FUERZA/frag;

//Tabla
run("Set Measurements...", "mean redirect=None decimal=3");
titulo1 = "Results";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if(isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings:Cuadrante\tEventos\tFusiones\tFisiones\tNo calificados\tIntensidad prom.\tIntensidad total\tDuración prom.\tDensidad vesicular");
for(i=1; i<frag+1; i++)
	{
	print(f, i+"\t  "+evento[i]+"\t  "+fusion[i]+"\t  "+fision[i]+"\t  "+noCal[i]+"\t  "+fuerza[i]+"\t  "+intensidad[i]+"\t  "+longitud[i]+"\t  "+intensidadTotal[i]);	
	}
print(f, "");
print(f, " Totales"+"\t   "+EVENTO+"\t  "+FUSION+"\t  "+FISION+"\t  "+NOCAL+"\t  "+FUERZA+"\t  "+INTENSIDAD+"\t  "+LONGITUD+"\t  "+INTENSIDADTOTAL);

//*
selectWindow("Final");
makeOval(cx-ow/2, cy-oh/2, ow, oh);
roiManager("Add");
roiManager("Select", i-1);
roiManager("Rename", "Inclusion");
//*/

//selectImage(IIDD);
selectWindow("Plot");
//run("Close");
Close();
run("Set Measurements...", "mean min redirect=None decimal=3");
