/* 
GazeTrack: Eye positions demo
-
In this demo, the user's eyes are represented 
by individual eye icons
-

Before you run this demo, make sure the
Tobii eye-tracker (EyeX, 4C) is connected
to the computer, and that the Tobii software 
is running and calibrated to your eyes.

Finally, make sure the 'TobiiStream.exe' is 
running and displaying gaze data. You can
download this application from:
http://hci.soc.napier.ac.uk/GazeTrack/TobiiStream.zip

by Augusto Esteves
http://hci.soc.napier.ac.uk
https://github.com/AugustoEst/gazetrack

If you enjoyed this demo, 
and would like to make a contribution to the project:
ETH: 0xED6A9bA7d99D8cb55037d9c68C60998eA17eCfC7
BTC: 3QSrrQdET35F2CdaZKSK1PnCrRc7np9mdQ
XLM: GD263F3X5D5ULX7TBXF6ULPGKEICAHJEO22ZOJABNVJSCYPEJW6JBU7G
*/

import gazetrack.*;
import oscP5.*;
import netP5.*;

GazeTrack gazeTrack;
OscP5 oscP5;
NetAddress myRemoteLocation;

int receivePort = 8000;
String sendIP = "127.0.0.1";
int sendPort = 1234;

PShape eye_pic;

void setup() 
{
  fullScreen();
  frameRate(60);
  
  // Gaze cursor param.
  noFill();
  stroke(50, 100);
  strokeWeight(4);
  
  gazeTrack = new GazeTrack(this);
  
  // If the TobiiStream.exe asked you to use a 
  // different socket port (e.g., 5656), use this instead:
  // gazeTrack = new GazeTrack(this, "5656");
  
  oscP5 = new OscP5(this, sendPort);
  
  myRemoteLocation = new NetAddress(sendIP, receivePort);
}

void draw() 
{
  background(255);
  
  if (gazeTrack.gazePresent())
  {
    OscMessage gazeData = new OscMessage("/eyeGaze");
    
    ellipse(gazeTrack.getGazeX(), gazeTrack.getGazeY(), 80, 80);
    
    // Print the tracker's timestamp for the gaze cursor above
    println("Latest gaze data at: " + gazeTrack.getTimestamp());
    println("X: " + gazeTrack.getGazeX() );
    println("Y: " + gazeTrack.getGazeY() );
    gazeData.add(gazeTrack.getGazeX());
    gazeData.add(gazeTrack.getGazeY());
    oscP5.send(gazeData, myRemoteLocation);
  }
}
