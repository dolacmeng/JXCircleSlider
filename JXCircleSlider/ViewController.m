//
//  ViewController.m
//  JXCircleSlider
//
//  Created by JackXu on 15/6/23.
//  Copyright (c) 2015年 BFMobile. All rights reserved.
//

#import "ViewController.h"
#import "JXCircleSlider.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JXCircleSlider *slider = [[JXCircleSlider alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    slider.center = self.view.center;
    
    [slider addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];

    [slider changeAngle:260];
    [self.view addSubview:slider];
}

-(void)newValue:(JXCircleSlider*)slider{
    NSLog(@"newValue:%d",slider.angle);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
