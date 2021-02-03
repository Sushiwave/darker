float clearPhase0BlankTime = 2.0;
float clearPhase2BlankTime = 2.0;
float clearPhase1Length = 2.5;
float clearPhase2Length = 2.0;
float clearPhase3Length = 1.0;
float clearPhase4Length = 2.0;

float clearPhase0 = clearPhase0BlankTime;
float clearPhase1 = clearPhase0+clearPhase1Length;
float clearPhase2 = clearPhase1+clearPhase2Length+clearPhase2Length;
float clearPhase3 = clearPhase2+clearPhase3Length;
float clearPhase4 = clearPhase3+clearPhase4Length;


float calcSectionCurrentTime01(float globalTime, float sectionStartTime, float sectionLength)
{
  float localTime = min(globalTime-sectionStartTime, sectionLength);
  return min(1.0, max(0.0, (sectionLength-localTime)/sectionLength));
}


void gameClearProcess()
{
  float t = timerGameClear.getElapsedTimeSec();
  
  float noiseScale     = 0.0;
  float saturation     = 1.0;
  float sandstorm      = 0.0;
  float caInterval     = 0.0;
  float cellnoiseScale = 0.0;
  
  if(t <= clearPhase1)
  {
    float v = 1.0-calcSectionCurrentTime01(t, clearPhase0, clearPhase1Length);
    
    postProcessing.set("flashOut", v);
    postProcessing.set("flashOutColor", 0.0, 0.0, 0.0);
  }
  else if(t <= clearPhase2)
  {
    gameClearTextDisplaying = true;
   
    float v = calcSectionCurrentTime01(t, clearPhase1, clearPhase2Length);
    
    postProcessing.set("flashOut", v);
    
    noise = 0.0;
    
    postProcessing.set("enabledNoise",       true);
    postProcessing.set("enabledSinNoise",    true);
    postProcessing.set("enabledCellNoise",   true);
    postProcessing.set("inversed",           false);
    postProcessing.set("enabledShadow",      false);
    postProcessing.set("enabledLightEffect", false);
  }
  else if(t <= clearPhase3)
  {
    float v = 1.0-calcSectionCurrentTime01(t, clearPhase2, clearPhase3Length);
    
    noiseScale     = v*0.005;
    cellnoiseScale = v*0.5;
    sandstorm      = v*0.5;
    caInterval     = v*0.02;
  }
  else if(t <= clearPhase4)
  {
    float v = 1.0-calcSectionCurrentTime01(t, clearPhase3, clearPhase4Length);
    
    noiseScale     = v*0.2+0.005;
    saturation     = 1.0+v*2.0;
    sandstorm      = v*0.5+0.5;
    cellnoiseScale = 0.5+0.5*v;
    caInterval     = v*0.005+0.02;
  }
  else
  {
    noiseScale     = 0.305;
    caInterval     = 0.025;
    saturation     = 3.0;
    cellnoiseScale = 1.0;
    sandstorm      = 1.0;
  }
  
  postProcessing.set("noiseScale",      noiseScale+noise*0.305);
  postProcessing.set("caInterval",      0.01+caInterval+noise*0.24);
  postProcessing.set("saturationScale", saturation+noise*2.0);
  postProcessing.set("sandstormScale",  sandstorm+noise);
  postProcessing.set("cellnoiseScale",  cellnoiseScale+noise);
}
