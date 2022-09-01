//
//  NgWaveFormManager.h
//  flutter_ng_waveform
//
//  Created by MacBook Pro on 2022/8/19.
//

#import <Foundation/Foundation.h>
#import "EZAudio.h"

NS_ASSUME_NONNULL_BEGIN

@interface NgWaveFormManager : NSObject

@property (nonatomic, assign) BOOL isRecording;

+ (instancetype)shareInstance;

- (BOOL)initAudio;

- (NSArray *)getAudioFiles;

/// fileTyle    heart心脏  lung肺
- (void)startRecord:(NSString *)fileType;

- (void)stopRecord;

- (void)startPlayWithFile:(NSString *)filePath;

- (void)pausePlay;

- (BOOL)audioFileRename:(NSString *)currentName FutureName:(NSString *)futureName;

- (BOOL)deleteAudioFile:(NSString *)fileName;

- (EZAudioPlotGL *)waveformView;

@end

NS_ASSUME_NONNULL_END
