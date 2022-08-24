import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ng_waveform/flutter_ng_waveform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterNgWaveformPlugin = FlutterNgWaveform();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterNgWaveformPlugin.getPlatformVersion() ??
          'Unknown platform version';
      await _flutterNgWaveformPlugin.initAudio();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              TextButton(
                  onPressed: () => _clickStartRecordAction(),
                  child: const Text('开始录音')),
              TextButton(
                  onPressed: () => _clickStopRecordAction(),
                  child: const Text('停止录音')),
              TextButton(
                  onPressed: () => _clickStartPlayAction(),
                  child: const Text('播放录音')),
              TextButton(
                  onPressed: () => _clickPausePlayAction(),
                  child: const Text('暂停录音')),
              TextButton(
                  onPressed: () => _clickAudioFilesAction(),
                  child: const Text('录音列表')),
              TextButton(
                  onPressed: () => _clickRenameAction(),
                  child: const Text('重命名')),
              TextButton(
                  onPressed: () => _clickDeleteAction(),
                  child: const Text('删除文件')),
              Container(
                width: 300,
                height: 200,
                child: const UiKitView(viewType: 'waveformView'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clickStartRecordAction() {
    _flutterNgWaveformPlugin.startRecord();
  }

  void _clickStopRecordAction() {
    _flutterNgWaveformPlugin.stopRecord();
  }

  void _clickStartPlayAction() {
    _flutterNgWaveformPlugin.startPlay();
  }

  void _clickPausePlayAction() {
    _flutterNgWaveformPlugin.pausePlay();
  }

  void _clickAudioFilesAction() async {
    List audios = await _flutterNgWaveformPlugin.audioFiles();
    for (var element in audios) {
      print('--- 文件名: $element');
    }
  }

  void _clickRenameAction() async {
    print(await _flutterNgWaveformPlugin.audioFileRename(
        '20220824160856.m4a', 'modifiedName.m4a'));
  }

  void _clickDeleteAction() async {
    print(await _flutterNgWaveformPlugin.deleteAudioFile('20220824160721.m4a'));
  }
}
