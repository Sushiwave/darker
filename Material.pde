enum MaterialType
{
  defaultMaterial,
  shaderMaterial
}

abstract class Material 
  implements Cloneable
{
  private final MaterialType type;
  
  protected Material(MaterialType type)
  {
    this.type = type;
  }
  public MaterialType getType()
  {
    return type;
  }
   
  public abstract void apply();
  public abstract void apply(PGraphics context);
  public abstract void cancel();
  public abstract void cancel(PGraphics context);
  public abstract Material clone();
}

class ShaderMaterial
  extends Material
  implements Cloneable
{
  PShader m_shader;
  
  public ShaderMaterial(PShader shader)
  {
    super(MaterialType.shaderMaterial);
    m_shader = shader;
  }
  
  public Material clone()
  {
    Material material = new ShaderMaterial(this.m_shader);
    return material;
  }
  
  public PShader getShader()
  {
    return m_shader;
  }
  
  void apply()
  {
    shader(m_shader);
  }
  void apply(PGraphics context)
  {
    context.shader(m_shader);
  }
  void cancel()
  {
  }
  void cancel(PGraphics context)
  {
    context.resetShader();
  }
}

class DefaultMaterial 
  extends Material
  implements Cloneable
{ 
  public color bodyColor;
  public color edgeColor;
  public boolean stroke;
  
  private void m_initProperties(color bodyColor, color edgeColor, boolean stroke)
  {
    this.bodyColor = bodyColor;
    this.edgeColor = edgeColor;
    this.stroke    = stroke;
  }
 
  public DefaultMaterial()
  {
    super(MaterialType.defaultMaterial);
    
    color black = color(0.0, 0.0, 0.0);
    bodyColor = black;
    edgeColor = black;
  }
  public DefaultMaterial(color bodyColor)
  {
    super(MaterialType.defaultMaterial);
    m_initProperties(bodyColor, color(0.0), false);
  }
  public DefaultMaterial(color bodyColor, color edgeColor)
  {
    super(MaterialType.defaultMaterial);
    m_initProperties(bodyColor, edgeColor, true);
  }
  
  public Material clone()
  {
    Material material = new DefaultMaterial(this.bodyColor, this.edgeColor);
    return material;
  }
  
  void apply()
  {
    fill(bodyColor);
    if (stroke)
    {
      stroke(edgeColor);
    }
    else
    {
      noStroke();
    }
  }
  void apply(PGraphics context)
  {
    context.fill(bodyColor);
    if(stroke)
    {
      context.stroke(edgeColor);
    }
    else
    {
      context.noStroke();
    }
  }
  void cancel()
  {
  }
  void cancel(PGraphics context)
  {
  }
}
