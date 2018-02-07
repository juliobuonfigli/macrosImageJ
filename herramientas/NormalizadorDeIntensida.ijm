ip=40;

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

function IP(vector, w, h) {
	suma=0;
	for(i=0; i<w*h; i++)
		suma=suma+vector[i];
	suma=suma/(w*h);
	return suma;
}

selectWindow("b");
w = getWidth;                                 
h = getHeight;
res= VECTORIZAR("b", w, h);
co=ip/IP(res, w, h);

for(i=0; i<w*h; i++)
	res[i]=res[i]*co;

newImage("tratada", "8-bit black", w, h, 1);
 i = 0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		setPixel(x, y, res[i]);
		i++;
		}
	}
