w=getWidth;
h=getHeight;
frames=nSlices;
if(w/2>h/2)
	larger=w/2;
	else
	larger=h/2;
frag=20;
pi=3.141592653589793; 
dt=pi/frag;
esp=1.25;
X=newArray(50);
Y=newArray(50);
ran=random;

for(j=1; j<frames+1; j++) 
	{
	setSlice(j);
	t=0; CONT=0; previous=0;
	for(i=0; i<frag; i++)
		{
		run("Select None");
		cont=0;
		do
			{
			cont++;
			xc=round(cont*cos(t)+w/2);
			yc=round(cont*sin(t)+h/2);
			pValue=getPixel(xc, yc);
			}
		while(pValue<3 && cont<previous+7) 
		previous=cont;
		X[CONT]=xc;			
		Y[CONT]=yc;
		t=t+2*dt;
		CONT++;
		}
	for(e=CONT; e<50; e++) {  X[e]=xc; 	Y[e]=yc; }
	
	run("Select None");
	makePolygon(X[0], Y[0], X[1], Y[1], X[2], Y[2], X[3], Y[3], X[4], Y[4], X[5], Y[5], X[6], Y[6], X[7], Y[7], X[8], Y[8], X[9], Y[9], X[10], Y[10], X[11], Y[11], X[12], Y[12], X[13], Y[13], X[14], Y[14], X[15], Y[15], X[16], Y[16], X[17], Y[17], X[18], Y[18], X[19], Y[19], X[20], Y[20], X[21], Y[21], X[22], Y[22], X[23], Y[23], X[24], Y[24], X[25], Y[25], X[26], Y[26], X[27], Y[27], X[28], Y[28], X[29], Y[29], X[30], Y[30], X[31], Y[31], X[32], Y[32], X[33], Y[33], X[34], Y[34], X[35], Y[35], X[36], Y[36], X[37], Y[37], X[38], Y[38], X[39], Y[39], X[40], Y[40], X[41], Y[41], X[42], Y[42], X[43], Y[43], X[44], Y[44], X[45], Y[45], X[46], Y[46], X[47], Y[47], X[48], Y[48], X[49], Y[49]);
	roiManager("Add");
	roiManager("Select", j-1);
	roiManager("Rename", j);
	}
t=0;
for(j=0; j<frag; j++)
	{
	for(i=1; i<frames; i++)
		{
		setSlice(i);
		roiManager("Select", i);
		Roi.getCoordinates(xp, yp);
		run("Select None");
		d1=sqrt(pow(xp[j]-w/2, 2)+pow(yp[j]-h/2, 2));
		d2=sqrt(pow(xp[j+1]-w/2, 2)+pow(yp[j+1]-h/2, 2));
		xa=xp[j]+5*cos(t+2*dt);
		ya=yp[j]+5*sin(t+2*dt);
		XB=xp[j]+15*cos(t+2*dt);
		YB=yp[j]+15*sin(t+2*dt);
		xb=xp[j+1]+5*cos(t+4*dt);
		yb=yp[j+1]+5*sin(t+4*dt);	
		XA=xp[j+1]+15*cos(t+4*dt);
		YA=yp[j+1]+15*sin(t+4*dt);
		if(j==frag-1) {
		xb=xp[0]+5*cos(t+4*dt);
		yb=yp[0]+5*sin(t+4*dt);	
		XA=xp[0]+15*cos(t+4*dt);
		YA=yp[0]+15*sin(t+4*dt); }
		makePolygon(xa, ya, xb, yb, XA, YA, XB, YB);
		wait(10);
		run("Select None");
		xa=xp[j]+18*cos(t);
		ya=yp[j]+18*sin(t);
		XB=xp[j]+30*cos(t);
		YB=yp[j]+30*sin(t);
		xb=xp[j+1]+18*cos(t+6*dt);
		yb=yp[j+1]+18*sin(t+6*dt);	
		XA=xp[j+1]+30*cos(t+6*dt);
		YA=yp[j+1]+30*sin(t+6*dt);
		if(j==frag-1) {
		xb=xp[0]+18*cos(t+6*dt);
		yb=yp[0]+18*sin(t+6*dt);	
		XA=xp[0]+30*cos(t+6*dt);
		YA=yp[0]+30*sin(t+6*dt); }
		makePolygon(xa, ya, xb, yb, XA, YA, XB, YB);
		wait(50);
		run("Select None");
		}
	t=t+2*dt;
	}


	