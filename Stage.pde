class Stage
  implements IDrawable
{
  private final int DEFAULT_BLOCK = 1;
  private final int DANGER_BLOCK  = 2;
      
  private ArrayList<BoundaryBox> m_boundaries;
  private BoundaryBox m_upperSideBlocker;
  private BoundaryBox m_lowerSideBlocker;
  private BoundaryBox m_startPointBlocker;
  private BoundaryBox m_endPointBlocker;
  private boolean m_isShaderTimeUpdatingStopped = false;
  private float w;
  private float h;
  
  private void m_generateStageFromStageFile(String filename, int w, int h)
  {
    final String lines[] = loadStrings(filename);
    m_boundaries = new ArrayList<BoundaryBox>();
    
    if(lines.length > 0)
    {
      final int elementCountX = lines[0].length();
      final int elementCountY = lines.length;
      final int elementCount = elementCountX*elementCountY;
      final float elementWidth  = w/float(elementCountX);
      final float elementHeight = h/float(elementCountY);
     
      ArrayList<Boolean> scanStatusList = new ArrayList(elementCount);
      for(int i = 0; i < elementCount; ++i)
      {
        scanStatusList.add(false);
      }
      
      for(int y = 0; y < elementCountY; ++y)
      {
        final String line = lines[y];
        for(int x = 0; x < elementCountX; ++x)
        {
          final int index         = x+y*elementCountX;
          final boolean scanned   = scanStatusList.get(index);
          if(scanned == false)
          {
            scanStatusList.set(index, true);
            
            final int boundaryBoxID = Character.getNumericValue(line.charAt(x));
            if(boundaryBoxID == 1 || boundaryBoxID == 7)
            {
               m_boundaries.add(m_generateBoundaryBox(lines, boundaryBoxID, x, y, elementCountX, elementCountY, elementWidth, elementHeight, scanStatusList));
            }
          }
        }
      }     
    }
  }
  private BoundaryBox m_generateBoundaryBox(String lines[], int boundaryBoxID, int offsetX, int offsetY, int elementCountX, int elementCountY, float elementWidth, float elementHeight, ArrayList<Boolean> scanStatusList)
  {
    int boundaryElementCountX = m_countBoundaryBoxElementCountX(boundaryBoxID, lines, offsetX, offsetY, elementCountX);
    int boundaryElementCountY = m_countBoundaryBoxElementCountY(boundaryBoxID, lines, offsetX, offsetY, elementCountY);
  
    //スキャン状態の更新
    for(int y = offsetY; y < offsetY+boundaryElementCountY; ++y)
    {
      for(int x = offsetX; x < offsetX+boundaryElementCountX; ++x)
      {
        int index = x+y*elementCountX;
        scanStatusList.set(index, true);
      }
    }
    
    final float boundaryWidth  = boundaryElementCountX*elementWidth;
    final float boundaryHeight = boundaryElementCountY*elementHeight;
    final PVector position = new PVector(offsetX*elementWidth+boundaryWidth*0.5, offsetY*elementHeight+boundaryHeight*0.5);
    return new BoundaryBox(boundaryWidth, boundaryHeight, position);
  }
  int m_countBoundaryBoxElementCountX(int boundaryBoxID, String lines[], int offsetX, int offsetY, int elementCountX)
  {
    int count = 0;
    String line = lines[offsetY];
    for(int x = offsetX; x < elementCountX; ++x)
    {
      int scannedID = Character.getNumericValue(line.charAt(x));
      if(boundaryBoxID == scannedID)
      {
        ++count;
      }
      else
      {
        break;
      }
    } 
    return count;
  }
  int m_countBoundaryBoxElementCountY(int boundaryBoxID, String lines[], int offsetX, int offsetY, int elementCountY)
  {
    int count = 0;
    for(int y = offsetY; y < elementCountY; ++y)
    {
      String line = lines[y];
      float scannedID = Character.getNumericValue(line.charAt(offsetX));
      if(boundaryBoxID == scannedID)
      {
        ++count;
      }
      else
      {
        break;
      }
    } 
    return count;
  }
  
  void m_attachMaterialToStage(String filename)
  {
    final String lines[] = loadStrings(filename);
    if(lines.length > 0)
    {
      int count = m_boundaries.size();
      String line = lines[0];
      for(int i = 0; i < count; ++i)
      {
        int blockType = Character.getNumericValue(line.charAt(i));
        BoundaryBox currentBB= m_boundaries.get(i);
        switch(blockType)
        {
        case DEFAULT_BLOCK:
          currentBB.setMaterial(new DefaultMaterial(color(0, 0, 0)));
          break;
        case DANGER_BLOCK:
          PShader shader = loadShader("Shader/DangerBlock.glsl");
          currentBB.setMaterial(new ShaderMaterial(shader));
          break;
        }
      }
    }
  }
  
  Stage(String stageFilename, String stageMaterialMapFilename, int w, int h)
  {
    this.w = w;
    this.h = h;
    float blockerWidth  = 200.0;
    float blockerHeight = h;
    m_startPointBlocker = new BoundaryBox(blockerWidth, blockerHeight, new PVector( -blockerWidth*0.5, blockerHeight*0.5));
    m_endPointBlocker   = new BoundaryBox(blockerWidth, blockerHeight, new PVector(w+blockerWidth*0.5, blockerHeight*0.5));
  
    blockerWidth  = w+blockerWidth*4.0;
    blockerHeight = 200.0;
    m_upperSideBlocker = new BoundaryBox(blockerWidth, blockerHeight, new PVector(blockerWidth*0.5,  -blockerHeight*0.5));
    m_lowerSideBlocker = new BoundaryBox(blockerWidth, blockerHeight, new PVector(blockerWidth*0.5, h+blockerHeight*0.5));
  
    m_generateStageFromStageFile(stageFilename, w, h);
    m_attachMaterialToStage(stageMaterialMapFilename);
  }

  float getHeight()
  {
    return h;
  }
  float getWidth()
  {
    return w;
  }
  
  void stopUpdatingShaderTime()
  {
    m_isShaderTimeUpdatingStopped = true;
  }
  void resumeUpdatingShaderTime()
  {
    m_isShaderTimeUpdatingStopped = false;
  }
  
  void m_updateShaderParameter(BoundaryBox bb)
  {
    float t = millis()/1000.0;
    Material material = bb.getMaterialCopy();
    if(material.getType() == MaterialType.shaderMaterial)
    {
      ShaderMaterial shaderMaterial = (ShaderMaterial)material;
      PShader shader = shaderMaterial.getShader();
      shader.set("reso", bb.getWidth(), bb.getHeight());
      if(m_isShaderTimeUpdatingStopped == false)
      {
        shader.set("time", t);
      }
    }
  }
  void draw_()
  {
    m_upperSideBlocker.draw_();
    m_lowerSideBlocker.draw_();
    m_startPointBlocker.draw_();
    m_endPointBlocker.draw_();
    for(BoundaryBox boundary : m_boundaries)
    {
      m_updateShaderParameter(boundary);
      boundary.draw_();
    }
  }
  void draw_(PGraphics context)
  {
    m_upperSideBlocker.draw_(context);
    m_lowerSideBlocker.draw_(context);
    m_startPointBlocker.draw_(context);
    m_endPointBlocker.draw_(context);
    for(BoundaryBox boundary : m_boundaries)
    {
      m_updateShaderParameter(boundary);
      boundary.draw_(context);
    }
  }
  void draw_(Material material)
  {
    m_upperSideBlocker.draw_(material);
    m_lowerSideBlocker.draw_(material);
    m_startPointBlocker.draw_(material);
    m_endPointBlocker.draw_(material);
    for(BoundaryBox boundary : m_boundaries)
    {
      boundary.draw_(material);
    }
  }
  void draw_(PGraphics context, Material material)
  {
    m_upperSideBlocker.draw_(context, material);
    m_lowerSideBlocker.draw_(context, material);
    m_startPointBlocker.draw_(context, material);
    m_endPointBlocker.draw_(context, material);
    for(BoundaryBox boundary : m_boundaries)
    {
      boundary.draw_(context, material);
    }
  }
}
