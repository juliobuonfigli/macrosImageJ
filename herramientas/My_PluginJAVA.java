import ij.*;
import ij.process.*;
import ij.gui.*;
import java.awt.*;
import ij.plugin.*;
import ij.plugin.frame.*;

public class My_Plugin implements PlugIn {


int H;
int W;
int unosMascara;
int[] ejeX;
int[] ejeY
int[] Rojo;
int[] Verde;
int[] RojoAndMascara;
int[] VerdeAndMascara;
int[] mascara;
int[][] rojo;
int[][] verde;
int[][] unosColo;
int[] unosRojos;
int[] unosVerdes;  
float [] elMayor;
float [][] colo;
String[] titles;
int[] wList;
int i1Index;
int i2Index;
int i3Index;
ImagePlus i1;
ImagePlus i2;
ImagePlus i3;
ImagePlus imp; 

public boolean mainDialog() {
        GenericDialog gd = new GenericDialog("Image Deconstructor");
        gd.addChoice("Channel_1 (red): ", titles, titles[0]);
        gd.addChoice("Channel_2 (green): ", titles, titles[1]);
        gd.addChoice("Mask: ", titles, titles[2]);
       
      gd.showDialog();
        
        int i1Index = gd.getNextChoiceIndex();
        int i2Index = gd.getNextChoiceIndex();
        int i3Index = gd.getNextChoiceIndex();
        i1 = WindowManager.getImage(wList[i1Index]);
        i2 = WindowManager.getImage(wList[i2Index]);
        i3 = WindowManager.getImage(wList[i3Index]);
return true;       
    }

public void run(String arg) {

wList = WindowManager.getIDList();
 
        if (wList==null || wList.length<2) {
            IJ.showMessage("There must be at least three windows open");
            return;
}
titles = new String[wList.length];
        for (int i=0; i<wList.length; i++) {
            ImagePlus imp = WindowManager.getImage(wList[i]);
            if (imp!=null)
                titles[i] = imp.getTitle();
            else
                titles[i] = " ";
        }
mainDialog();


ImageProcessor pi1 = i1.getProcessor();
ImageProcessor pi2 = i2.getProcessor();
ImageProcessor pi3 = i3.getProcessor();

H=pi1.getHeight();
W=pi1.getWidth();

Rojo=new int[H*W];
Verde=new int[H*W];
mascara=new int[H*W];

int f=0;
for(int r=0; r<W; r++)
	{
	for(int s=0; s<H; s++)
		{
		Rojo[f]=pi1.getPixel(r, s);	
		Verde[f]=pi2.getPixel(r, s);
		mascara[f]=pi3.getPixel(r, s);
		f++;
		}
	}

unosMascara=0;
for(int i=0; i<H*W; i++)
	{
	if(mascara[i]==255)
		unosMascara++;	
	}

RojoAndMascara=new int[unosMascara];
VerdeAndMascara=new int[unosMascara];

int o=0;
for(int i=0; i<H*W; i++)
	{
	if(mascara[i]==255)
		{
		RojoAndMascara[o]=Rojo[i];
		VerdeAndMascara[o]=Verde[i];
		o++;
		}
	}

rojo=new int[255][unosMascara];
verde=new int[255][unosMascara];
ejeX=new int[255];
ejeY=new int[255];
unosColo=new int[255][255]; 
unosRojos=new int[255];
unosVerdes=new int[255];  
colo=new float[255][255];
elMayor=new float [];


for(int j=0; j<255; j++)
	{
	IJ.showStatus("Segmenting: " + j);
	for(int i=0; i<unosMascara; i++)
		{
		if(RojoAndMascara[i]==j)
			{
			rojo[j][i]=255;
			unosRojos[j]++;
			}
			else
			rojo[j][i]=0;
		if(VerdeAndMascara[i]==j)
			{
			verde[j][i]=255;
			unosVerdes[j]++;
			}
			else
			verde[j][i]=0;
		}
	}

for(int e=0; e<255; e++)
	{
	IJ.showStatus("Correlating: " + j);
	for(int j=0; j<255; j++)
		{
		for(int i=0; i<unosMascara; i++)
			{
			if(rojo[e][i]*verde[j][i]!=0)
				unosColo[e][j]++;
			}		
		colo[e][j]=unosColo[e][j]/(unosRojos[e]+unosVerdes[j]);
		}     
	}


for(e=0; e<255; e++)
	{ 
	elMayor[e]==0;
	for(j=0; j<255; j++)
		if(colo[e][j]>elMayor[e])
			{
			elMayor[e]=colo[e][j];
			ejeX[e]=e;
			ejeY[e]=j;	
			}
		}
	}	

Plot plot1 = new Plot("Correlation","Red","Green", ejeX, ejeY);
   
        plot1.show();

}}



