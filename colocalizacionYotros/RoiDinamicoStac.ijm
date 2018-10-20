
//mascara de triple correlacion normalizada

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
		vec[i]=round(((vec[i]-min)*254)/(max-min))+1;
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
	for (i=0; i<l; i++)
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

	externo="none"
	dispM="Ninguna";  
	radM=6;
	dispC="Ninguna";  
	radC=6;
	cond=false;
	noNorm=false;
	render=false;
	mmc=false;
setBatchMode(true);

selectWindow("sRED");
run("8-bit");
selectWindow("sGREEN");
run("8-bit");
selectWindow("sBLUE");
run("8-bit");

for(ii=0; ii<1; ii++) {
if(ii==0) metodo="El mayor";
if(ii==1) metodo= "Rojo";
if(ii==2) metodo= "Verde";
if(ii==3) metodo= "Azul";
if(ii==4) metodo="RV";
if(ii==5) metodo= "RA";
if(ii==6) metodo= "VA";

for(jj=1; jj<12; jj++) {

selectWindow("sRED");
setSlice(jj);
w=getWidth;
h=getHeight;
run("Duplicate...", "title=Red");
selectWindow("sGREEN");
setSlice(jj);
run("Duplicate...", "title=Green");
selectWindow("Red");
//run("8-bit");
r=newArray(w*h); R=newArray(w*h);
r=VECTORIZAR("Red", w, h); 
R=VECTORIZAR("Red", w, h);
selectWindow("Green");
//run("8-bit");
v=newArray(w*h); V=newArray(w*h);
v=VECTORIZAR("Green", w, h);
V=VECTORIZAR("Green", w, h);

selectWindow("sBLUE");
setSlice(jj);
run("Duplicate...", "title=Blue");
selectWindow("Blue");
//run("8-bit");
a=newArray(w*h); A=newArray(w*h);
a=VECTORIZAR("Blue", w, h); 
A=VECTORIZAR("Blue", w, h);	


md=newArray(w*h);

if(noNorm==false) 
	{
	normalizacion(R, w*h); normalizacion(V, w*h); 
	normalizacion(r, w*h); normalizacion(v, w*h);
	normalizacion(a, w*h); normalizacion(A, w*h); 
	}  

if(metodo=="Rojo") md=R;
if(metodo=="Verde") md=V;
if(metodo=="Azul") md=A;
if(metodo=="RV") md=ELMAYOR(R, V, w*h);
if(metodo=="RA") md=ELMAYOR(R, A, w*h);
if(metodo=="VA") md=ELMAYOR(A, V, w*h);
if(metodo=="El mayor") md=TripleMAYOR(R, V, A, w*h);
if(metodo=="Promedio") md=TriplePROM(R, V, A, w*h);	
if(metodo=="Random") md=tripleRan(R, V, A, w*h);

	rv=newArray(w*h);
	ra=newArray(w*h);
	va=newArray(w*h);
	rv=inter(r, v, w*h);
	ra=inter(r, a, w*h);
	va=inter(v, a, w*h);
	
coloRV=newArray(255);
coloRA=newArray(255);
coloVA=newArray(255);
coloR=newArray(255);
coloV=newArray(255);
coloA=newArray(255);
coloRVA=newArray(255);
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

if(ii==0) tota="000";
if(ii==1) tota="111";
if(ii==2) tota="222";
if(ii==3) tota="333";
if(ii==4) tota="444";
if(ii==5) tota="555";
if(ii==6) tota="666";

selectWindow("Red"); close();
selectWindow("Green"); close();
selectWindow("Blue"); close(); 

aa=newArray(256);
for(f=0; f<256; f++)     
	aa[f]=f;

Plot.create("Plot", "Umbral", "correlacion"); 
Plot.setLimits(0, 255, -1, 1);
Plot.setLineWidth(1);
Plot.setColor("yellow", "yellow");           
Plot.add("line", aa, coloRV);
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
Plot.makeHighResolution("Plot",1.0,"disable");

}

if(ii==0) run("Images to Stack", "name=Mayor title=Plot use");	
if(ii==1) run("Images to Stack", "name=Rojo title=Plot use");	
if(ii==2) run("Images to Stack", "name=Verde title=Plot use");	
if(ii==3) run("Images to Stack", "name=Azul title=Plot use");	
if(ii==4) run("Images to Stack", "name=RV title=Plot use");	
if(ii==5) run("Images to Stack", "name=RA title=Plot use");	
if(ii==6) run("Images to Stack", "name=VA title=Plot use");
}

setBatchMode("Exit and display");