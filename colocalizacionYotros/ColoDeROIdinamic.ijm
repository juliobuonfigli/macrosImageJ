
function normalizacion(img) 
	{
	selectWindow(img);
	w=getWidth;
	h=getHeight;
	run("Set Measurements...", "mean min redirect=None decimal=2");
	run("Select None");
	run("Measure");
	max=getResult("Max", 0);
	min=getResult("Min", 0);
	run("Clear Results");
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++)
			{
		 	p=getPixel(x, y);
		 	setPixel(x, y, round(((p-min)*255)/(max-min))+1);
		 	}	
		}
	}

function convo(img, fu, r, f) 
	{
	if(fu=="Lineal") e=1;
	if(fu=="Cuadratica") e=2;
	if(fu=="Cubica") e=3;
	if(fu=="Geometrica") e=4;
	if(fu=="Aritmetica") e=5;

	function PSF(r, e, f)
		{
	 	w=2*r-1;
	 	h=2*r-1;
	 	vec=newArray(w*h);
	
	 	function func(r, d, e, f) 
	 		{
	 		if(e==1)
	 			v=255/(d+1);
	 		if(e==2)
	 			v=255/(d*d+1);
	 		if(e==3)
	 			v=255/(d*d*d+1);
	 		if(e==4)
	 			v=255/pow(2, d);
	 		if(e==5)
	 			v=255-255*f*(d+1)/r;
	 		return v;
	 		}
		
		 cx= floor(w/2);
		 cy= floor(h/2);
		 v=0; 	 cont=0;
		 for(y=0; y<h; y++) 
		 	{
		    for (x = 0; x < w; x++) 
		    	{
		       	d=sqrt(pow(cx-x, 2)+pow(cy-y, 2));
				if(d>=r) 
		        	v=0;
		    	else 
		        	v=func(r, d, e, f);       
		       	vec[cont]=v;
		       	cont++;
		    	}
			}
		return vec;
		}
	          
	alP=2*r-1;   anP=2*r-1;
	selectWindow(img);
	an = getWidth;               
	al = getHeight;
	AN=an+anP; 	AL=al+alP;
	H=newArray(anP*alP);
	G=newArray(an*al);
	H=PSF(r, e, f);
	selectWindow(img);
	run("Duplicate...", "title=img2 duplicate");
	run("Canvas Size...", "width=AN height=AL position=Center zero");
	selectWindow("img2");
	N=0; 	M=0; 	j=0;
	
	for(k=0; k<al*an; k++)
		{
		suma=0;
		i=0;
		for(n=N; n<N+alP; n++)
			{
			for(m=M; m<M+anP; m++)
				{
				suma=suma+H[i]*getPixel(m+alP/2, n+anP/2)/255;
				i++;
				}
			}
		M++;
		if(M>an-1)
			{M=0; N++;}
		G[j]=suma;
		j++;
		}
	
	selectWindow(img);
	i=0;
	for (y=0; y<al; y++)
		{
		for (x=0; x<an; x++)
			{
			setPixel(x, y, G[i]);
			i++;
			}
		}                
	updateDisplay();
	}

function promedio(vec, n)
	{
	p=0;
	for(i=0; i<n; i++)
		p=p+vec[i];
	return p/n; 	
	}

function INSTANTMASK(md, s, w, h)
	{
	m=newArray(w*h);
	for(i=0; i<w*h; i++)
		{
		if(md[i]>=s)
			m[i]=true;
		else
			m[i]=false;	
		}
	return m;
	}
	
function CONTEO(mask)
	{
	n=0;
	for(i=0; i<w*h; i++) {
		if(mask[i]==true)
			n++; }
	return n;
	}
	
function vectorizar(r, mask, n)
	{
	vec=newArray(n);
	c=0;
	for(i=0; i<w*h; i++)
		{
		if(mask[i]==true)
			{
			vec[c]=r[i];	
			c++;		
			}
		}
	return vec;
	}
	
function PEARSON(r1, v1, n)
	{
	denv=0; denr=0; num=0;
	pr=promedio(r1, n);
	pv=promedio(v1, n);
	for(i=0; i<n; i++)
		{
		num=num+(r1[i]-pr)*(v1[i]-pv);
		denr=denr+(r1[i]-pr)*(r1[i]-pr);	
		denv=denv+(v1[i]-pv)*(v1[i]-pv);	
		}
	return num/sqrt(denr*denv);
	}

function VECTORIZAR(imagenAvectorizar, an, al)                     
	{
	selectWindow(imagenAvectorizar);
	vector=newArray(an*al);
	  i = 0;
	  for (y=0; y<al; y++)
		{
		for (x=0; x<an; x++)
			{
			vector[i] = getPixel(x,y);
			i++; 
			}
		}
	return vector;
	}

function ELMAYOR(r, v)
	{
	newImage("MD", "8-bit black", w, h, 1);	
	i=0;
	for (y=0; y<h; y++)
		{
		for (x=0; x<w; x++)
			{
			if(r[i]>v[i])
				setPixel(x, y, r[i]);
			else
				setPixel(x, y, v[i]);
			i++; 
			}
		}
	}

function PROMEDIO(r, v)
	{
	newImage("MD", "8-bit black", w, h, 1);	
	i=0;
	for (y=0; y<h; y++)
		{
		for (x=0; x<w; x++)
			{
			setPixel(x, y, round((v[i]+r[i])/2));
			i++; 
			}
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
               
 Dialog.create("COLOCALIZACION");                  //ventana de carga de relaciones                                                      
  Dialog.addChoice("Rojo: ", figura);  
  Dialog.addChoice("Verde: ", figura); 
  Dialog.addChoice("ROI dinamico: ", newArray("Promedio", "El mayor", "Suma", "Rojo", "Verde")); 
  Dialog.addCheckbox("Normalizar: ", true);
  Dialog.addChoice("Dispesrsion: ", newArray("Ninguna", "Lineal", "Cuadratica", "Cubica", "Geometrica", "Aritmetica"));  
  Dialog.addNumber("Radio de Dipersion: ", 6);
  Dialog.addCheckbox("Normalizar solo la mascara: ", false);
  Dialog.addCheckbox("Dispersar solo la mascara: ", true);
  
Dialog.show();
   	red=Dialog.getChoice();
   	green=Dialog.getChoice();
   	metodo=Dialog.getChoice();
    norm=Dialog.getCheckbox();
    disp=Dialog.getChoice();  
    rad=Dialog.getNumber();
    condN=Dialog.getCheckbox();
    condD=Dialog.getCheckbox();
    
selectWindow(red);
w=getWidth;
h=getHeight;
run("Duplicate...", "title=Red");
if(norm==true && condN==false) normalizacion("Red"); 
if(disp!="Ninguno" && condD==false) convo("Red", disp, rad, 1);
run("Duplicate...", "title=RED");
if(norm==true && cond==true) normalizacion("RED"); 
if(disp!="Ninguno" && condD==true) convo("RED", disp, rad, 1);

selectWindow(green);
run("Duplicate...", "title=Green");
if(norm==true && condN==false) normalizacion("Green"); 
if(disp!="Ninguno" && condD==false) convo("Green", disp, rad, 1);
run("Duplicate...", "title=GREEN");
if(norm==true && cond==true) normalizacion("GREEN"); 
if(disp!="Ninguno" && condD==true) convo("GREEN", disp, rad, 1);

selectWindow("Red");
run("8-bit");
r=newArray(w*h);
r=VECTORIZAR("Red", w, h);
selectWindow("Green");
run("8-bit");
v=newArray(w*h);
v=VECTORIZAR("Green", w, h);

if(metodo=="Suma")
	{
	imageCalculator("Add create 32-bit", "GREEN","RED");
	selectWindow("Result of GREEN");
	rename("MD");
	run("8-bit");
	}

if(metodo=="Rojo")
	{
	selectWindow("RED");
	rename("MD");
	run("8-bit");
	selectWindow("GREEN");
	close();
	}

if(metodo=="Verde")
	{
	selectWindow("GREEN");
	rename("MD");
	run("8-bit");
	selectWindow("RED");
	close();
	}

if(metodo=="El mayor")
	ELMAYOR(r, v);

if(metodo=="Promedio")
	PROMEDIO(r, v);
		
colo=newArray(255);
mask=newArray(w*h);

md=VECTORIZAR("MD", w, h);

for(i=1; i<256; i++)
	{
	mask=INSTANTMASK(md, i, w, h);
	n=CONTEO(mask);
	r1=newArray(n);
	v1=newArray(n);
	r1=vectorizar(r, mask, n);
	v1=vectorizar(v, mask, n);
	colo[i-1]=PEARSON(r1, v1, n);	
	//print(colo[i]);
	//for(j=0; j<5; j++)
	//	print(r1[round(random*(n-1))]);
	}

a=newArray(256);
for(f=0; f<256; f++)     
	a[f]=f;

Plot.create("Plot", "Umbral", "correlacion"); 
Plot.setLimits(0, 255, -1, 1);
Plot.setColor("black", "black");           
Plot.setLineWidth(1);
Plot.add("line", a, colo);

	
