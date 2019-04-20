
/* TimeSeriesGraph -- time is on the x axis
 */
abstract class TimeSeriesGraph extends Graph {
  private int numUpdates;
  
  /* Calls Graph constructor Passes argument to the super-class constructor, and sets the number of update calls to 0.
  *
  * tested visually.
  */
  public TimeSeriesGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
    numUpdates = 0;
  }
  
  /** In subclasses this will compute the y value of the next point in the graph.
   */
  public abstract int nextY(SugarGrid g);
  
  /*  Overrides the superclass update method. 
  *   If the "number of updates" -- the number of points updated so far -- is 0, calls the superclass update method. 
  *   Otherwise, calls nextY(g) to get the y-coordinate of the next point in the line. 
  *
  *   Draws a 1x1 square (i.e., a point; color is your choice) at the point that would be at 
  *   (number of updates, nextpoint(g)) in the graph that is being plotted. 
  *
  *   Increases the number of updates by 1. 
  *
  *   If the number of updates exceeds the width of the graph, set the number of updates back to 0 
  *   (erasing the graph on the next call, and starting over). 
  *
  * tested visually.
  */
  public void update(SugarGrid g) {
    if (numUpdates == 0) {
      super.update(g);
    }
    else {
      fill(0,0,255);
      rect(xOnScreen(numUpdates/10),yOnScreen(nextY(g)), 1, 1);
    }
    if (++numUpdates/10 > howWide) {
      numUpdates = 0;
    }
  }
}

/** A line graph of the number of agents on the SugarScape
 */
class NumberOfAgentsTimeSeriesGraph extends TimeSeriesGraph {
  int numUpdates;
  
  /* Constructor, calls parent constructor
  */
  public NumberOfAgentsTimeSeriesGraph(int x, int y, int howWide, int howTall) {
    super(x, y, howWide, howTall, "steps", "num agents");
    numUpdates = 0;
  }

  /*
  */
  public int nextY(SugarGrid g) {
     return g.getAgents().size()/3;
  }
}

/** A line graph of the number of agents on the SugarScape
 */
class AverageAgentSugerTimeSeriesGraph extends TimeSeriesGraph {
  
  /* Constructor, calls parent constructor
  */
  public AverageAgentSugerTimeSeriesGraph(int x, int y, int howWide, int howTall) {
    super(x, y, howWide, howTall, "steps", "agents");
  }

  /*
  */
  public int nextY(SugarGrid g) {
    ArrayList<Agent> agts = g.getAgents();
    int totalSugar = 0;
    for (Agent agt: agts) {
      totalSugar += agt.getSugarLevel();
    }
    return totalSugar/agts.size();
  }
}

/** A line graph of the number of agents on the SugarScape
 */
class AverageAgentAgeTimeSeriesGraph extends TimeSeriesGraph {
  int maxAge;
  
  /* Constructor, calls parent constructor
  */
  public AverageAgentAgeTimeSeriesGraph(int x, int y, int howWide, int howTall, int maxAge) {
    super(x, y, howWide, howTall, "steps", "avg age");
    this.maxAge = maxAge;
  }

  /*
  */
  public int nextY(SugarGrid g) {
    ArrayList<Agent> agts = g.getAgents();
    int totalAge = 0;
    for (Agent agt: agts) {
      totalAge += agt.getAge();
    }
    int avgAge = 0; if (agts.size() != 0) { avgAge = totalAge/agts.size(); }
    if (avgAge > maxAge) avgAge = maxAge;
    return howTall*avgAge/maxAge;
  }
}

/** A line graph of the average wealth of agents on the SugarScape
 */
class AverageAgentWealthTimeSeriesGraph extends TimeSeriesGraph {
  int maxWealth;
  
  /* Constructor, calls parent constructor
  */
  public AverageAgentWealthTimeSeriesGraph(int x, int y, int howWide, int howTall, int maxWealth) {
    super(x, y, howWide, howTall, "steps", "avg wealth");
    this.maxWealth = maxWealth;
  }

  /*
  */
  public int nextY(SugarGrid g) {
    ArrayList<Agent> agts = g.getAgents();
    int totalWealth = 0;
    for (Agent agt: agts) {
      totalWealth += agt.getSugarLevel();
    }
    int avgWealth = 0; if (agts.size() != 0) { avgWealth = totalWealth/agts.size(); }
    if (avgWealth > maxWealth) avgWealth = maxWealth;
    return howTall*avgWealth/maxWealth;
  } 
}

/** A line graph of the percent of agents in the true culture
 */
class PercentTrueCultureTimeSeriesGraph extends TimeSeriesGraph {
    /* Constructor, calls parent constructor
  */
  public PercentTrueCultureTimeSeriesGraph(int x, int y, int howWide, int howTall) {
    super(x, y, howWide, howTall, "steps", "true culture");
  }

  /*
  */
  public int nextY(SugarGrid g) {
    int numTrue = 0;
    ArrayList<Agent> agts = g.getAgents();
    for (Agent a : agts) {
      if (a.getTribe()) { numTrue++; }
    } 
    if (agts.size() == 0) { return 0; }
    if (numTrue == 0 && agts.get(0).getTribe()) {
      return howTall; 
    } else if (numTrue == 0) {
      return 0;
    }
    int percentTrue = agts.size()/numTrue;
      return howTall/percentTrue;
  } 
}
