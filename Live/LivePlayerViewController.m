//
//  LivePlayerViewController.m
//  Live
//
//  Created by amby on 2024/5/6.
//

#import "LivePlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "Header.h"

@interface LivePlayerViewController ()
@end

@implementation LivePlayerViewController {
    IJKFFMoviePlayerController *_player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#endif
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    NSURL *url = [NSURL URLWithString:RTMP_SERVER_URL];
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    _player.view.frame = self.view.bounds;
    _player.scalingMode = IJKMPMovieScalingModeAspectFit;
    _player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:_player.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_player prepareToPlay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player shutdown];
}

@end
