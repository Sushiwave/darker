static class KeyState
{
  private static HashMap<String, Boolean> stateDict = new HashMap<String, Boolean>();
  
  private KeyState()
  {
  }
  
  public static void update(String key_, Boolean pressed)
  {
    stateDict.put(key_, pressed);
  }
  
  public static Boolean pressed(String key_)
  {
    if(stateDict.containsKey(key_))
    {
      return stateDict.get(key_);
    }
    else
    {
      return false;
    }
  }
}

void keyPressed()
{
  switch(key)
  {
    case 'a':
      KeyState.update("a", true);
      break;
    case 'b':
      KeyState.update("b", true);
      break;
    case 'd':
      KeyState.update("d", true);
      break;
    case 'i':
      KeyState.update("i", true);
      break;
    case 'n':
      KeyState.update("n", true);
      break;
    case 'r':
      KeyState.update("r", true);
      break;
    case 'w':
      KeyState.update("w", true);
      break;
    case ESC:
      key = 0;
      KeyState.update("Escape", true);
      break;
  }
}
void keyReleased()
{
  switch(key)
  {
    case 'a':
      KeyState.update("a", false);
      break;
    case 'b':
      KeyState.update("b", false);
      break;
    case 'd':
      KeyState.update("d", false);
      break;
    case 'i':
      KeyState.update("i", false);
      break;
    case 'n':
      KeyState.update("n", false);
      break;
    case 'r':
      KeyState.update("r", false);
      break;
    case 'w':
      KeyState.update("w", false);
      break;
    case ESC:
      key = 0;
      KeyState.update("Escape", false);
      break;
  }
}
