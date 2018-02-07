/*Significancia Estadística de la Triple Colocalización (SETC)
Julio Buonfigli
*/

// COLOCALIZACIÓN

id1=getImageID();          //identificación de IDs
tamano=0;
figura=newArray(30);
for(i=id1-10; i<id1+11; i++)
	{
	if(isOpen(i))
		{
		selectImage(i);
		tamano++;
		figura[tamano]=getTitle();
		}		
	}
imagen1=figura[1];          
imagen2=figura[2];
imagen3=figura[3];
imagen4=figura[4];
/*
if(nImages>4)
imagen5=figura[5];
if(nImages>5)
imagen6=figura[6];       
imagen7=figura[7];
imagen8=figura[8];
imagen9=figura[9];
imagen10=figura[10];
*/


  Dialog.create("SETC");                                                                           
  Dialog.addChoice("Rojo:", newArray(imagen1, imagen2, imagen3, imagen4));                  //genero ventana de inicio
  Dialog.addChoice("Verde:", newArray(imagen1, imagen2, imagen3, imagen4));
  Dialog.addChoice("Azul:", newArray(imagen1, imagen2, imagen3, imagen4));
  Dialog.addChoice("Máscara:", newArray(imagen1, imagen2, imagen3, imagen4));
  Dialog.addCheckbox("Mostrar resultados de doble colocalización", false);
  Dialog.addCheckbox("Comparar resultados con imágenes generadas", true);
  Dialog.addNumber("Número de imágenes generadas:", 5); 
  Dialog.addCheckbox("Mostrar ejemplo de imágenes generadas", true);
  Dialog.addCheckbox("Mostrar selección de canales", true);
  Dialog.addCheckbox("Mostrar secuencia de procesamiento de imágenes", false);
        Dialog.show();
   	rojo=Dialog.getChoice();
   	verde=Dialog.getChoice();
   	azul=Dialog.getChoice();
   	mascara=Dialog.getChoice();
   	dobleColo=Dialog.getCheckbox();
   	generadas=Dialog.getCheckbox();
   	numGeneradas=Dialog.getNumber();
   	ejemplo=Dialog.getCheckbox();
   	mostrarCanales=Dialog.getCheckbox();
	proceso=Dialog.getCheckbox();

if(numGeneradas>50)
	exit("El número de imágenes generadas no puede ser mayor a 50");

if(proceso==true)
	g=false;
	else
	g=true;	

setBatchMode(g);                   //por si quiero ver como se procesan las imágenes

imageCalculator("AND create", rojo, mascara);    //opero imagenes con la máscara
id2=getImageID();
selectImage(id2);
rojoAndMascara = getTitle();
imageCalculator("AND create", verde, mascara);  
id3=getImageID();
selectImage(id3);
verdeAndMascara = getTitle();
imageCalculator("AND create", azul, mascara);  
id4=getImageID();
selectImage(id4);
azulAndMascara = getTitle();


imageCalculator("AND create", rojoAndMascara, verdeAndMascara);     //opero para obtener doble colocalización
id5=getImageID();
selectImage(id5);
rename("auxiliar1");
rojoAndVerde = getTitle();
if(dobleColo==true)
	{
	imageCalculator("AND create", azulAndMascara, rojoAndMascara);  
	id6=getImageID();
	selectImage(id6);
	rename("auxiliar2");
	rojoAndAzul = getTitle();
	imageCalculator("AND create", verdeAndMascara, azulAndMascara);  
	id7=getImageID();
	selectImage(id7);
	rename("auxiliar3");
	verdeAndAzul = getTitle();
	}

imageCalculator("AND create", rojoAndVerde, azulAndMascara);     //obtengo triple colocalización
id8=getImageID();
selectImage(id8);
rename("Triple Colocalización");
rvam = getTitle();


selectWindow(mascara);       //Cuento la cantidad pixeles de la seleccion (o máscara)
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosMascara = 0;
   cerosMascara = 0;    
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosMascara++;
		else
		cerosMascara++;
	}


selectWindow(rvam);                                   //Cuento la cantidad de pixeles de triple colo
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosRvam = 0;    
for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
            	a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosRvam++;
	}		


selectWindow(rojoAndMascara);     //Cuento la cantidad de pixeles rojos dentro de la seleccion
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosRojos = 0;    
   cerosRojos = 0;
for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosRojos++;
		else
		cerosRojos++;
	}


selectWindow(verdeAndMascara);    //Cuento la cantidad de pixeles verdes dentro de la seleccion
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosVerdes = 0;    
   cerosVerdes =0;
for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosVerdes++;
		else
		cerosVerdes++;
	}	

selectWindow(azulAndMascara);      //Cuento cantidad de pixeles azules dentro de la selección 
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosAzules = 0;    
   cerosAzules = 0; 
for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosAzules++;
		else
		cerosAzules++;
	}

   selectWindow(rojoAndVerde);     //Cuento pixeles de doble colo rojo y Verde
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosRV = 0;    
   cerosRV = 0;
for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosRV++;
		else
		cerosRV++;
	}

if(dobleColo==true)
{
selectWindow(rojoAndAzul);     //Cuento pixeles de doble colo rojo y Azul
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosRA = 0;    
   cerosRA = 0;
for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosRA++;
		else
		cerosRA++;
	}


selectWindow(verdeAndAzul);     //Cuento pixeles de doble colo verde y azul
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosVA = 0;    
   cerosVA = 0;
for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosVA++;
		else
		cerosVA++;
	}
}

imageCalculator("OR create", rojoAndMascara, verdeAndMascara);    //Calculo la superficie cubierta total dentro de la máscara
	id9 = getImageID();		
	selectImage(id9);
	rojoOrverde = getTitle();
imageCalculator("OR create", rojoOrverde, azulAndMascara);                 
	id10 = getImageID();
	selectImage(id10);
	rvamOr = getTitle();


selectWindow(rvamOr);     //Cuento pixeles de superficie cubierta total
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosRvamOr = 0;    
   cerosRvamOr = 0;
for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosRvamOr++;
		else
		cerosRvamOr++;
	}


selectImage(id2);       //cierro las imágenes que no estoy usando. 
close();
selectImage(id3);
close();
selectImage(id4);
close();
selectImage(id5);
close();
if(dobleColo==true)
	{
	selectImage(id6);
	close();	
	selectImage(id7);
	close();
	}
selectImage(id9);
close();
selectImage(id10);
close();
selectImage(id8);
close();

if(dobleColo==true)
	{
	rv=(unosRV/unosRojos)*100;                            //calculo coeficientes de colocalización
	vr=(unosRV/unosVerdes)*100;
	ra=(unosRA/unosRojos)*100;
	ar=(unosRA/unosAzules)*100;
	va=(unosVA/unosVerdes)*100;
	av=(unosVA/unosAzules)*100;
	}
rvasc=(unosRvam/unosRvamOr)*100;
rvaenr=(unosRvam/unosRojos)*100;
rvaenv=(unosRvam/unosVerdes)*100;
rvaena=(unosRvam/unosAzules)*100;


/*
print(cerosMascara);        //Sentencias de prueba de codigo
print(unosMascara);
print(cerosRojos);
print(unosRojos);
print(cerosVerdes);
print(unosVerdes);
print(cerosAzules);
print(unosAzules);
print(unosRvam);
print(cerosRV);
print(unosRV);
print(cerosRA);
print(unosRA);
print(cerosVA);
print(unosVA);
print(cerosRvamOr);
print(unosRvamOr);
*/






//  SIGNIFICANCIA ESTADÍSTICA


cerosRandRojos=cerosRojos-cerosMascara;                       // calculo la cantidad de ceros dentro de la máscara para cada color
cerosRandVerdes=cerosVerdes-cerosMascara;
cerosRandAzules=cerosAzules-cerosMascara;

if(generadas==true)
{
if(dobleColo==true)
	{
	rrv=newArray(numGeneradas);                           //Defino arreglos para cada indice de colocalización
	rvr=newArray(numGeneradas);
	rra=newArray(numGeneradas);
	rar=newArray(numGeneradas);
	rva=newArray(numGeneradas);
	rav=newArray(numGeneradas);
	}
rrvasc=newArray(numGeneradas);
rrvaenr=newArray(numGeneradas);
rrvaenv=newArray(numGeneradas);
rrvaena=newArray(numGeneradas);

if(dobleColo==true)
	{
	pcrrv=0;		                                       //Inicializo contadores positivos
	pcrvr=0;	
	pcrra=0;
	pcrar=0;
	pcrva=0;
	pcrav=0;
	}
pcrrvasc=0;
pcrrvaenr=0;
pcrrvaenv=0;
pcrrvaena=0;

if(dobleColo==true)
	{
	ncrrv=0;		                                       //Inicializo contadores negativos
	ncrvr=0;
	ncrra=0;
	ncrar=0;
	ncrva=0;
	ncrav=0;
	}
ncrrvasc=0;
ncrrvaenr=0;
ncrrvaenv=0;
ncrrvaena=0;


for(s=0; s<numGeneradas; s++)                        //rulo para generar tantas imágenes aleatorias para cada fluoróforo como se cargue en el diálogo de entrada
	{
	beep();

	selectWindow(mascara);                            //genero una imagen aleatoria para el canal rojo
	run("Duplicate...", "title=Rojo");
	idr1 = getImageID();		
	selectImage(idr1);
	imagenRandRojo = getTitle();
   	w = getWidth;
   	h = getHeight;
   	z=0;
            f=0;
   	r1=0;    
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			z = getPixel(x,y);
			if(z==255)
				{
				f=random;
				if(f<=cerosRandRojos/unosMascara)
					{
					setPixel(x, y, 0);
					r1++;
					}
				}
			}
		}
	updateDisplay();


	selectWindow(mascara);                            //genero una imagen aleatoria para el canal verde
	run("Duplicate...", "title=Verde");
	idr2 = getImageID();		
	selectImage(idr2);
	imagenRandVerde = getTitle();
   	w = getWidth;
   	h = getHeight;
   	z=0;
   	f=0;
   	r2=0;    
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			z = getPixel(x,y);
			if(z==255)
				{
				f=random;
				if(f<=cerosRandVerdes/unosMascara)
					{
					setPixel(x, y, 0);
					r2++;
					}
				}
			}
		}
	updateDisplay();


	selectWindow(mascara);                            //genero una imagen aleatoria para el canal azul
	run("Duplicate...", "title=Azul");
	idr3 = getImageID();		
	selectImage(idr3);
	imagenRandAzul = getTitle();
   	w = getWidth;
   	h = getHeight;
   	z=0;
   	f=0;
   	r3=0;    
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			z = getPixel(x,y);
			if(z==255)
				{
				f=random;
				if(f<=cerosRandAzules/unosMascara)
					{
					setPixel(x, y, 0);
					r3++;
					}
				}
			}
		}
	updateDisplay();
	

	imageCalculator("AND create", imagenRandRojo, imagenRandVerde);     //opero para obtener doble colocalización
	idr4=getImageID();
	selectImage(idr4);
	rename("auxiliar1");
	rojoAndVerde = getTitle();
	if(dobleColo==true)
	{
	imageCalculator("AND create", imagenRandRojo, imagenRandAzul);  
	idr5=getImageID();
	selectImage(idr5);
	rename("auxiliar2");
	rojoAndAzul = getTitle();
	imageCalculator("AND create", imagenRandVerde, imagenRandAzul);  
	idr6=getImageID();
	selectImage(idr6);
	rename("auxiliar3");
	verdeAndAzul = getTitle();
	}

	imageCalculator("AND create", rojoAndVerde, imagenRandAzul);     //obtengo triple colocalización
	idr7=getImageID();
	selectImage(idr7);
	rename("Triple Colocalización");
	rvam = getTitle();

	selectWindow(imagenRandRojo);     //Cuento la cantidad de pixeles rojos dentro de la seleccion
   	w = getWidth;
   	h = getHeight;
   	a = newArray(w*h);
   	i = 0;
   	unosRojos = 0;    
   	cerosRojos = 0;
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
          			a[i++] = getPixel(x,y);
		}
	for(i=0; i<w*h; i++)
		{
		if(a[i]==255)
			unosRojos++;
			else
			cerosRojos++;
		}


	selectWindow(imagenRandVerde);    //Cuento la cantidad de pixeles verdes dentro de la seleccion
   	w = getWidth;
  	 h = getHeight;
  	 a = newArray(w*h);
  	 i = 0;
   	unosVerdes = 0;    
   	cerosVerdes =0;
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
          			a[i++] = getPixel(x,y);
		}
	for(i=0; i<w*h; i++)
		{
		if(a[i]==255)
			unosVerdes++;
			else
			cerosVerdes++;
		}	

	selectWindow(imagenRandAzul);      //Cuento cantidad de pixeles azules dentro de la selección 
   	w = getWidth;
   	h = getHeight;
   	a = newArray(w*h);
   	i = 0;
   	unosAzules = 0;    
   	cerosAzules = 0; 
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
          			a[i++] = getPixel(x,y);
		}
	for(i=0; i<w*h; i++)
		{
		if(a[i]==255)
			unosAzules++;
			else
			cerosAzules++;
		}

	selectWindow(rvam);                                   //Cuento la cantidad de pixeles de triple colo
   	w = getWidth;
   	h = getHeight;
   	a = newArray(w*h);
   	i = 0;
   	unosRvam = 0;    
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
            		a[i++] = getPixel(x,y);
		}
	for(i=0; i<w*h; i++)
		{
		if(a[i]==255)
			unosRvam++;
		}		

	if(dobleColo==true)
	{
	selectWindow(rojoAndVerde);     //Cuento pixeles de doble colo rojo y Verde
	w = getWidth;
   	h = getHeight;
   	a = newArray(w*h);
   	i = 0;
   	unosRV = 0;    
   	cerosRV = 0;
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
          			a[i++] = getPixel(x,y);
		}
	for(i=0; i<w*h; i++)
		{
		if(a[i]==255)
			unosRV++;
			else
			cerosRV++;
		}


	selectWindow(rojoAndAzul);     //Cuento pixeles de doble colo rojo y Azul
 	  w = getWidth;
 	  h = getHeight;
 	  a = newArray(w*h);
 	  i = 0;
 	  unosRA = 0;    
 	  cerosRA = 0;
	for (y=0; y<h; y++)
		{
	      	for (x=0; x<w; x++)
          			a[i++] = getPixel(x,y);
		}
	for(i=0; i<w*h; i++)
		{
		if(a[i]==255)
			unosRA++;
			else
			cerosRA++;
		}


	selectWindow(verdeAndAzul);     //Cuento pixeles de doble colo verde y azul
	   w = getWidth;
	   h = getHeight;
	   a = newArray(w*h);
	   i = 0;
	   unosVA = 0;    
	   cerosVA = 0;
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
          			a[i++] = getPixel(x,y);
		}
	for(i=0; i<w*h; i++)
		{
		if(a[i]==255)
			unosVA++;
			else
			cerosVA++;
		}
	}

	imageCalculator("OR create", imagenRandRojo, imagenRandVerde);    //Calculo la superficie cubierta total dentro de la máscara
	idr8 = getImageID();		
	selectImage(idr8);
	rojoOrverde = getTitle();
	imageCalculator("OR create", rojoOrverde, imagenRandAzul);                 
	idr9 = getImageID();
	selectImage(idr9);
	rvamOr = getTitle();


	selectWindow(rvamOr);     //Cuento pixeles de superficie cubierta total
   	w = getWidth;
  	 h = getHeight;
  	 a = newArray(w*h);
  	 i = 0;
   	unosRvamOr = 0;    
   	cerosRvamOr = 0;
	for (y=0; y<h; y++)
		{
	      	for (x=0; x<w; x++)
          			a[i++] = getPixel(x,y);
		}
	for(i=0; i<w*h; i++)
		{
		if(a[i]==255)
			unosRvamOr++;
			else
			cerosRvamOr++;
		}
	
	if(dobleColo==true)
	{
	rrv[s]=(unosRV/unosRojos)*100;                            //calculo coeficientes de colocalización
	rvr[s]=(unosRV/unosVerdes)*100;
	rra[s]=(unosRA/unosRojos)*100;
	rar[s]=(unosRA/unosAzules)*100;
	rva[s]=(unosVA/unosVerdes)*100;
	rav[s]=(unosVA/unosAzules)*100;	
	}
	rrvasc[s]=(unosRvam/unosRvamOr)*100;
	rrvaenr[s]=(unosRvam/unosRojos)*100;
	rrvaenv[s]=(unosRvam/unosVerdes)*100;
	rrvaena[s]=(unosRvam/unosAzules)*100;

	if(dobleColo==true)
	{
	if(rrv[s]<rv)                           //Para cada coeficiente de colocalización cuento cuantas veces fue mayor el generado al azar
		pcrrv++;
		else
		ncrrv++;	
	if(rvr[s]<vr)
		pcrvr++;
		else
		ncrvr++;
	if(rra[s]<ra)
		pcrra++;
		else
		ncrra++;
	if(rar[s]<ar)
		pcrar++;
		else
		ncrar++;	
	if(rva[s]<va)
		pcrva++;
		else
		ncrva++;
	if(rav[s]<av)
		pcrav++;
		else
		ncrav++;
	}
	if(rrvasc[s]<rvasc)
		pcrrvasc++;
		else
		ncrrvasc++;	
	if(rrvaenr[s]<rvaenr)
		pcrrvaenr++;
		else
		ncrrvaenr++;	
	if(rrvaenv[s]<rvaenv)
		pcrrvaenv++;
		else
		ncrrvaenv++;
	if(rrvaena[s]<rvaena)
		pcrrvaena++;
		else
		ncrrvaena++;	
	
	selectImage(idr1);       //cierro las imágenes que no estoy usando. 
	close();
	selectImage(idr2);
	close();
	selectImage(idr3);
	close();
	selectImage(idr4);
	close();
	if(dobleColo==true)
		{
		selectImage(idr5);
		close();
		selectImage(idr6);	
		close();
		}
	selectImage(idr7);
	close();	
	selectImage(idr8);
	close();
	selectImage(idr9);	
	close();
	}	

if(dobleColo==true)
	{	
	sumRrv=0;                          //inicializo variables de suma para promedios
	sumRvr=0;
	sumRra=0;
	sumRvr=0;
	sumRar=0;
	sumRva=0;
	sumRav=0;
	}
sumRrvasc=0;
sumRrvaenr=0;
sumRrvaenv=0;
sumRrvaena=0;


for(i=0; i<numGeneradas; i++)         //sumo
	{
	if(dobleColo==true)
		{		
		sumRrv=sumRrv+rrv[i];
		sumRvr=sumRvr+rvr[i];
		sumRra=sumRra+rra[i];
		sumRar=sumRar+rar[i];
		sumRva=sumRva+rva[i];
		sumRav=sumRav+rav[i];
		}
	sumRrvasc=sumRrvasc+rrvasc[i];
	sumRrvaenr=sumRrvaenr+rrvaenr[i];
	sumRrvaenv=sumRrvaenv+rrvaenv[i];
	sumRrvaena=sumRrvaena+rrvaena[i];
	}

if(dobleColo==true)
	{
	promRrv=sumRrv/numGeneradas;                                    //promedio
	promRvr=sumRvr/numGeneradas; 
	promRra=sumRra/numGeneradas; 
	promRar=sumRar/numGeneradas; 
	promRva=sumRva/numGeneradas; 
	promRav=sumRav/numGeneradas;
	} 
promRrvasc=sumRrvasc/numGeneradas; 
promRrvaenr=sumRrvaenr/numGeneradas; 
promRrvaenv=sumRrvaenv/numGeneradas; 
promRrvaena=sumRrvaena/numGeneradas; 
		
}



//RESULTADOS



print("RESULTADOS:");                               //Muestro resultados
print("");
if(dobleColo==true)
	{
	print("DOBLE COLOCALIZACIÓN:");
	print("El porcentaje de fluoróforo rojo en el canal verde es de: "+rv+" %.");
	if(generadas==true)
		{
		print("Y el resultado del promedio de aleatorizaciones es de: "+promRrv+" %.");
		print("Los resultados de colocalización por azar fueron en "+pcrrv+" aleatorizaciones menores que el ensayo y en "+ncrrv+" aleatorizaciones mayores"); 
		}
	print("El porcentaje de fluoróforo verde en el canal rojo es de: "+vr+" %.");
	if(generadas==true)
		{
		print("Y el resultado del promedio de aleatorizaciones es de: "+promRvr+" %.");
		print("Los resultados de colocalización por azar fueron en "+pcrvr+" aleatorizaciones menores que el ensayo y en "+ncrvr+" aleatorizaciones mayores");
		}
	print("El porcentaje de fluoróforo rojo en el canal azul es de: "+ra+" %."); 
	if(generadas==true)
		{
		print("Y el resultado del promedio de aleatorizaciones es de: "+promRra+" %");
		print("Los resultados de colocalización por azar fueron en "+pcrra+" aleatorizaciones menores que el ensayo y en "+ncrra+" aleatorizaciones mayores");
		}
	print("El porcentaje de fluoróforo azul en el canal rojo es de: "+ar+" %."); 
	if(generadas==true)
		{	
		print("Y el resultado del promedio de aleatorizaciones es de: "+promRar+" %.");
		print("Los resultados de colocalización por azar fueron en "+pcrar+" aleatorizaciones menores que el ensayo y en "+ncrar+" aleatorizaciones mayores");
		}
	print("El porcentaje de fluoróforo verde en el canal azul es de: "+va+" %."); 
		if(generadas==true)
		{
		print("Y el resultado del promedio de aleatorizaciones es de: "+promRva+" %.");
		print("Los resultados de colocalización por azar fueron en "+pcrva+" aleatorizaciones menores que el ensayo y en "+ncrva+" aleatorizaciones mayores");
		}
	print("El porcentaje de fluoróforo azul en el canal verde es de: "+av+" %."); 
	if(generadas==true)
		{
		print("Y el resultado del promedio de aleatorizaciones es de: "+promRav+" %.");
		print("Los resultados de colocalización por azar fueron en "+pcrav+" aleatorizaciones menores que el ensayo y en "+ncrav+" aleatorizaciones mayores");	
		}	
	print("");
	}
print("TRIPLE COLOCALIZACIÓN:");
print("El porcentaje de triple colocalización sobre la superficie cubierta por los tres fluoróforos es de: "+rvasc+" %.");
if(generadas==true)
	{
	print("Y el resultado del promedio de aleatorizaciones es de: "+promRrvasc+" %.");
	print("Los resultados de colocalización por azar fueron en "+pcrrvasc+" aleatorizaciones menores que el ensayo y en "+ncrrvasc+" aleatorizaciones mayores");
	}
print("El porcentaje de triple colocalización respecto del canal rojo es de: "+rvaenr+" %.");
if(generadas==true)
	{
	print("Y el resultado del promedio de aleatorizaciones es de: "+promRrvaenr+" %.");
	print("Los resultados de colocalización por azar fueron en "+pcrrvaenr+" aleatorizaciones menores que el ensayo y en "+ncrrvaenr+" aleatorizaciones mayores");
	}
print("El porcentaje de triple colocalización respecto del canal verde es de: "+rvaenv+" %.");
if(generadas==true)
	{
	print("Y el resultado del promedio de aleatorizaciones es de: "+promRrvaenv+" %.");
	print("Los resultados de colocalización por azar fueron en "+pcrrvaenv+" aleatorizaciones menores que el ensayo y en "+ncrrvaenv+" aleatorizaciones mayores");
	}
print("El porcentaje de triple colocalización respecto del canal azul es de: "+rvaena+" %.");
if(generadas==true)
	{
	print("Y el resultado del promedio de aleatorizaciones es de: "+promRrvaena+" %.");
	print("Los resultados de colocalización por azar fueron en "+pcrrvaena+" aleatorizaciones menores que el ensayo y en "+ncrrvaena+" aleatorizaciones mayores");
	}

setBatchMode(false);

if(ejemplo==true)                                     //Creo un ejemplo de imágenes aleatorizadas
{
selectWindow(mascara);                            //genero una imagen aleatoria para el canal rojo
	run("Duplicate...", "title=RojoAleatorio");
	run("Red");
	idr1 = getImageID();		
	selectImage(idr1);
	imagenRandRojo = getTitle();
   	w = getWidth;
   	h = getHeight;
   	z=0;
            f=0;
   	r1=0;    
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			z = getPixel(x,y);
			if(z==255)
				{
				f=random;
				if(f<=cerosRandRojos/unosMascara)
					{
					setPixel(x, y, 0);
					r1++;
					}
				}
			}
		}
	updateDisplay();


	selectWindow(mascara);                            //genero una imagen aleatoria para el canal verde
	run("Duplicate...", "title=VerdeAleatorio");
	run("Green");
	idr2 = getImageID();		
	selectImage(idr2);
	imagenRandVerde = getTitle();
   	w = getWidth;
   	h = getHeight;
   	z=0;
   	f=0;
   	r2=0;    
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			z = getPixel(x,y);
			if(z==255)
				{
				f=random;
				if(f<=cerosRandVerdes/unosMascara)
					{
					setPixel(x, y, 0);
					r2++;
					}
				}
			}
		}
	updateDisplay();


	selectWindow(mascara);                            //genero una imagen aleatoria para el canal azul
	run("Duplicate...", "title=AzulAleatorio");
	run("Blue");
	idr3 = getImageID();		
	selectImage(idr3);
	imagenRandAzul = getTitle();
   	w = getWidth;
   	h = getHeight;
   	z=0;
   	f=0;
   	r3=0;    
	for (y=0; y<h; y++)
		{
      		for (x=0; x<w; x++)
			{
          			z = getPixel(x,y);
			if(z==255)
				{
				f=random;
				if(f<=cerosRandAzules/unosMascara)
					{
					setPixel(x, y, 0);
					r3++;
					}
				}
			}
		}
	updateDisplay();		
}

imageCalculator("AND create", rojo, mascara);                       //Genero imagen de colocalizacion
run("Red");
rename("Rojo");
imageCalculator("AND create", verde, mascara);  
run("Green");
rename("Verde");
imageCalculator("AND create", azul, mascara);  
run("Blue");
rename("Azul");
if(mostrarCanales==true)
	run("Merge Channels...", "c1=Rojo c2=Verde c3=Azul create keep");
	else
	run("Merge Channels...", "c1=Rojo c2=Verde c3=Azul create");

/*
selectWindow(imagenRandAzul);     //lineas de prueba de codigo. Cuento unos en la imagen aleatoria y comparo con la real
   w = getWidth;
   h = getHeight;
   a = newArray(w*h);
   i = 0;
   unosRandAzules = 0;    
  for (y=0; y<h; y++)
	{
      	for (x=0; x<w; x++)
          		a[i++] = getPixel(x,y);
	}
for(i=0; i<w*h; i++)
	{
	if(a[i]==255)
		unosRandAzules++;
	}

print(unosAzules);
print(unosRandAzules);
*/




