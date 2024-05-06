//
//  ViewController.m
//  Live
//
//  Created by amby on 2024/5/6.
//

#import "ViewController.h"
#import "LivePlayerViewController.h"
#import "LiveRecordViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    recordBtn.frame = CGRectMake(100, 100, 100, 100);
    [recordBtn setTitle:@"record" forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    playBtn.frame = CGRectMake(100, 300, 100, 100);
    [playBtn setTitle:@"play" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
}

- (void)record:(id)sender{
    [self.navigationController pushViewController:[LiveRecordViewController new] animated:YES];
}

- (void)play:(id)sender{
    [self.navigationController pushViewController:[LivePlayerViewController new] animated:YES];
}

@end
