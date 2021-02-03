public BodyDef makeBodyDefDescriptor(PVector initialPosition, BodyType bodyType)
{
  BodyDef def = new BodyDef();
  def.type = bodyType;
  def.position.set(System.getBox2DContext().coordPixelsToWorld(initialPosition.x, initialPosition.y));

  return def;
}
public FixtureDef makeFixtureDefDescriptor(Shape shape, float friction, float restitution, float density)
{
  FixtureDef def = new FixtureDef();
  def.shape       = shape;
  def.friction    = friction;
  def.restitution = restitution;
  def.density     = density;
  
  return def;
}
public FixtureDef makeFixtureDefDescriptor(Shape shape, float density)
{
  FixtureDef def = new FixtureDef();
  def.shape   = shape;
  def.density = density;
  
  return def;
}
public FixtureDef makeFixtureDefDescriptor(Shape shape)
{
  FixtureDef def = new FixtureDef();
  def.shape = shape;

  return def;
}

  
  
abstract class PhysicallySimulatedObject  
  extends GameDrawableObject
{
  private Body m_body;

  
  
  private void m_destroyAllFixtureDefs()
  {
    Fixture fixture = m_body.getFixtureList();
    m_body.destroyFixture(fixture);
  }
  protected void m_updateBodyShape(Shape shape)
  {
    float friction    = this.getFriction();
    float restitution = this.getRestitution();
    float density     = this.getDensity();
    
    FixtureDef def = makeFixtureDefDescriptor(shape, friction, restitution, density);
    
    m_destroyAllFixtureDefs();
    
    m_body.createFixture(def);
  }
  protected Fixture m_getFixtureList()
  {
    return m_body.getFixtureList();
  }
  
  
  private void m_initializeProperties(BodyType bodyType, ArrayList<FixtureDef> fixtureDefs, PVector initialPosition)
  {
    BodyDef bodyDef = makeBodyDefDescriptor(initialPosition, bodyType);
    
    m_body = System.getBox2DContext().createBody(bodyDef);
    for(FixtureDef fixtureDef : fixtureDefs)
    {
      m_body.createFixture(fixtureDef);
    }
  }
  
  
  
  public PhysicallySimulatedObject()
  {
    super();
  }
  public PhysicallySimulatedObject(BodyType bodyType, FixtureDef fixtureDef, PVector initialPosition)
  {
    super();
    ArrayList<FixtureDef> fixtureDefs = new ArrayList();
    fixtureDefs.add(fixtureDef);
    m_initializeProperties(bodyType, fixtureDefs, initialPosition);
  }
  public PhysicallySimulatedObject(BodyType bodyType, FixtureDef fixtureDef, Material material, PVector initialPosition)
  {
    super(material);
    ArrayList<FixtureDef> fixtureDefs = new ArrayList();
    fixtureDefs.add(fixtureDef);
    m_initializeProperties(bodyType, fixtureDefs, initialPosition);
  }
  public PhysicallySimulatedObject(BodyType bodyType, ArrayList<FixtureDef> fixtureDefs, PVector initialPosition)
  {
    super();
    m_initializeProperties(bodyType, fixtureDefs, initialPosition);
  }
  public PhysicallySimulatedObject(BodyType bodyType, ArrayList<FixtureDef> fixtureDefs, Material material, PVector initialPosition)
  {
    super(material);
    m_initializeProperties(bodyType, fixtureDefs, initialPosition);
  }

  
  
  public PVector getPosition()
  {
    Box2DProcessing box2d = System.getBox2DContext();
    Vec2 v2 = box2d.getBodyPixelCoord(m_body);
    return new PVector(v2.x, v2.y);
  }
  public float getAngle()
  {
    return m_body.getAngle();
  }
  public float getFriction()
  {
    return m_body.getFixtureList().getFriction();
  }
  public float getRestitution()
  {
    return m_body.getFixtureList().getRestitution();
  }
  public float getDensity()
  {
    return m_body.getFixtureList().getDensity();
  }
  
  public void destroy()
  {
    System.getBox2DContext().destroyBody(m_body);
  }
  
  public DistanceJoint makeDistanceJointWith(PhysicallySimulatedObject object, float len, float frequency, float dampingRatio)
  {
    Box2DProcessing box2d = System.getBox2DContext();
    
    DistanceJointDef jointDef = new DistanceJointDef();
    jointDef.bodyA = object.m_body;
    jointDef.bodyB = this.m_body;
    jointDef.length = box2d.scalarPixelsToWorld(len);
    jointDef.frequencyHz = frequency;
    jointDef.dampingRatio = dampingRatio;
  
    return (DistanceJoint) box2d.world.createJoint(jointDef);
  }

  void applyForce(PVector force)
  {
    Box2DProcessing box2d = System.getBox2DContext();
    
    Vec2 p = m_body.getWorldCenter();
    Vec2 f = box2d.vectorPixelsToWorld(force);
    
    applyForce(f, p);
  }
  void applyForce(PVector force, PVector position)
  {
    Box2DProcessing box2d = System.getBox2DContext();
    
    Vec2 p = box2d.vectorPixelsToWorld(position);
    Vec2 f = box2d.vectorPixelsToWorld(force);
    
    m_body.applyForce(f, p);
  }
  void applyForce(Vec2 force)
  {
    applyForce(force, m_body.getWorldCenter());
  }
  void applyForce(Vec2 force, Vec2 position)
  {
    m_body.applyForce(force, position);
  }
  
  void setUserData()
  {
    m_body.setUserData(this);
  }
  void setUserData(Object object)
  {
    m_body.setUserData(object);
  }
  
  abstract void draw_();
  abstract void draw_(PGraphics context);
  abstract void draw_(Material material);
  abstract void draw_(PGraphics context, Material material);
}
