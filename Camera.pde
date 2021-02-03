class Camera
{
  public PVector lookAt;
  public PVector zoom;
  public float   angle;

  
  
  private void m_initializeProperties(PVector lookAt, PVector zoom, float angle)
  {
    this.lookAt = lookAt;
    this.zoom   = zoom;
    this.angle  = angle;
  }
  
  
  
  Camera()
  {
    m_initializeProperties(new PVector(width*0.5, height*0.5), new PVector(1.0, 1.0), 0.0);
  }
  Camera(PVector lookAt, PVector zoom, float angle)
  {
    m_initializeProperties(lookAt, zoom, angle);
  }
  
  
  
  PMatrix2D createMatrix()
  {
    PMatrix2D mat = new PMatrix2D();
    mat.set(1.0, 0.0, width*0.5,
            0.0, 1.0, height*0.5);
    mat.rotate(-angle);
    mat.scale(zoom.x, zoom.y);
    mat.translate(-lookAt.x, -lookAt.y);
    
    return mat;
  }
  
  
  
  void setToPipeline()
  {
    setMatrix(createMatrix());
  }
  void setToPipeline(PGraphics context)
  {
    context.setMatrix(createMatrix());
  }
}
