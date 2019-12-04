void checkForIr() {
  //outputln("Checking for IR");
  //output("RECIEVER 1:       ");
 // Serial.print(analogRead(recieverPin1));
  //Serial.print("       RECIEVER 2:       ");
 // Serial.println(analogRead(recieverPin2));
  
  if (analogRead(recieverPin1) < 900 || analogRead(recieverPin2) < 900) {
    uint8_t buf[64];
    buf[0] = 234;
    int len = (buf, sizeof(buf));
    sendData(buf, len); //Sends a hit marker to the send function
    outputln("Hit");

  }
}
void shootLazer() {
  //outputln("die mf");
  digitalWrite(emitterPin, HIGH);
  delay(10);
  digitalWrite(emitterPin, LOW);
}
