#import "FlutterNgWaveformPlugin.h"
#import "NgWaveFormManager.h"
#import "WaveformViewFactory.h"

@implementation FlutterNgWaveformPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_ng_waveform"
            binaryMessenger:[registrar messenger]];
    FlutterNgWaveformPlugin* instance = [[FlutterNgWaveformPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    WaveformViewFactory *waveViewFactory = [[WaveformViewFactory alloc] init];
    [registrar registerViewFactory:waveViewFactory withId:@"waveformView"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"initAudio" isEqualToString:call.method]) {
      result(@([NgWaveFormManager shareInstance].initAudio));
  } else if ([@"startRecord" isEqualToString:call.method]) {
      [[NgWaveFormManager shareInstance] startRecord:@""];
  } else if ([@"stopRecord" isEqualToString:call.method]) {
      [[NgWaveFormManager shareInstance] stopRecord];
  } else if ([@"startPlay" isEqualToString:call.method]) {
      [[NgWaveFormManager shareInstance]startPlayWithFile:@""];
  } else if ([@"pausePlay" isEqualToString:call.method]) {
      [[NgWaveFormManager shareInstance] pausePlay];
  } else if ([@"audioFiles" isEqualToString:call.method]) {
      result([[NgWaveFormManager shareInstance] getAudioFiles]);
  } else if ([@"audioFileRename" isEqualToString:call.method]) {
      result(@([[NgWaveFormManager shareInstance] audioFileRename:call.arguments[@"currentName"] FutureName:call.arguments[@"futureName"]]));
  } else if ([@"deleteAudioFile" isEqualToString:call.method]) {
      result(@([[NgWaveFormManager shareInstance] deleteAudioFile:call.arguments]));
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}


@end
