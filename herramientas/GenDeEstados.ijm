// generador de estados

macro "Relationship Generator [g]" 
{

w=11;
h=11;
max=70;

function NEWFIGURE(vector)
	{
	newImage("image", "8-bit black", w, h, 1);       
	selectWindow("image");
	i=0;
	for (y=0; y<w; y++)
		{
		for (x=0; x<h; x++)
			{
			if(vector[i]==true)
				setPixel(x, y, 255);
			i++;
			}
		} 
	return "image";
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

function DOBLE(c1, c2)
	{
	n=0;
	for(i=0; i<w*h; i++)
		{
		if(c1[i]==true && c2[i]==true)
			n++;
		}
	return n;
	}

function TRIPLE(c1, c2, c3)
	{
	n=0;
	for(i=0; i<w*h; i++)
		{
		if(c1[i]==true && c2[i]==true && c3[i]==true)
			n++;
		}
	return n;
	}

/*function LOAD(vec, n)
	{
	s=0;
	for(i=0; i<w*h; i++)
		vec[i]=false;
	do  {
		vec[round(random()*(w*h-1))]=true;	
		s++;
		}
	while(s<n)
	return vec;	
	}*/

function LOAD(vec, n)
	{
	for(i=0; i<w*h; i++)
		vec[i]=false;
	for(j=0; j<n; j++)
		{
		do  {
			pos=round(random()*(w*h-1));	
			}
			while(vec[pos]==true);
		vec[pos]=true;
		}
	return vec;	
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
	if(s<sl && s>=0)
		{res=2;}
	else
		{
		if(e<sl && e>=0)
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
	
dobles=newArray(3);
ss0=newArray("SC-SC-SC", "NS-NS-NS", "SE-SE-SE", "SC-NS-SE", "SC-SC-NS", "SC-SC-SE", "SC-SE-SE", "SC-NS-NS", "SE-SE-NS", "SE-NS-NS", "Any");
ss1=newArray("SC", "NS", "SE");
ss2=newArray("SC", "NS", "SE", "Any");
Dialog.create("Load relationships");                    //ventana de carga de relaciones                                                      
  Dialog.addChoice("RedGreen: ", ss1);  
  Dialog.addChoice("Double 2: ", ss1); 
  Dialog.addChoice("Double 3: ", ss1); 
  Dialog.addChoice("Triples: ", ss0);         
  Dialog.addChoice("General ", ss2);  
  Dialog.addChoice("Signifecance level: ", newArray("0.1", "0.05", "0.01"));
  Dialog.addNumber("Iteration's limit (x1000): ", 10);   
  Dialog.addNumber("Random seed: ", 1); 
  
Dialog.show();
   	dobles[0]=Dialog.getChoice();
   	dobles[1]=Dialog.getChoice();
   	dobles[2]=Dialog.getChoice();
  	triples=Dialog.getChoice();
	general=Dialog.getChoice();
  	sl=Dialog.getChoice();
  	iLimit=Dialog.getNumber()*1000;
	seed=Dialog.getNumber();

if(sl=="0.01") 
	SL=0.01; 
else 
	{
	if(sl=="0.05")
		SL=0.05;
	else
		SL=0.1;
	}

r=newArray(w*h);
g=newArray(w*h);
b=newArray(w*h);

random("seed", seed);

DOBLES=newArray(3);
for(i=0; i<3; i++)
	DOBLES[i]=NumLet(dobles[i]);

cond1=DOBLES[0]+DOBLES[1]+DOBLES[2];
	
if(triples=="SC-SC-SC") cond2=6;
if(triples=="NS-NS-NS") cond2=0;
if(triples=="SE-SE-SE") cond2=-9;
if(triples=="SC-NS-SE") cond2=-1;
if(triples=="SC-SC-NS") cond2=4;
if(triples=="SC-SC-SE") cond2=1;
if(triples=="SC-SE-SE") cond2=-4;
if(triples=="SC-NS-NS") cond2=2;
if(triples=="SE-SE-NS") cond2=6;
if(triples=="SE-NS-NS") cond2=-3;
if(triples=="Any") cond2=10;

if(general=="SC") cond3=2;
if(general=="NS") cond3=0;
if(general=="SE") cond3=-3;
if(general=="Any") cond3=10;

SS=newArray(7);
eSS=newArray(7);
ss=newArray(7);
total=0;  
  
do 
	{	
	condition=0;  
	if(total%100==0)
		{
		do
			{
			nr=round(random()*max)+1;
			ng=round(random()*max)+1;
			r=LOAD(r, nr);
			g=LOAD(g, ng);
			rg=DOBLE(r, g);
			SS[0]=aHG(ng, nr, w*h, rg);
			eSS[0]=aHG(w*h-ng, nr, w*h, nr-rg);
			COND0=NumNum(SS[0], eSS[0], SL);
			} 
		while(COND0!=DOBLES[0])
		}
	nb=round(random()*max)+1;
	b=LOAD(b, nb);
	//	aHG(N-d, N-n, N, n-x)
	rb=DOBLE(r, b);
	gb=DOBLE(g, b);
	rgb=TRIPLE(r, g, b);
	//aHG(d, n, N, x) 
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
	//if(dd<rgb) dd=rgb;
	
	SS[6]=aHG(dd, nb, w*h, rgb);
	eSS[6]=aHG(w*h-dd, nb, w*h, nb-rgb);


	for(i=0; i<7; i++)
		ss[i]=NumNum(SS[i], eSS[i], SL);
		
	COND1=ss[0]+ss[1]+ss[2];
	COND2=ss[3]+ss[4]+ss[5];
	
	co1=0; co2=0; co3=0;
	if(cond1==COND1)
		co1=1;
	if(cond2==COND2 || cond2==10)
		co2=1;
	if(cond3==ss[6] || cond3==10)
		co3=1;
	
	condition=co1+co2+co3;
	
	showStatus("Iterations: "+total);
   	total++;
	}
while(condition<3 && total<iLimit)

red=NEWFIGURE(r);
rename("Red");
green=NEWFIGURE(g);
rename("Green");
blue=NEWFIGURE(b);
rename("Blue");

run("Merge Channels...", "c1=Red c2=Green c3=Blue create");
run("Size...", "width=40 height=40 constrain average interpolation=None");

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
print(f, "\\Headings:Resultado\t RojoVerde\t VerdeRojo\t RojoAzul\t AzulRojo\t VerdeAzul\t AzulVerde\t TripleRojo\t TripleVerde\t TripleAzul\t TripleGeneral\t Iteraciones");
print(f, " Coeficientes"+"\t  "+rg/nr+"\t  "+rg/ng+"\t  "+rb/nr+"\t  "+rb/nb+"\t  "+gb/ng+"\t  "+gb/nb+"\t  "+rgb/nr+"\t  "+rgb/ng+"\t  "+rgb/nb+"\t  "+3*rgb/(nb+nr+ng)+"\t  "+total);
print(f, " Significancias"+"\t  "+sS[0]+"\t  "+"  "+"\t  "+sS[1]+"\t  "+"  "+"\t  "+sS[2]+"\t  "+"  "+"\t  "+sS[3]+"\t  "+sS[4]+"\t  "+sS[5]+"\t  "+sS[6]+"\t  "+seed);
print(f, " SC p"+"\t  "+SS[0]+"\t  "+"  "+"\t  "+SS[1]+"\t  "+"  "+"\t  "+SS[2]+"\t  "+"  "+"\t  "+SS[3]+"\t  "+SS[4]+"\t  "+SS[5]+"\t  "+SS[6]+"\t  "+" ");
print(f, " SE p"+"\t  "+eSS[0]+"\t  "+"  "+"\t  "+eSS[1]+"\t  "+"  "+"\t  "+eSS[2]+"\t  "+"  "+"\t  "+eSS[3]+"\t  "+eSS[4]+"\t  "+eSS[5]+"\t  "+eSS[6]+"\t  "+" ");

print("SS[0]: "+SS[0]+"  rg: "+rg+"  nb: "+nb+" w*h: "+w*h+"  rgb: "+rgb);
print(rg+"   "+rb+"    "+gb);
print(nr+"   "+ng+"    "+nb);
}//fin

