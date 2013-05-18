//
//  MLMainViewController.h
//  usage
//
//  Created by Ewan Mcdougall on 22/04/2013.
//  Copyright (c) 2013 Ewan Mcdougall. All rights reserved.
//

#import "MLFlipsideViewController.h"

@interface MLMainViewController : UIViewController <MLFlipsideViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property(strong, nonatomic) IBOutlet UILabel *bigLabel;
@property(strong, nonatomic) IBOutlet UILabel *bigDisplay;

@property(strong, nonatomic) IBOutlet UILabel *littleLabel;
@property(strong, nonatomic) IBOutlet UILabel *littleDisplay;

@property(strong, nonatomic) IBOutlet FUIButton *refreshButton;

- (IBAction)showInfo:(id)sender;
- (IBAction)refresh:(id)sender;

@end
