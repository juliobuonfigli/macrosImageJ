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
w=getWidth;          //Cuidado!!! la pise mas abajo           
h=getHeight;

wai=true;
//wai=false;
movimiento=true;
frames=62;
pi=3.141592653589793; 
frag=15;                      //fragmentación de anillos. 
dt=pi/frag;                //intervalo
fA=1.25;                     //espesor de anillo
sepin=0.05;               //separacion entre segmentos de anillo interno
Fagran=1.12;            //Factor de agrandamiento de ovalo para encerrar inclusion con membrana
//movimiento=false;        //calculo de coordenadas del centro de la inclusion

//umbralGFi=2.3;            //umbral general rojo (aceptación negra)
umbralPFi=0.6;           //multiplica el promedio (aceptacion verde). 
//umbralGFu=1.7;              //multiplica el promedio (aceptacion rojo)
umbralPFu=1.8;              //multiplica el promedio (rechazo verde)

t=0;
rename("Final");


/*
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
*/


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
fuerza=newArray(frag+1);
intensidad=newArray(frag+1);
longitud=newArray(frag+1);

 

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
		run("Measure");    //aca va unavariable que sume todos las pasadas
		//run("Capture Image");
		//rename(33333000+100*i+j);
		if(wai==true)
			wait(30);
		run("Select None");
		}
	
		
	s=frames-1;
	q=newArray(frames-1);
	w=newArray(frames-1);     //Cuidado!!! pise w de ancho de la imagen
	e=newArray(frames-1);
	INTENSIDAD=0;
	FUERZA=0;
	EVENTO=0;
	FUSION=0;
	FISION=0;
	NOCAL=0;

	
for(k=0; k<frames-1; k++)
	e[k]=getResult("Mean", k)/255;	
		 		
pe=0;

for(k=0; k<frames-1; k++)         
	pe=pe+e[k];

pe=pe/frames;

event=newArray(frames);       //genera un vector que registra eventos fusion=3, fision=1, nocalificados=2
for(k=0; k<frames-1; k++)
	event[k]=0;
for(k=0; k<frames-1; k++)
	{
	if(e[k]>umbralPFu*pe) // && e[k]>umbralPrin*umbralGFu) 	
	 	{
		EVENTO++;
		INTENSIDAD=INTENSIDAD+e[k];
		event[k]=3;
	 	}
	 if(e[k]<umbralPFi*pe) // && e[k]<umbralPrin*umbralGFi) 	
		{
		EVENTO++;
		event[k]=1;			
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
		if(sumeven/rr==3)
			FUSION++;
			else
			FISION++;
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
intensidad[i]=INTENSIDAD;
fuerza[i]=FUERZA;
	
 	 
	 a=newArray(61);
	 UMBRALGFI=newArray(61);
	 UMBRALPFI=newArray(61);
	 UMBRALGFU=newArray(61);
	 UMBRALPFU=newArray(61);
	 	 for(f=0; f<61; f++)     //creacion del plot
	 	{
	 	a[f]=f+1;
	 	//UMBRALGFI[f]=umbralPrin*umbralGFi;
		UMBRALPFI[f]=umbralPFi*pe;
	 	//UMBRALGFU[f]=umbralPrin*umbralGFu;
	 	UMBRALPFU[f]=umbralPFu*pe;
	 	}
	 n = e.length;
 	 //a = Array.getSequence(n);
	Plot.create("Plot", "Frame", "Intensity"); 
	Plot.setLimits(0, n, 0, 0.8);  
	//Plot.setColor("black", "black");           
    //Plot.add("line", a, UMBRALGFI);
    Plot.setColor("black", "black");           
    Plot.add("line", a, UMBRALPFI);    
	//Plot.setColor("black", "black");           
    //Plot.add("line", a, UMBRALGFU);
    Plot.setColor("black", "black");           
    Plot.add("line", a, UMBRALPFU);
	Plot.setColor("red", "red");
    Plot.add("line", a, e);
    Plot.makeHighResolution("Plot",1.0,"disable");
    rename(frag*1000+i);
	run("Clear Results"); 
	t=t+2*dt;
	}  //fin for principal
//IIDD=getImageID();

//run("Images to Stack", "name=movie title=3333 use");	
run("Images to Stack", "name=Stack title=15 use");

EVENTO=0;
FISION=0;
FUSION=0;
FUERZA=0;
INTENSIDAD=0;

for(i=1; i<frag+1; i++)
{
EVENTO=EVENTO+evento[i];
FISION=FISION+fision[i];
FUSION=FUSION+fusion[i];
FUERZA=FUERZA+fuerza[i];
INTENSIDAD=INTENSIDAD+intensidad[i];
LONGITUD=LONGITUD+longitud[i];
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
print(f, "\\Headings:Cuadrante\tEventos\tFusiones\tFisiones\tIntensidad prom.\tIntensidad total\tDuración prom.");
for(i=1; i<frag+1; i++)
	{
	print(f, i+"\t  "+evento[i]+"\t  "+fusion[i]+"\t  "+fision[i]+"\t   "+fuerza[i]+"\t  "+intensidad[i]+"\t  "+longitud[i]);	
	}
print(f, "");
print(f, " Totales"+"\t   "+EVENTO+"\t  "+FUSION+"\t  "+FISION+"\t   "+FUERZA+"\t  "+INTENSIDAD+"\t  "+LONGITUD);

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