import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_ng_waveform_platform_interface.dart';

/// An implementation of [FlutterNgWaveformPlatform] that uses method channels.
class MethodChannelFlutterNgWaveform extends FlutterNgWaveformPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ng_waveform');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initAudio() async {
    final canStart = await methodChannel.invokeMethod("initAudio");
    return canStart;
  }

  @override
  Future<void> startRecord() async {
    await methodChannel.invokeMethod("startRecord");
  }

  @override
  Future<void> stopRecord() async {
    await methodChannel.invokeMethod("stopRecord");
  }

  @override
  Future<void> startPlay() async {
    await methodChannel.invokeMethod("startPlay");
  }

  @override
  Future<void> pausePlay() async {
    await methodChannel.invokeMethod("pausePlay");
  }

  @override
  Future<List> audioFiles() async {
    return await methodChannel.invokeMethod("audioFiles");
  }

  @override
  Future<bool> audioFileRename(String currentName, String futureName) async {
    return await methodChannel.invokeMethod("audioFileRename",
        {"currentName": currentName, "futureName": futureName});
  }

  @override
  Future<bool> deleteAudioFile(String fileName) async {
    return await methodChannel.invokeMethod("deleteAudioFile", fileName);
  }
}
