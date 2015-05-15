//
//  PayWebVC.m
//  MyHospital
//
//  Created by XYQS on 15/5/8.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "PayWebVC.h"
#import <Security/Security.h>

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}


@end


@interface PayWebVC ()<UIWebViewDelegate>

@property(nonatomic)BOOL authed;

@property(nonatomic)NSURLRequest *myRequest;
@property(nonatomic)UIWebView *myWebView;

@end

@implementation PayWebVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付界面";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    self.myWebView = webView;
    webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"pay.html"];
    NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    NSString *host = [self stringWithString:str];

    [NSURLRequest allowsAnyHTTPSCertificateForHost:host];

    [webView loadHTMLString:str baseURL:nil];
    
}

- (NSString *)stringWithString:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"="];
    NSString *string = arr[5];
    NSArray *array = [string componentsSeparatedByString:@"//"];
    NSString *string2 = array[0];
    NSArray *array1 = [array[1] componentsSeparatedByString:@"/"];
    NSString *string3 = array1[0];
    NSString *allString = [NSString stringWithFormat:@"%@//%@",string2,string3];
    return allString;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    //判断是不是https
    if ([scheme isEqualToString:@"https"])
    {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (self.authed)
        {
            return YES;
        }
        //        NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlStr]] delegate:self];
        
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [doc stringByAppendingPathComponent:@"pay.html"];
        NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]] delegate:self];
        
        [conn start];
        [webView stopLoading];
        return NO;
    }
    return YES;
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
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    self.authed = YES;
    //webview 重新加载请求。
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"pay.html"];
    //[self.myWebView loadHTMLString:self.htmlStr baseURL:[NSURL fileURLWithPath:path]];
    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    [connection cancel];
}

@end
