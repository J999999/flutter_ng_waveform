import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ng_waveform_method_channel.dart';

abstract class FlutterNgWaveformPlatform extends PlatformInterface {
  /// Constructs a FlutterNgWaveformPlatform.
  FlutterNgWaveformPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNgWaveformPlatform _instance = MethodChannelFlutterNgWaveform();

  /// The default instance of [FlutterNgWaveformPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNgWaveform].
  static FlutterNgWaveformPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNgWaveformPlatform] when
  /// they register themselves.
  static set instance(FlutterNgWaveformPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> initAudio() async {
    throw UnimplementedError('initAudio() has not been implemented.');
  }

  Future<void> startRecord() {
    throw UnimplementedError('startRecord() has not been implemented.');
  }

  Future<void> stopRecord() async {
    throw UnimplementedError('stopRecord() has not been implemented.');
  }

  Future<void> startPlay() async {
    throw UnimplementedError('startPlay() has not been implemented.');
  }

  Future<void> pausePlay() async {
    throw UnimplementedError('pausePlay() has not been implemented.');
  }

  Future<List> audioFiles() async {
    throw UnimplementedError('audioFiles() has not been implemented.');
  }

  Future<bool> audioFileRename(String currentName, String futureName) async {
    throw UnimplementedError('audioFileRename() has not been implemented.');
  }

  Future<bool> deleteAudioFile(String fileName) async {
    throw UnimplementedError('deleteAudioFile() has not been implemented.');
  }
}
