
setForegroundColor(255, 255, 255);
run("Draw", "slice");
Roi.getCoordinates(xp, yp);
for(i=2; i<101; i++)
	{
	setSlice(i);
	makePolygon(xp[0], yp[0], xp[1], yp[1], xp[2], yp[2], xp[3], yp[3], xp[4], yp[4], xp[5], yp[5], xp[6], yp[6], xp[7], yp[7], xp[8], yp[8], xp[9], yp[9], xp[10], yp[10], xp[11], yp[11], xp[12], yp[12], xp[13], yp[13], xp[14], yp[14], xp[15], yp[15], xp[16], yp[16], xp[17], yp[17]);
	run("Draw", "slice");
	roiManager("add");
	roiManager("Select", i-2);
	Roi.getCoordinates(xp, yp);
	for(j=0; j<18; j++)
		{
		if(random>0.86)
			xp[j]=xp[j]+round((2*random-1));	
		if(random>0.86)
			yp[j]=yp[j]+round((2*random-1));
		}
	}