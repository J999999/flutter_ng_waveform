//
//  WaveformView.h
//  flutter_ng_waveform
//
//  Created by MacBook Pro on 2022/8/22.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaveformView : NSObject<FlutterPlatformView>

- (id)initWithFrame:(CGRect)frame viewId:(int64_t)viewId args:(id)args;

@end

NS_ASSUME_NONNULL_END
