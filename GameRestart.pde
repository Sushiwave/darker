void restartProcess()
{
  float t = timerRestart.getElapsedTimeSec();
  
  float fadeInOut = 0.0;
  
  float time1 = 4.0;
  if ( t <= time1 )
  {
    t = min(t, time1);
    float v = min(1.0, max(0.0, (time1-t)/time1));
    fadeInOut = v;
  }
  
  postProcessing.set("fadeInOut", fadeInOut);
  
  if (t >= time1)
  {
    restarting = false;
    noise = min(noise+0.005, 1.0);
    gameReset();
  }
}
