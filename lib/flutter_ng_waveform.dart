import 'flutter_ng_waveform_platform_interface.dart';

class FlutterNgWaveform {
  Future<String?> getPlatformVersion() {
    return FlutterNgWaveformPlatform.instance.getPlatformVersion();
  }

  Future<bool> initAudio() {
    return FlutterNgWaveformPlatform.instance.initAudio();
  }

  Future<void> startRecord() {
    return FlutterNgWaveformPlatform.instance.startRecord();
  }

  Future<void> stopRecord() {
    return FlutterNgWaveformPlatform.instance.stopRecord();
  }

  Future<void> startPlay() async {
    return FlutterNgWaveformPlatform.instance.startPlay();
  }

  Future<void> pausePlay() async {
    return FlutterNgWaveformPlatform.instance.pausePlay();
  }

  Future<List> audioFiles() async {
    return FlutterNgWaveformPlatform.instance.audioFiles();
  }

  Future<bool> audioFileRename(String currentName, String futureName) async {
    return FlutterNgWaveformPlatform.instance
        .audioFileRename(currentName, futureName);
  }

  Future<bool> deleteAudioFile(String fileName) async {
    return FlutterNgWaveformPlatform.instance.deleteAudioFile(fileName);
  }
}
