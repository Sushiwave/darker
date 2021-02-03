void inverseAnimation()
{
  if(inverseAnimationRunning == false)
  {
    if(KeyState.pressed("i"))
    {
      angleOffset = camera.angle == PI ? PI : 0.0;
      
      timerInverse.start();
      inverseAnimationRunning = true;
    }
  }
  
  if(inverseAnimationRunning)
  {
    final float maxAngle = angleOffset+PI;
    
    float t = min(timerInverse.getElapsedTimeSec(), 0.5)*2.0;
    camera.angle = min(angleOffset+min(1.0, max(0.0, (1.0-pow(1.0-t, 3.0))))*PI, maxAngle);
    
    if(camera.angle == maxAngle)
    {
      gravityScale*=-1.0;
      box2d.setGravity(0.0, gravityScale);
      
      inversed = !inversed;
      postProcessing.set("inversed", inversed);
      movement.inverseDirectionOfMovement();
      
      timerInverse.reset();
      inverseAnimationRunning = false;
    }
  }
}
