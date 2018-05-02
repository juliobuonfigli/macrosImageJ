// generador de estados

macro "ColoHipergeométrica [g]" 
{

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

function FAC(x)
	{
	if(x==0) x=1; else {
	for(i=x-1; i>0; i--)
		x=x*i; }
	return x;
	}

function BinCoef(n, k)
	{
	res=FAC(n)/(FAC(k)*FAC(n-k));
	return res;	
	}

function Contar(vec)
	{
	res=0;
	for(i=0; i<w*h; i++)
		{
		if(vec[i]>0)
			res++;
		}
	return res;	
	}

function HG(d, n, N, x)  //funcion hipergeometrica
	{
	res=BinCoef(d, x)*BinCoef(N-d, n-x)/BinCoef(N, n);
	return res;
	}

function aHG(d, n, N, x)  //funcion hipergeometrica acumulada
	{
	res=0;
	for(i=x; i<n+1; i++)
		res=res+HG(d, n, N, i);
	return res; 	
	}

function EM(d, n, N)  //funcion hipergeometrica acumulada
	{
	res=0;
	for(i=1; i<n+1; i++)
		res=res+i*HG(d, n, N, i);
	return res; 	
	}

function DOBLE(c1, c2)
	{
	n=0;
	for(i=0; i<w*h; i++)
		{
		if(c1[i]>0 && c2[i]>0)
			n++;
		}
	return n;
	}

function TRIPLE(c1, c2, c3)
	{
	n=0;
	for(i=0; i<w*h; i++)
		{
		if(c1[i]>0 && c2[i]>0 && c3[i]>0)
			n++;
		}
	return n;
	}

function NumLet(let)
	{
	if(let=="SC")
		{res=2;}
	else
		{
		if(let=="NS")
			res=0;
		else
			res=-3;
		}	
	return res;
	}
	
function NumNum(s, e, sl)
	{
	if(s<sl)
		{res=2;}
	else
		{
		if(e<sl)
			res=-3;
		else
			res=0;
		}		
	return res;
	}

function LetNum(num)
	{
	if(num==2)
		{res="SC";}
	else
		{
		if(num==0)
			res="NS";
		else
			res="SE";
		}	
	return res;
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
                   
                  
 Dialog.create("Load channels");                  //ventana de carga de relaciones                                                      
  Dialog.addChoice("Red: ", figura);  
  Dialog.addChoice("Green: ", figura); 
  Dialog.addChoice("Blue: ", figura); 
    Dialog.addChoice("Signifecance level: ", newArray("0.1", "0.05", "0.01"));
Dialog.show();
   	red=Dialog.getChoice();
   	green=Dialog.getChoice();
   	blue=Dialog.getChoice();
sl=Dialog.getChoice();

if(sl=="0.01") 
	SL=0.01; 
else 
	{
	if(sl=="0.05")
		SL=0.05;
	else
		SL=0.1;
	}

selectWindow(red); run("Select None"); 
rename("Red");
//run("Duplicate...", "title=Red"); 
run("8-bit"); 
w = getWidth;               
h = getHeight;
selectWindow(green); run("Select None"); 
run("8-bit"); rename("Green"); 
selectWindow(blue); run("Select None"); 
run("8-bit");  rename("Blue");
	
r=newArray(w*h);
g=newArray(w*h);
b=newArray(w*h);

r=VECTORIZAR(red, w, h);
g=VECTORIZAR(green, w, h);
b=VECTORIZAR(blue, w, h);

SS=newArray(7);
eSS=newArray(7);
ss=newArray(7);

nr=Contar(r);
ng=Contar(g);
nb=Contar(b);

rg=DOBLE(r, g);
SS[0]=aHG(ng, nr, w*h, rg);
eSS[0]=aHG(w*h-ng, nr, w*h, nr-rg);
rb=DOBLE(r, b);
gb=DOBLE(g, b);
rgb=TRIPLE(r, g, b);
 
SS[1]=aHG(nb, nr, w*h, rb);
SS[2]=aHG(ng, nb, w*h, gb);
eSS[1]=aHG(w*h-nb, nr, w*h, nr-rb);
eSS[2]=aHG(w*h-ng, nb, w*h, nb-gb);
	
SS[3]=aHG(gb, nr, w*h, rgb);
SS[4]=aHG(rb, ng, w*h, rgb);
SS[5]=aHG(rg, nb, w*h, rgb);
eSS[3]=aHG(w*h-gb, nr, w*h, nr-rgb);
eSS[4]=aHG(w*h-rb, ng, w*h, ng-rgb);
eSS[5]=aHG(w*h-rg, nb, w*h, nb-rgb);

dd=round(nr*ng/(w*h));

SS[6]=aHG(dd, nb, w*h, rgb);
eSS[6]=aHG(w*h-dd, nb, w*h, nb-rgb);

for(i=0; i<7; i++)
	ss[i]=NumNum(SS[i], eSS[i], SL);

//run("Merge Channels...", "c1=Red c2=Green c3=Blue create");
//run("Size...", "width=40 height=40 constrain average interpolation=None");

sS=newArray(7);
for(i=0; i<7; i++)
	sS[i]=toString(LetNum(ss[i]));

titulo1 = "Results";                                            
titulo2 = "["+titulo1+"]";
  f = titulo2;
 if (isOpen(titulo1))
    print(f, "\\Clear");
 else
run("Table...", "name="+titulo1+" width=250 height=600");
print(f, "\\Headings:Resultado\t RojoVerde\t VerdeRojo\t RojoAzul\t AzulRojo\t VerdeAzul\t AzulVerde\t TripleRojo\t TripleVerde\t TripleAzul\t TripleGeneral");
print(f, " Coeficientes"+"\t  "+rg/nr+"\t  "+rg/ng+"\t  "+rb/nr+"\t  "+rb/nb+"\t  "+gb/ng+"\t  "+gb/nb+"\t  "+rgb/nr+"\t  "+rgb/ng+"\t  "+rgb/nb+"\t  "+3*rgb/(nb+nr+ng));
print(f, " Significancias"+"\t  "+sS[0]+"\t  "+"  "+"\t  "+sS[1]+"\t  "+"  "+"\t  "+sS[2]+"\t  "+"  "+"\t  "+sS[3]+"\t  "+sS[4]+"\t  "+sS[5]+"\t  "+sS[6]);
print(f, " SC p"+"\t  "+SS[0]+"\t  "+"  "+"\t  "+SS[1]+"\t  "+"  "+"\t  "+SS[2]+"\t  "+"  "+"\t  "+SS[3]+"\t  "+SS[4]+"\t  "+SS[5]+"\t  "+SS[6]);
print(f, " SE p"+"\t  "+eSS[0]+"\t  "+"  "+"\t  "+eSS[1]+"\t  "+"  "+"\t  "+eSS[2]+"\t  "+"  "+"\t  "+eSS[3]+"\t  "+eSS[4]+"\t  "+eSS[5]+"\t  "+eSS[6]);

print(dd);

//print("SS[0]: "+SS[0]+"  rg: "+rg+"  nb: "+nb+" w*h: "+w*h+"  rgb: "+rgb);
}//fin
