import java.util.Collections;
import java.util.Random;
import java.util.List;

class FertilityRule {
  private HashMap<Character, Integer[]> childbearingOnset;
  private HashMap<Character,Integer[]> climactericOnset;
  private HashMap<Agent, Integer> childbearingAge = new HashMap<Agent, Integer>();
  private HashMap<Agent, Integer> climactericAge = new HashMap<Agent, Integer>();
  private HashMap<Agent, Integer> sugarLevels = new HashMap<Agent, Integer>();
  
  /* Initializes a new FertilityRule with the specified ages for the start of the fertile 
  * and infertile periods for agents of each sex.
  */
   public FertilityRule(HashMap<Character, Integer[]> childbearingOnset, HashMap<Character,Integer[]> climactericOnset) {
    this.childbearingOnset = childbearingOnset;
    this.climactericOnset = climactericOnset;
  }
  
  /* Determines whether Agent a is fertile.  
  *  
  */
  public boolean isFertile(Agent a) {
    Integer[] minAges = childbearingOnset.get(a.getSex());
    Integer[] maxAges = climactericOnset.get(a.getSex());;
    if (a == null || a.isAlive() != true) {
      childbearingAge.remove(a);
      climactericAge.remove(a);
      return false;
    } else if (childbearingAge.containsKey(a) == false && climactericAge.containsKey(a) == false) {
      Random rand = new Random();
      int randAge = rand.nextInt((minAges[1] - minAges[0]) + 1) + minAges[0];
      childbearingAge.put(a, randAge);
      randAge = rand.nextInt((maxAges[1] - maxAges[0]) + 1) + maxAges[0];
      climactericAge.put(a, randAge);
      sugarLevels.put(a, a.getSugarLevel());
    } 
    int agentAge = a.getAge();
    if (agentAge < climactericAge.get(a) && agentAge >= childbearingAge.get(a) && a.getSugarLevel() >= sugarLevels.get(a)) {
      return true;
    } else {
      return false;
    }
  }
  
  /* Determines whether the two passed agents can form a breeding pair or not. 
  *  local is the radius 1 vision around agent a.
  *  
  */
  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local) {
    if (isFertile(a) == true && isFertile(b) == true && a.getSex() != b.getSex()) {
      boolean localB = false; boolean localEmpty = false;
      for (Square s : local) {
        if (s.getAgent() == b) { localB = true; } 
        if (s.getAgent() == null) { localEmpty = true; }
      }
      if (localB && localEmpty) {
        return true;
      }
    }
    return false;
  }
  /* Creates and places a new Agent that is the offspring of a and b.  A newly created Agent is nurtured by its two parents.
  *
  */
  public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal, SugarGrid grid) {
    if (!canBreed(a, b, aLocal)) {
      return null;
    } else {
      Random rand = new Random();
      int childMetab;
      int choose = rand.nextInt(1);
      if (choose == 0) { childMetab = a.getMetabolism(); } else { childMetab = b.getMetabolism(); } 
      int childVision;
      choose = rand.nextInt(1);
      if (choose == 0) { childVision = a.getVision(); } else { childVision = b.getVision(); } 
      MovementRule childMove = a.getMovementRule();
      Agent child = new Agent(childMetab, childVision, 0, childMove);
      a.gift(child, sugarLevels.get(a)/2);
      b.gift(child, sugarLevels.get(b)/2);
      LinkedList<Square> emptySquares = new LinkedList<Square>();
      for (Square s : aLocal) {
        if (s.getAgent() == null) {
          emptySquares.add(s);
        }
      }
      for (Square s : bLocal) {
        if (s.getAgent() == null) {
          emptySquares.add(s);
        }
      }
      Square randSquare = emptySquares.get(rand.nextInt(emptySquares.size()));
      grid.placeAgent(child, randSquare.getX(), randSquare.getY());
      child.nurture(a, b);
      return child;
    }
  }
}

class FertilityRuleTester {
  public void test() {
    int minMetabolism = 3;
    int maxMetabolism = 6;
    int minVision = 2;
    int maxVision = 4;
    int minInitialSugar = 5;
    int maxInitialSugar = 10;
    MovementRule mr = new PollutionMovementRule();
    
    //test constructor
    
    //test isFertile
    
    //test canBreed
    
    //test Breed
    
  }
}
