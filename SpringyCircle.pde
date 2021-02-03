class SpringyCircleCollisionInfo
{
  PParticleSystem particleSystem;
  PCircle collidedParticle;  
  
  SpringyCircleCollisionInfo(PParticleSystem particleSystem, PCircle collidedParticle)
  {
    this.particleSystem = particleSystem;
    this.collidedParticle = collidedParticle;
  }
}

class SpringyCircle 
  extends GameDrawableObject
{
  protected PParticleSystem m_particleSystem;
  private PCircle m_centerCircle;
  float m_radius;
  
  private void m_initializeProperties(PParticleSystem particleSystem)
  {
    m_particleSystem = particleSystem;
  }

  private void m_constructSpringyCircle(int lod, float radius, float particleRadius, PVector initialPosition)
  {
    final float da    = TWO_PI/float(lod);
    final float clen  = TWO_PI*radius;
    final float dclen = clen/float(lod);

    final float frequency    = 2.0;
    final float dampingRatio = 1.0;
    final float friction     = 0.99;
    final float restitution  = 0.3;
    final float density      = 100.0;
    
    m_radius = radius;
    
    m_particleSystem.reset();

    //r=radiusの極座標上にPCircleを配置
    for (int i = 0; i < lod; ++i)
    {
      float a = da*float(i);
      PVector offset = (new PVector(cos(a), sin(a))).mult(radius);
      PCircle particle = new PCircle(particleRadius, BodyType.DYNAMIC, initialPosition.add(offset), friction, restitution, density);
      m_particleSystem.add(particle);
      particle.setUserData(new SpringyCircleCollisionInfo(m_particleSystem, particle));
    }

    //中心に存在するPCircleと各PCircleの間にDistanceJointの関係を生成する
    m_centerCircle = new PCircle(particleRadius, BodyType.DYNAMIC, initialPosition, 0.0, 0.3, 1.0);
    int count = m_particleSystem.size();
    for (int i = 0; i < count; ++i)
    {
      m_particleSystem.get(i).makeDistanceJointWith(m_centerCircle, radius, frequency, dampingRatio);
    }

    //隣接するPCircle同士の間にDistanceJointの関係を生成する
    for (int i = 1; i <= lod; ++i)
    {
      int nearestCircleIndex = (i-1)%lod;
      PhysicallySimulatedObject particle0 = m_particleSystem.get(i%lod);
      PhysicallySimulatedObject particle1 = m_particleSystem.get(nearestCircleIndex);
      float arcLength = dclen-particleRadius;

      particle0.makeDistanceJointWith(particle1, arcLength, frequency, dampingRatio);
    }

    //対面するPCircle同士の間にDistanceJointの関係を生成する
    for (int i = 0; i < lod; ++i)
    {
      int facedCircleIndex = (i+(lod/2-1))%lod;
      PhysicallySimulatedObject particle0 = m_particleSystem.get(i);
      PhysicallySimulatedObject particle1 = m_particleSystem.get(facedCircleIndex);
      float diameter = radius*2.0;

      particle0.makeDistanceJointWith(particle1, diameter, frequency, dampingRatio);
    }
  }

  float getRadius()
  {
    return m_radius;
  }

  PVector getPosition()
  {
    return m_centerCircle.getPosition();
  }

  public SpringyCircle(int lod, float radius, float particleRadius, PParticleSystem particleSystem, Material material, PVector initialPosition)
  { 
    super(material);
    m_initializeProperties(particleSystem);
    m_constructSpringyCircle(lod, radius, particleRadius, initialPosition);
  }
  public SpringyCircle(int lod, float radius, float particleRadius, PParticleSystem particleSystem, PVector initialPosition)
  {
    super();
    m_initializeProperties(particleSystem);
    m_constructSpringyCircle(lod, radius, particleRadius, initialPosition);
  }

  public void update()
  {
    m_particleSystem.update();
  }
  
  public void draw_(Material material)
  {
    pushMatrix();
    material.apply();
    beginShape(); 
    int count = m_particleSystem.size();
    for (int i = 0; i < count; ++i)
    {
      PhysicallySimulatedObject particle = m_particleSystem.get(i);
      PVector position = particle.getPosition();
      vertex(position.x, position.y);
    }   
    endShape(CLOSE);
    material.cancel();
    popMatrix();
  }
  public void draw_(PGraphics context, Material material)
  {
    context.pushMatrix();
    material.apply(context);
    context.beginShape(); 
    int count = m_particleSystem.size();
    for (int i = 0; i < count; ++i)
    {
      PhysicallySimulatedObject particle = m_particleSystem.get(i);
      PVector position = particle.getPosition();
      context.vertex(position.x, position.y);
    }   
    context.endShape(CLOSE);
    material.cancel();
    context.popMatrix();
  }
  public void draw_()
  {
    draw_(m_material);
  }
  public void draw_(PGraphics context)
  {
    draw_(context, m_material);
  }

}
