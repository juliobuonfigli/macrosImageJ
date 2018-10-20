
function elMayor(vec, l)
	{
	m=0;
	for(i=0; i<l; i++) {
		if(vec[i]>m)
			m=vec[i];  }
	return m;
	}

function elMenor(vec, l)
	{
	m=255*255;
	for(i=0; i<l; i++) {
		if(vec[i]<m)
			m=vec[i];  }
	return m;
	}

function normalizacion(vec, l) 
	{
	max=elMayor(vec, l);
	min=elMenor(vec, l);
	for(i=0; i<l; i++)
		vec[i]=round(((vec[i]-min)*255)/(max-min))+1;
	}

function renderize(vec, img)
	{
	selectWindow(img);
	w=getWidth; h=getHeight; 
	i=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++) 
			{
			setPixel(x, y, vec[i]); 
			i++; 
			}
		}
	}

function convo(array, an, al, fu, r, f) 
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
	 		if(e==1) v=1/(d+1);
	 		if(e==2) v=1/(d*d+1);
	 		if(e==3) v=1/(d*d*d+1);
	 		if(e==4) v=1/pow(2, d);
	 		if(e==5) v=1-f*(d+1)/r;
	 		return v;
	 		}
	 
		 cx=floor(w/2); 	 cy=floor(h/2);
		 v=0; 	 cont=0;
		 for(y=0; y<h; y++)
		 	{
		    for(x=0; x<w; x++)
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
	          
	alP=2*r-1; 	anP=2*r-1;
	AN=an+anP; 	AL=al+alP;
	H=newArray(anP*alP); 	G=newArray(an*al); 	R=newArray(AN*AL);
	i=0; j=0;
	for(y=0; y<AL; y++) 
		{
		for(x=0; x<AN; x++) 
			{
			if(x<anP/2 || x>an+anP/2 || y<alP/2 || y>al+alP/2) 
				{R[i]=0; i++; }
				else 
				{R[i]=array[j]; i++; j++; } 
			}
		}
	
	H=PSF(r, e, f);
	N=0; 	M=0; 	j=0;
	for(k=0; k<al*an; k++)
		{
		showStatus("Dispersing...");
		suma=0;
		i=0;
		for(n=N; n<N+alP; n++)
			{
			for(m=M; m<M+anP; m++)
				{
				pos=AN*n+m;
				suma=suma+H[i]*R[pos];
				i++;
				}
			}
		M++;
		if(M>an-1)
			{M=0; N++;}
		G[j]=suma;
		j++;
		}
	return G;
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

function ELMAYOR(r, v, l)
	{
	vec=newArray(l);
	for (i=0; i<l; i++)
		{
		if(r[i]>v[i])
			vec[i]=r[i];
		else
			vec[i]=v[i];
		}
	return vec;
	}

function PROMEDIO(r, v, l)
	{
	vec=newArray(l);
	for (i=0; i<l; i++)
		vec[i]=round((r[i]+v[i])/2);
	return vec;
	}

function corCero(col)
	{
	vec=newArray(2); vec[0]=1; vec[1]=0; 
	for(i=0; i<255; i++) 
		{
		 if(abs(col[i])<vec[0])
		 	{
		 	vec[0]=abs(col[i]);
		 	vec[1]=i+1;
		 	}
		}
	return vec;	
	}

function renderMask(vec, mask, w, h)
	{
	newImage("MinimaCorrelacion", "8-bit black", w, h, 1);		
	i=0;
	for(y=0; y<h; y++)
		{
		for(x=0; x<w; x++) 
			{
			if(mask[i]>=vec[1])
				setPixel(x, y, 255); 
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
  Dialog.addChoice("ROI dinamico: ", newArray("El mayor", "Promedio", "Rojo", "Verde")); 
  Dialog.addChoice("Dispersion de mascara: ", newArray("Ninguna", "Lineal", "Cuadratica", "Cubica", "Geometrica", "Aritmetica"));  
  Dialog.addNumber("Radio de Dipersion: ", 6);
  Dialog.addChoice("Dispersion de canales: ", newArray("Ninguna", "Lineal", "Cuadratica", "Cubica", "Geometrica", "Aritmetica"));  
  Dialog.addNumber("Radio de Dipersion: ", 6);
  Dialog.addCheckbox("Dispersar canales como mascara", true);
  Dialog.addCheckbox("No normalizar", false);
  Dialog.addCheckbox("Renderizar canales", true);
  Dialog.addCheckbox("Mascara de minima correlacion", true);
   
Dialog.show();
   	red=Dialog.getChoice();
   	green=Dialog.getChoice();
   	metodo=Dialog.getChoice();
    dispM=Dialog.getChoice();  
    radM=Dialog.getNumber();
    dispC=Dialog.getChoice();  
    radC=Dialog.getNumber();
    cond=Dialog.getCheckbox();
    noNorm=Dialog.getCheckbox();
    render=Dialog.getCheckbox();
    mmc=Dialog.getCheckbox();
    
selectWindow(red);
w=getWidth;
h=getHeight;
run("Duplicate...", "title=Red");
selectWindow(green);
run("Duplicate...", "title=Green");
selectWindow("Red");
run("8-bit");
r=newArray(w*h); R=newArray(w*h);
r=VECTORIZAR("Red", w, h); 
R=VECTORIZAR("Red", w, h);
selectWindow("Green");
run("8-bit");
v=newArray(w*h); V=newArray(w*h);
v=VECTORIZAR("Green", w, h);
V=VECTORIZAR("Green", w, h);

if(dispM!="Ninguna" && cond==true) 
	{
	R=convo(R, w, h, dispM, radM, 1); V=convo(V, w, h, dispM, radM, 1); 
	r=R; v=V;
	} 
else
	{
	if(dispM!="Ninguna") {R=convo(R, w, h, dispM, radM, 1); V=convo(V, w, h, dispM, radM, 1);} 
	if(dispC!="Ninguna") {r=convo(r, w, h, dispC, radC, 1); v=convo(v, w, h, dispC, radC, 1);} 	
	}
md=newArray(w*h);

if(noNorm==false) 
	{
	normalizacion(R, w*h); normalizacion(V, w*h); 
	normalizacion(r, w*h); normalizacion(v, w*h);
	}  

if(metodo=="Rojo") md=R;
if(metodo=="Verde") md=V;
if(metodo=="El mayor") md=ELMAYOR(R, V, w*h);
if(metodo=="Promedio") md=PROMEDIO(R, V, w*h);
		
colo=newArray(255);
mask=newArray(w*h);

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

newImage("MD", "8-bit black", w, h, 1);	
renderize(md, "MD");

if(render==true)
	{
	renderize(r, "Red");
	renderize(v, "Green");	
	}
else
	{
	selectWindow("Red"); close();
	selectWindow("Green"); close();
	}

if(mmc==true)
	{
	umColo=newArray(2);
	umColo=corCero(colo);
	renderMask(umColo, md, w, h);	
	}



	