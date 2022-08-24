//
//  WaveformViewFactory.m
//  flutter_ng_waveform
//
//  Created by MacBook Pro on 2022/8/22.
//

#import "WaveformViewFactory.h"
#import "WaveformView.h"

@implementation WaveformViewFactory

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    
    WaveformView *waveView = [[WaveformView alloc] initWithFrame:frame viewId:viewId args:args];
    return waveView;
}

@end
