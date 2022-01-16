class Settings {
  final int contrast;
  final int brightness;
  final int gamma;
  final int black_equalizer;
  final int color_vibrance;
  final int color_temperature;
  final int sharpness;
  final int low_blue_light;
  final int super_resolution;
  final int overdrive;

  factory Settings.fromJson(Map<String, dynamic> data) {
    final contrast = data['contrast'] as int;
    final brightness = data['brightness'] as int;
    final gamma = data['gamma'] as int;
    final black_equalizer = data['black_equalizer'] as int;
    final color_vibrance = data['color_vibrance'] as int;
    final color_temperature = data['color_temperature'] as int;
    final sharpness = data['sharpness'] as int;
    final low_blue_light = data['low_blue_light'] as int;
    final super_resolution = data['super_resolution'] as int;
    final overdrive = data['overdrive'] as int;

    return Settings(
        contrast,
        brightness,
        gamma,
        black_equalizer,
        color_vibrance,
        color_temperature,
        sharpness,
        low_blue_light,
        super_resolution,
        overdrive);
  }

  Settings(
      this.contrast,
      this.brightness,
      this.gamma,
      this.black_equalizer,
      this.color_vibrance,
      this.color_temperature,
      this.sharpness,
      this.low_blue_light,
      this.super_resolution,
      this.overdrive);
}
