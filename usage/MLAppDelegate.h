//
//  MLAppDelegate.h
//  usage
//
//  Created by Ewan Mcdougall on 22/04/2013.
//  Copyright (c) 2013 Ewan Mcdougall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLTMobileUsage;

@class MLMainViewController;

@interface MLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MLMainViewController *mainViewController;

@end
