ip=6000;

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

selectWindow("p");
w = getWidth;                                 
h = getHeight;
vec1= VECTORIZAR("p", w, h);
vec2=newArray(w*h);
res=newArray(w*h);


j=0;
for(Y=0; Y<h; Y++)
	{
	for(X=0; X<w; X++)
		{
		i=0;
		for(y=0; y<h; y++)
			{
			for(x=0; x<w; x++)
				{
				if(i==j) {} else {
				vec2[i]=vec2[i]+round(vec1[j]/sqrt((X-x)*(X-x)+(Y-y)*(Y-y)+1));}
				i++;
				}
			}
		j++;	
		}
	}

for(i=0; i<w*h; i++)
	res[i]=vec1[i]+vec2[i];

co=ip/IP(res, w, h);

for(i=0; i<w*h; i++)
	res[i]=res[i]*co;

newImage("singularidad", "16-bit black", w, h, 1);
 i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		setPixel(x, y, res[i]);
		i++;
		}
	}


