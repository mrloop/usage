//
//  MLMainViewController.m
//  usage
//
//  Created by Ewan Mcdougall on 22/04/2013.
//  Copyright (c) 2013 Ewan Mcdougall. All rights reserved.
//

#import "MLMainViewController.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FUIButton.h"
#import "UIBarButtonItem+FlatUI.h"
#import "MLTMobileUsage.h"
#import "MAKVONotificationCenter.h"
#import "UIView+Glow.h"

@interface MLMainViewController ()

@end

@implementation MLMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor pomegranateColor];
  [UIBarButtonItem configureFlatButtonsWithColor:[UIColor pumpkinColor]
                                highlightedColor:[UIColor purpleColor]
                                    cornerRadius:5];

  self.bigDisplay.font = [UIFont flatFontOfSize:90];
  self.littleDisplay.font = [UIFont flatFontOfSize:90];
  self.bigLabel.font = [UIFont flatFontOfSize:20];
  self.littleLabel.font = [UIFont flatFontOfSize:20];

  self.refreshButton.buttonColor = [UIColor pumpkinColor];
  self.refreshButton.shadowColor = [UIColor sunflowerColor];
  self.refreshButton.shadowHeight = 3.0f;
  self.refreshButton.cornerRadius = 6.0f;
  self.refreshButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
  [self.refreshButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
  [self.refreshButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 
  [self observeTarget:[MLTMobileUsage sharedClient] keyPath:@"refreshing" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
    if([notification.newValue boolValue]){
      [self.refreshButton setTitle:@"Refreshing..." forState: UIControlStateNormal];
      [self.refreshButton startGlowingWithColor:[UIColor whiteColor] intensity:0.2];
      self.refreshButton.enabled = NO;
    }else{
      [self.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
      [self.refreshButton stopGlowing];
      self.refreshButton.enabled = YES;
    }
  }];
  
  
  [self observeTarget:[MLTMobileUsage sharedClient] keyPath:@"minutesRemaining" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
    self.bigDisplay.text = notification.newValue;
    NSLog(@"-%@-",notification.newValue);
  }];

  [self observeTarget:[MLTMobileUsage sharedClient] keyPath:@"textsRemaining" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
    self.littleDisplay.text = notification.newValue;
  }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
  if(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
    self.bigDisplay.font = [UIFont flatFontOfSize:90];
    self.littleDisplay.font = [UIFont flatFontOfSize:90];
  }else{
    self.bigDisplay.font = [UIFont flatFontOfSize:70];
    self.littleDisplay.font = [UIFont flatFontOfSize:70];
  }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(MLFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (IBAction)refresh:(id)sender{
  [[MLTMobileUsage sharedClient] refresh];
}

- (IBAction)showInfo:(id)sender
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    MLFlipsideViewController *controller = [[MLFlipsideViewController alloc] initWithNibName:@"MLFlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    [self presentViewController:controller animated:YES completion:nil];
  } else {
    if (!self.flipsidePopoverController) {
      MLFlipsideViewController *controller = [[MLFlipsideViewController alloc] initWithNibName:@"MLFlipsideViewController" bundle:nil];
      controller.delegate = self;
      self.flipsidePopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    }
    if ([self.flipsidePopoverController isPopoverVisible]) {
      [self.flipsidePopoverController dismissPopoverAnimated:YES];
    } else {
      [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
  }
}


@end
