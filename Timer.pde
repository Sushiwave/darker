class Timer
{
  private float m_startTime = 0.0;
  private boolean m_running = false;
  
  private float m_seconds()
  {
    return millis()/1000.0;
  }
  
  void start()
  {
    if(m_running == false)
    {
      m_startTime = m_seconds();
      m_running = true;
    }
  }
  void reset()
  {
    m_running = false;
  }
  
  float getElapsedTimeSec()
  {
    if (m_running)
    {
      return m_seconds()-m_startTime; 
    }
    else
    {
      return 0.0;
    }
  }
}
