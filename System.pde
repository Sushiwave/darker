static class System
{
  private static Box2DProcessing box2DContext;
  
  private System()
  {
  }
  
  public static void changeBox2DContext(Box2DProcessing context)
  {
    box2DContext = context;
  }
  
  public static Box2DProcessing getBox2DContext()
  {
    return box2DContext;
  }
}
