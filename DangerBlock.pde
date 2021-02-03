class DangerBlock
  extends BoundaryBox
{
  DangerBlock(float w, float h, PVector position)
  {
    super(w, h, position);
  }
  DangerBlock(float w, float h, PVector position, float density)
  {
    super(w, h, position, density);
  }
  DangerBlock(float w, float h, PVector position, float friction, float restitution, float density)
  {
    super(w, h, position, friction, restitution, density);
  }
}
