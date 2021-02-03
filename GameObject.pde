class GameObject
{
}



abstract class GameDrawableObject 
  extends GameObject 
  implements IDrawable
{
  protected Material m_material;
  
  public GameDrawableObject()
  {
    this.m_material = new DefaultMaterial(color(0.0), color(0.0));
  }
  public GameDrawableObject(Material material)
  {
    this.m_material = material;
  }
  
  abstract void draw_();
  abstract void draw_(PGraphics context);
}
