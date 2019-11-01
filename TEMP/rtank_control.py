import paho.mqtt.client as mqtt
from time import sleep
from bluetooth import *
from PiToBluefruit import send_ble
import RPi.GPIO as GPIO
drive_motor = [7, 11, 13, 15]
steer_motor = [31, 33, 35, 37]
shoot_motor = [32, 36, 38, 40]
step_seq = [
	[1,0,0,0],
	[0,1,0,0],
	[0,0,1,0],
	[0,0,0,1]
]
def pin_setup (arr):
    for pin in arr:
        GPIO.setup(pin, GPIO.OUT)
        GPIO.output(pin,0)

def run_motor(val):
    if val % 2 == 1:
        for i in range(256):
            for step_seq in range(4):
                for pin in range(4):
                    GPIO.output(control_pins[pin], halfstep_seq[halfstep][pin])
                time.sleep(0.001)
    elif val % 4 >= 2:
        for i in range(256):
            for step_seq in range(4):
                for pin in range(4):
                    GPIO.output(control_pins[pin], halfstep_seq[halfstep][pin])
                time.sleep(0.001)
    elif val % 8 >= 4:
        for i in range(256):
            for step_seq in range(4):
                for pin in range(4):
                    GPIO.output(control_pins[pin], halfstep_seq[halfstep][pin])
                time.sleep(0.001)


if __name__=='__main__':
    pin_setup(drive_motor)
    pin_setup(steer_motor)
    pin_setup(shoot_motor)
    
    try:
        global flag
        flag = True

        BLE_SERVER = None
        UUID = None

        def start_client(broker='192.168.2.41', sub_list=['other', 'info'], client_name='client-002'):
            return broker, sub_list, mqtt.Client(client_name)

        broker, sub_list, client = start_client()

        pub_topic = sub_list[0]
        sub_topic = sub_list[1]

        def bluetooth_call(message):
            print("Called Bluetooth")
            sleep(3)
            if None in [BLE_SERVER, UUID]:
                send_ble(message=message)
            else:
                send_ble(addr=BLE_SERVER ,uuid=UUID , message=message)
            return message


        def on_message(client, userdata, message):
            sleep(1)
            message = str(message.payload.decode("utf-8").strip())
            
            try:
                if message == "quit":
                    print("setting flag to false")
                    global flag
                    flag = False
                elif message == "1":
                    client.publish(pub_topic, bluetooth_call(message) + " was sent to ble\n")
                else:
                    client.publish(pub_topic, message + " was recived on pi\n")
            except Exception as err:
                print(err)
            finally:
                print("Messsage recieved: ", message, "\n")


        client.on_message = on_message


        client.connect(broker)
        client.loop_start()

        print("listening on ", sub_topic)
        print("returning info on ", pub_topic)

        client.subscribe(sub_topic)

        while flag:
            sleep(1)
    finally:
	print("Closing Temp/Light Client")
	sleep(1)
	client.disconnect()
	client.loop_stop()
    GPIO.cleanup()

