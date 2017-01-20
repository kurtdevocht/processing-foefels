import processing.video.*; // Needed for camera input

int dots = 750;        // The number of dots
float dotMinSize = 1;  // The minimum size of a dot
float dotMaxSize = 17; // The maximum size of a dot
float spacing = 240 / sqrt( dots );    // The spacing between dots => Calculated so that the radius of the resulting image will be 240

Capture cam;
float phi = ( (sqrt( 5 ) + 1 ) / 2 ); // The golden ratio (https://en.wikipedia.org/wiki/Golden_ratio#Golden_ratio_conjugate)

void setup() {
  size(640, 480);

  // Find a camera with size 640x480
  String[] cameras = Capture.list();
  
  if( cameras.length == 0 ) {
    println( "There are no cameras available for capture." );
    exit();
  } 
  
  int goodIndex = -1;
  println("Available cameras:");
  for( int i = 0; i < cameras.length; i++ ) {
    String camera = cameras[i];
    print(camera);
  
    if( camera.contains("size=640x480")){
      goodIndex=i;
      println( " <<< Good camera, will take this one!" );
    }
    else{
      println();
    }
  }
  
  if( goodIndex == -1 ){
    println( "There are no camera's with size=640x480" );
    exit();
  }
  
  // Good camera found -> Start it
  cam = new Capture( this, cameras[goodIndex] );
  cam.start();        
}
void draw() {
  background( #F6FFDB );
  if( cam.available() ) {
    cam.read();
  }
  
  for(int dot = 1; dot < dots; dot++)
  {
    // Calculate te angle of a dot ( % 5000 is there because otherwise results get inprecise for very large frame numbers)
    float a = (float)( (dot -( frameCount % 5000 ) ) * phi * 2 * Math.PI);
    
    // Calculate the radius of the dot
    float r = sqrt(dot) * spacing;
    
    // Convert polar coordinates (angle and radius) to cartesian coordinates (x & y)
    float x = width / 2 + cos( a ) * r;
    float y = height / 2 + sin( a ) * r;
    
    // Calculate the size of the dot depending on the brightness of the corresponding camera pixel    
    color pixel = cam.get( (int)x, (int)y );
    float dotSize = map( brightness(pixel), 255, 0, dotMinSize, dotMaxSize );
    strokeWeight(dotSize);

    // Add some transparency on the borders
    float alpha = 255;
    if( r > 200) {
      alpha = map(r, 200, sqrt(dots) * spacing, 255, 0 );
    }
    stroke(pixel, alpha);
    
    // Le moment suprême: draw a dot!
    point(x, y);
  }
}