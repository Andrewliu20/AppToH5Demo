//
//  ViewController.m
//  AppStateToH5Demo
//
//  Created by andrewliu on 16/7/14.
//  Copyright © 2016年 andrewliu. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "AFNetworking.h"

#define LOGIN_URL @"http://192.168.1.220:8092/Api/Auth/MobileLogin"

@interface ViewController ()

@property (nonatomic,strong) UILabel *accountLabel;

@property (nonatomic,strong) UILabel *pswLable;

@property (nonatomic,strong) UITextField *acountField;

@property (nonatomic,strong) UITextField *pswField;

@property (nonatomic,strong) UIButton *submitButton;

@end

@implementation ViewController
{
    BOOL _flag;
    NSString *_useId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self loadUI];
    
   
}


#pragma mark -- 初始化UI
- (void)loadUI{
    
    // 账户
    _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 90, 50)];
    
    self.accountLabel.text = @"手机号：";
    self.accountLabel.textColor = [UIColor blackColor];
    self.accountLabel.textAlignment = NSTextAlignmentLeft;
    self.accountLabel.font  = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.accountLabel];
    
    _acountField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, self.view.frame.size.width-150, 50)];
    
    self.acountField.borderStyle = UITextBorderStyleRoundedRect;
    self.acountField.backgroundColor = [UIColor whiteColor];
    self.acountField.placeholder = @"输入手机号";
    self.acountField.font = [UIFont fontWithName:@"Arial" size:14.0f];
    self.acountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.acountField.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.acountField];
    
    //密码
    _pswLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 90, 50)];
    
    self.pswLable.text = @"验证码：";
    self.pswLable.textColor = [UIColor blackColor];
    self.pswLable.textAlignment = NSTextAlignmentLeft;
    self.pswLable.font  = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.pswLable];
    
    _pswField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, self.view.frame.size.width-150, 50)];
    
    self.pswField.borderStyle = UITextBorderStyleRoundedRect;
    self.pswField.backgroundColor = [UIColor whiteColor];
    self.pswField.placeholder = @"输入验证码";
    self.pswField.secureTextEntry = YES;
    self.pswField.font = [UIFont fontWithName:@"Arial" size:14.0f];
    self.pswField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pswField.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.pswField];
    
    //登陆按钮
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 300, 100, 50)];
    
    [self.submitButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor grayColor];
    self.submitButton.layer.cornerRadius = 10.0;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
    
}

#pragma mark -- 登陆，并保存账户和密码

- (void)submitClick{
    
    [self.pswField resignFirstResponder];
   
    if (self.acountField.text.length >0 && self.pswField.text.length > 0) {
        //登录验证
        [self loadSource];
        
        WebViewController *webView = [[WebViewController alloc] init];
       
        if (_flag) {
             webView.userId = _useId;
//            webView.code = self.pswField.text;
//            webView.phoneNum = self.acountField.text;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webView];
            
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            
            
        }
        
    }else {
        
        [self alertView_null];
        
        
//        WebViewController *webView = [[WebViewController alloc] init];
//        
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webView];
//        
//        [self presentViewController:nav animated:YES completion:nil];

    }
    
    
   
}

#pragma mark -- 提示框
- (void)alertView{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"验证码不正确" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)alertView_null{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机或者验证码不能为空" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//登录验证
- (void)loadSource{
    
    
     AFHTTPRequestOperationManager*manager = [AFHTTPRequestOperationManager manager];
    [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求的参数

    NSDictionary *param = @{
                            @"Mobile":self.acountField.text,
                            @"Code":self.pswField.text,
                            @"Platform":@3
                            
                            };
    
    NSLog(@"iphone=%@",self.acountField.text);
    NSLog(@"code = %@",self.pswField.text);
   
    [manager POST:LOGIN_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
//        NSLog(@"%@",operation);
        if ([responseObject[@"Code"] integerValue] == 200) {
            _flag = true;
            NSLog(@"登录成功!%@",responseObject);
            
            _useId = responseObject[@"Data"][@"Id"];
            
            
        }else{
            _flag = false;
            //输入用户名和验证码不正确
            [self alertView];
        }
        

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _flag = NO;
        NSLog(@"失败%@",error);
    }];
   
    
}


@end
