static PolygonShape createPBoxShape(float w, float h)
{
  Box2DProcessing box2d = System.getBox2DContext();
  float box2dWidth  = box2d.scalarPixelsToWorld(w/2.0);
  float box2dHeight = box2d.scalarPixelsToWorld(h/2.0);
  
  PolygonShape shape = new PolygonShape();
  shape.setAsBox(box2dWidth, box2dHeight);

  return shape;
}

class PBox 
  extends PhysicallySimulatedObject
  implements IMaterialGetter, IMaterialSetter
{  
  private float m_w;
  private float m_h;
 
  
  
  private void m_initializeProperties(float w, float h)
  {
    m_w = w;
    m_h = h;
  }

  
  
  public PBox()
  {
    super();
  }
  public PBox(float w, float h, BodyType bodyType, PVector initialPosition, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPBoxShape(w, h), density), initialPosition);
    m_initializeProperties(w, h);
  }
  public PBox(float w, float h, BodyType bodyType, Material material, PVector initialPosition, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPBoxShape(w, h), density), material, initialPosition);
    m_initializeProperties(w, h);
  }
  public PBox(float w, float h, BodyType bodyType, PVector initialPosition, float friction, float restitution, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPBoxShape(w, h), friction, restitution, density), initialPosition);
    m_initializeProperties(w, h);
  }
  public PBox(float w, float h, BodyType bodyType, Material material, PVector initialPosition, float friction, float restitution, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPBoxShape(w, h), friction, restitution, density), material, initialPosition);
    m_initializeProperties(w, h);
  }
  public PBox(float w, float h, BodyType bodyType, Material material, PVector initialPosition)
  {
    super(bodyType, makeFixtureDefDescriptor(createPBoxShape(w, h)), material, initialPosition);
    m_initializeProperties(w, h);
  }
  public PBox(float w, float h, BodyType bodyType, PVector initialPosition)
  {
    super(bodyType, makeFixtureDefDescriptor(createPBoxShape(w, h)), initialPosition);
    m_initializeProperties(w, h);
  }
  
  
  
  public void setMaterial(Material material)
  {
    this.m_material = material;
  }
  public Material getMaterialCopy()
  {
    return m_material.clone();
  }
  
  
  
  public void updateWidth(float w)
  {
    this.updateSize(w, m_h);
  }
  public void updateHeight(float h)
  {
    this.updateSize(m_w, h);
  }
  public void updateSize(float w, float h)
  {
    m_w = w;
    m_h = h;
    
    m_updateBodyShape(createPBoxShape(w, h));
  }
  
  
  
  public float getWidth()
  {
    return m_w;
  }
  public float getHeight()
  {
    return m_h;
  }
  
  
  public void draw_(Material material)
  {
    PVector position = this.getPosition();
    float angle   = this.getAngle();
 
    pushMatrix();
      translate(position.x, position.y);
      rotate(-angle);
      material.apply();
      rectMode(CENTER);
      rect(0, 0, m_w, m_h);
      material.cancel();
    popMatrix();
  }
  public void draw_(PGraphics context, Material material)
  {
    PVector position = this.getPosition();
    float angle   = this.getAngle();
 
    context.pushMatrix();
      context.translate(position.x, position.y);
      context.rotate(-angle);
      material.apply(context);
      context.rectMode(CENTER);
      context.rect(0, 0, m_w, m_h);
      material.cancel(context);
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
