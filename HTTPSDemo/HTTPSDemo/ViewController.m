//
//  ViewController.m
//  HTTPSDemo
//
//  Created by 周经伟 on 15/12/26.
//  Copyright © 2015年 excellence. All rights reserved.
//

#import "ViewController.h"
#import "PKHTTPSRequest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PKHTTPSRequest *httpsRequest = [[PKHTTPSRequest alloc] init];
    [httpsRequest requestHttps];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
