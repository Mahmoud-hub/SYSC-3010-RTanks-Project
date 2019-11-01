
void output(String txt){
  if(canOutput){
    Serial.print(txt);
  }
}
void output(int txt){
  if(canOutput){
    Serial.print(txt);
  }
}
void outputln(String txt){
  if(canOutput){
    Serial.println(txt);
  }
}
