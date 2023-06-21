import java.util.*;

Stack<Rect> rects;
float speed;
boolean gameOver;
int score;

void setup()
{
  fullScreen(P3D);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  textSize(50);

  rects = new Stack<Rect>();
  speed = 5;
  gameOver = false;
  score = 0;

  rects.push(new Rect(width/2, height * .75, width/3, height/2));
  rects.peek().isLocked = true;
  rects.push(new Rect(width * .25, height/2 - height * .05, width/3, height * .1));
}

void draw()
{
  background(0);
  text(score,width/2,height * .05);
  
  if (!gameOver)
  {
    rotateX(-PI/4);
    for (Rect rect : rects)
      rect.render();
  } else
  {
    text("Game Over!\nRestart: r", width/2, height/2);

    if (keyPressed && key == 'r')
      setup();
  }
}

class Rect
{
  float x, y, w, h;
  boolean isLocked;

  public Rect(float x, float y, float w, float h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void render()
  {
    fill(255);
    push();
    translate(x,y,0);
    //rect(x, y, w, h);
    box(w,h,width * .25);
    pop();

    if (!isLocked)
    {
      x += speed;

      if (x > width * .75 || x < width * .25)
        speed *= -1;
    }
  }

  void moveDown()
  {
    y += height * .1;
  }

  void update(Rect rect)
  {
    if (abs(rect.x - x) >= rect.w)
    {
      gameOver = true;
    } else if (x > rect.x)
    {
      float tempx = ((x - w/2) + (rect.x + rect.w/2))/2;
      w = (rect.x + rect.w/2) - (x - w/2);
      x = tempx;
    } else if (x < rect.x)
    {
      float tempx = ((x + w/2) + (rect.x - rect.w/2))/2;
      w = (x + w/2) - (rect.x - rect.w/2);
      x = tempx;
    } else
    {
      x = rect.x;
      w = rect.w;
    }
  }
}

void mousePressed()
{
  Rect curr = rects.pop();
  curr.isLocked = true;
  curr.update(rects.peek());
  rects.push(curr);

  for (Rect rect : rects)
    rect.moveDown();

  rects.push(new Rect(width * .25, height/2 - height * .05, rects.peek().w, rects.peek().h));
  
  if(score % 3 == 0)
    speed += 1;
    
  score++;
}
