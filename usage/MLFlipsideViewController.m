//
//  MLFlipsideViewController.m
//  usage
//
//  Created by Ewan Mcdougall on 22/04/2013.
//  Copyright (c) 2013 Ewan Mcdougall. All rights reserved.
//

#import "MLFlipsideViewController.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FUIButton.h"
#import "MLTMobileUsage.h"
#import "MAKVONotificationCenter.h"
#import "UIView+Glow.h"

@interface MLFlipsideViewController ()

@end

@implementation MLFlipsideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    }
    return self;
}
							
- (void)viewDidLoad
{
  
  [super viewDidLoad];
  [self setupSubView: self.view];
  self.view.backgroundColor = [UIColor belizeHoleColor];
  self.passwordTextfield.secureTextEntry = YES;
  self.saveButton.buttonColor = [UIColor turquoiseColor];
  self.saveButton.shadowColor = [UIColor greenSeaColor];
 
  self.statusLabel.font = [UIFont boldFlatFontOfSize:20];
  self.saveButton.shadowHeight = 3.0f;
  self.saveButton.cornerRadius = 6.0f;
  self.saveButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
  [self.saveButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
  [self.saveButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
 
  
  [self observeTarget:[MLTMobileUsage sharedClient] keyPath:@"refreshing" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
    if([notification.newValue boolValue]){
      [self.saveButton setTitle:@"Checking..." forState: UIControlStateNormal];
      self.statusLabel.text = @"";
      self.saveButton.enabled = NO;
      [self.saveButton startGlowingWithColor:[UIColor whiteColor] intensity:0.2];
      self.passwordTextfield.enabled = NO;
      self.usernameTextfield.enabled = NO;
    }else{
      [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
      self.statusLabel.text = [[MLTMobileUsage sharedClient] statusMessage];
      self.saveButton.enabled = YES;
      [self.saveButton stopGlowing];
      self.passwordTextfield.enabled = YES;
      self.usernameTextfield.enabled = YES;
    }
  }];
  
}

- (void)setupSubView:(UIView*)view
{
  for(id subview in view.subviews){
    if([subview isMemberOfClass: [UINavigationBar class]]){
      [subview configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    }
    if([subview isMemberOfClass: [UILabel class]]){
      ((UILabel*)subview).font = [UIFont flatFontOfSize:20];
    }
    if([subview isMemberOfClass: [UITextField class]]){
      ((UITextField*)subview).font = [UIFont flatFontOfSize:18];
    }
    [self setupSubView:subview];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
  [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)save:(id)sender{
  if(self.usernameTextfield.text.length > 0 && self.passwordTextfield.text.length > 0){
    [[MLTMobileUsage sharedClient] setUserName:self.usernameTextfield.text password:self.passwordTextfield.text];
    [[MLTMobileUsage sharedClient] refresh];
  }
}

@end
