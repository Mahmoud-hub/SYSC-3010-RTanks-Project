void checkForIr() {
  int reading = analogRead(recPin);

  if (reading < 4) {
    
    Serial.println("in 1");
    if (ledState && millis() - timeDelay > 100) {
      ledState = !ledState;
      timeDelay = millis();
      digitalWrite(ledPin, HIGH);
    } else if (!ledState && millis() - timeDelay > 100) {
      ledState = !ledState;
      timeDelay = millis();
      digitalWrite(ledPin, LOW);
    }
  }
}
void hitDetected(uint8_t *value, int len){
  bleuart.write( value, len );
}
