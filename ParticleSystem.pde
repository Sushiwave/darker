abstract class PParticleSystem
  implements IUpdatable, IDrawable
{
  protected ArrayList<PhysicallySimulatedObject> m_particles;
  
  PParticleSystem()
  {
    m_particles = new ArrayList();
  }
  
  void add(PhysicallySimulatedObject particle)
  {
    m_particles.add(particle);
  }
  PhysicallySimulatedObject get(int index)
  {
    return m_particles.get(index);
  }
  void reset()
  {
    m_particles.clear();
  }
  int size()
  {
    return m_particles.size();
  }
  
  void destroyAll()
  {
    for(PhysicallySimulatedObject particle : m_particles)
    {
      particle.destroy();
    }
  }
  
  void draw_()
  {
    for(PhysicallySimulatedObject particle : m_particles)
    {
      particle.draw_();
    }
  } 
  void draw_(PGraphics context)
  {
    for(PhysicallySimulatedObject particle : m_particles)
    {
      particle.draw_(context);
    }
  }
  void draw_(Material material)
  {
    for(PhysicallySimulatedObject particle : m_particles)
    {
      particle.draw_(material);
    }
  }
  void draw_(PGraphics context, Material material)
  {
    for(PhysicallySimulatedObject particle : m_particles)
    {
      particle.draw_(context, material);
    }
  }
 
  
  
  abstract void update();
}
