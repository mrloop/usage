//
//  MLTMobileUsage.m
//  usage
//
//  Created by Ewan Mcdougall on 28/04/2013.
//  Copyright (c) 2013 Ewan Mcdougall. All rights reserved.
//

#import "MLTMobileUsage.h"
#import "SSKeychain.h"

NSString * const SERVICE_NAME = @"tmobile_usage";

static NSString * const kMLTMobileUsageURLString = @"https://www.t-mobile.co.uk/service/your-account/mtm-user-login-dispatch/";
static NSString * const kMLTMobileUsageUseURLString = @"https://www.t-mobile.co.uk/service/your-account/private/mtm-view-recent-use/";
static NSString * const kMLTMobileUsageHomeURLString = @"https://www.t-mobile.co.uk/service/your-account/private/home/";
static NSString * const kMLTMobileUsageWaitURLString = @"https://www.t-mobile.co.uk/service/your-account/private/mtm-wait-recent-use/";
static NSString * const kMLTMobileUsageLoginFailureURLString = @"https://www.t-mobile.co.uk/service/your-account/login/";

@implementation MLTMobileUsage

@synthesize minutesRemaining, dataRemaining, textsRemaining, refreshing, validCredentials, statusMessage;

UIWindow* _window;
UIWebView* _webView;

+ (MLTMobileUsage *)sharedClient{
  static MLTMobileUsage *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[MLTMobileUsage alloc] init];
    _window = [[UIWindow alloc] init];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1000, 200)];
    _webView.delegate = _sharedClient;
    [_window addSubview:_webView];
  });
  
  return _sharedClient;
}

- (void) refresh {
  [self setValue:[NSNumber numberWithBool:YES] forKey:@"refreshing"];
  [_webView stopLoading];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kMLTMobileUsageURLString]];
  [_webView loadRequest:request];
}

- (void) setUserName:(NSString *)userName password:(NSString *)password{
  //delete all account for this service
  for(NSDictionary* account in [SSKeychain accountsForService:SERVICE_NAME]){
    [SSKeychain deletePasswordForService:SERVICE_NAME account:[account objectForKey:kSSKeychainAccountKey]];
  }
  [SSKeychain setPassword:password forService:SERVICE_NAME account:userName];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
  NSLog(@"----> %@",webView.request.mainDocumentURL.absoluteString);
  NSLog(@"----> %@",error.localizedDescription);
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  NSLog(@"%@",webView.request.mainDocumentURL.absoluteString);
  NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
  NSLog(@"%@", currentURL);
  if ([webView.request.mainDocumentURL.absoluteString isEqualToString:kMLTMobileUsageURLString]){
    [self login];
    
  }else if([webView.request.mainDocumentURL.absoluteString isEqualToString:kMLTMobileUsageHomeURLString]){//logged in
    [_webView stopLoading];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kMLTMobileUsageUseURLString]]];
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"validCredentials"];
    
  }else if([webView.request.mainDocumentURL.absoluteString isEqualToString:kMLTMobileUsageUseURLString] ||
           [webView.request.mainDocumentURL.absoluteString isEqualToString:kMLTMobileUsageWaitURLString]){
    [_webView stopLoading];
    [self setValue:[self getTextValue:@"Text messages"] forKey:@"textsRemaining"];
    NSLog(@"%i",self.textsRemaining.length);
    [self setValue:[self getTextValue:@"Minutes"] forKey:@"minutesRemaining"];
    [self setValue:[NSNumber numberWithBool: NO] forKey:@"refreshing"];
    [self setValue:@"Valid Details" forKey:@"statusMessage"];
    
  }else if([webView.request.mainDocumentURL.absoluteString isEqualToString:kMLTMobileUsageLoginFailureURLString]){//l
    if([self loginFailure]){
      [self setValue:[NSNumber numberWithBool: NO] forKey:@"refreshing"];
      [self setValue:[NSNumber numberWithBool: NO] forKey:@"validCredentials"];
      [self setValue:@"Invalid Details" forKey:@"statusMessage"];
    }
  }
}

- (BOOL)loginFailure{
  NSString *script = @"xpath ='//div[@class=\"top-error\"]';\
    v = document.evaluate(xpath, document, null, XPathResult.ANY_TYPE,null).iterateNext();\
    v != null";
  NSString *result = [_webView stringByEvaluatingJavaScriptFromString:script];
  
  return [result boolValue];
}

- (NSString*)getTextValue:(NSString*)string {
  NSString *script = [NSString stringWithFormat:@"\
    xpath = '//table[@id=\"mtm-recent-use-table\"]//text()[contains(., \"%@\")]';\
    v = document.evaluate(xpath, document, null, XPathResult.ANY_TYPE,null).iterateNext();\
    v.nodeValue",string];
  NSString *result = [_webView stringByEvaluatingJavaScriptFromString:script];
  result = [result stringByReplacingOccurrencesOfString:string withString:@""];
  return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void) login{
  NSArray* accounts = [SSKeychain accountsForService:SERVICE_NAME];
  if([accounts count] > 0){
    NSDictionary* result = [accounts objectAtIndex:0];
    NSString* username = [result objectForKey:kSSKeychainAccountKey];
    NSString* password = [SSKeychain passwordForService:SERVICE_NAME account:username];
    NSString *loginScript = [NSString stringWithFormat:@"\
                             document.getElementById('username').value='%@';\
                             document.getElementById('password').value='%@';\
                             document.getElementById('mtm-login-btn').click();",
                             username, password];
    [_webView stringByEvaluatingJavaScriptFromString:loginScript];
  }else{
    [self setValue:[NSNumber numberWithBool: NO] forKey:@"refreshing"];
  }
}


@end
