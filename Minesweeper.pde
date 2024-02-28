import de.bezier.guido.*;
int num_rows=5;
int num_cols=5;
int num_mines=2;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

public void setup(){
    size(500,550);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make(this);
    //your code to initialize buttons goes here
    buttons=new MSButton[num_rows][num_cols];
    for(int i=0;i<num_rows;i++){
      for(int j=0;j<num_cols;j++){
        buttons[i][j]=new MSButton(i,j);
      }
    }
    mines=new ArrayList <MSButton>();
    setMines();
}

public void setMines(){
    //your code
    for(int m=0;m<num_mines;m++){
      int randx=(int)(Math.random()*num_rows);
      int randy=(int)(Math.random()*num_cols);
      if(!mines.contains(buttons[randx][randy]))
        mines.add(buttons[randx][randy]);
      else
        m--;
    }
}

public void draw(){
    background(0);
    if(isWon() == true)
        displayWinningMessage();
}

public boolean isWon(){
    //your code here
    return false;
}

public void displayLosingMessage(){
    //your code here
}

public void displayWinningMessage(){
    //your code here
}

public boolean isValid(int r, int c){
  if(r>=0 && r<num_rows && c>=0 && c<num_cols)
    return true;
  return false;
}

public int countMines(int row, int col){
    int numMines = 0;
    //your code here
    for(int i=0;i<=2;i++){
      for(int j=0;j<=2;j++){
        if(isValid(row+i-1,col+j-1)){
          if((row+i-1==row && col+j-1==col)||(mines.contains(buttons[row+i-1][col+j-1])))
            numMines++;
        }
      }
    }
    return numMines;
}

public class MSButton{
    private int myRow, myCol;
    private float x,y,width,height;
    private boolean clicked, flagged;
    private String myLabel;
    public MSButton(int row, int col){
        width = 500/num_cols;
        height = 500/num_rows;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add(this); // register it with the manager
    }
    // called by manager
    public void mousePressed(){
      //your code here
      clicked = true;
      if(mouseButton==RIGHT){
        flagged = !flagged;
        clicked = false;
      }
      else if(mines.contains(this))
        displayLosingMessage();
      //else if(countMines(r,c)>0)
      //  setLabel(num_mines);
    }
    public void draw(){    
        if(flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){
        myLabel = newLabel;
    }
    public void setLabel(int newLabel){
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged(){
        return flagged;
    }
}
