macro "NN [n]" {

function IP(vector, w, h) {
	suma=0;
	for(i=0; i<w*h; i++)
		suma=suma+vector[i];
	suma=suma/(w*h);
	return suma;
}


function VECTORIZAR(imagenAvectorizar, an, al)     //1: funcion para vectorizar imagenes                    
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

function DCart(a, b, w, h, res) {
i=0;
j=0;
num=0;
res1=0.1107;
res2=0.3084;
for(y1=0; y1<h; y1++)
	{
	for(x1=0; x1<w; x1++)
		{
		j=0;
		for(y2=0; y2<h; y2++)
			{
			for(x2=0; x2<w; x2++)
				{
				d=sqrt((res1*(x1-x2)+res2)*(res1*(x1-x2)+res2)+(res1*(y1-y2)+res2)*(res1*(y1-y2)+res2));
				//d=sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+res);
				coef=a[i]*b[j]/d;
				if(coef==NaN)
					coef=0;
				num=num+coef;
				j++;
				}
			}
		i++;
		}
	}
	return num;
}

function DPolar(a, b, w, h, res) {
i=0;
num=0;
pi=3.141593;
for(y1=0; y1<h; y1++)
	{
	for(x1=0; x1<w; x1++)
		{
		j=0;
		for(R=0; R<5; R++) 
			{
			 if(R==0) k=1;
             if(R==1) k=8; 
             if(R==2) k=12;
			 if(R==3) k=16; 
             if(R==4) k=32;
             alfa=0;
             for(t=0; t<k; t++)
				{
                alfa=alfa+(2*pi)/k;
                x=round(R*cos(alfa))+x1;
                y=round(R*sin(alfa))+y1;
				j=w*y+x;  
                d=sqrt((x1-x)*(x1-x)+(y1-y)*(y1-y))+res;
				if(j<0 || j>w*h-1)
					coef=0;
					else
					coef=(a[i]*b[j])*(a[i]*b[j])/d;
				if(coef==NaN)
					coef=0;
				num=num+coef;
                }       
              }
           i++;
           }
        }
    return num;
	}
				


id1=getImageID();          //identificación de IDs
tamano=0;
figura=newArray(nImages);
for(i=id1-10000; i<id1+10000; i++)
	{
	if(isOpen(i) && tamano<nImages)
		{
		selectImage(i);
		figura[tamano]=getTitle();
		tamano++;
		}		
	}

 Dialog.create("NNMM");                                                       
  Dialog.addChoice("Red:", figura);         
  Dialog.addChoice("Green:", figura);          
  Dialog.addCheckbox("Restrict to a 4 pixels radio", true);
  Dialog.addNumber("Average intensity: ", 40); 
  Dialog.addNumber("Residue: ", 1); 
  

       Dialog.show();
   	rojo=Dialog.getChoice();
   	verde=Dialog.getChoice();
   	rr=Dialog.getCheckbox();
	AI=Dialog.getNumber();
	residuo=Dialog.getNumber();

selectWindow(rojo);
run("8-bit");
run("Select None");
selectWindow(verde);
run("8-bit");
run("Select None");
	
w = getWidth;                                 
h = getHeight;

r=VECTORIZAR(rojo, w, h); 
v=VECTORIZAR(verde, w, h);
ipr=AI/IP(r, w, h);
ipv=AI/IP(v, w, h);

	for(j=0; j<w*h; j++) {
		r[j]=round(r[j]*ipr); 
		v[j]=round(v[j]*ipv); }

if(rr==true)
	NN=2*DPolar(r, v, w, h, residuo)/(DPolar(r, r, w, h, residuo)+DPolar(v, v, w, h, residuo));
	else
	NN=DCart(r, v, w, h, residuo);//(DCart(r, r, w, h, residuo)+DCart(v, v, w, h, residuo));

print(NN);

}