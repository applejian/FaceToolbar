//
//  ViewController.m
//  FaceToolbarDemo
//
//  Created by andy on 15/12/14.
//  Copyright © 2015年 andy. All rights reserved.
//

#import "ViewController.h"

#undef  QQ_NEW_FACE
#define QQ_NEW_FACE (1)  // 1 qq 手机qq 最新表情 0 远经典表情


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initText{
    //    由于是单例  每次调用前 需要重置一些 参数
    FaceToolBarDismiss();// 移除输入调
    
    
    
    FaceToolBarEmpty();// 手动 清空文本框内容
    FaceToolBarSetPlaceholder(@"回复:德玛");//设置 Placeholder
    //    FaceToolBarClearAccessor();//清除绑定
    //    FaceToolBarShow();//手动弹起键盘
    
}

- (IBAction)type1Click:(id)sender {
    [self initText];

    
    
    FaceToolBarSetAccessor(sender);//适配 目标view 的弹出高度 看需要


    
    
    
    FaceToolBarShowIn(self,^(NSString * content){
        NSLog(@"输入框内容为：%@",content);
        
        if (content.length <= 0) {
            
            NSLog(@"没有内容啊 不收回键盘");
            
            return NO;
        }else{
            return YES;
        }
    });
    
}


- (IBAction)type2Click:(id)sender {
    [self initText];
    
    FaceToolBarShowAtBottom(self,^(NSString * content){
        NSLog(@"输入框内容为：%@",content);
        
        if (content.length <= 0) {
            
            NSLog(@"没有内容啊 不收回键盘");
            
            return NO;
        }else{
            return YES;
        }
    });
}
@end
