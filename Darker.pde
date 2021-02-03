import shiffman.box2d.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;
PShader postProcessing;
PGraphics result;
PGraphics mainPass;
PGraphics shadowPass;

SpringyCircle player;
SpringyCircleParticleSystemForGame movement;
Camera camera;
Stage stage;

PImage thinkingFaceImage;

PFont customFont; 
Timer timerInverse;
Timer timerGameOver;
Timer timerGameClear;
Timer timerRestart;
Timer timerStart;

float gravityScale;
float angleOffset;
float textAlpha;
float noise;
float offset;

boolean inversed;
boolean isGameOvered;
boolean isGameCleared;
boolean inverseAnimationRunning;
boolean gameOverTextDisplaying;
boolean gameClearTextDisplaying;
boolean starting;
boolean restarting;
boolean gameOverProcessInvalidated;


void setup()
{
  size(1024, 640, P2D);
  gameSetup();
  gameReset();
}
void draw()
{
  float time = millis()/1000.0;
  postProcessing.set("time", time);
  
  {
    if(KeyState.pressed("Escape"))
    {
      refresh();
    }
  
    if(KeyState.pressed("b"))
    {
      gameOverProcessInvalidated = true;
    }
    else if(KeyState.pressed("n"))
    {
      gameOverProcessInvalidated = false;
    }
  }
  
  if(isGameCleared == false)
  {
    if(player.getPosition().x >= stage.getWidth()-width/2.0)
    {
      isGameCleared = true;
      gameOverProcessInvalidated = true;
      timerGameClear.start();
    }
  }
  else
  {
    gameClearProcess();
  }
  
  
  if (restarting)
  {
    restartProcess();   
  }
  else
  { 
    if(isGameOvered)
    {
      gameOverProcess(); 
    }
    else
    {
      if(starting)
      {
        startProcess();
      }
      gameLoop();
    }
  }
  
  
  
  //影をレンダリング
  if(gameOverTextDisplaying == false)
  {
    shadowPass.beginDraw();
      shadowPass.background(0);
      camera.setToPipeline(shadowPass);
      stage.draw_(shadowPass, new DefaultMaterial(255));
    shadowPass.endDraw();
  }
  else
  {
    shadowPass.beginDraw();
      shadowPass.background(255);
    shadowPass.endDraw();
  }
  
  mainPass.beginDraw();
    if(gameOverTextDisplaying)
    {
      mainPass.background(255);
      mainPass.textFont(customFont, 100);
      mainPass.fill(0, 0, 0, textAlpha*255.0);
      mainPass.textAlign(CENTER, CENTER);
      mainPass.text("Game Over", width/2, height/2);
    }
    else if(gameClearTextDisplaying)
    {
      float t = timerGameClear.getElapsedTimeSec();
      if(t <= 10.1)
      {
        background(255);
      }
      
      if(10.0 <= t && t <= 12.0)
      {
        mainPass.imageMode(CENTER);
        for(int i = 0; i < 10; ++i)
        {
          if(frameCount%5==0)
          {
            mainPass.image(thinkingFaceImage, random(width), random(height), 100+random(100), 100+random(100));
          }
        }
      }
      else if(12.0 <= t && t < 13.0)
      {
        offset += 5.0;
      }
      else if (t >= 13.0)
      {
        exit();
      }
      
      mainPass.textFont(customFont, 100);
      mainPass.fill(0);
      mainPass.textAlign(CENTER, CENTER);
      mainPass.text("Game Clear", width/2+offset, height/2-offset);
    }
    else
    {
      mainPass.background(color(150, 150, 130));
      camera.setToPipeline(mainPass);
      if(starting)
      {
        mainPass.textFont(customFont, 200);
        mainPass.fill(255, 255, 255, textAlpha*255.0);
        mainPass.textAlign(CENTER, CENTER);
        mainPass.text("START", width/2, height/2);
      }
      player.draw_(mainPass);
      stage.draw_(mainPass);
    }
  mainPass.endDraw();
  
  result.beginDraw();
    mainPass.textureWrap(CLAMP);
    result.shader(postProcessing);
    result.image(mainPass, 0, 0);
  result.endDraw();
  
  image(result, 0, 0);
}
