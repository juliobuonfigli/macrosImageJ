// Conversion de una imagen a 4 bit



run("8-bit");

w = getWidth;                                  
h = getHeight;
//run("RGB Stack");
//run("Split Channels");
//rename("rgbImage");

selectWindow("rgbImage (red)");

a = newArray(w*h);
i = 0;
   for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
                        a[i] = getPixel(x,y);
		if(a[i]<16)
			setPixel(x, y, 0);
		if(a[i]>15 && a[i]<33)
			setPixel(x, y, 16);
		if(a[i]>32 && a[i]<49)
			setPixel(x, y, 32);
		if(a[i]>48 && a[i]<65)
			setPixel(x, y, 48);
		if(a[i]>64 && a[i]<71)
			setPixel(x, y, 64);
		if(a[i]>80 && a[i]<97)
			setPixel(x, y, 80);
		if(a[i]>96 && a[i]<113)
			setPixel(x, y, 96);
		if(a[i]>112 && a[i]<129)
			setPixel(x, y, 112);
		if(a[i]>128 && a[i]<145)
			setPixel(x, y, 128);
		if(a[i]>144 && a[i]<161)
			setPixel(x, y, 144);
		if(a[i]>160 && a[i]<177)
			setPixel(x, y, 160);
		if(a[i]>176 && a[i]<193)
			setPixel(x, y, 176);
		if(a[i]>192 && a[i]<209)
			setPixel(x, y, 192);
		if(a[i]>208 && a[i]<225)
			setPixel(x, y, 208);
		if(a[i]>224 && a[i]<241)
			setPixel(x, y, 224);
		if(a[i]>240 && a[i]<256)
			setPixel(x, y, 240);
		i++;
		}
	}

		
selectWindow("rgbImage (green)");

a = newArray(w*h);
i = 0;
   for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
                        a[i] = getPixel(x,y);
		if(a[i]<16)
			setPixel(x, y, 0);
		if(a[i]>15 && a[i]<33)
			setPixel(x, y, 16);
		if(a[i]>32 && a[i]<49)
			setPixel(x, y, 32);
		if(a[i]>48 && a[i]<65)
			setPixel(x, y, 48);
		if(a[i]>64 && a[i]<71)
			setPixel(x, y, 64);
		if(a[i]>80 && a[i]<97)
			setPixel(x, y, 80);
		if(a[i]>96 && a[i]<113)
			setPixel(x, y, 96);
		if(a[i]>112 && a[i]<129)
			setPixel(x, y, 112);
		if(a[i]>128 && a[i]<145)
			setPixel(x, y, 128);
		if(a[i]>144 && a[i]<161)
			setPixel(x, y, 144);
		if(a[i]>160 && a[i]<177)
			setPixel(x, y, 160);
		if(a[i]>176 && a[i]<193)
			setPixel(x, y, 176);
		if(a[i]>192 && a[i]<209)
			setPixel(x, y, 192);
		if(a[i]>208 && a[i]<225)
			setPixel(x, y, 208);
		if(a[i]>224 && a[i]<241)
			setPixel(x, y, 224);
		if(a[i]>240 && a[i]<256)
			setPixel(x, y, 240);
		i++;
		}
	}

		
selectWindow("rgbImage (blue)");

a = newArray(w*h);
i = 0;
   for (y=0; y<h; y++)
	{
	for (x=0; x<w; x++)
		{
                        a[i] = getPixel(x,y);
		if(a[i]<16)
			setPixel(x, y, 0);
		if(a[i]>15 && a[i]<33)
			setPixel(x, y, 16);
		if(a[i]>32 && a[i]<49)
			setPixel(x, y, 32);
		if(a[i]>48 && a[i]<65)
			setPixel(x, y, 48);
		if(a[i]>64 && a[i]<71)
			setPixel(x, y, 64);
		if(a[i]>80 && a[i]<97)
			setPixel(x, y, 80);
		if(a[i]>96 && a[i]<113)
			setPixel(x, y, 96);
		if(a[i]>112 && a[i]<129)
			setPixel(x, y, 112);
		if(a[i]>128 && a[i]<145)
			setPixel(x, y, 128);
		if(a[i]>144 && a[i]<161)
			setPixel(x, y, 144);
		if(a[i]>160 && a[i]<177)
			setPixel(x, y, 160);
		if(a[i]>176 && a[i]<193)
			setPixel(x, y, 176);
		if(a[i]>192 && a[i]<209)
			setPixel(x, y, 192);
		if(a[i]>208 && a[i]<225)
			setPixel(x, y, 208);
		if(a[i]>224 && a[i]<241)
			setPixel(x, y, 224);
		if(a[i]>240 && a[i]<256)
			setPixel(x, y, 240);
		i++;
		}
	}
		

run("Merge Channels...", "c1=[rgbImage (red)] c2=[rgbImage (green)] c3=[rgbImage (blue)] create");
run("RGB Color");	
