class JoystickController {
  void onJoystickMove(joystickId, double dx, double dy) {
    print("Joystick $joystickId moved: dx=$dx, dy=$dy");
  }
}