/*
TITLE: Uncle Holly
AUTHOR: Kyle Koon
DATE DUE: 2/3/21
DATE SUBMITTED: 2/3/21
COURSE TITLE: Game Design
MEETING TIME(S): Mon. and Wed. at 2pm
DESCRIPTION: This program creates the Uncle Holly Game. In this game, the user left clicks on presesnts as they come off of a conveyor belt. They must then
drag the present into the correctly colored present box. The objective of the game is to package as many presents as possible and to save Christmas.
HONOR CODE: On my honor, I neither gave nor received unauthorized aid on this assignment. Signature: Kyle Koon
*/

import java.util.Random;

int scene = 1; //program will start on scene 1

//will store image files
PImage holly;
PImage hollyHead;
PImage textCloud;
PImage elf1;
PImage explosion;

present[] presents = new present[10]; //will store an array of 10 present objects
//declares the 10 present objects
present bike;
present tank;
present tennisBall;
present scooter;
present socks;
present helmet;
present glove;
present iphone;
present fireTruck;
present bomb;
present currentPres;

boolean chosen = false; //keeps track of whether or not a random present image has been generated
boolean clicked = false; //keeps track of whether or not a present image has been clicked
boolean packaged = false; //keeps track of whether the present has been placed in a package or not

Box[] boxes = new Box[3]; //will store an array of 3 Box objects
//declares the 3 Box objects
Box b1;
Box b2;
Box b3;

int points = 0; //the player starts with 0 points
int Time; //stores the duration in milliseconds that the game has been running
float currentSpeed = 3; //stores the default speed of the presents


class present {
  private PImage img;
  private float x;
  private int y;
  private float speed;
  private String Color;
  
  present(PImage tempImg, float tempX, int tempY, String tempColor){
    img = tempImg;
    x = tempX;
    y = tempY;
    Color = tempColor;
  }
  
  void showImg(){ //displays the image on screen
    image(img,x,y);
  }
  
  void showImg(float MouseX, float MouseY){ //displays the image on screen where the user's current mouse position is
    image(img,MouseX,MouseY);
  }
  
  void setSpeed(float tempSpeed){ //sets how quickly the image moves across screen
    speed = tempSpeed;
  }
  
  void increaseSpeed(float inc){ //increases the speed of the image across the screen
    speed += inc;
  }
  
  void moveImg(){ //alters the x position of the image on screen
    x += speed;
  }
}


class Box {
  private int x;
  private int y;
  private int w;
  private int h;
  private String Color;
  
  Box(int tempX, int tempY, int tempW, int tempH, String tempColor){
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    Color = tempColor;
  }
  
  void show(){ //displays the box on screen
    rect(x,y,w,h);
  }
}

void scene1(){ //the first scene of the game (splash screen)
  background(0);
  textSize(50);
  textAlign(CENTER);
  text("UNCLE HOLLY", width/2, height/8);
  fill(150);
  imageMode(CENTER);
  image(holly, width/2, height/2);
  holly.resize(400,0); //proportionally shrinks the image
  text("CLICK TO PLAY", width/2, height-height/8+50);
}

void scene2(){ //the second scene of the game (preamble)
  background(0);
  imageMode(CENTER);
  image(hollyHead,width-hollyHead.width, height/2);
  textAlign(LEFT);
  textSize(20);
  text(" Hey, I'm Santa's brother Holly. Santa just tested positive \n for COVID, so he put me in charge. We've got to get these \n presents packaged up and ready to go. \n All you have to do is click and drag the presents into the \n appropriate colored boxes. Good luck! Let's save Christmas!", 0, height/2-75);
  text(" Also, dont package the bombs. I don't know how those got in there. \n If you finish with more than 15 points, you win!", 0, height/2+150);
  textAlign(CENTER);
  text("Click to continue", width/2, height-100);
}

void scene3(){ //the third scene of the game (actual gameplay)
  background(255);
  rect(50,150,100,100); //draws the main part of the "conveyor belt"
  rect(50,250,width,5); //draws the belt of the conveyor belt
  updateClock(); //decreases the amount of time remaining to play the game
  text("Points: " + points,width-150,20); //displays the player's current point count
  if(!chosen || (currentPres != null && currentPres.x > width)){ //runs if a random present hasn't been selected or if the current present has gone off screen
    if(currentPres != null && currentPres.x > width && currentPres.Color != "black"){ //runs if the current present has gone off screen and is not a bomb
      points -= 1; //the user loses one point for letting the present get away
      currentPres.x = 200; //the current presents x coordinate is reset
      currentPres.y = 200; //the current presents y coordinate is reset
    }
    currentPres = pickPresent(presents); //a new random present is selected
    chosen = true; //signifies that a new present has been selected
  }
  if(!clicked && !packaged){ //runs if the user has not clicked on the present and has not dragged the present into a box 
    currentPres.showImg(); //displays the current present
    if(Time%10 == 0){ //runs every 10 seconds
      updateSpeeds(); //increases the speeds of the presents
    }
    else{
      currentPres.setSpeed(currentSpeed); //keep the speed of the presents the same
    }
  }
  if(clicked){ //runs if the user has clicked on the present
    currentPres.setSpeed(0); //the current present's speed is set to 0
    currentPres.showImg(mouseX,mouseY); //the current present's positioning is now mapped to the player's mouse position
    if(checkIfBoxed()){ //runs if the user has dragged the present into a box
      currentPres.x = 200; //resets the current present's x position
      currentPres.y = 200; //resets the current present's y position
    }
  }
  currentPres.moveImg(); //increases the x value of the current present's position (moves it across screen)
  fill(255,0,0);
  b1.show(); //displays the red box
  fill(0,255,0);
  b2.show(); //displays the green box
  fill(0,0,255);
  b3.show(); //displays the blue box
  image(elf1,elf1.width,height-100); //places an image of an elf in the bottom left
  elf1.resize(100,0);
}

void scene4(){ //the fourth scene of the game (ending)
  background(0);
  textAlign(CENTER);
  textSize(30);
  fill(255);
  if(points > 15){ //the player wins if they have more than 15 points
    text("Good Job. Christmas is saved! \n You finished with " + points + " points", width/2, height/2); //displays win message with player's final point count
  }
  else{
    text("Santa is going to be disappointed. \n You finished with " + points + " points", width/2, height/2); //displays lose message with player's final point count
  }
  image(hollyHead,width/2,height/2-hollyHead.height);
}
  

void setup(){
  size(900,900);
  //loads various images
  holly = loadImage("UncleHolly.jpeg");
  hollyHead = loadImage("HollyHead.PNG");
  textCloud = loadImage("textCloud.png");
  elf1 = loadImage("Elf1.PNG");
  
  
  //creates 10 present objects and adjusts their sizing
  bike = new present(loadImage("bike.png"),200,200,"green");
  bike.img.resize(100,0);
  tank = new present(loadImage("tank.jpg"),200,200,"green");
  tank.img.resize(100,0);
  tennisBall = new present(loadImage("tennisBall.jpg"),200,200,"green");
  tennisBall.img.resize(100,0);
  scooter = new present(loadImage("scooter.png"),200,200,"blue");
  scooter.img.resize(100,0);
  socks = new present(loadImage("socks.png"),200,200,"blue");
  socks.img.resize(100,0);
  helmet = new present(loadImage("helmet.png"),200,200,"blue");
  helmet.img.resize(100,0);
  glove = new present(loadImage("glove.png"),200,200,"red");
  glove.img.resize(100,0);
  iphone = new present(loadImage("iphone.jpg"),200,200,"red");
  iphone.img.resize(100,0);
  fireTruck = new present(loadImage("fireTruck.jpg"),200,200,"red");
  fireTruck.img.resize(100,0);
  bomb = new present(loadImage("bomb.jpg"),200,200,"black");
  bomb.img.resize(100,0);
  //stores the 10 present objects into an array
  presents[0] = bike;
  presents[1] = tank;
  presents[2] = tennisBall;
  presents[3] = scooter;
  presents[4] = socks;
  presents[5] = helmet;
  presents[6] = glove;
  presents[7] = iphone;
  presents[8] = fireTruck;
  presents[9] = bomb;
  
  
  //creates 3 Box objects
  b1 = new Box(width/4,height-100,100,100,"red");
  b2 = new Box(2*width/4,height-100,100,100,"green");
  b3 = new Box(3*width/4,height-100,100,100,"blue");
  //stores the 3 Box objects into an array
  boxes[0] = b1;
  boxes[1] = b2;
  boxes[2] = b3;
}

void draw(){
  switch(scene){ //runs if the scene number changes
    case 1:
      scene1();
      break;
    case 2:
      scene2();
      break;
    case 3:
      scene3();
      break;
    case 4:
      scene4();
      break;
  }
}

void mousePressed(){
  if(scene != 3){ //allows the user to click through the first two scenes
    scene+=1;
  }
  else{
    if(!clicked){ //runs if the user has not clicked on a present
      if(mouseX > currentPres.x - 50 && mouseX < currentPres.x + 50) { //checks if the user clicks within the present's current x position + or - 50 pixels
        if(mouseY > currentPres.y - 50 && mouseY < currentPres.y + 50){ //checks if the user clicks within the present's current y position + or - 50 pixels 
            clicked = true; //signifies that the user has successfully clicked on the present
            if(currentPres.Color == "black"){ //runs if the user has clicked on the bomb
              points-=5; //the user loses 5 points
              chosen = false; //a present is no longer in existence
              packaged = false; //the present was not packaged
              clicked = false; //the present is no longer clicked
              currentPres.x = 200; //the present's x value is reset
              currentPres.y = 200; //the present's y value is reset
            }
        }
      }
    }
  }
}

boolean checkIfBoxed(){ //checks if the user has dragged a present into the appropriate box or not
  for(int i = 0; i < boxes.length; i++){ //iterates through the three boxes
    if(mouseX > boxes[i].x && mouseX < boxes[i].x + boxes[i].w){ //checks if mouse is within the box in the x direction
      if(mouseY > boxes[i].y && mouseY < boxes[i].y + boxes[i].h){ //checks if mouse is within the box in the y direction
        if(boxes[i].Color == currentPres.Color){ //runs if the color of the present matches the color of the box (a successful packaging)
          points+=1; //the user gains one point
          chosen = false; //a present is no longer in existence
          packaged = false; //the present is no longer packaged
          clicked = false; //the present is no longer clicked
          return true; //the present was boxed
        }
        else{ //runs if the color of the present does not match the color of the box
          points-=2; //the user loses 2 points
          chosen = false; //a present is no longer in existence
          packaged = false; //the present is no longer packaged
          clicked = false; //the present is no longer clicked
          return true; //the present was boxed
        }
      }
    }
  }
  return false; //the present was never boxed
}

present pickPresent(present[] Presents){ //picks a random present object from the Presents array
  Random rand = new Random();
  int i = rand.nextInt(Presents.length);
  return Presents[i];
}

void updateClock(){ //changes the amount of time remaining in the game
  Time = millis(); //gets the time in milliseconds of the game being open
  Time/=1000; //converts milliseconds into seconds
  textAlign(LEFT);
  text("Time Remaining: " + (61-Time),20,20); //displays the amount of time remaining to play the game
  if(Time > 60){ //runs if the user has been playing for 60 seconds (time has expired)
    scene++; //the scene is changed to the end scene
  }
}

void updateSpeeds(){
  for(int i = 0; i < presents.length; i++){
    presents[i].setSpeed(currentSpeed+.05);
  }
  currentSpeed+=.05;
}
