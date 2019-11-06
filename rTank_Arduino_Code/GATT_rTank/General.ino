void pinSetup() {
  pinMode(ledPin, OUTPUT);
  pinMode(outputPin, OUTPUT);
  digitalWrite(outputPin, HIGH);
  pinMode(A0, OUTPUT);
}
void output(String txt) {
  if (canOutput) {
    Serial.print(txt);
  }
}
void output(int txt) {
  if (canOutput) {
    Serial.print(txt);
  }
}
void outputln(String txt) {
  if (canOutput) {
    Serial.println(txt);
  }
}
