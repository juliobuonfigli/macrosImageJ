
function raizCubica(w)                     
	{
    x=w; y=1;  e=0.00001;       
  	while(x-y>e)
  		{
    	x=(2*x+y)/3;
    	y=w/(x*x);
 		}
	return x;
	}

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
		//vec[i]=round(((vec[i]-min)*254)/(max-min))+1;
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

function TP(r1, v1, a1, n)
	{
	denv=0; denr=0; dena=0; num=0;
	pr=promedio(r1, n);
	pv=promedio(v1, n);
	pa=promedio(a1, n);
	for(i=0; i<n; i++)
		{
		if((r1[i]-pr)>0 && (v1[i]-pv)>0 && (a1[i]-pa)>0)
			num=num+abs(r1[i]-pr)*abs(v1[i]-pv)*abs(a1[i]-pa);
		else
			{
			if((r1[i]-pr)<0 && (v1[i]-pv)<0 && (a1[i]-pa)<0)
				num=num+abs(r1[i]-pr)*abs(v1[i]-pv)*abs(a1[i]-pa);
			else
				num=num-abs(r1[i]-pr)*abs(v1[i]-pv)*abs(a1[i]-pa)/3;
			}
		denr=denr+abs(r1[i]-pr)*abs(r1[i]-pr)*abs(r1[i]-pr);	
		denv=denv+abs(v1[i]-pv)*abs(v1[i]-pv)*abs(v1[i]-pv);	
		dena=dena+abs(a1[i]-pa)*abs(a1[i]-pa)*abs(a1[i]-pa);	
		}
	return num/raizCubica(denr*denv*dena);
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

function TripleMAYOR(r, v, a, l)
	{
	vec=newArray(l);
	for (i=0; i<l; i++)
		{
		if(r[i]>=v[i] && r[i]>=a[i])
			vec[i]=r[i];
		else
			{
			if(v[i]>=r[i] && v[i]>=a[i])
				vec[i]=v[i];
			else
				vec[i]=a[i];
			}
		}
	return vec;
	}

function dobleRan(r, v, l)
	{
	vec=newArray(l);
	for (i=0; i<l; i++)
		{
		if(random<0.5)
			vec[i]=r[i];
		else
			vec[i]=v[i];
		}
	return vec;
	}

function tripleRan(r, v, a, l)
	{
	vec=newArray(l);
	for (i=0; i<l; i++)
		{
		ran=random;
		if(ran<0.3333333333)
			vec[i]=r[i];
		else
			{
			if(ran>0.6666666666)
				vec[i]=v[i];
			else
				vec[i]=a[i];
			}
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

function inter(r, v, l)
	{
	vec=newArray(l);
	pr=promedio(r, l);
	pv=promedio(v, l);
	for(i=0; i<l; i++)
		vec[i]=round((r[i]-pr)*(v[i]-pv));
	normalizacion(vec, l);
	return vec;
	}

function TriplePROM(r, v, a, l)
	{
	vec=newArray(l);
	for (i=0; i<l; i++)
		vec[i]=round((r[i]+v[i]+a[i])/3);
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
  
  figura2=newArray(nImages+1);
  figura2[0]="none";
  for(i=1; i<nImages+1; i++)
		figura2[i]=figura[i-1];
               
 Dialog.create("COLOCALIZACION");                  //ventana de carga de relaciones                                                      
  Dialog.addChoice("Rojo: ", figura);  
  Dialog.addChoice("Verde: ", figura); 
  Dialog.addChoice("Azul: ", figura2);
  Dialog.addChoice("Mascara externa: ", figura2);   
  Dialog.addChoice("Combinacion: ", newArray("El mayor", "Promedio", "Random", "Rojo", "Verde", "azul", "RV", "RA", "VA")); 
  Dialog.addChoice("Dispersion de mascara: ", newArray("Ninguna", "Lineal", "Cuadratica", "Cubica", "Geometrica", "Aritmetica"));  
  Dialog.addNumber("Radio de Dipersion: ", 6);
  Dialog.addChoice("Dispersion de canales: ", newArray("Ninguna", "Lineal", "Cuadratica", "Cubica", "Geometrica", "Aritmetica"));  
  Dialog.addNumber("Radio de Dipersion: ", 6);
  Dialog.addCheckbox("Dispersar canales como mascara", true);
  Dialog.addCheckbox("No normalizar", false);
  Dialog.addCheckbox("Renderizar canales", false);
  Dialog.addCheckbox("Mascara de minima correlacion", true);
   
	Dialog.show();
	red=Dialog.getChoice();
	green=Dialog.getChoice();
	blue=Dialog.getChoice();
	externo=Dialog.getChoice();
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

if(blue!="none")
	{
	selectWindow(blue);
	run("Duplicate...", "title=Blue");
	selectWindow("Blue");
	run("8-bit");
	a=newArray(w*h); A=newArray(w*h);
	a=VECTORIZAR("Blue", w, h); 
	A=VECTORIZAR("Blue", w, h);	
	}

if(externo!="none")
	{
	selectWindow(externo);
	run("Duplicate...", "title=MD");
	selectWindow("MD");
	E=newArray(w*h);
	E=VECTORIZAR("MD", w, h);
	}
	 
if(dispM!="Ninguna" && cond==true) 
	{
	if(externo=="none")
		{
		R=convo(R, w, h, dispM, radM, 1); V=convo(V, w, h, dispM, radM, 1); r=R; v=V;
		if(blue!="none") { A=convo(A, w, h, dispM, radM, 1); a=A; }
		}
	else
		E=convo(E, w, h, dispM, radM, 1);	
	} 
else
	{
	if(externo=="none")
		{
		if(dispM!="Ninguna") 
			{
			R=convo(R, w, h, dispM, radM, 1); 
			V=convo(V, w, h, dispM, radM, 1);
			if(blue!="none") A=convo(A, w, h, dispM, radM, 1); 
			} 
		}
	else
		E=convo(E, w, h, dispM, radM, 1);		
	if(dispC!="Ninguna") 
		{
		r=convo(r, w, h, dispC, radC, 1); 
		v=convo(v, w, h, dispC, radC, 1); 	
		if(blue!="none") a=convo(a, w, h, dispC, radC, 1); 
		}
	}

md=newArray(w*h);

if(noNorm==false) 
	{
	normalizacion(R, w*h); normalizacion(V, w*h); 
	normalizacion(r, w*h); normalizacion(v, w*h);
	if(blue!="none") { normalizacion(a, w*h); normalizacion(A, w*h); } 
	}  

if(externo=="none")
	{
	if(metodo=="Rojo") md=R;
	if(metodo=="Verde") md=V;
    if(blue=="none")
		{
		if(metodo=="El mayor") md=ELMAYOR(R, V, w*h);
		if(metodo=="Promedio") md=PROMEDIO(R, V, w*h);
		if(metodo=="Random") md=dobleRan(R, V, w*h);
		}
	else
		{
		if(metodo=="Azul") md=A;
		if(metodo=="RV") md=ELMAYOR(R, V, w*h);
		if(metodo=="RA") md=ELMAYOR(R, A, w*h);
		if(metodo=="VA") md=ELMAYOR(A, V, w*h);
		if(metodo=="El mayor") md=TripleMAYOR(R, V, A, w*h);
		if(metodo=="Promedio") md=TriplePROM(R, V, A, w*h);	
		if(metodo=="Random") md=tripleRan(R, V, A, w*h);
		}
	}
else
	md=E;

if(blue!="none")
	{
	rv=newArray(w*h);
	ra=newArray(w*h);
	va=newArray(w*h);
	rv=inter(r, v, w*h);
	ra=inter(r, a, w*h);
	va=inter(v, a, w*h);
	}
	
coloRV=newArray(255);
if(blue!="none") {
coloRA=newArray(255);
coloVA=newArray(255);
coloR=newArray(255);
coloV=newArray(255);
coloA=newArray(255);
coloRVA=newArray(255); }
mask=newArray(w*h);

for(i=1; i<256; i++)
	{
	mask=INSTANTMASK(md, i, w, h);
	n=CONTEO(mask);
	r1=newArray(n);
	v1=newArray(n);
	r1=vectorizar(r, mask, n);
	v1=vectorizar(v, mask, n);
	coloRV[i-1]=PEARSON(r1, v1, n);	
	if(blue!="none") 
		{
		a1=newArray(n);
		rv1=newArray(n);
		ra1=newArray(n);
		va1=newArray(n);
		a1=vectorizar(a, mask, n);
		rv1=vectorizar(rv, mask, n);
		ra1=vectorizar(ra, mask, n);
		va1=vectorizar(va, mask, n);
		coloRA[i-1]=PEARSON(r1, a1, n);	
		coloVA[i-1]=PEARSON(v1, a1, n);	
		coloR[i-1]=PEARSON(r1, va1, n);	
		coloV[i-1]=PEARSON(v1, ra1, n);
		coloA[i-1]=PEARSON(a1, rv1, n);
		coloRVA[i-1]=TP(r1, v1, a1, n);
		}
	//print(colo[i]);
	//for(j=0; j<5; j++)
	//	print(r1[round(random*(n-1))]);
	}

aa=newArray(256);
for(f=0; f<256; f++)     
	aa[f]=f;

Plot.create("Plot", "Umbral", "correlacion"); 
Plot.setLimits(0, 255, -1, 1);
Plot.setLineWidth(1);
Plot.setColor("yellow", "yellow");           
if(blue=="none") Plot.setColor("black", "black");
Plot.add("line", aa, coloRV);
if(blue!="none")
	{
	Plot.setColor("black", "black");  
	Plot.add("line", aa, coloRVA);
	Plot.setColor("magenta", "magenta");       
	Plot.add("line", aa, coloRA);    
	Plot.setColor("cyan", "cyan");          
	Plot.add("line", aa, coloVA); 
	Plot.setColor("Red", "Red");   
	Plot.add("line", aa, coloR);        
	Plot.setColor("green", "green");       
	Plot.add("line", aa, coloV);    
	Plot.setColor("blue", "blue");     
	Plot.add("line", aa, coloA);      
	}
	
if(externo=="none") newImage("MD", "8-bit black", w, h, 1);	
renderize(md, "MD");

if(render==true)
	{
	renderize(r, "Red");
	renderize(v, "Green");	
	if(blue!="none") renderize(a, "Blue");	
	}
else
	{
	selectWindow("Red"); close();
	selectWindow("Green"); close();
	if(blue!="none") { selectWindow("Blue"); close(); }
	}

if(mmc==true)
	{
	if(blue=="none")
		{
		umColo=newArray(2);
		umColo=corCero(coloRV);
		renderMask(umColo, md, w, h);	
		}
	else
		{
		umColo=newArray(2);
		umColo=corCero(coloRV);
		renderMask(umColo, md, w, h);
		rename("RG-minimum");
		//run("Yellow");
		umColo=corCero(coloRA);
		renderMask(umColo, md, w, h);
		rename("RB-minimum");
		//run("Magenta");
		umColo=corCero(coloVA);
		renderMask(umColo, md, w, h);
		rename("GB-minimum");
		//run("Cyan");
		umColo=corCero(coloR);
		renderMask(umColo, md, w, h);
		rename("R-minimum");
		//run("Red");
		umColo=corCero(coloV);
		renderMask(umColo, md, w, h);
		rename("G-minimum");
		//run("Green");
		umColo=corCero(coloA);
		renderMask(umColo, md, w, h);
		rename("B-minimum");
		//run("Blue");
		umColo=corCero(coloRVA);
		renderMask(umColo, md, w, h);
		rename("RGB-minimum");
		run("Images to Stack", "method=[Copy (center)] name=Stack title=minimum use");
		}
	}

	