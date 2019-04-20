import java.util.LinkedList;
import java.util.Collections;

interface MovementRule {
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle);
}

class SugarSeekingMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public SugarSeekingMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    for (Square s : neighborhood) {
      if (s.getSugar() > retval.getSugar() ||
          (s.getSugar() == retval.getSugar() && 
           g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle)
          )
         ) {
        retval = s;
      } 
    }
    return retval;
  }
}

class PollutionMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public PollutionMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    boolean bestSquareHasNoPollution = (retval.getPollution() == 0);
    for (Square s : neighborhood) {
      boolean newSquareCloser = (g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle));
      if (s.getPollution() == 0) {
        if (!bestSquareHasNoPollution || s.getSugar() > retval.getSugar() ||
            (s.getSugar() == retval.getSugar() && newSquareCloser)
           ) {
          retval = s;
        }
      }
      else if (!bestSquareHasNoPollution) { 
        float newRatio = s.getSugar()*1.0/s.getPollution();
        float curRatio = retval.getSugar()*1.0/retval.getPollution();
        if (newRatio > curRatio || (newRatio == curRatio && newSquareCloser)) {
          retval = s;
        }
      }
    }
    return retval;
  }
}

class CombatMovementRule extends SugarSeekingMovementRule {
  int alpha;
  public boolean test() {
    return true;
  }
  /* Initializes a new CombatMovementRule with the specified value of alpha.
  *
  */
  public CombatMovementRule(int alpha) {
    this.alpha = alpha;
  }
  
  /* Moves the Agent according to the following rules.
  *    completed by findTargets
  * 1. Remove from neighbourhood any Square containing an Agent of the same tribe as the Agent on the middle Square.
  * 2. Remove from neighbourhood any Square containing an Agent that has at least as much sugar a the agent on the middle square.
  * 3. For each remaining Square in neighbourhood that contains an Agent, get the vision that the Agent on middle would have if it moved to that Square. If the vision contains any Agent with more sugar than the Agent on middle, and the opposite tribe, then remove the Square in question from neighbourhood.
  *    completed by calculateBestMove
  * 4. Replace each Square in neighbourhood that still has an Agent with a new Square that has the same x and y coordinates, but a Sugar and MaximumSugar level that are increased by the minimum of alpha and the sugar level of the occupying agent.
  * 5. Call the superclass movement method on what's left of neighbourhood, and, if necessary, determine which original square corresponded to a replacement square (if that's what was returned). The original and replacement squares will have the same x and y coordinates. Store the result (which must be one of the original squares in neighbourhood) in target.
  *    completed by fight
  * 6. If target is not occupied, just return target.
  * 7. Otherwise, store the occupying agent as casualty.
  * 8. Remove casualty from its Square.
  * 9. Increase the wealth of this agent by the minimum of casualty's sugarlevel  and alpha
  * 10. Call the SugarGrid's killAgent() method on casualty.
  * 11. Return target.
  *
  */
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    neighbourhood = findTargets(neighbourhood, g, middle);
    Square target = calculateBestMove(neighbourhood, g, middle);
    if (target != null && target.getAgent() != null) { fight(middle.getAgent(), target, g); }
    return target; //stubbed
  }
  
  /* Eliminates the squares that contain agents of the same tribe or stronger then our agent. 
  *  Also removes squares that would put the middle agent in vision of these opposed agents.
  *
  */
  public LinkedList<Square> findTargets(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    LinkedList<Square> toRemove = new LinkedList<Square>();
    Agent a  = middle.getAgent();
    for (Square s : neighbourhood) {
      if (s.getAgent() != null) {
        if (s.getAgent() == a ||
             s.getAgent().getTribe() == a.getTribe() ||
              s.getAgent().getSugarLevel() >= a.getSugarLevel()) { 
                toRemove.add(s); 
        }
      }
    }
    for (Square s : toRemove) { neighbourhood.remove(s); } toRemove.clear();
    for (Square moveTo : neighbourhood) {
      LinkedList<Square> nextVis = g.generateVision(moveTo.getX(), moveTo.getY(), a.getVision());
      for (Square otherA : nextVis) {
        if (otherA.getAgent() != null && 
             otherA.getAgent().getTribe() != a.getTribe() && 
              otherA.getAgent().getSugarLevel() > a.getSugarLevel()) {
                toRemove.add(moveTo);
                continue;
        }
      }
    }
    for (Square s : toRemove) { neighbourhood.remove(s); } toRemove.clear();
    return neighbourhood;
  }
  
  /* Strips agents from neighbourhood replacing with empty squares then calls the superclass move method on them, then returns the original square.
  *
  */
  public Square calculateBestMove(LinkedList<Square> neighbourhood, SugarGrid g, Square middle) {
    LinkedList<Square> agentSquares = new LinkedList<Square>();
    for (Square s : neighbourhood) {
      if (s.getAgent() != null) {
        agentSquares.add(s);
      }
    }
    for (Square s : agentSquares) {
      Square emptySquare = new Square(s.getSugar()+alpha+s.getAgent().getSugarLevel(), s.getMaxSugar()+alpha+s.getAgent().getSugarLevel(), s.getX(), s.getY());
      neighbourhood.remove(s);
      neighbourhood.add(emptySquare);
    }
    Square target = super.move(neighbourhood, g, middle);
    for (Square s : agentSquares) {
      if (s.getX() == target.getX() && s.getY() == target.getY()) {
        target = s;
      }
    }
    return target; 
  }
  
  
  /* Kills the agent on target and rewards the murderer a or just returns target if it is not occupied
  *
  */
  public void fight(Agent a, Square target, SugarGrid g) {
    Agent casualty = target.getAgent();
    target.setAgent(null);
    a.setSugarLevel(a.getSugarLevel()+casualty.getSugarLevel()+alpha);
    g.killAgent(casualty);
  }
}

class SugarSeekingMovementRuleTester {
  public void test() {
    SugarSeekingMovementRule mr = new SugarSeekingMovementRule();
    //stubbed
  }
}

class PollutionMovementRuleTester {
  public void test() {
    PollutionMovementRule mr = new PollutionMovementRule();
    //stubbed
  }
}

class CombatMovementRuleTester {
  public void test() {
    //setup test environment
    //setup sugargrid 
    int alpha = 2;
    int beta = 1;
    int gamma = 1;
    int equator = 1;
    int numSquares = 4; 
    SeasonalGrowbackRule sgr = new SeasonalGrowbackRule(alpha, beta, gamma, equator, numSquares);
    HashMap<Character, Integer[]> childbearingOnset = new HashMap<Character, Integer[]>();
    Integer[] start = {0, 0}; 
    childbearingOnset.put('X', start); 
    childbearingOnset.put('Y', start);
    HashMap<Character,Integer[]> climactericOnset = new HashMap<Character, Integer[]>();
    Integer[] endX = {30, 40}; Integer[] endY = {40, 50}; 
    climactericOnset.put('X', endX); climactericOnset.put('Y', endY);
    rr = new ReplacementRule(50, 110, af);
    fr = new FertilityRule(childbearingOnset, climactericOnset);
    SugarGrid grid = new SugarGrid(5, 5, 1, sgr, rr, fr);
    //create and place agents
    MovementRule cmr = new CombatMovementRule(1000);
    Agent a = new Agent(1, 2, 1000, cmr);
    Agent b = new Agent(1, 2, 100, cmr);
    Agent c = new Agent(1, 2, 100, cmr);
    Agent d = new Agent(1, 2, 100, cmr);
    Agent e = new Agent(1, 2, 2000, cmr);
    Agent f = new Agent(1, 2, 100, cmr);
    Agent g = new Agent(1, 2, 2000, cmr);
    Agent h = new Agent(1, 2, 2000, cmr);
    boolean[] trueCulture  = {true, true, true, true, true, true, true, true, true, true, true}; 
    boolean[] falseCulture  = {false, false, false, false, false, false, false, false, false, false, false}; 
    a.setCulture(trueCulture);
    b.setCulture(falseCulture);
    c.setCulture(trueCulture);
    d.setCulture(falseCulture);
    e.setCulture(trueCulture);
    f.setCulture(falseCulture);
    g.setCulture(falseCulture);
    h.setCulture(falseCulture);
    grid.placeAgent(a, 2, 2);
    grid.placeAgent(b, 0, 2);
    grid.placeAgent(c, 4, 2);
    grid.placeAgent(d, 2, 0);
    grid.placeAgent(e, 0, 0);
    grid.placeAgent(f, 0, 4);
    grid.placeAgent(g, 4, 0);
    grid.placeAgent(h, 2, 4);
    //test move
    LinkedList<Square> neighbourhood = grid.generateVision(a.getSquare().getX(), a.getSquare().getY(), 2);
    Square target = cmr.move(neighbourhood, grid, a.getSquare());
    assert(target.getX() == 0 && target.getY() == 2 && target.getAgent() == null);
  }
}
