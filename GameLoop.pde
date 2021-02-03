void gameLoop()
{
  System.getBox2DContext().step();
  player.update();
  inverseAnimation();
  
  PVector playerPosition = player.getPosition();
  
  boolean nearTheStartPoint = playerPosition.x <= width/float(2);
  boolean nearTheEndPoint = stage.getWidth()-width/float(2) <= playerPosition.x;
  boolean isCameraStopped = nearTheStartPoint || nearTheEndPoint;
 
  float stageWidth = stage.getWidth();
  
  if(inversed)
  {
    postProcessing.set("lightPosition", isCameraStopped ? (nearTheStartPoint ? (width-playerPosition.x)/float(width) : (stageWidth-playerPosition.x)/float(width)) : 0.5, playerPosition.y/float(height));
  }
  else 
  {
    postProcessing.set("lightPosition", isCameraStopped ? (nearTheStartPoint ? playerPosition.x/float(width) : 1.0-(stageWidth-playerPosition.x)/float(width)) : 0.5, (float(height)-playerPosition.y)/float(height));
  }
  
  float playerPositionX = player.getPosition().x;
  if(playerPositionX >= width/2.0)
  {
    camera.lookAt.x = playerPositionX;
  }
  camera.lookAt.x = min(camera.lookAt.x, stage.getWidth()-width*0.5);
}
