void setup()
{
  size( 800, 500 );
  //fullScreen();
  noStroke();
}

void draw(){
  
   background( 0 );
   
   // Draw the bigg bubble that follows the mouse
  fill( 240 );
  ellipse( mouseX, mouseY, 40, 40 );
  
  // Dividing by a bigger number gives the grid a faster wave-effect
  float a = millis() / 6053.0f;
  // Calculate the grid value ('normal' distance between small bubbles)
  float grid = 30 + 20 * sin ( a );
  
  // Dividing by a bigger number will make the diameter of the small bubbles change faster
  float b = millis() / 4657.0f;
  // Calculate the diamter of the small bubbles 
  float diam = 12 + 10 * cos( b );
  
  // Set the fill color for the small bubbles
  fill( 150 );

  for(
      float x = width / 2 - ceil( width / ( 2 * grid ) ) * grid; // OK, this is hard ;-) This makes sure the middle row is always at the center of the screen
      x <= width;
      x += grid)
  {

    for(
      float y = height / 2 - ceil( height / ( 2 * grid ) ) * grid;
      y <= height;
      y += grid)
    {
      // How far is this small bubble away from the big bubble (from center to center)?
      PVector distance = new PVector( x - mouseX, y - mouseY );
      
      // Calculate an imaginary force 'push' => The closer the small bubble is to the big bubble, the harder it will be pushed away.
      // 'push' will always be positive
      float push = 40 - sqrt( distance.mag() );
      push = max( push, 0 );
      
      // Calculate an offset for this small bubble
      PVector offset =
        PVector.fromAngle( distance.heading() )  // It is pushed away in the direction of the 'distance' vector
        .mult( push );                           // It is pushed away with a distance push
      
      // Finally time to draw the bubble!
      ellipse( x + offset.x, y + offset.y, diam, diam);
    }
  }
}