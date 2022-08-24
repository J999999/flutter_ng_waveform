//
//  NgWaveFormManager.m
//  flutter_ng_waveform
//
//  Created by MacBook Pro on 2022/8/19.
//

#import "NgWaveFormManager.h"

@interface NgWaveFormManager()<EZMicrophoneDelegate, EZRecorderDelegate, EZAudioPlayerDelegate>

@property (nonatomic, strong) EZAudioPlotGL *audioPlot;

//
// The microphone component
//
@property (nonatomic, strong) EZMicrophone *microphone;

//
// The recorder component
//
@property (nonatomic, strong) EZRecorder *recorder;

//
// The audio player that will play the recorded file
//
@property (nonatomic, strong) EZAudioPlayer *player;

@property (nonatomic, copy) NSString *currentTime;

@end


@implementation NgWaveFormManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)shareInstance {
    static NgWaveFormManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NgWaveFormManager alloc] init];
    });
    return instance;
}

- (BOOL)initAudio {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
        return NO;
    }
    [session setActive:YES error:&error];
    if (error)
    {
        NSLog(@"Error setting up audio session active: %@", error.localizedDescription);
        return NO;
    }
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    self.player = [EZAudioPlayer audioPlayerWithDelegate:self];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if (error)
    {
        NSLog(@"Error overriding output to the speaker: %@", error.localizedDescription);
        return NO;
    }
    [self setupNotifications];
    return YES;
}

- (void)startRecord:(NSString *)fileType {
    [self waveformClear];
    [self.microphone startFetchingAudio];
    self.recorder = [EZRecorder recorderWithURL:[self audioFilePathURL:[self getCurrentDate]] clientFormat:[self.microphone audioStreamBasicDescription] fileType:EZRecorderFileTypeM4A delegate:self];
}

- (void)stopRecord {
    [self.microphone stopFetchingAudio];
    if (self.recorder) {
        self.recorder.delegate = nil;
        [self.recorder closeAudioFile];
    }
}

- (void)startPlayWithFile:(NSString *)filePath {
    [self waveformClear];
    EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:[self audioFilePathURL:self.currentTime]];
    [self.player playAudioFile:audioFile];
}

- (void)pausePlay {
    [self.player pause];
}

- (void)waveformClear {
    [self.audioPlot clear];
}

- (NSArray *)getAudioFiles {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:[self applicationDocumentsDirectory] error:nil];
    return array;
}

- (BOOL)audioFileRename:(NSString *)currentName FutureName:(NSString *)futureName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [self applicationDocumentsDirectory], currentName];
    NSString *moveToPath = [NSString stringWithFormat:@"%@/%@", [self applicationDocumentsDirectory], futureName];
    
    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
    return isSuccess;
    
}

- (BOOL)deleteAudioFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isSuccess = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [self applicationDocumentsDirectory], fileName] error:&error];
    return isSuccess;
}

//------------------------------------------------------------------------------
#pragma mark - EZMicrophoneDelegate
//------------------------------------------------------------------------------

- (void)microphone:(EZMicrophone *)microphone changedPlayingState:(BOOL)isPlaying
{
    NSLog(@"changedPlayingState");
}
- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.audioPlot updateBuffer:buffer[0]
                                   withBufferSize:bufferSize];
    });
}
- (void)microphone:(EZMicrophone *)microphone hasBufferList:(AudioBufferList *)bufferList withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
    
    [self.recorder appendDataFromBufferList:bufferList withBufferSize:bufferSize];
    
}

//------------------------------------------------------------------------------
#pragma mark - EZRecorderDelegate
//------------------------------------------------------------------------------
- (void)recorderDidClose:(EZRecorder *)recorder {
    recorder.delegate = nil;
}
- (void)recorderUpdatedCurrentTime:(EZRecorder *)recorder {
    
}

//------------------------------------------------------------------------------
#pragma mark - EZAudioPlayerDelegate
//------------------------------------------------------------------------------

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidChangePlayState:)
                                                 name:EZAudioPlayerDidChangePlayStateNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEndOfFile:)
                                                 name:EZAudioPlayerDidReachEndOfFileNotification
                                               object:self.player];
}
- (void)playerDidChangePlayState:(NSNotification *)notification
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        EZAudioPlayer *player = [notification object];
        BOOL isPlaying = [player isPlaying];
        if (isPlaying)
        {
            weakSelf.recorder.delegate = nil;
        }
//        weakSelf.playingAudioPlot.hidden = !isPlaying;
    });
}

//------------------------------------------------------------------------------

- (void)playerDidReachEndOfFile:(NSNotification *)notification
{
//    [self playWaveformClear];
}
- (void) audioPlayer:(EZAudioPlayer *)audioPlayer
         playedAudio:(float **)buffer
      withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
          inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.audioPlot updateBuffer:buffer[0]
                                 withBufferSize:bufferSize];
    });
}

//------------------------------------------------------------------------------

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.currentTimeLabel.text = [audioPlayer formattedCurrentTime];
    });
}

//------------------------------------------------------------------------------
#pragma mark - waveform view
//------------------------------------------------------------------------------
- (EZAudioPlotGL *)waveformView {
    self.audioPlot = [[EZAudioPlotGL alloc] init];
    self.audioPlot.frame = CGRectMake(0, 0, 200, 100);
    self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.984 green: 0.71 blue: 0.365 alpha: 1];
    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.audioPlot.plotType        = EZPlotTypeRolling;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    self.audioPlot.gain = 2.0f;
    return self.audioPlot;
}

//------------------------------------------------------------------------------
#pragma mark - Utility
//------------------------------------------------------------------------------

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    basePath = [basePath stringByAppendingPathComponent:@"Audios"];
    return basePath;
}

- (void)createDir {
    NSString *fileDir = [self applicationDocumentsDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

- (NSString *)getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *dateNow = [NSDate date];
    //把NSDate按formatter格式转成NSString
    NSString *currentTime = [formatter stringFromDate:dateNow];
    self.currentTime = currentTime;
    return currentTime;
}

- (NSURL *)audioFilePathURL:(NSString *)fileName {
    [self createDir];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.m4a", [self applicationDocumentsDirectory], fileName]];
    return url;
}
@end
