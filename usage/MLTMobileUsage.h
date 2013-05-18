//
//  MLTMobileUsage.h
//  usage
//
//  Created by Ewan Mcdougall on 28/04/2013.
//  Copyright (c) 2013 Ewan Mcdougall. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SERVICE_NAME;

@interface MLTMobileUsage : NSObject <UIWebViewDelegate>

@property (readonly) NSString* minutesRemaining;
@property (readonly) NSString* textsRemaining;
@property (readonly) NSString* dataRemaining;
@property (readonly) NSString* statusMessage;
@property (readonly) BOOL refreshing;
@property (readonly) BOOL validCredentials;

+ (MLTMobileUsage *)sharedClient;

- (void) setUserName:(NSString*)userName password:(NSString*)password;
- (void) refresh;

@end
