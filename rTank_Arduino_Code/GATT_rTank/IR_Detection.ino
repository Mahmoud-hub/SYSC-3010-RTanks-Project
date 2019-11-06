void checkIR() {
  int reading = analogRead(recPin);

  if (reading < 4) {
    sendData(control, 1);
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
