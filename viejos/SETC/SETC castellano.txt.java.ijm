
/*
SETC (Significancia Estad�stica de la Triple Colocalizaci�n)
Julio Buonfigli
Prototipo 20

*/

macro "SSTC" {


//DOBLE O TRIPLE Y CARGA DE IMAGENES

Dialog.create("SETC");    //genero ventana de inicio
  Dialog.addMessage("Significancia Estad�stica de la Triple Colocalizaci�n");                                                                
  Dialog.addChoice("N�mero de canales:", newArray("Dos", "Tres"));    
  Dialog.show();
   	canals=Dialog.getChoice();

if(isOpen("rojoAndMascara"))
	{
	selectWindow("rojoAndMascara");
	close();
	}
if(isOpen("verdeAndMascara"))
	{
	selectWindow("verdeAndMascara");
	close();
	}
if(isOpen("azulAndMascara"))
	{
	selectWindow("azulAndMascara");
	close();
	}

requires("1.29p");              //muestra un mensaje si la versi�n de imagej usada no es compatible

id1=getImageID();          //identificaci�n de IDs
tamano=0;
figura=newArray(nImages*2);
for(i=id1-800; i<id1+800; i++)
	{
	if(isOpen(i))
		{
		selectImage(i);
		figura[tamano]=getTitle();
		tamano++;
		}		
	}





//TRIPLE Y DOBLES

if(canals=="Tres")
{
  Dialog.create("SETC");    //genero ventana de inicio
                                                                    
  Dialog.addChoice("Rojo:", figura);         
  Dialog.addChoice("Verde:", figura);          
  Dialog.addChoice("Azul:", figura);    
  Dialog.addChoice("M�scara:", figura);  
  Dialog.addCheckbox("Calcular coeficientes de Pearson y Mandres", true);
  Dialog.addCheckbox("Significancia estad�stica de Manders", false); 
  Dialog.addCheckbox("Calcular coeficientes de Intersecci�n", true);
  Dialog.addCheckbox("Significancia estad�stica de coef. de intersecci�n", false); 
  Dialog.addNumber("N�mero de im�genes generadas:", 20); 
  Dialog.addCheckbox("Circunscribir m�scara", false);
  Dialog.addCheckbox("Mostrar ejemplos de imagenes generadas", false);
  Dialog.addCheckbox("Mostrar referencias de tabla de resultados", true);
  
       Dialog.show();
   	rojo=Dialog.getChoice();
   	verde=Dialog.getChoice();
   	azul=Dialog.getChoice();
   	mascara=Dialog.getChoice();
   	pearson=Dialog.getCheckbox();
	generadasP=Dialog.getCheckbox();
	interseccion=Dialog.getCheckbox();
	generadasI=Dialog.getCheckbox();
	numGeneradas=Dialog.getNumber();
	intOR=Dialog.getCheckbox();
   	imagenAleatoria=Dialog.getCheckbox();
	referencias=Dialog.getCheckbox();






//SENTENCIAS USADAS EN VARIOS BLOQUES

if(pearson==false && interseccion==false)
	exit("Seleccionar al menos un casillero de coeficientes");   
if(numGeneradas>50)
	exit("El n�mero de im�genes generadas no puede ser mayor a 50");   

selectWindow(mascara);
run("Select None");

selectWindow(rojo);
run("8-bit");
selectWindow(verde);
run("8-bit");
selectWindow(azul);
run("8-bit");

w = getWidth;                                  //cargo tama�o de imagen
h = getHeight;

imageCalculator("AND create", azul, mascara);                       //opero imagenes con la m�scara
rename("azulAndMascara");
imageCalculator("AND create", verde, mascara);  
rename("verdeAndMascara");
imageCalculator("AND create", rojo, mascara);   
rename("rojoAndMascara");

setBatchMode(true);

function contarUnos(ventana)                     //Declaro una funci�n que cuenta unos
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   sumador=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		sumador++;
	}
return sumador;
}

function contarCeros(ventana)                     //Declaro una funci�n que cuenta ceros
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   sumador=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==0)
		sumador++;
	}
return sumador;
}

unosMascara=contarUnos(mascara);                        //cuento unos y ceros en la mascara
cerosMascara=contarCeros(mascara);

if(unosMascara+cerosMascara!=w*h)
	exit("Binarizar la m�scara antes de ejecutar la aplicaci�n");

function sumarPixInt(ventana)                     //Declaro una funci�n que suma intensidades de todos los pixeles
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   suma=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	suma=suma+a[i];
	}
return suma;
}






// CALCULO DE COEFICIENTE DE PEARSON Y MANDERS

if(pearson==true)
{

showStatus("Calculando coeficiente de Pearson y Manders...");

sumRojo=sumarPixInt("rojoAndMascara");                     //sumo intensidades en cada imagen
sumVerde=sumarPixInt("verdeAndMascara");
sumAzul=sumarPixInt("azulAndMascara");

pr=sumRojo/unosMascara;                                    //calculo promedios de intensidad para cada imagen 
pv=sumVerde/unosMascara;
pa=sumAzul/unosMascara;

   numVA=0;                        //inicializo variables de coeficiente de pearson
   numRA=0; 
   nunRV=0;
   denR=0;
   denV=0;
   denA=0;

numMRt=0;                     //inicializo variables de coeficiente de Manders
numMVt=0;
numMAt=0;
numMRv=0;
numMVr=0;
numMRa=0;
numMAr=0;
numMVa=0;
numMAv=0; 
 
selectWindow("rojoAndMascara");	
  r = newArray(w*h);
  i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		r[i] = getPixel(x,y);
		if(r[i] == 255)
			r[i]=254;
		i++;
		}
	}
sumRojoR=0;
i=0;
for (i=0; i<w*h; i++)
	sumRojoR=sumRojoR+r[i];
	

selectWindow("verdeAndMascara");	
  v = newArray(w*h);
  i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		v[i] = getPixel(x,y);
		if(v[i] == 255)
			v[i]=254;
		i++;
		}
	}
sumVerdeR=0;
i=0;
for (i=0; i<w*h; i++)
	sumVerdeR=sumVerdeR+v[i];

selectWindow("azulAndMascara");	   
  az = newArray(w*h);
  i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		az[i] = getPixel(x,y);
		if(az[i] == 255)
			az[i]=254;
		i++;
		}
	}
sumAzulR=0;
i=0;
for (i=0; i<w*h; i++)
	sumAzulR=sumAzulR+az[i];

for(i=0; i<w*h; i++)                                     //calculo todas las series                
	{
	showStatus("Calculando coeficiente de Pearson y Manders...");
	denR=denR+(r[i]-pr)*(r[i]-pr);                                                                 //Pearson                                          
	denV=denV+(v[i]-pv)*(v[i]-pv);
	denA=denA+(az[i]-pa)*(az[i]-pa);
	numVA=numVA+(v[i]-pv)*(az[i]-pa);
	numRA=numRA+(r[i]-pr)*(az[i]-pa);
	numRV=numRV+(r[i]-pr)*(v[i]-pv);
	if(r[i]*v[i]*az[i] != 0)                                                                              //Manders
		{
		numMRt=numMRt+r[i];
		numMVt=numMVt+v[i];
		numMAt=numMAt+az[i];
		}
	if(r[i]*v[i] != 0)
		{
		numMRv=numMRv+r[i];
		numMVr=numMVr+v[i];
		}	
	if(r[i]*az[i] != 0)
		{
		numMRa=numMRa+r[i];
		numMAr=numMAr+az[i];
		}	
	if(az[i]*v[i] != 0)
		{
		numMAv=numMAv+az[i];
		numMVa=numMVa+v[i];
		}	
	}

denRV=sqrt(denR*denV);                             //calculo coeficientes de Pearson
denRA=sqrt(denR*denA);
denVA=sqrt(denA*denV);

PrRV=numRV/denRV;                                     
PrRA=numRA/denRA;
PrVA=numVA/denVA;


MRt=numMRt/sumRojo;                                   //calculo coeficientes de Manders
MVt=numMVt/sumVerde;
MAt=numMAt/sumAzul;
MRv=numMRv/sumRojo;
MVr=numMVr/sumVerde;
MRa=numMRa/sumRojo;
MAr=numMAr/sumAzul;
MVa=numMVa/sumVerde;
MAv=numMAv/sumAzul;

showStatus("");

}
 









//  SIGNIFICANCIA ESTAD�STICA DE MANDERS

if(generadasP==true && pearson==true)
{

showStatus("Calculando significancia estad�stica para coeficiente de Manders...");


rMRt=newArray(numGeneradas);                           //Defino arreglos para cada indice de colocalizaci�n
rMVt=newArray(numGeneradas);
rMAt=newArray(numGeneradas);
rMRv=newArray(numGeneradas);
rMVr=newArray(numGeneradas);
rMRa=newArray(numGeneradas);
rMAr=newArray(numGeneradas);
rMVa=newArray(numGeneradas);
rMAv=newArray(numGeneradas);

rnumMRt=newArray(numGeneradas);                      //inicializo variables de coeficiente de Manders
rnumMVt=newArray(numGeneradas);  
rnumMAt=newArray(numGeneradas);  
rnumMRv=newArray(numGeneradas);  
rnumMVr=newArray(numGeneradas);  
rnumMRa=newArray(numGeneradas);  
rnumMAr=newArray(numGeneradas);  
rnumMVa=newArray(numGeneradas);  
rnumMAv=newArray(numGeneradas);  

pMRt=0;		                                       //Inicializo contadores positivos
pMVt=0;	
pMAt=0;
pMRv=0;
pMVr=0;
pMRa=0;
pMAr=0;
pMVa=0;
pMAv=0;

nMRt=0;		                                       //Inicializo contadores negativos
nMVt=0;	
nMAt=0;
nMRv=0;
nMVr=0;
nMRa=0;
nMAr=0;
nMVa=0;
nMAv=0;


Mrvvr=MRv+MVr;                                            //variables �tiles en condicionales de triple colocalizaci�n            
Marra=MRa+MAr;
Mvaav=MVa+MAv;

function cantPixInt(ventana)                     //Declaro una funci�n que cuenta pixeles distintos de cero
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   suma=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
		
	}
for(i=0; i<w*h; i++)
	{
	if(a[i] != 0)
		suma++;
	}
return suma;
}

valoresR=cantPixInt("rojoAndMascara");            //cantidad de pixeles mayores que cero
valoresV=cantPixInt("verdeAndMascara");  
valoresA=cantPixInt("azulAndMascara"); 


selectWindow("rojoAndMascara");
rb=newArray(w*h);                               //genero un vector que contiene solo los valores distintos de cero para cada canal
s=0;
for(i=0; i<w*h; i++)
	{
	if(r[i] != 0)
		{
		rb[s]=r[i];
		s++;
		}
	}

selectWindow("verdeAndMascara");
vb=newArray(w*h);                               
s=0;
for(i=0; i<w*h; i++)
	{
	if(v[i] != 0)
		{
		vb[s]=v[i];
		s++;
		}
	}

selectWindow("azulAndMascara");
ab=newArray(w*h);                              
s=0;
for(i=0; i<w*h; i++)
	{
	if(az[i] != 0)
		{
		ab[s]=az[i];
		s++;
		}
	}


for(s=0; s<numGeneradas; s++)                                        //rulo para generar tantas im�genes aleatorias para cada fluor�foro como se cargue en el di�logo de entrada
{
 
//beep();                                                                                    //genero imagenes aleatorias

random("seed", round(random*w*h*10));
	
u=newArray(w*h+10);                                                                //desordeno aleatoriamente el vector rojo
i=0;
for(i=0; i<w*h; i++)
	u[i]=true;

rd=newArray(w*h);
i=0;	
while(i<valoresR)
	{
	e=round(random*valoresR);
        	if(u[e]==true)
		{
		rd[i]=rb[e];
		u[e]=false;
		i++;
		}
	}
	
factor=valoresR/unosMascara;                                                                            //pongo los valores en la mascara

selectWindow(mascara);
run("Duplicate...", "title=RandRojo");
suma=0;
i=0;
while(suma<sumRojoR-255)
	{
	for (y=0; y<h; y++)
		{
		for (x=0; x<w; x++)
			{
			p=random;
			l=getPixel(x, y);
			if(l==255 && p <= factor)
				{
				setPixel(x, y, rd[i]);
				suma=suma+rd[i];
				i++;
				}
			}
		}
	}

for (y=0; y<h; y++)                                      //cambio unos por ceros
	{
	for (x=0; x<w; x++)
		{
		l=getPixel(x, y);
		if(l == 255)
			setPixel(x, y, 0);
		}
	}
	
                                                                //desordeno aleatoriamente el vector verde
i=0;
for(i=0; i<w*h; i++)
	u[i]=true;

vd=newArray(w*h);
i=0;	
while(i<valoresV)
	{
	e=round(random*valoresV);
        	if(u[e]==true)
		{
		vd[i]=vb[e];
		u[e]=false;
		i++;
		}
	}
	
factor=valoresV/unosMascara;                                                                            //pongo los valores en la mascara

selectWindow(mascara);
run("Duplicate...", "title=RandVerde");
suma=0;
i=0;
while(suma<sumVerdeR-255)
	{
	for (y=0; y<h; y++)
		{
		for (x=0; x<w; x++)
			{
			p=random;
			l=getPixel(x, y);
			if(l==255 && p <= factor)
				{
				setPixel(x, y, vd[i]);
				suma=suma+vd[i];
				i++;
				}
			}
		}
	}

for (y=0; y<h; y++)                                      //cambio unos por ceros
	{
	for (x=0; x<w; x++)
		{
		l=getPixel(x, y);
		if(l == 255)
			setPixel(x, y, 0);
		}
	}


                                     
i=0;                                       //desordeno aleatoriamente el vector azul
for(i=0; i<w*h; i++)
	u[i]=true;

ad=newArray(w*h);
i=0;	
while(i<valoresA)
	{
	e=round(random*valoresA);
        	if(u[e]==true)
		{
		ad[i]=ab[e];
		u[e]=false;
		i++;
		}
	}
	
factor=valoresA/unosMascara;                                                                            //pongo los valores en la mascara

selectWindow(mascara);
run("Duplicate...", "title=RandAzul");
suma=0;
i=0;
while(suma<sumAzulR-255)
	{
	for (y=0; y<h; y++)
		{
		for (x=0; x<w; x++)
			{
			p=random;
			l=getPixel(x, y);
			if(l==255 && p <= factor)
				{
				setPixel(x, y, ad[i]);
				suma=suma+ad[i];
				i++;
				}
			}
		}
	}

for (y=0; y<h; y++)                                      //cambio unos por ceros
	{
	for (x=0; x<w; x++)
		{
		l=getPixel(x, y);
		if(l == 255)
			setPixel(x, y, 0);
		}
	}

	
selectWindow("RandRojo");        //obtengo el valor de cada pixel para cada imagen y los transformo en vectores unidimensionales	
   rR = newArray(w*h);    
   i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		rR[i++] = getPixel(x,y);
	}

selectWindow("RandVerde");	
  vR = newArray(w*h);
  i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		vR[i++] = getPixel(x,y);
	}

selectWindow("RandAzul");	   
  aR = newArray(w*h);
  i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		aR[i++] = getPixel(x,y);
	}

	for(i=0; i<w*h; i++)                                     //calculo doble colocalizacion de imagenes generadas                
	{
	if(rR[i]*vR[i] != 0)
		{
		rnumMRv[s]=rnumMRv[s]+rR[i];
		rnumMVr[s]=rnumMVr[s]+vR[i];
		}	
	if(rR[i]*aR[i] != 0)
		{
		rnumMRa[s]=rnumMRa[s]+rR[i];
		rnumMAr[s]=rnumMAr[s]+aR[i];
		}	
	if(aR[i]*vR[i] != 0)
		{
		rnumMAv[s]=rnumMAv[s]+aR[i];
		rnumMVa[s]=rnumMVa[s]+vR[i];
		}	
	}

if(Mrvvr==Mvaav && Mrvvr==Marra)
{
for(i=0; i<w*h; i++) 
	{
	if(r[i]*v[i]*aR[i] != 0)                                                                              
		{
		rnumMRt[s]=rnumMRt[s]+r[i];
		rnumMVt[s]=rnumMVt[s]+v[i];
		rnumMAt[s]=rnumMAt[s]+aR[i];
		}
	}
}
    else
	{
	if(Mrvvr>=Mvaav && Mrvvr>=Marra)                                //busco el canal que menos colocaliza y calculo triple colo
		{													
		for(i=0; i<w*h; i++) 
			{
			if(r[i]*v[i]*aR[i] != 0)                                                                              
				{
				rnumMRt[s]=rnumMRt[s]+r[i];
				rnumMVt[s]=rnumMVt[s]+v[i];
				rnumMAt[s]=rnumMAt[s]+aR[i];
				}
			}
		}
	if(Mvaav>=Mrvvr && Mvaav>=Marra)
		{
		for(i=0; i<w*h; i++) 
			{													
			if(rR[i]*v[i]*az[i] != 0)                                                                              
				{
				rnumMRt[s]=rnumMRt[s]+rR[i];
				rnumMVt[s]=rnumMVt[s]+v[i];
				rnumMAt[s]=rnumMAt[s]+az[i];
				}
			}
		}
	if(Marra>=Mvaav &&  Marra>=Mrvvr)
		{
		for(i=0; i<w*h; i++) 
			{											
			if(r[i]*vR[i]*az[i] != 0)                                                                            
				{
				rnumMRt[s]=rnumMRt[s]+r[i];
				rnumMVt[s]=rnumMVt[s]+vR[i];
				rnumMAt[s]=rnumMAt[s]+az[i];
				}
			}
		}
	}
	
rMRt[s]=rnumMRt[s]/sumRojo;                                   //calculo coeficientes de Manders
rMVt[s]=rnumMVt[s]/sumVerde;
rMAt[s]=rnumMAt[s]/sumAzul;
rMRv[s]=rnumMRv[s]/sumRojo;
rMVr[s]=rnumMVr[s]/sumVerde;
rMRa[s]=rnumMRa[s]/sumRojo;
rMAr[s]=rnumMAr[s]/sumAzulR;
rMVa[s]=rnumMVa[s]/sumVerde;
rMAv[s]=rnumMAv[s]/sumAzul;	



	if(rMRt[s]<=MRt)                           //Para cada coeficiente de colocalizaci�n cuento cuantas veces fue mayor el generado al azar
		pMRt++;
		else
		nMRt++;	
	if(rMVt[s]<=MVt)
		pMVt++;
		else
		nMVt++;
	if(rMAt[s]<=MAt)
		pMAt++;
		else
		nMAt++;
	if(rMRa[s]<=MRa)
		pMRa++;
		else
		nMRa++;	
	if(rMAr[s]<=MAr)
		pMAr++;
		else
		nMAr++;
	if(rMAv[s]<=MAv)
		pMAv++;
		else
		nMAv++;
	if(rMVa[s]<=MVa)
		pMVa++;
		else
		nMVa++;	
	if(rMRv[s]<=MRv)
		pMRv++;
		else
		nMRv++;	
	if(rMVr[s]<=MVr)
		pMVr++;
		else
		nMVr++;
	
	

selectWindow("RandRojo");                           //cierro im�genes para que no interfieran en el pr�ximo ciclo del lazo	
close();
selectWindow("RandVerde");
close();
selectWindow("RandAzul");
close();

	
}


sumMRt=0;                          //inicializo variables de suma para promedios
sumMVt=0;
sumMAt=0;
sumMRv=0;
sumMVr=0;
sumMRa=0;
sumMAr=0;
sumMVa=0;
sumMAv=0;


for(i=0; i<numGeneradas; i++)         //sumo
	{	
	sumMRt=sumMRt+rMRt[i];
	sumMVt=sumMVt+rMVt[i];
	sumMAt=sumMAt+rMAt[i];
	sumMRv=sumMRv+rMRv[i];
	sumMVr=sumMVr+rMVr[i];
	sumMRa=sumMRa+rMRa[i];
	sumMAr=sumMAr+rMAr[i];
	sumMVa=sumMVa+rMVa[i];
	sumMAv=sumMAv+rMAv[i];
	}
	
promMRt=sumMRt/numGeneradas;                                    //promedio
promMVt=sumMVt/numGeneradas; 
promMAt=sumMAt/numGeneradas; 
promMRv=sumMRv/numGeneradas; 
promMVr=sumMVr/numGeneradas; 
promMRa=sumMRa/numGeneradas;
promMAr=sumMAr/numGeneradas; 
promMVa=sumMVa/numGeneradas; 
promMAv=sumMAv/numGeneradas; 

ratioMrt=pMRt/numGeneradas;                            //Valores de la tabla de resultados, colo significativa (SC)....
ratioMvt=pMVt/numGeneradas;
ratioMat=pMAt/numGeneradas;                            
ratioMrv=pMRv/numGeneradas;
ratioMvr=pMVr/numGeneradas;
ratioMra=pMRa/numGeneradas;                            
ratioMar=pMAr/numGeneradas;
ratioMva=pMVa/numGeneradas;
ratioMav=pMAv/numGeneradas;                            


if(pMRt==0)
	SSMrt="SE";
	else
	if(pMRt==numGeneradas)
		SSMrt="SC";
		else
		SSMrt="NS";

if(pMVt==0)
	SSMvt="SE";
	else
	if(pMVt==numGeneradas)
		SSMvt="SC";
		else
		SSMvt="NS";

if(pMAt==0)
	SSMat="SE";
	else
	if(pMAt==numGeneradas)
		SSMat="SC";
		else
		SSMat="NS";

if(pMVr==0)
	SSMvr="SE";
	else
	if(pMVr==numGeneradas)
		SSMvr="SC";
		else
		SSMvr="NS";

if(pMRv==0)
	SSMrv="SE";
	else
	if(pMRv==numGeneradas)
		SSMrv="SC";
		else
		SSMrv="NS";

if(pMRa==0)
	SSMra="SE";
	else
	if(pMRa==numGeneradas)
		SSMra="SC";
		else
		SSMra="NS";

if(pMAr==0)
	SSMar="SE";
	else
	if(pMAr==numGeneradas)
		SSMar="SC";
		else
		SSMar="NS";

if(pMVa==0)
	SSMva="SE";
	else
	if(pMVa==numGeneradas)
		SSMva="SC";
		else
		SSMva="NS";

if(pMAv==0)
	SSMav="SE";
	else
	if(pMAv==numGeneradas)
		SSMav="SC";
		else
		SSMav="NS";

/*
if(promMRt>0.99)
	promMRt=round(promMRt);
if(promMVt>0.99)
	promMVt=round(promMVt);
if(promMRt>0.99)
	promMAt=round(promMAt);
if(promMRv>0.99)
	promMRv=round(promMRv);
if(promMVr>0.99)
	promMVr=round(promMVr);
if(promMRa>0.99)
	promMRa=round(promMRa);
if(promMAr>0.99)
	promMAr=round(promMAr);
if(promMVa>0.99)
	promMVa=round(promMVa);
if(promMAv>0.99)
	promMAv=round(promMAv);

*/
}

showStatus("");










//BINARIZACI�N

setBatchMode(false);

if(interseccion==true)
{  
  Dialog.create("Binarizaci�n");                                                                                                                                                 //cuadro de di�logo de selecci�n de tipo de binarizaci�n                                         
  Dialog.addChoice("Seleccione el tipo de binarizaci�n", newArray("por defecto", "seg�n intensidad promedio", "manual")); 
        Dialog.show();
	bin=Dialog.getChoice();

if(bin=="por defecto")
{
selectWindow("rojoAndMascara");
run("Make Binary");
selectWindow("verdeAndMascara");                                                             
run("Make Binary");
selectWindow("azulAndMascara");                                           
run("Make Binary");
}
 
  	
if(bin=="seg�n intensidad promedio")
{

 Dialog.create("Factor de Multiplicaci�n");                                                                                                                                                                                        
 Dialog.addChoice("Seleccione el factor de multiplicaci�n", newArray(0.125, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.5, 3, 4)); 
 Dialog.addMessage("El factor multiplica la intensidad promedio de cada canal para fijar el umbral\na partir del cual cada pixel ser� llevado a su m�ximo o m�nimo valor.\nMientras mayor sea el factor menor ser� la cantidad de pixeles blancos en la imagen.");           
       Dialog.show();
	factorP=Dialog.getChoice();

if(pearson==false)
{
sumRojo=sumarPixInt("rojoAndMascara");                     //sumo intensidades en cada imagen
sumVerde=sumarPixInt("verdeAndMascara");
sumAzul=sumarPixInt("azulAndMascara");
}

pr=sumRojo/unosMascara;                                    //calculo promedios de intensidad para cada imagen 
pv=sumVerde/unosMascara;
pa=sumAzul/unosMascara;                   


selectWindow("rojoAndMascara");            //binariza canal rojo segun intensidad promedio   
i = 0;
 for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		{	
		showStatus("Binarizando im�genes...");
		a = getPixel(x,y);
		if(a>pr*factorP)
			setPixel(x, y, 255);
			else
			setPixel(x, y, 0);
		}

	}
updateDisplay();


selectWindow("verdeAndMascara");      //binariza canal verde seg�n intensidad promedio
i = 0;
 for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		{	
		showStatus("Binarizando im�genes...");
		a = getPixel(x,y);
		if(a>pv*factorP)
			setPixel(x, y, 255);
			else
			setPixel(x, y, 0);
		}

	}
updateDisplay();


selectWindow("azulAndMascara");    //binariza canal azul seg�n intensidad promedio    
i = 0;
 for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		{	
		showStatus("Binarizando im�genes...");
		a = getPixel(x,y);
		if(a>pa*factorP)
			setPixel(x, y, 255);
			else
			setPixel(x, y, 0);
		}

	}
updateDisplay();

}


if(bin=="manual")          
                           //binarizaci�n manual
{  
selectWindow("rojoAndMascara");
run("Threshold...");                                                                    
waitForUser("Binarizaci�n manual", "Pulse OK luego de binarizar rojoAndMascara");
updateDisplay();
selectWindow("verdeAndMascara");                                                             
waitForUser("Binarizaci�n manual", "Pulse OK luego de binarizar verdeAndMascara");
updateDisplay();
selectWindow("azulAndMascara");                                           
waitForUser("Binarizaci�n manual", "Pulse OK luego de binarizar azulAndMascara");
updateDisplay();
selectWindow("Threshold");
run("Close");

 }
}














// COLOCALIZACI�N DE INTERSECCI�N    

imageCalculator("OR create", "rojoAndMascara", "verdeAndMascara");    //Calculo la superficie cubierta total dentro de la m�scara
rename("rojoOrVerde");
imageCalculator("OR create", "rojoOrVerde", "azulAndMascara");                 
rename("OR");
if(intOR==true)
{   
selectWindow("OR");                            
run("Duplicate...", "title=GOR"); 
run("Mean...", "radius=1");
//run("Gaussian Blur...", "sigma=1");
run("Threshold...");
setThreshold(1, 255);
run("Convert to Mask");
unosGOR=contarUnos("GOR");
selectWindow("Threshold");
run("Close");
}

setBatchMode(true);

if(interseccion==true)
{
showStatus("Calculando porcentage de colocalizaci�n de intersecci�n...");

cerosRojos=contarCeros("rojoAndMascara");                     //cuento ceros en cada canal
cerosVerdes=contarCeros("verdeAndMascara");
cerosAzules=contarCeros("azulAndMascara");

cerosRandRojos=cerosRojos-cerosMascara;                       // calculo la cantidad de ceros dentro de la m�scara para cada color
cerosRandVerdes=cerosVerdes-cerosMascara;
cerosRandAzules=cerosAzules-cerosMascara;

imageCalculator("AND create", "rojoAndMascara", "verdeAndMascara");     //opero para obtener doble colocalizaci�n
rename("rojoAndVerde");
imageCalculator("AND create", "azulAndMascara", "rojoAndMascara");  
rename("rojoAndAzul");
imageCalculator("AND create", "verdeAndMascara", "azulAndMascara");  
rename("verdeAndAzul");

imageCalculator("AND create", "rojoAndVerde", "azulAndMascara");     //obtengo triple colocalizaci�n
rename("TripleColocalizacion");

unosRvam=contarUnos("TripleColocalizacion");             // cuento pixeles de triple colo

unosRojos=contarUnos("rojoAndMascara");                     //cuento unos en cada canal
unosVerdes=contarUnos("verdeAndMascara");
unosAzules=contarUnos("azulAndMascara");

unosRV=contarUnos("rojoAndVerde");                       //cuento unos de doble colo
unosRA=contarUnos("rojoAndAzul");
unosVA=contarUnos("verdeAndAzul");

unosRvamOr=contarUnos("OR");                           //cuento unos en el triple OR

rv=(unosRV/unosRojos)*100;                            //calculo coeficientes de colocalizaci�n
vr=(unosRV/unosVerdes)*100;
ra=(unosRA/unosRojos)*100;
ar=(unosRA/unosAzules)*100;
va=(unosVA/unosVerdes)*100;
av=(unosVA/unosAzules)*100;
rvasc=(unosRvam/unosRvamOr)*100;
rvaenr=(unosRvam/unosRojos)*100;
rvaenv=(unosRvam/unosVerdes)*100;
rvaena=(unosRvam/unosAzules)*100;

selectWindow("TripleColocalizacion");         //cierro im�genes para que no interfieran con futuras corridas
close();

}


selectWindow("rojoOrVerde");
close();
selectWindow("OR");
close();







//  SIGNIFICANCIA ESTAD�STICA INTERSECCI�N

if(generadasI==true && interseccion==true)
{

showStatus("Calculando significancia estad�stica de colocalizaci�n de intersecci�n...");

rrv=newArray(numGeneradas);                           //Defino arreglos para cada indice de colocalizaci�n
rvr=newArray(numGeneradas);
rra=newArray(numGeneradas);
rar=newArray(numGeneradas);
rva=newArray(numGeneradas);
rav=newArray(numGeneradas);
rrvasc=newArray(numGeneradas);
rrvaenr=newArray(numGeneradas);
rrvaenv=newArray(numGeneradas);
rrvaena=newArray(numGeneradas);

pcrrv=0;		                                       //Inicializo contadores positivos
pcrvr=0;	
pcrra=0;
pcrar=0;
pcrva=0;
pcrav=0;
pcrrvasc=0;
pcrrvaenr=0;
pcrrvaenv=0;
pcrrvaena=0;

ncrrv=0;		                                       //Inicializo contadores negativos
ncrvr=0;
ncrra=0;
ncrar=0;
ncrva=0;
ncrav=0;
ncrrvasc=0;
ncrrvaenr=0;
ncrrvaenv=0;
ncrrvaena=0;

rvvr=rv+vr;                                            //variables �tiles en condicionales de triple colocalizaci�n            
arra=ra+ar;
vaav=va+av;



for(s=0; s<numGeneradas; s++)                        //rulo para generar tantas im�genes aleatorias para cada fluor�foro como se cargue en el di�logo de entrada
	{
	//beep();

	random("seed", round(random*w*h*10));
if(intOR==true)
{
	selectWindow("GOR");                            //genero una imagen aleatoria para el canal rojo
	run("Duplicate...", "title=RandRojo");
	z=0;
            f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			f=random;
			if(f<=(unosGOR-unosRojos)/unosGOR)
			setPixel(x, y, 0);
			}
		}
		
	
	selectWindow("GOR");                            //genero una imagen aleatoria para el canal verde
	run("Duplicate...", "title=RandVerde");
	z=0;
   	f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			f=random;
			if(f<=(unosGOR-unosVerdes)/unosGOR)
				setPixel(x, y, 0);
			
			}
		}
	

	selectWindow("GOR");                            //genero una imagen aleatoria para el canal azul
	run("Duplicate...", "title=RandAzul");
	z=0;
   	f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			f=random;
			if(f<=(unosGOR-unosAzules)/unosGOR)
				setPixel(x, y, 0);
			}
		}
}
else
{
selectWindow(mascara);                            //genero una imagen aleatoria para el canal rojo
	run("Duplicate...", "title=RandRojo");
	z=0;
            f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			f=random;
			if(f<=cerosRandRojos/unosMascara)
			setPixel(x, y, 0);
			}
		}
		
	
	selectWindow(mascara);                            //genero una imagen aleatoria para el canal verde
	run("Duplicate...", "title=RandVerde");
	z=0;
   	f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			f=random;
			if(f<=cerosRandVerdes/unosMascara)
				setPixel(x, y, 0);
			
			}
		}
	

	selectWindow(mascara);                            //genero una imagen aleatoria para el canal azul
	run("Duplicate...", "title=RandAzul");
	z=0;
   	f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			f=random;
			if(f<=cerosRandAzules/unosMascara)
				setPixel(x, y, 0);
			}
		}
}	
	
	imageCalculator("AND create", "RandRojo", "RandVerde");     //opero para obtener doble colocalizaci�n
	rename("RandRojoAndRandVerde");
	imageCalculator("AND create", "RandRojo", "RandAzul");  
	rename("RandRojoAndRandAzul");
	imageCalculator("AND create", "RandVerde", "RandAzul");  
	rename("RandVerdeAndRandAzul");

	if(rvvr==vaav && rvvr==arra)
		{													
		imageCalculator("AND create", "RandAzul", "rojoAndVerde");     // chequeo cual es color que menos colocaliza con el resto y obtengo triple colocalizaci�n
		rename("RandTripleColocalizacion");
		}
		else
		{
		if(rvvr>=vaav && rvvr>=arra)
			{													
			imageCalculator("AND create", "RandAzul", "rojoAndVerde");     
			rename("RandTripleColocalizacion");
			}
		if(vaav>=rvvr && vaav>=arra)
			{													
			imageCalculator("AND create", "RandRojo", "verdeAndAzul");   
			rename("RandTripleColocalizacion");
			}
		if(arra>=vaav &&  arra>=rvvr)
			{													
			imageCalculator("AND create", "RandVerde", "rojoAndAzul");  
			rename("RandTripleColocalizacion");
			}
		}

if(isOpen("RandTripleColocalizacion"))	
	{}
	else
	exit("Error de binarizaci�n");
 
	RandunosRvam=contarUnos("RandTripleColocalizacion");         //Cuento la cantidad de pixeles de triple colo
	
	RandunosRV=contarUnos("RandRojoAndRandVerde");    //cueno pixeles de doble colo 
	RandunosRA=contarUnos("RandRojoAndRandAzul"); 
	RandunosVA=contarUnos("RandVerdeAndRandAzul"); 

	
// la superficie cubierta total aleatoria es la misma que la del ensayo
// igual que el total de unos para cada color son los del ensayo


	rrv[s]=(RandunosRV/unosRojos)*100;                            //calculo coeficientes de colocalizaci�n
	rvr[s]=(RandunosRV/unosVerdes)*100;
	rra[s]=(RandunosRA/unosRojos)*100;
	rar[s]=(RandunosRA/unosAzules)*100;
	rva[s]=(RandunosVA/unosVerdes)*100;
	rav[s]=(RandunosVA/unosAzules)*100;	
	rrvasc[s]=(RandunosRvam/unosRvamOr)*100;
	rrvaenr[s]=(RandunosRvam/unosRojos)*100;
	rrvaenv[s]=(RandunosRvam/unosVerdes)*100;
	rrvaena[s]=(RandunosRvam/unosAzules)*100;


	if(rrv[s]<=rv)                           //Para cada coeficiente de colocalizaci�n cuento cuantas veces fue mayor el generado al azar
		pcrrv++;
		else
		ncrrv++;	
	if(rvr[s]<=vr)
		pcrvr++;
		else
		ncrvr++;
	if(rra[s]<=ra)
		pcrra++;
		else
		ncrra++;
	if(rar[s]<=ar)
		pcrar++;
		else
		ncrar++;	
	if(rva[s]<=va)
		pcrva++;
		else
		ncrva++;
	if(rav[s]<=av)
		pcrav++;
		else
		ncrav++;
	if(rrvasc[s]<=rvasc)
		pcrrvasc++;
		else
		ncrrvasc++;	
	if(rrvaenr[s]<=rvaenr)
		pcrrvaenr++;
		else
		ncrrvaenr++;	
	if(rrvaenv[s]<=rvaenv)
		pcrrvaenv++;
		else
		ncrrvaenv++;
	if(rrvaena[s]<=rvaena)
		pcrrvaena++;
		else
		ncrrvaena++;	
	

selectWindow("RandRojo");                           //cierro im�genes para que no interfieran en el pr�ximo ciclo del lazo	
close();
selectWindow("RandVerde");
close();
selectWindow("RandAzul");
close();
selectWindow("RandRojoAndRandVerde");
close();	
selectWindow("RandRojoAndRandAzul");
close();
selectWindow("RandVerdeAndRandAzul");
close();
selectWindow("RandTripleColocalizacion");
close();
	
}


sumRrv=0;                          //inicializo variables de suma para promedios
sumRvr=0;
sumRra=0;
sumRvr=0;
sumRar=0;
sumRva=0;
sumRav=0;
sumRrvasc=0;
sumRrvaenr=0;
sumRrvaenv=0;
sumRrvaena=0;


for(i=0; i<numGeneradas; i++)         //sumo
	{	
	sumRrv=sumRrv+rrv[i];
	sumRvr=sumRvr+rvr[i];
	sumRra=sumRra+rra[i];
	sumRar=sumRar+rar[i];
	sumRva=sumRva+rva[i];
	sumRav=sumRav+rav[i];
	sumRrvasc=sumRrvasc+rrvasc[i];
	sumRrvaenr=sumRrvaenr+rrvaenr[i];
	sumRrvaenv=sumRrvaenv+rrvaenv[i];
	sumRrvaena=sumRrvaena+rrvaena[i];
	}
	
promRrv=sumRrv/numGeneradas;                                    //promedio
promRvr=sumRvr/numGeneradas; 
promRra=sumRra/numGeneradas; 
promRar=sumRar/numGeneradas; 
promRva=sumRva/numGeneradas; 
promRav=sumRav/numGeneradas;
promRrvasc=sumRrvasc/numGeneradas; 
promRrvaenr=sumRrvaenr/numGeneradas; 
promRrvaenv=sumRrvaenv/numGeneradas; 
promRrvaena=sumRrvaena/numGeneradas; 

ratioPcrrvasc=pcrrvasc/numGeneradas; 
ratioIrrvaenr=pcrrvaenr/numGeneradas;                                            //Valores de la tabla de resultados, colo significativa (SC)....
ratioIrrvaenv=pcrrvaenv/numGeneradas;
ratioIrrvaena=pcrrvaena/numGeneradas;                            
ratioIrv=pcrrv/numGeneradas;
ratioIvr=pcrvr/numGeneradas;
ratioIra=pcrra/numGeneradas;                            
ratioIar=pcrar/numGeneradas;
ratioIva=pcrva/numGeneradas;
ratioIav=pcrav/numGeneradas;                            


if(pcrrvasc==0)
	SSIst="SE";
	else
	if(pcrrvasc==numGeneradas)
		SSIst="SC";
		else
		SSIst="NS";

if(rrvaenr==0)
	SSItenr="SE";
	else
	if(rrvaenr==numGeneradas)
		SSItenr="SC";
		else
		SSItenr="NS";

if(rrvaenv==0)
	SSItenv="SE";
	else
	if(rrvaenv==numGeneradas)
		SSItenv="SC";
		else
		SSItenv="NS";

if(rrvaena==0)
	SSItena="SE";
	else
	if(rrvaena==numGeneradas)
		SSItena="SC";
		else
		SSItena="NS";

if(pcrrv==0)
	SSIrv="SE";
	else
	if(pcrrv==numGeneradas)
		SSIrv="SC";
		else
		SSIrv="NS";

if(pcrvr==0)
	SSIvr="SE";
	else
	if(pcrvr==numGeneradas)
		SSIvr="SC";
		else
		SSIvr="NS";

if(pcrra==0)
	SSIra="SE";
	else
	if(pcrvr==numGeneradas)
		SSIra="SC";
		else
		SSIra="NS";

if(pcrar==0)
	SSIar="SE";
	else
	if(pcrar==numGeneradas)
		SSIar="SC";
		else
		SSIar="NS";

if(pcrva==0)
	SSIva="SE";
	else
	if(pcrva==numGeneradas)
		SSIva="SC";
		else
		SSIva="NS";

if(pcrav==0)
	SSIav="SE";
	else
	if(pcrav==numGeneradas)
		SSIav="SC";
		else
		SSIav="NS";



}

showStatus("");








//RESULTADOS

if(interseccion==true)
{
selectWindow("rojoAndVerde");               //cierro im�genes para que no interfieran con futuras corridas de la aplicaci�n
close();
selectWindow("rojoAndAzul");
close();
selectWindow("verdeAndAzul");
close();
}

if(interseccion==false)
{
rv="  ******";      
vr="  ******"; 
ra="  ******"; 
ar="  ******";
va="  ******";
av="  ******"; 
rvasc="  ******"; 
rvaenr="  ******"; 
rvaenv="  ******";
rvaena="  ******";
}

if(pearson==false)
{
PrRV="  ******";                                                  //variables que no se calculan
PrRA="  ******";
PrVA="  ******";
MRt=" ******";		                                       
MVt=" ******";	
MAt=" ******";
MRv=" ******";
MVr=" ******";
MRa=" ******";
MAr=" ******";
MVa=" ******";
MAv=" ******";
}

if(generadasI==false || interseccion==false)
{
promRrv="  ******";      
promRvr="  ******"; 
promRra="  ******"; 
promRar="  ******";
promRva="  ******";
promRav="  ******"; 
promRrvasc="  ******"; 
promRrvaenr="  ******"; 
promRrvaenv="  ******";
promRrvaena="  ******";
ratioPcrrvasc=" ******"; 
ratioIrrvaenr=" ******";                                          
ratioIrrvaenv=" ******";
ratioIrrvaena=" ******";                          
ratioIrv=" ******";
ratioIvr=" ******";
ratioIra=" ******";                          
ratioIar=" ******";
ratioIva=" ******";
ratioIav=" ******";
SSIst=" ******";
SSItenr=" ******";
SSItenv=" ******";
SSItena=" ******";
SSIrv=" ******";
SSIvr=" ******";
SSIra=" ******";
SSIar=" ******";
SSIva=" ******";
SSIav=" ******";
/*
pcrrv="  ******";                                       
pcrvr="  ******";	 
pcrra="  ******"; 
pcrar="  ******"; 
pcrva="  ******";
pcrav="  ******"; 
pcrrvasc="  ******";  
pcrrvaenr="  ******"; 
pcrrvaenv="  ******";
pcrrvaena="  ******"; 
ncrrv="  ******";                                       
ncrvr="  ******"; 
ncrra="  ******";
ncrar="  ******"; 
ncrva="  ******";
ncrav="  ******"; 
ncrrvasc="  ******";
ncrrvaenr="  ******";
ncrrvaenv="  ******";
ncrrvaena="  ******";
*/
}
if(generadasP==false || pearson==false)
{
/*
pMRt=" ******";		                                       
pMVt=" ******";	
pMAt=" ******";
pMRv=" ******";
pMVr=" ******";
pMRa=" ******";
pMAr=" ******";
pMVa=" ******";
pMAv=" ******";
nMRt=" ******";		                                      
nMVt=" ******";	
nMAt=" ******";
nMRv=" ******";
nMVr=" ******";
nMRa=" ******";
nMAr=" ******";
nMVa=" ******";
nMAv=" ******";
*/
ratioMrt=" ******";
ratioMvt=" ******";
ratioMat=" ******";                          
ratioMrv=" ******";
ratioMvr=" ******";
ratioMra=" ******";                    
ratioMar=" ******";
ratioMva=" ******";
ratioMav=" ******";                            
SSMrt=" ******";
SSMvt=" ******";
SSMat=" ******";
SSMvr=" ******";
SSMrv=" ******";
SSMra=" ******";
SSMar=" ******";
SSMva=" ******";
SSMav=" ******";
promMRt=" ******";                            
promMVt=" ******";
promMAt=" ******";
promMRv="  ******";
promMVr="  ******";
promMRa="  ******";
promMAr="  ******";
promMVa="  ******";
promMAv="  ******";
}


titulo1 = "Resultados";                                            //genero cuadro que muestra resultados
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if (isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings:para\t% intersecci�n\t% aleatorizaciones\t  SE \trelaci�n\tPearson\tManders\taleatorizaciones\t  SE\trelaci�n");
print(f, "Doble colocalizaci�n");
print(f, " Rojo en verde"+"\t  "+rv+"\t  "+promRrv+"\t  "+SSIrv+"\t  "+ratioIrv+"\t  "+PrRV+"\t  "+MRv+"\t  "+promMRv+"\t  "+SSMrv+"\t  "+ratioMrv);
print(f, " Verde en rojo"+"\t  "+vr+"\t  "+promRvr+"\t  "+SSIvr+"\t  "+ratioIvr+"\t  "+PrRV+"\t  "+MVr+"\t  "+promMVr+"\t  "+SSMvr+"\t  "+ratioMvr);
print(f, " Rojo en azul"+"\t  "+ra+"\t  "+promRra+"\t  "+SSIra+"\t  "+ratioIra+"\t  "+PrRA+"\t  "+MRa+"\t  "+promMRa+"\t  "+SSMra+"\t  "+ratioMra);
print(f, " Azul en rojo"+"\t  "+ar+"\t  "+promRar+"\t  "+SSIar+"\t  "+ratioIar+"\t  "+PrRA+"\t  "+MAr+"\t  "+promMAr+"\t  "+SSMar+"\t  "+ratioMar);
print(f, " Verde en azul"+"\t  "+va+"\t  "+promRva+"\t  "+SSIva+"\t  "+ratioIva+"\t  "+PrVA+"\t  "+MVa+"\t  "+promMVa+"\t  "+SSMva+"\t  "+ratioMva);
print(f, " Azul en verde"+"\t  "+av+"\t  "+promRav+"\t  "+SSIav+"\t  "+ratioIav+"\t  "+PrVA+"\t  "+MAv+"\t  "+promMAv+"\t  "+SSMav+"\t  "+ratioMav);
print(f, "Triple colocalizaci�n");
print(f, " General"+"\t  "+rvasc+"\t  "+promRrvasc+"\t  "+SSIst+"\t  "+ratioPcrrvasc+"\t  ******"+"\t  ******"+ " \t   ******"+ " \t   ******"+ " \t   ******");
print(f, " Seg�n rojo"+"\t  "+rvaenr+"\t  "+promRrvaenr+"\t  "+SSItenr+"\t  "+ratioIrrvaenr+"\t  ******"+"\t  "+MRt+"\t  "+promMRt+"\t  "+SSMrt+"\t  "+ratioMrt);
print(f, " Seg�n verde"+"\t  "+rvaenv+"\t  "+promRrvaenv+"\t  "+SSItenv+"\t  "+ratioIrrvaenv+"\t  ******"+"\t  "+MVt+"\t  "+promMVt+"\t  "+SSMvt+"\t  "+ratioMvt);
print(f, " Seg�n azul"+"\t  "+rvaena+"\t  "+promRrvaena+"\t  "+SSItena+"\t  "+ratioIrrvaena+"\t  ******"+"\t  "+MAt+"\t  "+promMAt+"\t  "+SSMat+"\t  "+ratioMat);
print(f, "");
if(generadasP==true || generadasI==true)
print(f, "valor P: "+1/numGeneradas);

if(referencias==true)
{
print("REFERENCIAS:\n");
print("% intersecci�n: porcentage de colocalizaci�n seg�n coeficientes de intersecci�n.\n");
print("% aleatorizaciones: promedio de resultados de colocalizaci�n obtenidos de las im�genes generadas (o aleatorizaciones) para coeficientes de intersecci�n.\n");
print("SE: significancia estad�stica. El primero de la tabla (de izquierda a derecha), para coeficientes de intersecci�n, y el segundo para Manders.\n");
print("SC: colocalizaci�n significativa; SE: exclusi�n significativa; NS: resultado no significativo.\n");
print("relaci�n: entre la cantidad de aleatorizaciones que arrojaron resultados de colocalizaci�n menores que las im�genes generadas y la cantidad total de aleatorizaciones. \n");
print("Tiende a 1 cuando los resultados de aleatorizaciones se acercan a colocalizaci�n significativa y a cero cuando los resultados tienden a exclusi�n significativa.\n");
print(" El primero de la table (de izquierda a derecha), para coeficientes de intersecci�n y el segundo para Manders. \n");
print("Pearson: coeficiente de Pearson. Solo para colocalizaci�n doble.\n");
print("Manders: coeficiente de Manders.\n");
print("aleatorizaciones: promedio de resultados de colocalizaci�n obtenidos de las im�genes generadas para coeficientes de Manders.\n");
print("General: coeficiente de intersecci�n seg�n superficie cubierta por los tres canales.\n");
print("Valor P: define el nivel de significaci�n. Cuanto menor sea m�s significativos ser�n los resultados. Es el cociente: 1/(n�mero de im�genes generadas).\n");
print("\n");
}



setBatchMode(false);

// Resultados gr�ficos
          

if(interseccion==true)
{
run("Merge Channels...", "c1=[rojoAndMascara] c2=[verdeAndMascara] c3=[azulAndMascara] create keep");    //Genero imagen de triple colocalizaci�n
rename("Colocalizaci�n");
updateDisplay();
}

if(imagenAleatoria==true)
{
if(interseccion==true)
{
if(intOR==true)
{
selectWindow("GOR");
run("Duplicate...", "title=MascaraConfinada");
	selectWindow("GOR");                            //genero una imagen aleatoria para el canal rojo
	run("Duplicate...", "title=RojoAleatorioIntersecci�n");
	z=0;
            f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
			showStatus("Generando resultados gr�ficos...");
          			f=random;
			if(f<=(unosGOR-unosRojos)/unosGOR)
			setPixel(x, y, 0);
			}
		}
run("Red");
updateDisplay();
}
else
{
	selectWindow(mascara);                            //genero una imagen aleatoria para el canal rojo
	run("Duplicate...", "title=RojoAleatorioIntersecci�n");
	z=0;
            f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
			showStatus("Generando resultados gr�ficos...");
          			f=random;
			if(f<=cerosRandRojos/unosMascara)
			setPixel(x, y, 0);
			}
		}
run("Red");
updateDisplay();
}	
}

if(pearson==true && generadasP==true)
{                                     
i=0;                                       //desordeno aleatoriamente el vector
for(i=0; i<w*h; i++)
	u[i]=true;

vd=newArray(w*h);
i=0;	
while(i<valoresV)
	{
	e=round(random*valoresV);
        	if(u[e]==true)
		{
		vd[i]=vb[e];
		u[e]=false;
		i++;
		}
	}
	
factor=valoresV/unosMascara;                                                                            //pongo los valores en la mascara

selectWindow(mascara);
run("Duplicate...", "title=VerdeAleatorioManders");
suma=0;
i=0;
while(suma<sumVerdeR-255)
	{
	for (y=0; y<h; y++)
		{
		for (x=0; x<w; x++)
			{
			showStatus("Generando resultados gr�ficos...");
			p=random;
			l=getPixel(x, y);
			if(l==255 && p <= factor)
				{
				setPixel(x, y, vd[i]);
				suma=suma+vd[i];
				i++;
				}
			}
		}
	}

for (y=0; y<h; y++)                                      //cambio unos por ceros
	{
	for (x=0; x<w; x++)
		{
		l=getPixel(x, y);
		if(l == 255)
			setPixel(x, y, 0);
		}
	}
run("Green");
updateDisplay();
 }
}
/*
selectWindow("rojoAndMascara");
rename("Rojo");
selectWindow("verdeAndMascara");
rename("Verde");
selectWindow("azulAndMascara");
rename("Azul");
*/

selectWindow("rojoAndMascara");
close();
selectWindow("verdeAndMascara");
close();
selectWindow("azulAndMascara");
close();
if(intOR==true)
{
selectWindow("GOR");
close();
}
/*
print(rMRt[0]);
print(rnumMRt[0]);
print(sumRojo);
print(unosRojos);
print(unosVerdes);                                         //sentencias de prueba de c�digo
print(unosAzules);
print(cerosRandRojos);
print(cerosRandVerdes);
print(cerosRandAzules);
print(unosMascara);
print(cerosMascara);
*/


}

//fin TRIPLE


















































if(canals=="Dos")
{

  Dialog.create("SETC");    //genero ventana de inicio
                                                                    
  Dialog.addChoice("Rojo:", figura);         
  Dialog.addChoice("Verde:", figura);          
   Dialog.addChoice("M�scara:", figura);  
  Dialog.addCheckbox("Calcular coeficientes de Pearson y Manders", true);
  Dialog.addCheckbox("Significancia estad�stica de Manders", false); 
  Dialog.addCheckbox("Calcular coeficientes de Intersecci�n", true);
  Dialog.addCheckbox("Significancia estad�stica de coef. de intersecci�n", false); 
  Dialog.addNumber("N�mero de im�genes generadas:", 50); 
  Dialog.addCheckbox("Circunscribir m�scara", false);
  Dialog.addCheckbox("Mostrar ejemplos de imagenes generadas", false);
  Dialog.addCheckbox("Mostrar referencias de tabla de resultados", true);
  
       Dialog.show();
   	rojo=Dialog.getChoice();
   	verde=Dialog.getChoice();
   	mascara=Dialog.getChoice();
   	pearson=Dialog.getCheckbox();
	generadasP=Dialog.getCheckbox();
	interseccion=Dialog.getCheckbox();
	generadasI=Dialog.getCheckbox();
	numGeneradas=Dialog.getNumber();
            intOR=Dialog.getCheckbox();
   	imagenAleatoria=Dialog.getCheckbox();
	referencias=Dialog.getCheckbox();
   	
	






//SENTENCIAS USADAS EN VARIOS BLOQUES

if(pearson==false && interseccion==false)
	exit("Seleccionar al menos un casillero de coeficientes");   
if(numGeneradas>50)
	exit("El n�mero de im�genes generadas no puede ser mayor a 50");   

selectWindow(mascara);
run("Select None");

selectWindow(rojo);
run("8-bit");
selectWindow(verde);
run("8-bit");


w = getWidth;                                  //cargo tama�o de imagen
h = getHeight;


imageCalculator("AND create", verde, mascara);     //opero im�genes con la m�scara
rename("verdeAndMascara");
imageCalculator("AND create", rojo, mascara);   
rename("rojoAndMascara");

setBatchMode(true);

function contarUnos(ventana)                     //Declaro una funci�n que cuenta unos
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   sumador=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		sumador++;
	}
return sumador;
}

function contarCeros(ventana)                     //Declaro una funci�n que cuenta ceros
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   sumador=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==0)
		sumador++;
	}
return sumador;
}

unosMascara=contarUnos(mascara);                        //cuento unos y ceros en la mascara
cerosMascara=contarCeros(mascara);

if(unosMascara+cerosMascara!=w*h)
	exit("Binarizar la m�scara antes de ejecutar la aplicaci�n");

function sumarPixInt(ventana)                     //Declaro una funci�n que suma intensidades de todos los pixeles
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   suma=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	suma=suma+a[i];
	}
return suma;
}








// CALCULO DE COEFICIENTE DE PEARSON Y MANDERS

if(pearson==true)
{

showStatus("Calculando coeficiente de Pearson y Manders...");

sumRojo=sumarPixInt("rojoAndMascara");                     //sumo intensidades en cada imagen
sumVerde=sumarPixInt("verdeAndMascara");

pr=sumRojo/unosMascara;                                    //calculo promedios de intensidad para cada imagen 
pv=sumVerde/unosMascara;

    nunRV=0;
   denR=0;
   denV=0;

numMRv=0;
numMVr=0;

 
selectWindow("rojoAndMascara");	
  r = newArray(w*h);
  i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		r[i] = getPixel(x,y);
		if(r[i] == 255)
			r[i]=254;
		i++;
		}
	}
sumRojoR=0;
i=0;
for (i=0; i<w*h; i++)
	sumRojoR=sumRojoR+r[i];
	

selectWindow("verdeAndMascara");	
  v = newArray(w*h);
  i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		v[i] = getPixel(x,y);
		if(v[i] == 255)
			v[i]=254;
		i++;
		}
	}
sumVerdeR=0;
i=0;
for (i=0; i<w*h; i++)
	sumVerdeR=sumVerdeR+v[i];



for(i=0; i<w*h; i++)                                     //calculo todas las series                
	{
	showStatus("Calculando coeficiente de Pearson y Manders...");
	denR=denR+(r[i]-pr)*(r[i]-pr);                                                                 //Pearson                                          
	denV=denV+(v[i]-pv)*(v[i]-pv);
	numRV=numRV+(r[i]-pr)*(v[i]-pv);
	
	if(r[i]*v[i] != 0)
		{
		numMRv=numMRv+r[i];
		numMVr=numMVr+v[i];
		}	
	
	}

denRV=sqrt(denR*denV);                             //calculo coeficientes de Pearson

PrRV=numRV/denRV;                                     

MRv=numMRv/sumRojo;
MVr=numMVr/sumVerde;


showStatus("");

}
 











//  SIGNIFICANCIA ESTAD�STICA DE MANDERS

if(generadasP==true && pearson==true)
{

showStatus("Calculando significancia estad�stica para coeficiente de Manders...");


rMRv=newArray(numGeneradas);
rMVr=newArray(numGeneradas);

rnumMRv=newArray(numGeneradas);  
rnumMVr=newArray(numGeneradas);  

pMRv=0;
pMVr=0;

nMRv=0;
nMVr=0;


function cantPixInt(ventana)                     //Declaro una funci�n que cuenta pixeles distintos de cero
{
selectWindow(ventana);       
   a = newArray(w*h);
   i = 0;
   suma=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
		
	}
for(i=0; i<w*h; i++)
	{
	if(a[i] != 0)
		suma++;
	}
return suma;
}

valoresR=cantPixInt("rojoAndMascara");            //cantidad de pixeles mayores que cero
valoresV=cantPixInt("verdeAndMascara");  


selectWindow("rojoAndMascara");
rb=newArray(w*h);                               //genero un vector que contiene solo los valores distintos de cero para cada canal
s=0;
for(i=0; i<w*h; i++)
	{
	if(r[i] != 0)
		{
		rb[s]=r[i];
		s++;
		}
	}



for(s=0; s<numGeneradas; s++)                                        //rulo para generar tantas im�genes aleatorias para cada fluor�foro como se cargue en el di�logo de entrada
{
 
//beep();                                                                                    //genero imagenes aleatorias

random("seed", round(random*w*h*10));
	
u=newArray(w*h+10);                                                                //desordeno aleatoriamente el vector rojo
i=0;
for(i=0; i<w*h; i++)
	u[i]=true;

rd=newArray(w*h);
i=0;	
while(i<valoresR)
	{
	e=round(random*valoresR);
        	if(u[e]==true)
		{
		rd[i]=rb[e];
		u[e]=false;
		i++;
		}
	}
	
factor=valoresR/unosMascara;                                                                            //pongo los valores en la mascara

selectWindow(mascara);
run("Duplicate...", "title=RandRojo");
suma=0;
i=0;
while(suma<sumRojoR-255)
	{
	for (y=0; y<h; y++)
		{
		for (x=0; x<w; x++)
			{
			p=random;
			l=getPixel(x, y);
			if(l==255 && p <= factor)
				{
				setPixel(x, y, rd[i]);
				suma=suma+rd[i];
				i++;
				}
			}
		}
	}

for (y=0; y<h; y++)                                      //cambio unos por ceros
	{
	for (x=0; x<w; x++)
		{
		l=getPixel(x, y);
		if(l == 255)
			setPixel(x, y, 0);
		}
	}
	
                                                                //desordeno aleatoriamente el vector verde


                                     
	
selectWindow("RandRojo");        //obtengo el valor de cada pixel para cada imagen y los transformo en vectores unidimensionales	
   rR = newArray(w*h);    
   i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		rR[i++] = getPixel(x,y);
	}


	
	for(i=0; i<w*h; i++)                                     //calculo doble colocalizacion de imagenes generadas                
	{
	if(rR[i]*v[i] != 0)
		{
		rnumMRv[s]=rnumMRv[s]+rR[i];
		rnumMVr[s]=rnumMVr[s]+v[i];
		}	
	}

	
rMRv[s]=rnumMRv[s]/sumRojo;
rMVr[s]=rnumMVr[s]/sumVerde;


	if(rMRv[s]<=MRv)
		pMRv++;
		else
		nMRv++;	
	if(rMVr[s]<=MVr)
		pMVr++;
		else
		nMVr++;


selectWindow("RandRojo");                           //cierro im�genes para que no interfieran en el pr�ximo ciclo del lazo	
close();


	
}

ratioMv=pMRv/numGeneradas;                            //Valores de la tabla de resultados, colo significativa (SC)....
ratioMr=pMVr/numGeneradas;

if(pMRv==0)
	SSMr="SE";
	else
	if(pMRv==numGeneradas)
		SSMr="SC";
		else
		SSMr="NS";

if(pMVr==0)
	SSMv="SE";
	else
	if(pMVr==numGeneradas)
		SSMv="SC";
		else
		SSMv="NS";

sumMRv=0;
sumMVr=0;


for(i=0; i<numGeneradas; i++)         //sumo
	{	
	sumMRv=sumMRv+rMRv[i];
	sumMVr=sumMVr+rMVr[i];
	}
	

promMRv=sumMRv/numGeneradas; 
promMVr=sumMVr/numGeneradas; 


}

showStatus("");













//BINARIZACI�N

setBatchMode(false);

if(interseccion==true)
{  
  Dialog.create("Binarizaci�n");                                                                                                                                                 //cuadro de di�logo de selecci�n de tipo de binarizaci�n                                         
  Dialog.addChoice("Seleccione el tipo de binarizaci�n", newArray("por defecto", "seg�n intensidad promedio", "manual")); 
        Dialog.show();
	bin=Dialog.getChoice();

if(bin=="por defecto")
{
selectWindow("rojoAndMascara");
run("Make Binary");
selectWindow("verdeAndMascara");                                                             
run("Make Binary");
}

   	
if(bin=="seg�n intensidad promedio")
{

 Dialog.create("Factor de Multiplicaci�n");                                                                                                                                                                                        
 Dialog.addChoice("Seleccione el factor de multiplicaci�n", newArray(0.125, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.5, 3, 4)); 
 Dialog.addMessage("El factor multiplica la intensidad promedio de cada canal para fijar el umbral\na partir del cual cada pixel ser� llevado a su m�ximo o m�nimo valor.\nMientras mayor sea el factor menor ser� la cantidad de pixeles blancos en la imagen.");           
       Dialog.show();
	factorP=Dialog.getChoice();

if(pearson==false)
{
sumRojo=sumarPixInt("rojoAndMascara");                     //sumo intensidades en cada imagen
sumVerde=sumarPixInt("verdeAndMascara");
}

pr=sumRojo/unosMascara;                                    //calculo promedios de intensidad para cada imagen 
pv=sumVerde/unosMascara;


selectWindow("rojoAndMascara");            //binariza canal rojo segun intensidad promedio   
i = 0;
 for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		{	
		showStatus("Binarizando im�genes...");
		a = getPixel(x,y);
		if(a>pr*factorP)
			setPixel(x, y, 255);
			else
			setPixel(x, y, 0);
		}

	}
updateDisplay();


selectWindow("verdeAndMascara");      //binariza canal verde seg�n intensidad promedio
i = 0;
 for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		{	
		showStatus("Binarizando im�genes...");
		a = getPixel(x,y);
		if(a>pv*factorP)
			setPixel(x, y, 255);
			else
			setPixel(x, y, 0);
		}

	}
updateDisplay();
}


if(bin=="manual")                                     //binarizaci�n manual
{  
selectWindow("rojoAndMascara");
run("Threshold...");                                                                    
waitForUser("Binarizaci�n manual", "Pulse OK luego de binarizar rojoAndMascara");
updateDisplay();
selectWindow("verdeAndMascara");                                                             
waitForUser("Binarizaci�n manual", "Pulse OK luego de binarizar verdeAndMascara");
updateDisplay();
selectWindow("Threshold");
run("Close");

 }
}














// COLOCALIZACI�N DE INTERSECCI�N        

if(intOR==true)
{
imageCalculator("OR create", "rojoAndMascara", "verdeAndMascara");          
rename("GOR"); 
run("Mean...", "radius=1");  
//run("Gaussian Blur...", "sigma=1");
run("Threshold...");
setThreshold(1, 255);
run("Convert to Mask");
unosGOR=contarUnos("GOR");
selectWindow("Threshold");
run("Close");
}

setBatchMode(true);

if(interseccion==true)
{
showStatus("Calculando porcentage de colocalizaci�n de intersecci�n...");

cerosRojos=contarCeros("rojoAndMascara");                     //cuento ceros en cada canal
cerosVerdes=contarCeros("verdeAndMascara");

cerosRandRojos=cerosRojos-cerosMascara;                       // calculo la cantidad de ceros dentro de la m�scara para cada color
cerosRandVerdes=cerosVerdes-cerosMascara;

imageCalculator("AND create", "rojoAndMascara", "verdeAndMascara");     //opero para obtener doble colocalizaci�n
rename("rojoAndVerde");

unosRojos=contarUnos("rojoAndMascara");                     //cuento unos en cada canal
unosVerdes=contarUnos("verdeAndMascara");

unosRV=contarUnos("rojoAndVerde");                       //cuento unos de doble colo

rv=(unosRV/unosRojos)*100;                            //calculo coeficientes de colocalizaci�n
vr=(unosRV/unosVerdes)*100;
supTot=(unosRV/(unosRojos+unosVerdes-unosRV))*100;



}












//  SIGNIFICANCIA ESTAD�STICA INTERSECCI�N

if(generadasI==true && interseccion==true)
{

showStatus("Calculando significancia estad�stica de colocalizaci�n de intersecci�n...");

rrv=newArray(numGeneradas);                           //Defino arreglos para cada indice de colocalizaci�n
rvr=newArray(numGeneradas);
rSupTot=newArray(numGeneradas);   

pcrrv=0;		                                       //Inicializo contadores positivos
pcrvr=0;	
pSupTot=0;

ncrrv=0;		                                       //Inicializo contadores negativos
ncrvr=0;
nSupTot=0;



for(s=0; s<numGeneradas; s++)                        //rulo para generar tantas im�genes aleatorias para cada fluor�foro como se cargue en el di�logo de entrada
	{
	//beep();

	random("seed", round(random*w*h*10));

if(intOR==true)
{
selectWindow("GOR");                            //genero una imagen aleatoria para el canal rojo
	run("Duplicate...", "title=RandRojo");
	z=0;
            f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			f=random;
			if(f<=(unosGOR-unosRojos)/unosGOR)
			setPixel(x, y, 0);
			}
		}
}
else
{
	selectWindow(mascara);                            //genero una imagen aleatoria para el canal rojo
	run("Duplicate...", "title=RandRojo");
	z=0;
            f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			f=random;
			if(f<=cerosRandRojos/unosMascara)
			setPixel(x, y, 0);
			}
		}
		
}	
	
	
	imageCalculator("AND create", "RandRojo", "verdeAndMascara");     //opero para obtener doble colocalizaci�n
	rename("RandRojoAndRandVerde");
	
	RandunosRV=contarUnos("RandRojoAndRandVerde");    //cueno pixeles de doble colo 
	
	
// la superficie cubierta total aleatoria es la misma que la del ensayo
// igual que el total de unos para cada color son los del ensayo


	rrv[s]=(RandunosRV/unosRojos)*100;                            //calculo coeficientes de colocalizaci�n
	rvr[s]=(RandunosRV/unosVerdes)*100;
	rSupTot[s]=(RandunosRV/(unosRojos+unosVerdes-RandunosRV))*100;

	if(rrv[s]<=rv)                           //Para cada coeficiente de colocalizaci�n cuento cuantas veces fue mayor el generado al azar
		pcrrv++;
		else
		ncrrv++;	
	if(rvr[s]<=vr)
		pcrvr++;
		else
		ncrvr++;
	if(rSupTot[s]<=supTot)
		pSupTot++;
		else
		nSupTot++;


	

selectWindow("RandRojo");                           //cierro im�genes para que no interfieran en el pr�ximo ciclo del lazo	
close();
selectWindow("RandRojoAndRandVerde");
close();	

	
}

ratioIr=pcrrv/numGeneradas;                                  //Valores de la tabla de resultados, colo significativa (SC)....                      
ratioIv=pcrvr/numGeneradas;
ratioIst=pSupTot/numGeneradas;

if(pcrrv==0)
	SSIr="SE";
	else
	if(pcrrv==numGeneradas)
		SSIr="SC";
		else
		SSIr="NS";

if(pcrvr==0)
	SSIv="SE";
	else
	if(pcrvr==numGeneradas)
		SSIv="SC";
		else
		SSIv="NS";

if(pSupTot==0)
	SSst="SE";
	else
	if(pSupTot==numGeneradas)
		SSst="SC";
		else
		SSst="NS";


sumRrv=0;                          //inicializo variables de suma para promedios
sumRvr=0;
sumSupTot=0;

for(i=0; i<numGeneradas; i++)         //sumo
	{	
	sumRrv=sumRrv+rrv[i];
	sumRvr=sumRvr+rvr[i];
	sumSupTot=sumSupTot+rSupTot[i];
	}
	
promRrv=sumRrv/numGeneradas;                                    //promedio
promRvr=sumRvr/numGeneradas; 
promSupTot=sumSupTot/numGeneradas;   

}

showStatus("");







//RESULTADOS

if(interseccion==true)
{
selectWindow("rojoAndVerde");               //cierro im�genes para que no interfieran con futuras corridas de la aplicaci�n
close();

}

if(interseccion==false)
{
rv="  ******";      
vr="  ******"; 
supTot="  ******"; 

}

if(pearson==false)
{
PrRV="  ******";                                                  //variables que no se calculan
MRv=" ******";
MVr=" ******";
}

if(generadasI==false || interseccion==false)
{
promRrv="  ******";      
promRvr="  ******"; 
promSupTot="  ******"; 
//pcrrv="  ******";                                     
//pcrvr="  ******";	 
//pSupTot="  ******"; 
//ncrrv="  ******";                                       
//ncrvr="  ******"; 
//nSupTot="  ******";
SSIr="  ******";
SSIv="  ******";
SSst="  ******";
ratioIst="  ******";
ratioIr="  ******";
ratioIv="  ******";
}
if(generadasP==false || pearson==false)
{
//pMRv=" ******";
//pMVr=" ******";
//nMRv=" ******";
//nMVr=" ******";
ratioMr="  ******";
ratioMv="  ******";
SSMr="  ******";
SSMv="  ******";
promMRv="  ******";
promMVr="  ******";
}


titulo1 = "Resultados";                                            //genero cuadro que muestra resultados
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if (isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings:para\t% intersecci�n\t% aleatorizaciones\t  SE \trelaci�n\tPearson\tManders\taleatorizaciones\t  SE\trelaci�n");
print(f, " Rojo en verde"+"\t  "+rv+"\t  "+promRrv+"\t  "+SSIr+"\t  "+ratioIr+"\t  "+PrRV+"\t  "+MRv+"\t  "+promMRv+"\t  "+SSMr+"\t  "+ratioMr);
print(f, " Verde en rojo"+"\t  "+vr+"\t  "+promRvr+"\t  "+SSIv+"\t  "+ratioIv+"\t  "+PrRV+"\t  "+MVr+"\t  "+promMVr+"\t  "+SSMv+"\t  "+ratioMv);
print(f, " General"+"\t  "+supTot+"\t  "+promSupTot+"\t  "+SSst+"\t  "+ratioIst+"\t    ******"+"\t   ******"+"\t    ******"+"\t   ******"+"\t   ******");
print(f, "");
if(generadasP==true || generadasI==true)
print(f, "Valor P= "+1/numGeneradas);

if(referencias==true)
{
print("REFERENCIAS:\n"); 
print("% intersecci�n: porcentage de colocalizaci�n seg�n coeficientes de intersecci�n.\n");
print("% aleatorizaciones: promedio de resultados de colocalizaci�n obtenidos de las im�genes generadas (o aleatorizaciones) para coeficientes de intersecci�n.\n");
print("SE: significancia estad�stica. El primero de la tabla (de izquierda a derecha), para coeficientes de intersecci�n, y el segundo para Manders.\n");
print("SC: colocalizaci�n significativa; SE: exclusi�n significativa; NS: resultado no significativo.\n");
print("relaci�n: entre la cantidad de aleatorizaciones que arrojaron resultados de colocalizaci�n menores que las im�genes generadas y la cantidad total de aleatorizaciones. \n");
print("Tiende a 1 cuando los resultados de aleatorizaciones se acercan a colocalizaci�n significativa y a cero cuando los resultados tienden a exclusi�n significativa.\n");
print(" El primero de la table (de izquierda a derecha), para coeficientes de intersecci�n y el segundo para Manders. \n");
print("Pearson: coeficiente de Pearson. Solo para colocalizaci�n doble.\n");
print("Manders: coeficiente de Manders.\n");
print("aleatorizaciones: promedio de resultados de colocalizaci�n obtenidos de las im�genes generadas para coeficientes de Manders.\n");
print("General: coeficiente de intersecci�n seg�n superficie cubierta por los dos canales.\n");
print("Valor P: define el nivel de significaci�n. Cuanto menor sea m�s significativos ser�n los resultados. Es el cociente: 1/(n�mero de im�genes generadas).\n");
print("\n");
}

setBatchMode(false);

// Resultados gr�ficos
          

if(interseccion==true)
{
run("Merge Channels...", "c1=[rojoAndMascara] c2=[verdeAndMascara] create keep");    //Genero imagen de triple colocalizaci�n
rename("Colocalizaci�n");
updateDisplay();
}

if(imagenAleatoria==true)
{

if(interseccion==true)
{

if(intOR==true)
{
selectWindow("GOR");
run("Duplicate...", "title=MascaraConfinada");
selectWindow("GOR");                                                          //muestro ejemplo de imagen aleatoria
	run("Duplicate...", "title=RojoAleatorioIntersecci�n");
	z=0;
            f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
			showStatus("Generando resultados gr�ficos...");
          			f=random;
			if(f<=(unosGOR-unosRojos)/unosGOR)
					setPixel(x, y, 0);
			}
		}
	run("Red");
	updateDisplay();
}
else
{
selectWindow(mascara);                                                          //muestro ejemplo de imagen aleatoria
	run("Duplicate...", "title=RojoAleatorioIntersecci�n");
	z=0;
            f=0;
   	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
			showStatus("Generando resultados gr�ficos...");
          			f=random;
			if(f<=cerosRandRojos/unosMascara)
					setPixel(x, y, 0);
			}
		}
	run("Red");
	updateDisplay();
}

}

if(pearson==true && generadasP==true)
{                                     
i=0;                                       //desordeno aleatoriamente el vector
for(i=0; i<w*h; i++)
	u[i]=true;

rd=newArray(w*h);
i=0;	
while(i<valoresR)
	{
	e=round(random*valoresR);
        	if(u[e]==true)
		{
		rd[i]=rb[e];
		u[e]=false;
		i++;
		}
	}
	
factor=valoresR/unosMascara;                                                                            //pongo los valores en la mascara

selectWindow(mascara);
run("Duplicate...", "title=VerdeAleatorioManders");
suma=0;
i=0;
while(suma<sumRojoR-255)
	{
	for (y=0; y<h; y++)
		{
		for (x=0; x<w; x++)
			{
			showStatus("Generando resultados gr�ficos...");
			p=random;
			l=getPixel(x, y);
			if(l==255 && p <= factor)
				{
				setPixel(x, y, rd[i]);
				suma=suma+rd[i];
				i++;
				}
			}
		}
	}

for (y=0; y<h; y++)                                      //cambio unos por ceros
	{
	for (x=0; x<w; x++)
		{
		l=getPixel(x, y);
		if(l == 255)
			setPixel(x, y, 0);
		}
	}
run("Green");
updateDisplay();
 }
}
/*
selectWindow("rojoAndMascara");
rename("Rojo");
selectWindow("verdeAndMascara");
rename("Verde");

*/

selectWindow("rojoAndMascara");
close();
selectWindow("verdeAndMascara");
close();
if(intOR==true)
{
selectWindow("GOR");
close();
}

}

//fin DOBLE

}
//FIN












































