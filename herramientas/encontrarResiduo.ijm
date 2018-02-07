


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



function DCartRand(a, b, w, h, res) {
i=0;
j=0;
num=0;
for(y1=0; y1<h; y1++)
	{
	for(x1=0; x1<w; x1++)
		{
		j=0;
		for(y2=0; y2<h; y2++)
			{
			for(x2=0; x2<w; x2++)
				{
				d=sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+res);
				coef=a[i]*b[j]/d;
				num=num+coef;
				j++;
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

 Dialog.create("MMSR");    //genero ventana de inicio                                                      
  Dialog.addChoice("Red:", figura);         
  Dialog.addChoice("Green:", figura);          
  
  
       Dialog.show();
   	red=Dialog.getChoice();
   	green=Dialog.getChoice();


w = getWidth;                                 
h = getHeight;

r=VECTORIZAR(red, w, h);
v=VECTORIZAR(green, w, h); 

/*res=1;
cr=DCartRand(r, r, w, h, res);
cv=DCartRand(v, v, w, h, res);*/

iter=0;

do{
	res=1000*random;
	cr=DCartRand(r, r, w, h, res);
	cv=DCartRand(v, v, w, h, res);
	iter++;
	showStatus(iter);	
	} while(abs(cr-cv)>((cr+cv)/2)*0.015 && iter<30000)
	
print(cv+"    "+cr+"    "+res+"             "+iter);

