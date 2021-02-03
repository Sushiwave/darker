class BoundaryBox
  extends PBox
{
  private PVector m_bottomLeft;
  private PVector m_topRight;
   
  void m_initProperties(float w, float h, PVector position)
  {
    m_bottomLeft = new PVector(position.x-w*0.5, position.y+h*0.5);
    m_topRight   = new PVector(position.x+w*0.5, position.y-h*0.5);
  }
 
  BoundaryBox(float w, float h, PVector position)
  {
    super(w, h, BodyType.STATIC, position);
    m_initProperties(w, h, position);
    setUserData(this);
  }
  BoundaryBox(float w, float h, PVector position, float density)
  {
    super(w, h, BodyType.STATIC, position, density);
    m_initProperties(w, h, position);
    setUserData(this);
  }
  BoundaryBox(float w, float h, PVector position, float friction, float restitution, float density)
  {
    super(w, h, BodyType.STATIC, position, friction, restitution, density);
    m_initProperties(w, h, position);
    setUserData(this);
  }
  
  BoundaryBox(float w, float h, Material material, PVector position)
  {
    super(w, h, BodyType.STATIC, material, position);
    m_initProperties(w, h, position);
    setUserData(this);
  }
  BoundaryBox(float w, float h, Material material, PVector position, float density)
  {
    super(w, h, BodyType.STATIC, material, position, density);
    m_initProperties(w, h, position);
    setUserData(this);
  }
  BoundaryBox(float w, float h, Material material, PVector position, float friction, float restitution, float density)
  {
    super(w, h, BodyType.STATIC, material, position, friction, restitution, density);
    m_initProperties(w, h, position);
    setUserData(this);
  }
  
  PVector getBottomLeft()
  {
    return m_bottomLeft;
  }
  PVector getTopRight()
  {
    return m_topRight;
  }
}
