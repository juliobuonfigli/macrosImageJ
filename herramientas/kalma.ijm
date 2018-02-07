//kalman
//rename("stackInicial");
run("8-bit");
w = getWidth;               
h = getHeight;
s=14;

vector=newArray(w*h);
k=0;  
  for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		u=0;
		for(i=1; i<s+1; i++)
			{
			setSlice(i);
			u=u+getPixel(x, y);
			i++;
			}
		vector[k] = u/s;
		k++;
		}
	}


newImage("Kalman", "8-bit black", w, h, 1);
n=0;
for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
		setPixel(x, y, vector[n]);
		n++;
		}
	} 

	