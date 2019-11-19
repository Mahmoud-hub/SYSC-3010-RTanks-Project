void checkForIr() {
  int reading = analogRead(recieverPin);

  if (reading < 4) {
    
    Serial.println("in 1");
    
  }
}
