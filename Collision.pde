void beginContact(Contact cp)
{
  Fixture fixture1 = cp.getFixtureA();
  Fixture fixture2 = cp.getFixtureB();
  
  Body body1 = fixture1.getBody();
  Body body2 = fixture2.getBody();
  
  Object object1 = body1.getUserData();
  Object object2 = body2.getUserData();
  
  collidedWithDangerBlock(object1, object2);
  collidedWithDangerBlock(object2, object1);
}
void endContact(Contact cp)
{
  Fixture fixture1 = cp.getFixtureA();
  Fixture fixture2 = cp.getFixtureB();
  
  Body body1 = fixture1.getBody();
  Body body2 = fixture2.getBody();
  
  Object object1 = body1.getUserData();
  Object object2 = body2.getUserData();
  
  collisionProcess(object1, object2);
  collisionProcess(object2, object1);
}
void collidedWithDangerBlock(Object object1, Object object2)
{
  if(object1 instanceof BoundaryBox)
  {
    BoundaryBox bb = (BoundaryBox) object1;
    if(object2 instanceof SpringyCircleCollisionInfo)
    {
      Material material = bb.getMaterialCopy();
      if(material.getType() == MaterialType.shaderMaterial)
      {
        if(gameOverProcessInvalidated == false)
        {
          if(isGameOvered == false)
          {
            isGameOvered = true; 
            stage.stopUpdatingShaderTime();
            timerGameOver.start();
          }
        }
      }
    }
  }
}
void collisionProcess(Object object1, Object object2)
{
  if(object1 instanceof BoundaryBox)
  {
    BoundaryBox bb = (BoundaryBox) object1;
    if(object2 instanceof SpringyCircleCollisionInfo)
    {
      SpringyCircleCollisionInfo collisionInfo = (SpringyCircleCollisionInfo) object2;
      
      float top = inversed ? bb.getBottomLeft().y : bb.getTopRight().y;
      if(abs(top-collisionInfo.collidedParticle.getPosition().y) <= 0.5)
      {
        SpringyCircleParticleSystemForGame particleSystem = (SpringyCircleParticleSystemForGame)collisionInfo.particleSystem;
        particleSystem.collidedWithSomething();
      }
    }
  }
}
