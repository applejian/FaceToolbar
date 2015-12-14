//
//  FaceToolBar.h
//  BaseProject
//
//  Created by andy on 15/12/8.
//  Copyright © 2015年 andy. All rights reserved.
//

//自定义键盘类型
typedef enum{
    KBType_Keyboard = 0,//键盘
    KBType_Face = 1,//表情
    
}KBType;

typedef BOOL (^FaceToolSendBlock)(NSString *content);


#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IOS9_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#define IOS7_OR_EARLIER		( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER		( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER		( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER		( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER		( !IOS4_OR_LATER )

#define IS_SCREEN_55_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size)  : NO)

#define IS_SCREEN_47_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_4_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_35_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IOS7_OR_LATER		(NO)
#define IOS6_OR_LATER		(NO)
#define IOS5_OR_LATER		(NO)
#define IOS4_OR_LATER		(NO)
#define IOS3_OR_LATER		(NO)

#define IS_SCREEN_4_INCH	(NO)
#define IS_SCREEN_35_INCH	(NO)

#endif

//单例创建
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}



//基于iphone5 的屏幕设计比例 之前的工程需求
#define ScaleX_IP5 (ScreenWidth/320.0)

#undef  QQ_NEW_FACE
#define QQ_NEW_FACE (1)

#define FACE_PRIFX_NAME                         QQ_NEW_FACE ? @"qqface" : @"face"
#define FACE_PLIST_NAME                         @"face"

#define GET_FACE_TEXT(tag)                      [NSString stringWithFormat:@"[//face%@]",tag];
#define GET_FACE_IMAGE(tag)                     [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",FACE_PRIFX_NAME,tag]]



#undef	DEFAULT_KEYBOARD_HEIGHT
#define	DEFAULT_KEYBOARD_HEIGHT                 (216.0f * ScaleX_IP5 )


#define EXPAND_VIEW_DEFAULT_HEIGHT              (45.0 * ScaleX_IP5 )

#define PARENT_STATUS_BAR_HEIGHT                (IOS7_OR_LATER ? 0.0 : 20.0 )

#undef	INPUT_TEXT_START_Y
#define INPUT_TEXT_START_Y                      (( IOS7_OR_LATER ? ScreenHeight : (ScreenHeight - PARENT_STATUS_BAR_HEIGHT)) - EXPAND_VIEW_DEFAULT_HEIGHT)

#define FACE_VIEW_HEIGHT                        ((180 + 35)  * ScaleX_IP5)

#define FACE_TOOL_BAR_BASE_HEIGHT               ( EXPAND_VIEW_DEFAULT_HEIGHT + FACE_VIEW_HEIGHT )

#define EXPAND_VIEW_MAX_LIMIT_NUMS              ( 10000 )// 最大限制字符长度
#define EXPAND_VIEW_MAX_HEIGHT                  ( IS_SCREEN_4_INCH || IS_SCREEN_35_INCH ? 100.0 : 114.0 )// 输入框最大高度

#define FACE_SIZE                               FFONT_SIZE 

//清除文本框内容
#define FaceToolBarEmpty()                      [[FaceToolBar sharedInstance] emptyTextView]
//显示1
#define FaceToolBarShowIn(id,sendBlock)         [[FaceToolBar sharedInstance] showIn:id :sendBlock]
//显示2
#define FaceToolBarShow()                       [[FaceToolBar sharedInstance] show]
//显示在底部
#define FaceToolBarShowAtBottom(id,sendBlock)   [[FaceToolBar sharedInstance] showAtBottom:id :sendBlock]
//关闭
#define FaceToolBarDismiss()                    [[FaceToolBar sharedInstance] dismiss]

#define FaceToolBarSetAccessor(view)            [[FaceToolBar sharedInstance] setAccessor:view]

#define FaceToolBarClearAccessor()              [[FaceToolBar sharedInstance] clearAccessor]

#define FaceToolBarSetPlaceholder(placeholder)  [[FaceToolBar sharedInstance] setPlaceholder:placeholder]



#import <UIKit/UIKit.h>
#import "FaceView.h"
#import "AutoExpandView.h"
#import "NSAttributedString+FaceExtension.h"

@interface FaceToolBar : UIToolbar


AS_SINGLETON(FaceToolBar)


@property (nonatomic, readonly) BOOL					shown;
@property (nonatomic, readonly) BOOL					animating;
@property (nonatomic, readonly) CGFloat					keyboardHeight;
@property (nonatomic, assign) UIView *					accessor;
@property (nonatomic, readonly) NSTimeInterval			animationDuration;
@property (nonatomic, readonly) UIViewAnimationCurve	animationCurve;
@property (nonatomic,copy)FaceToolSendBlock sendBlock;


- (void)setAccessor:(UIView *)view;// 需要被适配高度的view 效果类似目标输入框或者显示的视图 显示在键盘的上方 避免被遮挡
- (void)clearAccessor;
//- (void)showAccessor:(UIView *)view animated:(BOOL)animated;
//- (void)hideAccessor:(UIView *)view animated:(BOOL)animated;
//- (void)updateAccessorAnimated:(BOOL)animated;

#pragma mark - 清空表情输入框内容
- (void)emptyTextView;

#pragma mark - 显示表情输入框 target:目标controller或者目标view 
#pragma mark - sendBlock:键盘上的发送事件的回调，BOOL返回值表示键盘是否复位到初始位置
- (void)showIn:(id)target :(FaceToolSendBlock)sendBlock;

- (void)show;
#pragma mark - 显示表情输入框 在底部
- (void)showAtBottom:(id)target :(FaceToolSendBlock)sendBlock;
#pragma mark - 隐藏表情输入框 并释放
- (void)dismiss;

-(void)setPlaceholder:(NSString *)placeholder;


@end
