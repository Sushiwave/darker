void gameSetup()
{
  customFont = loadFont("Bahnschrift-48.vlw");
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  System.changeBox2DContext(box2d);
 
  timerInverse   = new Timer();
  timerGameOver  = new Timer();
  timerGameClear = new Timer();
  timerRestart   = new Timer();
  timerStart     = new Timer();
  
  noise = 0.0;
  
  mainPass = createGraphics(width, height, P2D);
  mainPass.noSmooth();
  shadowPass = createGraphics(width, height, P2D);
  shadowPass.noSmooth();
  result = createGraphics(width, height, P2D);
  result.noSmooth();
  
  thinkingFaceImage = loadImage("Resource/ThinkingFace.png");
  
  
  postProcessing = loadShader("Shader/PostProcessing.glsl");
  postProcessing.set("shadowMap", shadowPass);
  
  stage = new Stage("Stage.txt", "StageMaterial.txt", width*5, height);
}
