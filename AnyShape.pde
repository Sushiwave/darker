public PolygonShape createPAnyShape(Vec2 vertices[])
{
  PolygonShape shape = new PolygonShape();
  shape.set(vertices, vertices.length);
  return shape;
}
public PolygonShape createPAnyShape(ArrayList<Vec2> vertices)
{
  return createPAnyShape(vertices.toArray(new Vec2[vertices.size()]));
}



class PAnyShape
  extends PhysicallySimulatedObject
  implements IMaterialGetter, IMaterialSetter
{
  public PAnyShape()
  {
    super();
  }
  public PAnyShape(ArrayList<Vec2> vertices, BodyType bodyType, PVector initialPosition, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices), density), initialPosition);
  }
  public PAnyShape(ArrayList<Vec2> vertices, BodyType bodyType, Material material, PVector initialPosition, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices), density), material, initialPosition);
  }
  public PAnyShape(ArrayList<Vec2> vertices, BodyType bodyType, PVector initialPosition, float friction, float restitution, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices), friction, restitution, density), initialPosition);
  }
  public PAnyShape(ArrayList<Vec2> vertices, BodyType bodyType, Material material, PVector initialPosition, float friction, float restitution, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices), friction, restitution, density), material, initialPosition);
  }
  public PAnyShape(ArrayList<Vec2> vertices, BodyType bodyType, Material material, PVector initialPosition)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices)), material, initialPosition);
  }
  public PAnyShape(ArrayList<Vec2> vertices, BodyType bodyType, PVector initialPosition)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices)), initialPosition);
  }
  public PAnyShape(Vec2 vertices[], BodyType bodyType, PVector initialPosition, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices), density), initialPosition);
  }
  public PAnyShape(Vec2 vertices[], BodyType bodyType, Material material, PVector initialPosition, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices), density), material, initialPosition);
  }
  public PAnyShape(Vec2 vertices[], BodyType bodyType, PVector initialPosition, float friction, float restitution, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices), friction, restitution, density), initialPosition);
  }
  public PAnyShape(Vec2 vertices[], BodyType bodyType, Material material, PVector initialPosition, float friction, float restitution, float density)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices), friction, restitution, density), material, initialPosition);
  }
  public PAnyShape(Vec2 vertices[], BodyType bodyType, Material material, PVector initialPosition)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices)), material, initialPosition);
  }
  public PAnyShape(Vec2 vertices[], BodyType bodyType, PVector initialPosition)
  {
    super(bodyType, makeFixtureDefDescriptor(createPAnyShape(vertices)), initialPosition);
  }
  public PAnyShape(BodyType bodyType, ArrayList<FixtureDef> fixtureDefs, PVector initialPosition)
  {
    super(bodyType, fixtureDefs, initialPosition);
  }
  public PAnyShape(BodyType bodyType, ArrayList<FixtureDef> fixtureDefs, Material material, PVector initialPosition)
  {
    super(bodyType, fixtureDefs, material, initialPosition);
  }
  
  
  
  public void setMaterial(Material material)
  {
    this.m_material = material;
  }
  public Material getMaterialCopy()
  {
    return m_material.clone();
  }
  
  
 
  public void draw_()
  {
    draw_(m_material);
  }
  public void draw_(PGraphics context)
  {
    draw_(context, m_material);
  }
  public void draw_(Material material)
  {
    PVector position      = this.getPosition();
    float angle           = this.getAngle();
    Fixture fixture       = (Fixture) this.m_getFixtureList();
    Box2DProcessing box2d = System.getBox2DContext();
    PolygonShape shape    = (PolygonShape) fixture.getShape();
    
    pushMatrix();
      translate(position.x, position.y);
      rotate(-angle);
      material.apply();
      while(shape != null)
      {
        beginShape();
          int vertexCount = shape.getVertexCount();
          for(int i = 0; i < vertexCount; ++i)
          {
            Vec2 v = box2d.vectorWorldToPixels(shape.getVertex(i));
            vertex(v.x, v.y);
          }
          shape = (PolygonShape) fixture.getNext().getShape();
        endShape(CLOSE);
      }
      material.cancel();
    popMatrix();
  }
  public void draw_(PGraphics context, Material material)
  {
    PVector position      = this.getPosition();
    float angle           = this.getAngle();
    Fixture fixture       = (Fixture) this.m_getFixtureList();
    Box2DProcessing box2d = System.getBox2DContext();
    PolygonShape shape    = (PolygonShape) fixture.getShape();
    
    context.pushMatrix();
      context.translate(position.x, position.y);
      context.rotate(-angle);
      material.apply(context);
      while(shape != null)
      {
        beginShape();
          int vertexCount = shape.getVertexCount();
          for(int i = 0; i < vertexCount; ++i)
          {
            Vec2 v = box2d.vectorWorldToPixels(shape.getVertex(i));
            context.vertex(v.x, v.y);
          }
          shape = (PolygonShape) fixture.getNext().getShape();
        endShape(CLOSE);
      }
      material.cancel();
    context.popMatrix();  
  }
}
