class SpringyCircleParticleSystemForGame
  extends PParticleSystem
{
  private boolean m_jumpping           = false;
  private boolean m_isCollided         = false;
  private boolean m_enableManipulation = true;
  
  private int m_jumpFrame = 0;
  
  private float inverse = 1.0;
  
  //ジャンプループがn回目に達した場合
  private boolean m_isJumpEnded()
  {
    return m_jumpFrame == 30;
  }
  
  private void m_moveX(boolean isRight)
  { 
    final float   rotationScale = (isRight ? 1.0 : -1.0)*100.0;
    final PVector force         = new PVector((isRight ? -1.0 : 1.0)*inverse*15.0, 0.0);
    final int     interval      = 10;
    final int     count         = size();
        
    //PSpringyObjectを時計回り、もしくは反時計回りに回転させる
    for(int i = 0; i < count; ++i)
    {
      if (i%interval == 0)
      {
        PVector v1 = m_particles.get(i).getPosition();
        PVector v2 = m_particles.get((i+1)%(count-1)).getPosition();
        m_particles.get(i).applyForce(v1.sub(v2).normalize().mult(rotationScale));
      }
    }
 
    //右もしくは左方向に力を加える   
    for(int i = 0; i < count; ++i)
    {
      m_particles.get(i).applyForce(force);
    } 
  }
  private void m_jump()
  { 
    final int count = size();
    final PVector force = new PVector(0.0, -100.0*inverse);
    for(int i = 0; i < count; ++i)
    {   
      m_particles.get(i).applyForce(force);
    }
  }
  
  //各パーティクルが何かしらの物体と衝突した場合、呼び出す
  void collidedWithSomething()
  {
    m_isCollided = true;
  }
  
  void inverseDirectionOfMovement()
  {
    inverse *= -1;
  }
  void enableManipulation(boolean enable)
  {
    m_enableManipulation = enable;
  }
  
  void update()
  {   
    if(m_enableManipulation)
    {
      if(KeyState.pressed("a"))
      { 
        m_moveX(true);
      }
      if(KeyState.pressed("d"))
      {  
        m_moveX(false);
      }
      if(KeyState.pressed("w"))
      {
        //ジャンプ中でない、かつ何かしらの物体に衝突している場合、ジャンプのモーションをスタート
        if(m_isCollided && m_jumpping == false)
        { 
          m_jumpping = true;
        }
      }
    }
    
    if(m_jumpping == true)
    {
        m_jump();
        ++m_jumpFrame;
    }
    
    if(m_isJumpEnded())
    {
      m_jumpping = false;
      m_jumpFrame = 0;
    }
    
    m_isCollided = false;    
  }
}
