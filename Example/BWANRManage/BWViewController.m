//
//  BWViewController.m
//  BWANRManage
//
//  Created by bairdweng on 06/02/2021.
//  Copyright (c) 2021 bairdweng. All rights reserved.
//

#import "BWViewController.h"
#import <BWANRManage.h>
@interface BWViewController ()

@end

@implementation BWViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)openANR:(id)sender {    
    [[BWANRManage sharedInstance]show];
}

- (IBAction)anrTest:(id)sender {
	[self legTest];
}


- (void)legTest {
	sleep(2);
	NSLog(@"卡顿测试");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
