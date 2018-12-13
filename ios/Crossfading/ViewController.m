//
//  ViewController.m
//  Crossfading
//
//  Created by shaohua on 12/13/18.
//  Copyright © 2018 United Nations. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    // UI Begin
    UILabel *hello = [[UILabel alloc] init];
    hello.text = @"Hello!";
    hello.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:hello];

    UILabel *world = [[UILabel alloc] init];
    world.text = @"World!";
    world.alpha = 0;
    world.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:world];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hello attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hello attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:world attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:world attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    // UI End

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(onItemSelected)];
    hello.tag = 100; // 在 demo 中较为简洁
    world.tag = 200;
}

- (void)onItemSelected {
    UIView *hello = [self.view viewWithTag:100];
    UIView *world = [self.view viewWithTag:200];

    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIView animateWithDuration:1 animations:^{
        hello.alpha = 1 - hello.alpha;
        world.alpha = 1 - world.alpha;
    } completion:^(BOOL finished) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

@end
