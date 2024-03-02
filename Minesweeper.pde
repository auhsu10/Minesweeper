import de.bezier.guido.*;
private int num_rows=16;
private int num_cols=16;
private int num_mines=15;
private boolean gameOver=false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

public void setup(){
    size(500,500);
    textSize(25);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make(this);
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
    if(gameOver==true)
      displayLosingMessage();
    else if(isWon()==true)
      displayWinningMessage();
}

public boolean isWon(){
    for(int i=0;i<buttons.length;i++){
      for(int j=0;j<buttons[i].length;j++){
        if(mines.contains(buttons[i][j]) && !buttons[i][j].isFlagged())
          return false;
        if(!mines.contains(buttons[i][j]) && !buttons[i][j].clicked)
          return false;
      }
    }
    return true;
}

public void displayLosingMessage(){
  String[] lossmessage = {"Y","o","u"," ","L","o","s","t"};
  gameOver=true;
  buttons=new MSButton[num_rows][num_cols];
    for(int i=0;i<num_rows;i++){
      for(int j=0;j<num_cols;j++){
        buttons[i][j]=new MSButton(i,j);
        buttons[i][j].clicked=true;
      }
    }
  for(int i=0;i<lossmessage.length;i++)
    buttons[num_rows/2-1][i+4].setLabel(lossmessage[i]);
}

public void displayWinningMessage(){
  String[] winmessage = {"Y","o","u"," ","W","o","n","!"};
  buttons=new MSButton[num_rows][num_cols];
  for(int i=0;i<num_rows;i++){
    for(int j=0;j<num_cols;j++){
      buttons[i][j]=new MSButton(i,j);
      buttons[i][j].clicked=true;
    }
  }
  for(int i=0;i<winmessage.length;i++)
    buttons[num_rows/2-1][i+4].setLabel(winmessage[i]);
}

public boolean isValid(int r, int c){
  if(r>=0 && r<num_rows && c>=0 && c<num_cols)
    return true;
  return false;
}

public int countMines(int row, int col){
    int numMines = 0;
    for(int i=0;i<=2;i++){
      for(int j=0;j<=2;j++){
        if(isValid(row+i-1,col+j-1) && !(i==1 && j==1)){
          if(mines.contains(buttons[row+i-1][col+j-1]))
            numMines++;
        }
      }
    }
    return numMines;
}

public class MSButton{
    private int myRow, myCol;
    private float x,y,width,height;
    private boolean filled, clicked, flagged;
    private String myLabel;
    public MSButton(int row, int col){
        width = 500/num_cols;
        height = 500/num_rows;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = filled = false;
        Interactive.add(this); // register it with the manager
    }
    // called by manager
    public void mousePressed(){
      if(gameOver==false && isWon()==false){
        clicked = true;
        if(mouseButton==LEFT && isFlagged()==false)
          filled=true;
        if(mouseButton==RIGHT && filled==false){
          flagged = !flagged;
          clicked = false;
        }
        else if(mines.contains(this))
          displayLosingMessage();
        else if(countMines(myRow,myCol)>0 && filled==true)
          setLabel(countMines(myRow,myCol));
        else if(isFlagged()==false){
          for(int i=0;i<3;i++){
            for(int j=0;j<3;j++){
              if(isValid(myRow+i-1,myCol+j-1)==true && !(i==0 && j==0)){
                if(!buttons[myRow+i-1][myCol+j-1].flagged && !buttons[myRow+i-1][myCol+j-1].clicked)
                  buttons[myRow+i-1][myCol+j-1].mousePressed();
              }
            }
          }
        }
      }
    }
    public void draw(){
        if(gameOver==true)
          fill(160);
        else if(isWon()==true)
          fill(255);
        else if(flagged)
          fill(225,220,0);
        else if(clicked && mines.contains(this)) 
          fill(255,0,0);
        else if(clicked)
          fill(200);
        else 
          fill(60);
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
