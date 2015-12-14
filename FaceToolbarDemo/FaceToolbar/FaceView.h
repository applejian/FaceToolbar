//
//  FaceView.h
//  BaseProject
//
//  Created by andy on 15/12/8.
//  Copyright © 2015年 andy. All rights reserved.
//

#define FACE_BTN_KRect (24.0 * 1.5  * ScaleX_IP5 * 0.8)
#define DEL_BTN_TAG_STRING @"0"


#import <UIKit/UIKit.h>
typedef void (^FaceBtnClickBlockO)(NSString *tagString);
typedef void (^FaceBtnClickBlock)(void);



@interface FaceRangeData : NSObject

@property(nonatomic) NSInteger start;
@property(nonatomic) NSInteger end;

@end




@interface FaceView : UIView<UIScrollViewDelegate>{
    NSInteger totalPage;
    
    BOOL _inited;
    
}

@property(nonatomic,copy)FaceBtnClickBlockO faceBtnClickBlock;
@property(nonatomic,copy)FaceBtnClickBlock faceDelBtnClickBlock;
@property(nonatomic,copy)FaceBtnClickBlock faceSendBtnClickBlock;


@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UILabel * topLine;
@property(nonatomic,strong)UILabel * bottomLine;
@property(nonatomic,strong)UIPageControl * pager;
@property(nonatomic,strong)UIButton * faceSendBtn;


-(void)fillData:(NSArray *)dataList;
-(void)sendEnableSendBtn:(BOOL)en;


@end
