SugarGrid myGrid;
Graph numAgentsGraph;
Graph cultureGraph;
Graph ageAvgGraph;
Graph wealthGraph;
Graph ageGraph;
CombatMovementRule mr;
AgentFactory af;
FertilityRule fr;
ReplacementRule rr;
String displayType = "dual";

void setup() { 
  /* Testing */
  (new SquareTester()).test();
  (new AgentTester()).test();
  //(new SugarGridTester()).test();  
  (new GrowbackRuleTester()).test();
  (new StackTester()).test();
  (new QueueTester()).test();
  (new ReplacementRuleTester()).test();
  (new SeasonalGrowbackRuleTester()).test();
  (new FertilityRuleTester()).test();
  (new CombatMovementRuleTester()).test();

  size(1200,800);
  background(128);
  
  int minMetabolism = 3;
  int maxMetabolism = 6;
  int minVision = 2;
  int maxVision = 4;
  int minInitialSugar = 5;
  int maxInitialSugar = 10;
  mr = new CombatMovementRule(50);
  af = new AgentFactory(minMetabolism, maxMetabolism, minVision, maxVision, 
                                     minInitialSugar, maxInitialSugar, mr);
                                     
  HashMap<Character, Integer[]> childbearingOnset = new HashMap<Character, Integer[]>();
  Integer[] start = {0, 0}; 
  childbearingOnset.put('X', start); 
  childbearingOnset.put('Y', start);
  HashMap<Character,Integer[]> climactericOnset = new HashMap<Character, Integer[]>();
  Integer[] endX = {20, 50}; Integer[] endY = {20, 80}; 
  climactericOnset.put('X', endX); climactericOnset.put('Y', endY);
  rr = new ReplacementRule(50, 110, af);
  fr = new FertilityRule(childbearingOnset, climactericOnset);

  int alpha = 2;
  int beta = 1;
  int gamma = 1;
  int equator = 1;
  int numSquares = 4; 
  SeasonalGrowbackRule sgr = new SeasonalGrowbackRule(alpha, beta, gamma, equator, numSquares);
  
  myGrid = new SugarGrid(40,40,20, sgr, rr, fr);
  myGrid.addSugarBlob(15,15,2,9);
  myGrid.addSugarBlob(35,25,2,8);
  myGrid.addSugarBlob(15,45,2,7);
  for (int i = 0; i < 750; i++) {
    Agent a = af.makeAgent();
    myGrid.addAgentAtRandom(a);
  }
  
  wealthGraph = new AverageAgentWealthTimeSeriesGraph(850, 25, 300, 150, 1000);
  ageAvgGraph = new AverageAgentAgeTimeSeriesGraph(850, 225, 300, 150, 110);
  cultureGraph = new PercentTrueCultureTimeSeriesGraph(850, 425, 300, 150);
  numAgentsGraph = new NumberOfAgentsTimeSeriesGraph(850, 625, 300, 150);
  frameRate(15);
}

void draw() {
  cultureGraph.update(myGrid);
  ageAvgGraph.update(myGrid);
  wealthGraph.update(myGrid);
  numAgentsGraph.update(myGrid);
  myGrid.update();
  //background(255);
  myGrid.display(displayType);
  if (key == 'c') {
    displayType = "culture";
  } else if (key == 's') {
    displayType = "sex";
  } else if (key == 'd') {
    displayType = "dual";
  } else if (key == 'f') {
    displayType = "fertility";
  }
} 
