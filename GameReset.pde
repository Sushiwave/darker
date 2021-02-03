void gameReset()
{
  inversed                   = false;
  isGameOvered               = false;
  isGameCleared              = false;
  inverseAnimationRunning    = false;
  gameOverTextDisplaying     = false;
  gameClearTextDisplaying    = false;
  gameOverProcessInvalidated = false;
  restarting                 = false;
  starting                   = true;
  
  camera = new Camera();
  camera.lookAt = new PVector(width/2, height/2); 
  
  stage.resumeUpdatingShaderTime();
  
  
  angleOffset = 0.0;
  textAlpha   = 0.0;
  
  offset = 0.0;
  
  gravityScale = -10.0;
  box2d.setGravity(0.0, gravityScale);
    
  if (movement != null)
  {
    movement.destroyAll();
  }
  movement = new SpringyCircleParticleSystemForGame();
  player = new SpringyCircle(30, 40.0, 3.0, movement, new DefaultMaterial(color(255)), new PVector(200.0, height*0.5-250.0));  
  
  timerInverse.reset();
  timerGameOver.reset();
  timerGameClear.reset();
  timerRestart.reset();
  timerStart.reset();
  timerStart.start();
  
  postProcessing.set("inversed", false);
  postProcessing.set("enabledLightEffect", true);
  
  if(noise > 0.0)
  {
    postProcessing.set("enabledNoise",     true);
    postProcessing.set("enabledSinNoise",  true);
    postProcessing.set("enabledCellNoise", true);
  }
  else
  {
    postProcessing.set("enabledNoise",     false);
    postProcessing.set("enabledSinNoise",  false);
    postProcessing.set("enabledCellNoise", false);
  }
  
  postProcessing.set("noiseScale",      0.305*noise);
  postProcessing.set("caInterval",      0.01+0.24*noise);
  postProcessing.set("saturationScale", 1.0+2.0*noise);
  postProcessing.set("sandstormScale",  noise);
  
  postProcessing.set("flashOut",   0.0);
  postProcessing.set("fadeInOut",  0.0);
  postProcessing.set("lightScale", 1.0);
}

void refresh()
{
  noise = 0.0;
  gameReset();
}
