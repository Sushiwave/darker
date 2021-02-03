void startProcess()
{
  float t = timerStart.getElapsedTimeSec();
  
  float fadeInOut = 1.0;
  
  float time1 = 3.0;
  float time2 = 3.0;
  float time3 = 3.0;
  if ( t <= time1+2.0 )
  {
    t = min(t-2.0, time1);
    float v = min(1.0, max(0.0, 1.0-(time1-t)/time1));
    fadeInOut = v;
  }
  else if(t <= time1+time2+2.0+1.0)
  {
    t = min(t-time1-2.0-1.0, time2);
    float v = min(1.0, max(0.0, 1.0-(time2-t)/time2));
    textAlpha = v;
  }
  else if(t <= time1+time2+time3+2.0+1.0)
  {
    t = min(t-time1-time2-2.0-1.0, time3);
    float v = min(1.0, max(0.0, (time3-t)/time3));
    textAlpha = v;
  }
  postProcessing.set("fadeInOut", fadeInOut);
  
  if( t >= time1 )
  {
    postProcessing.set("fadeInOut", 1.0);
  }
  
  if(t >= time1+time2+time3+2.0)
  {
    starting = false;
  }
}
