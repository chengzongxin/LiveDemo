//
//  LiveRecordViewController.m
//  Live
//
//  Created by amby on 2024/5/6.
//

#import "LiveRecordViewController.h"
#import <LFLiveKit/LFLiveKit.h>
#import "Header.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface LiveRecordViewController ()<LFLiveSessionDelegate>

@property (nonatomic, strong) LFLiveSession *session;

@property (nonatomic, strong) NSString *filePath;

@end

@implementation LiveRecordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播";
    self.filePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.map4"] stringByExpandingTildeInPath];
    
    self.session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration]
                                                videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
    

    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"hidden preview" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btn];
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.session.preView = nil;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.session.preView = self.view;
    self.session.showDebugInfo = YES;
    self.session.delegate = self;
//    self.session.captureDevicePosition = AVCaptureDevicePositionBack;
    [self requestAccessForVideo];
    [self requestAccessForAudio];
    [self addControls];
    [self startLive];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.session.saveLocalVideo = YES;
        self.session.saveLocalVideoPath = [NSURL fileURLWithPath:self.filePath isDirectory:NO];
    });
}

- (void)addControls {
    // Implement control addition logic here
}

- (void)openBeautyFace {
    if (self.session) {
        self.session.beautyFace = !self.session.beautyFace;
    }
}

- (void)requestAccessForVideo {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self sessionRunning];
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
            [self sessionRunning];
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    [self sessionRunning];
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
            [self sessionRunning];
            break;
        default:
            break;
    }
}

- (void)startLive {
    LFLiveStreamInfo *streamInfo = [[LFLiveStreamInfo alloc] init];
    streamInfo.url = RTMP_SERVER_URL;
    [self.session startLive:streamInfo];
}

- (void)sessionRunning {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.session.running = YES;
    });
}

#pragma mark - LFLiveSessionDelegate

- (void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo {
    // Handle debug info
}

- (void)liveSession:(LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode {
    // Handle error code
}

- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    // Handle live state change
}
@end
