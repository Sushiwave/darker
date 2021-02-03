float overPhase0BlankTime = 2.0;
float overPhase2BlankTime = 1.0;
float overPhase1Length = 2.0;
float overPhase2Length = 1.5;
float overPhase3Length = 1.0;
float overPhase4Length = 4.0;

float overPhase0 = overPhase0BlankTime;
float overPhase1 = overPhase0+overPhase1Length;
float overPhase2 = overPhase1+overPhase2Length+overPhase2Length;
float overPhase3 = overPhase2+overPhase3Length;
float overPhase4 = overPhase3+overPhase4Length;



void gameOverProcess()
{
    postProcessing.set("enabledNoise",     true);
    postProcessing.set("enabledSinNoise",  true);
    postProcessing.set("enabledCellNoise", true);
    
    float t = timerGameOver.getElapsedTimeSec();
    
    float noiseScale     = 0.0;
    float lightScale     = 1.0;
    float saturation     = 0.0;
    float sandstorm      = 0.0;
    float caInterval     = 0.0;
    float cellnoiseScale = 0.0;

    if ( t <= overPhase1 )
    {
      float v = 1.0-calcSectionCurrentTime01(t, overPhase0, overPhase1Length);
      
      noiseScale     = v*0.005;
      saturation     = 1.0+v*2.0;
      cellnoiseScale = v*0.5;
      sandstorm      = v*0.5;
      caInterval     = v*0.02;
    }
    else if ( t <= overPhase2 )
    {
      float v = 1.0-calcSectionCurrentTime01(t, overPhase1, overPhase2Length);
      
      noiseScale     = v*0.2+0.005;
      saturation     = 3.0;
      sandstorm      = v*0.5+0.5;
      cellnoiseScale = 0.5+0.5*v;
      caInterval     = v*0.005+0.02;
    } 
    else if ( t <= overPhase3 )
    {
      float v = 1.0-calcSectionCurrentTime01(t, overPhase2, overPhase3Length);
      
      float flashOut = v;
      
      lightScale     = 1.0-v;
      noiseScale     = 0.305;
      caInterval     = 0.025;
      saturation     = 3.0;
      cellnoiseScale = 1.0;
      sandstorm      = 1.0;
      
      postProcessing.set("flashOut", flashOut);
      postProcessing.set("flashOutColor", 1.0, 1.0, 1.0);
    }
    else
    { 
      noiseScale = 0.0025;
      caInterval = 0.01;
      saturation = 1.0;
      lightScale = 0.0;
      
      textAlpha = 1.0-calcSectionCurrentTime01(t, overPhase3, overPhase4Length);
      
      postProcessing.set("flashOut", 0.0);
      postProcessing.set("inversed", false);
      postProcessing.set("enabledSinNoise", false);
      postProcessing.set("enabledCellNoise", false);
      postProcessing.set("lightPosition", 0.5, 0.5);
      postProcessing.set("enabledShadow", false);
  
      gameOverTextDisplaying = true;
      
      if(KeyState.pressed("r"))
      {
        restarting = true; 
        timerRestart.start();
      }
    }
    
    postProcessing.set("noiseScale", noiseScale+noise*0.305);
    postProcessing.set("caInterval", 0.01+caInterval+noise*0.24);
    postProcessing.set("saturationScale", saturation+noise*2.0);
    postProcessing.set("lightScale", lightScale);
    postProcessing.set("sandstormScale", sandstorm+noise);
    postProcessing.set("cellnoiseScale", cellnoiseScale+noise);
    postProcessing.set("enabledShadow", true);
}
