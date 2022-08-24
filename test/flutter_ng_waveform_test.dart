import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ng_waveform/flutter_ng_waveform.dart';
import 'package:flutter_ng_waveform/flutter_ng_waveform_platform_interface.dart';
import 'package:flutter_ng_waveform/flutter_ng_waveform_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNgWaveformPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNgWaveformPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> initAudio() => throw UnimplementedError();

  @override
  Future<void> startRecord() => throw UnimplementedError();

  @override
  Future<void> stopRecord() => throw UnimplementedError();

  @override
  Future<void> startPlay() => throw UnimplementedError();

  @override
  Future<void> pausePlay() => throw UnimplementedError();

  @override
  Future<List> audioFiles() => throw UnimplementedError();

  @override
  Future<bool> audioFileRename(String currentName, String futureName) =>
      throw UnimplementedError();

  @override
  Future<bool> deleteAudioFile(String fileName) => throw UnimplementedError();
}

void main() {
  final FlutterNgWaveformPlatform initialPlatform =
      FlutterNgWaveformPlatform.instance;

  test('$MethodChannelFlutterNgWaveform is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNgWaveform>());
  });

  test('getPlatformVersion', () async {
    FlutterNgWaveform flutterNgWaveformPlugin = FlutterNgWaveform();
    MockFlutterNgWaveformPlatform fakePlatform =
        MockFlutterNgWaveformPlatform();
    FlutterNgWaveformPlatform.instance = fakePlatform;

    expect(await flutterNgWaveformPlugin.getPlatformVersion(), '42');
  });
}
