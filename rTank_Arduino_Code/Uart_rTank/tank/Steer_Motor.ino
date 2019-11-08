void moveToPos(int x, int y){
  int pos = 0;
  if (pos < 56){
    pos = 56;
  }else if(pos > 124){
    pos = 124;
  }
  myservo.write(pos); 
}
