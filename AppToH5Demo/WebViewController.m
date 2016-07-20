//
//  WebViewController.m
//  AppStateToH5Demo
//
//  Created by andrewliu on 16/7/14.
//  Copyright © 2016年 andrewliu. All rights reserved.
//

#import "WebViewController.h"
#define H5URL @"http://www.mochoujun.com/qianbao/index"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;



@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self backItem];
    
    
//    self.userId = @"356";
    
    self.webView.scrollView.frame =self.webView.frame;
    _webView.backgroundColor = [UIColor grayColor];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-20)];
    _webView.delegate = self;
    //判断是否沙盒中是否有这个值
    if ([[[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]allKeys]containsObject:@"cookie"]) {
        //获取cookies：程序起来之后，uiwebview加载url之前获取保存好的cookies，并设置cookies，
        NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookie"];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
    }

    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:H5URL]];
    
    // 设置header，通过遍历cookies来一个一个的设置header
    for (NSHTTPCookie *cookie in cookies){
        
        // cookiesWithResponseHeaderFields方法，需要为URL设置一个cookie为NSDictionary类型的header，注意NSDictionary里面的forKey需要是@"Set-Cookie"
        NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:
                                    [NSDictionary dictionaryWithObject:
                                     [[NSString alloc] initWithFormat:@"%@=%@",[cookie name],[cookie value]]
                                                                forKey:@"Set-Cookie"]
                                                                          forURL:[NSURL URLWithString:H5URL]];
        
        // 通过setCookies方法，完成设置，这样只要一访问URL为HOST的网页时，会自动附带上设置好的header
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie
                                                           forURL:[NSURL URLWithString:H5URL]
                                                  mainDocumentURL:nil];
    }
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",H5URL]]];
    _webView.scalesPageToFit = YES;
    [ self.webView loadRequest:req];
    [self.view addSubview:self.webView];
}

- (void)backItem{
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickBack)];
    self.navigationItem.leftBarButtonItem = btn;
}
- (void)clickBack{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
#pragma mark --  webView的协议方法

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
  
    
    NSString *insertString = [NSString stringWithFormat: @"var script = document.createElement('script');"
                              "script.type = 'text/javascript';"
                              "script.text = \"function jsFunc() { "
//                              "var lendUrl = location.toString().split('?')[0];"
//                              "var zoneUrl = location.host.toString();"
//                              "var searchUrl = location.search;"
//                              "var data = { UserId: '%@' };"
//                              "CountFun(data, 'http://tongji.niuduz.com/DataCollect/AddData', zoneUrl, lendUrl, searchUrl);"
                              " localStorage.setItem('Id',%@);"
                              "$('.login').hide();"
//                              "window.location.href = 'http://www.mochoujun.com/app#/home'"
                              "}\";"
                              "document.getElementsByTagName('head')[0].appendChild(script);",self.userId];
   
    
   
    NSLog(@"insert string %@",insertString);
    [self.webView stringByEvaluatingJavaScriptFromString:insertString];
    [self.webView  stringByEvaluatingJavaScriptFromString:@"jsFunc();"];
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 将获取的cookie储存在沙盒中（ 通过 [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie: cookies]来保存cookies，但是我发现，即使这样设置之后再app退出之后，该cookies还是丢失了（其实是cookies过期的问题)
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSHTTPCookie *cookie;
    for (id c in nCookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            if ([cookie.name isEqualToString:@"PHPSESSID"]) {
                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookie"];
                break;
            }
        }
    }
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"--------------%@",error);
}
@end
