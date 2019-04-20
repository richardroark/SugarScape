import java.lang.Math;

class Agent {
  public static final int NOLIFESPAN = -999;
  private int metabolism;
  private int vision;
  private int sugarLevel;
  private MovementRule movementRule;
  private char sex;
  private int age;
  private int lifespan;
  private Square square;
  private  boolean[] culture;

  
  /* initializes a new Agent with the specified values for its 
  *  metabolism, vision, stored sugar, movement rule, and a uniformly random sex.
  *
  */
  public Agent(int metabolism, int vision, int initialSugar, MovementRule m) {
    this.metabolism = metabolism;
    this.vision = vision;
    this.sugarLevel = initialSugar;
    this.movementRule = m;
    Random rand = new Random();
    int randomSex = rand.nextInt(2);
    if (randomSex == 0) {
      this.sex = 'X';  
    } else if (randomSex == 1) {
      this.sex = 'Y';
    }
    age = 0;
    lifespan = NOLIFESPAN;
    square = null;
    culture = new boolean[11];
    for (int i = 0; i < 11; i++){
      boolean randBool;
      if (rand.nextInt(2) == 0) { randBool = true; } else { randBool = false; }
      culture[i] = randBool;
    }
  }
  /* initializes a new Agent with the specified values for its 
  *  metabolism, vision, stored sugar, movement rule, and passed sex.
  *
  */
  public Agent(int metabolism, int vision, int initialSugar, MovementRule m, char sex) {
    this.metabolism = metabolism;
    this.vision = vision;
    this.sugarLevel = initialSugar;
    this.movementRule = m;
    if (sex != 'X' && sex != 'Y') {
      assert(0 == 1);
    }
    this.sex = sex;
    age = 0;
    lifespan = NOLIFESPAN;
    square = null;
    culture = new boolean[11];
    Random rand = new Random();
    for (int i = 0; i < 11; i++){
      boolean randBool;
      if (rand.nextInt(2) == 0) { randBool = true; } else { randBool = false; }
      culture[i] = randBool;
    }
  }
  
  /* returns the amount of food the agent needs to eat each turn to survive. 
  *
  */
  public int getMetabolism() {
    return metabolism; 
  } 
  
  /* returns the agent's vision radius.
  *
  */
  public int getVision() {
    return vision; 
  } 
  
  /* returns the amount of stored sugar the agent has right now.
  *
  */
  public int getSugarLevel() {
    return sugarLevel; 
  } 
  
  /* returns the amount of stored sugar the agent has right now.
  *
  */
  public void setSugarLevel(int sugarLevel) {
    this.sugarLevel = sugarLevel;
  } 
  
  /* returns the Agent's movement rule.
  *
  */
  public MovementRule getMovementRule() {
    return movementRule; 
  } 
  
  /* returns the Agent's movement rule.
  *
  */
  public char getSex() {
    return sex;
  }
  
  /* returns the Agent's age.
  *
  */
  public int getAge() {
    return age; 
  } 
  
  /* sets the Agent's age.
  *
  */
  public void setAge(int howOld) {
    assert(howOld >= 0);
    this.age = howOld; 
  } 
  
  /* returns the Agent's lifespan.
  *
  */
  public int getLifespan() {
    return lifespan; 
  } 
  
  /* sets the Agent's lifespan.
  *
  */
  public void setLifespan(int span) {
    assert(span >= 0);
    this.lifespan = span; 
  } 
  
  /* returns the Square occupied by the Agent.
  *
  */
  public Square getSquare() {
    return square; 
  } 
  
  /* sets the the Square occupied by the Agent.
  *
  */
  public void setSquare(Square s) {
    this.square = s; 
  } 
  
  /* sets the culture of the Agent.
  *
  */
  public void setCulture(boolean[] newCulture) {
    culture = newCulture; 
  } 
  
  /* gets the culture of the Agent.
  *
  */
  public boolean[] getCulture() {
    return culture; 
  } 
  
  /* If other's culture does not match this Agent's culture in the randomly selected cultural attribute, then mutate other's culture to match the culture of this agent.
  *
  */
  public void influence(Agent other) {
    Random rand = new Random();
    int randAttribute = rand.nextInt(12); 
    if (this.culture[randAttribute] != other.culture[randAttribute]) {  
      other.culture[randAttribute] = this.culture[randAttribute];
      println("One of us, one of us. Gooba-gobble, gooba-gobble");
    }
  } 
  /* For each of the 11 dimensions of culture, set this Agent's value for that dimension to be one of the two parent values, selected uniformly at random.
  *
  */  
  public void nurture(Agent parent1, Agent parent2) {
    Random rand = new Random(); int randParent;
    for (int i = 0; i < 11; i++) {
      randParent = rand.nextInt(2); 
      if (randParent == 0) {
        this.culture[i] = parent1.culture[i];
      } else {
        this.culture[i] = parent2.culture[i];
      }
    }
  }
  
  /* Returns true only if this Agent's culture contains more true values than false values. Otherwise returns false. 
  *
  */
  public boolean getTribe() {
    int numTrue = 0;
    for (int i = 0; i < 11; i++) {
      if (culture[i] == true) { numTrue++; }
    }
    if (numTrue > 5) {
      return true;
    } else { return false; }
  }
  
  /* Provided that this agent has at least amount sugar, transfers that amount from this agent to the other agent. 
  *  Otherwise throws an assertion error.
  *
  */
  public void gift(Agent other, int amount) {
    assert(this.getSugarLevel() >= amount);
    this.setSugarLevel(this.getSugarLevel() - amount);
    other.setSugarLevel(amount);
  }
  
  /* Moves the agent from source to destination. 
  *  If the destination is already occupied, the program should crash with an assertion error
  *  instead, unless the destination is the same as the source.
  *
  */
  public void move(Square source, Square destination) {
    // make sure this agent occupies the source
    assert(this == source.getAgent());
    if (!destination.equals(source)) { 
      assert(destination.getAgent() == null);
      source.setAgent(null);
      destination.setAgent(this);
    }
  } 
  
  /* Reduces the agent's stored sugar level by its metabolic rate, to a minimum value of 0.
  *
  */
  public void step() {
    sugarLevel = Math.max(0, sugarLevel - metabolism); 
    age += 1;
  } 
  
  /* returns true if the agent's stored sugar level is greater than 0, false otherwise. 
  * 
  */
  public boolean isAlive() {
    return (sugarLevel > 0);
  } 
  
  /* The agent eats all the sugar at Square s. 
  *  The agent's sugar level is increased by that amount, and 
  *  the amount of sugar on the square is set to 0.
  *
  */
  public void eat(Square s) {
    if (s != null) { sugarLevel += s.getSugar(); s.setSugar(0); }
  } 
  
  /* Two agents are equal only if they're the same agent, 
  *  not just if they have the same properties.
  */
  public boolean equals(Agent other) {
    return this == other;
  }
  
  public void display(int x, int y, String displayType, int scale, boolean isFertile) {
    if (displayType == "culture") {
      if (getTribe() == true) {
        fill(0, 0, 255);
      } else {
        fill(255, 0, 0);
      }
    } else if (displayType == "sex") {
      if (getSex() == 'X') {
        fill(38, 41, 224);
      } else {
        fill(237, 33, 230);
      }
    } else if (displayType == "dual") {
      if (getTribe() == true) {
        if (getSex() == 'X') fill(114, 196, 219);
        else if (getSex() == 'Y') fill(232, 164, 211);
      } else {
        if (getSex() == 'X') fill(206, 34, 0);
        else if (getSex() == 'Y') fill(232, 161, 20); 
      }
    } else if (displayType == "fertility") {
      if (isFertile) {
        fill(30, 231, 234);
      } else {
        fill(237, 145, 32);
      }
    }
    ellipse(x, y, 3.0*scale/4, 3.0*scale/4);
  }
}

class AgentTester {
  
  public void test() {
    
    // test constructor, accessors
    int metabolism = 3;
    int vision = 2;
    int initialSugar = 4;
    MovementRule m = null;
    Agent a = new Agent(metabolism, vision, initialSugar, m);
    assert(a.isAlive());
    assert(a.getMetabolism() == 3);
    assert(a.getVision() == 2);
    assert(a.getSugarLevel() == 4);
    assert(a.getMovementRule() == null);
    
    // movement
    Square s1 = new Square(5, 9, 10, 10);
    Square s2 = new Square(5, 9, 12, 12);
    s1.setAgent(a);
    a.move(s1, s2);
    assert(s2.getAgent().equals(a));
    
    // eat
    a.eat(s2);
    assert(a.getSugarLevel() == 9);
    
    // test get/set MovementRule
    
    // step
    a.step();
    assert(a.getSugarLevel() == 6);
    a.step();
    a.step();
    a.step();
    assert(a.getSugarLevel() == 0);
    assert(!a.isAlive());
  }
}
