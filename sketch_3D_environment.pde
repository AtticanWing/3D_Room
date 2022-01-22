import java.awt.Robot;
Robot rbt;
boolean skipFrame;

//color pallette
color black = #000000;    //oak planks
color white = #FFFFFF;    //empty space
color grayblue = #7092BE; //stone

//map variables
int gridSize;
PImage map;

//environment variables
PImage stone, oakPlanks, leaves;
boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftRightHeadAngle, upDownHeadAngle;

void setup() {
  stone = loadImage("Deepslate_Bricks.png");
  oakPlanks = loadImage("Oak_Planks.png");
  leaves = loadImage("Oak_Leaves_C.png");
  textureMode(NORMAL);

  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 85*height/100;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;
  leftRightHeadAngle = radians(270);
  skipFrame = false;
  noCursor();

  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  //initialize map
  map  = loadImage("map.png");
  gridSize = 100;
}

void draw() {
  background(0);
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);
  drawFloor(-2000, 2000, height, gridSize);            //floor
  drawFloor(-2000, 2000, height-gridSize*6, gridSize); //ceiling
  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawFloor(int xmin, int xmax, int y, int inc) {
  stroke(255);
  int z = xmin;
  int x = xmin;
  while (z < xmax) {
    texturedCube(x, y, z, oakPlanks, inc);
    x += inc;
    if (x >= xmax) {
      x = xmin;
      z += inc;
    }
  }
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == grayblue) {
        for (int i = 1; i <= 5; i++) {
          texturedCube(x*gridSize-2000, height-gridSize*i, y*gridSize-2000, leaves, gridSize);
        }
      }
      if (c == black) {
        for (int i = 1; i <= 5; i++) {
          texturedCube(x*gridSize-2000, height-gridSize*i, y*gridSize-2000, stone, gridSize);
        }
      }
    }
  }
}

void controlCamera() {
  if (wkey) {
    eyeX += cos(leftRightHeadAngle)*10;
    eyeZ += sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX -= cos(leftRightHeadAngle)*10;
    eyeZ -= sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX -= cos(leftRightHeadAngle + PI/2)*10;
    eyeZ -= sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX -= cos(leftRightHeadAngle - PI/2)*10;
    eyeZ -= sin(leftRightHeadAngle - PI/2)*10;
  }

  if (skipFrame == false) {
    leftRightHeadAngle += (mouseX - pmouseX)*0.01;
    upDownHeadAngle += (mouseY-pmouseY)*0.01;
  }
  
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;

  if (mouseX < 2) {
    rbt.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else if (mouseX > width-2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
  
  println(eyeX, eyeY, eyeZ);
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
