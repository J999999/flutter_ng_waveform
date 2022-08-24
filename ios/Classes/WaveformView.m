//
//  WaveformView.m
//  flutter_ng_waveform
//
//  Created by MacBook Pro on 2022/8/22.
//

#import "WaveformView.h"
#import "NgWaveFormManager.h"

@implementation WaveformView {
    CGRect _frame;
    int64_t _viewId;
    id _args;
    
}

- (id)initWithFrame:(CGRect)frame viewId:(int64_t)viewId args:(id)args {
    
    if (self = [super init]) {
        _frame = frame;
        _viewId = viewId;
        _args = args;
    }
    return self;
}

- (UIView *)view {
    return [[NgWaveFormManager shareInstance] waveformView];
}

@end
