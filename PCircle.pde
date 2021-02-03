public CircleShape createPCircleShape(float radius)
{
  Box2DProcessing box2d = System.getBox2DContext();
  float box2dRadius  = box2d.scalarPixelsToWorld(radius);
  CircleShape shape = new CircleShape();
  shape.m_radius = box2d.scalarPixelsToWorld(box2dRadius);
  
  return shape;
}



class PCircle
  extends PhysicallySimulatedObject  
  implements IMaterialGetter, IMaterialSetter
{
  float m_radius;
  
  
  
  private void m_initializeProperties(float radius)
  {
    m_radius = radius;
  }

  
  
  public PCircle()
  {
    super();
  }
  public PCircle(float radius, BodyType bodyType, PVector initialPosition, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPCircleShape(radius), density), initialPosition);
    m_initializeProperties(radius);
  }
  public PCircle(float radius, BodyType bodyType, Material material, PVector initialPosition, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPCircleShape(radius), density), material, initialPosition);
    m_initializeProperties(radius);
  }
  public PCircle(float radius, BodyType bodyType, PVector initialPosition, float friction, float restitution, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPCircleShape(radius), friction, restitution, density), initialPosition);
    m_initializeProperties(radius);
  }
  public PCircle(float radius, BodyType bodyType, Material material, PVector initialPosition, float friction, float restitution, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPCircleShape(radius), friction, restitution, density), material, initialPosition);
    m_initializeProperties(radius);
  }
  public PCircle(float radius, BodyType bodyType, Material material, PVector initialPosition)
  {
    super(bodyType, makeFixtureDefDescriptor(createPCircleShape(radius)), material, initialPosition);
    m_initializeProperties(radius);
  }
  public PCircle(float radius, BodyType bodyType, PVector initialPosition)
  {
    super(bodyType, makeFixtureDefDescriptor(createPCircleShape(radius)), initialPosition);
    m_initializeProperties(radius);
  }
  
  
  
  public void updateRadius(float radius)
  {
    m_radius = radius;
    m_updateBodyShape(createPCircleShape(radius));
  }
  
  
  
  public void setMaterial(Material material)
  {
    this.m_material = material;
  }
  public Material getMaterialCopy()
  {
    return m_material.clone();
  }
  
  
  
  public void draw_(Material material)
  {
    PVector position = this.getPosition();
    float angle      = this.getAngle();
    
    pushMatrix();
      translate(position.x, position.y-m_radius);
      rotate(-angle);
      material.apply();
      ellipse(0, 0, m_radius*2, m_radius*2);
      material.cancel();
    popMatrix();
  }
  public void draw_(PGraphics context, Material material)
  {
    PVector position = this.getPosition();
    float   angle    = this.getAngle();
    
    context.pushMatrix();
      context.translate(position.x, position.y-m_radius);
      context.rotate(-angle);
      material.apply(context);
      context.ellipse(0, 0, m_radius*2, m_radius*2);
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
