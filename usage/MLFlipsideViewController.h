//
//  MLFlipsideViewController.h
//  usage
//
//  Created by Ewan Mcdougall on 22/04/2013.
//  Copyright (c) 2013 Ewan Mcdougall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUIButton;

@class MLFlipsideViewController;

@protocol MLFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(MLFlipsideViewController *)controller;
@end

@interface MLFlipsideViewController : UIViewController

@property(strong, nonatomic) IBOutlet UITextField *usernameTextfield;
@property(strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property(strong, nonatomic) IBOutlet FUIButton *saveButton;
@property(strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) id <MLFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
