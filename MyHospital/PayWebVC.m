//
//  PayWebVC.m
//  MyHospital
//
//  Created by XYQS on 15/5/8.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "PayWebVC.h"
#import <Security/Security.h>

@interface PayWebVC ()<UIWebViewDelegate>

@property(nonatomic)BOOL authed;

@property(nonatomic)NSURLRequest *myRequest;
@property(nonatomic)UIWebView *myWebView;

@end

@implementation PayWebVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    webView.delegate = self;
    self.myWebView = webView;
    webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"pay.html"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    self.myRequest = request;
    [webView loadRequest:request];
    
    
    //[webView loadHTMLString:self.htmlStr baseURL:nil];
    
    [self.view addSubview:webView];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    NSLog(@"scheme = %@",scheme);
    //判断是不是https
    if ([scheme isEqualToString:@"https"])
    {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (self.authed)
        {
            return YES;
        }
        NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:self.myRequest delegate:self];
        [conn start];
        [webView stopLoading];
        return NO;
    }
    return YES;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount]== 0)
    {
        _authed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount]== 0)
    {
        _authed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    NSLog(@"request = %@",request);
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    self.authed = YES;
    //webview 重新加载请求。
    [self.myWebView loadRequest:self.myRequest];
    [connection cancel];
}


@end
