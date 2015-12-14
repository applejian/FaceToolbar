//
//  AutoExpandView.h
//  BaseProject
//
//  Created by andy on 15/12/8.
//  Copyright © 2015年 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTTextView.h"

#define KSP (5.0  * ScaleX_IP5)

#define FFONT_SIZE (16 * ScaleX_IP5 )
#define KBTN_WIDTH (35.0 * ScaleX_IP5)

@interface AutoExpandView : UIView{
    BOOL _inited;
}

@property(nonatomic,assign)KBType ktype;
@property(nonatomic,strong)FTTextView * textView;
@property(nonatomic,strong)UIButton * keyBoardTypeBtn;

-(void)setKBtype:(KBType)ktype;


@end
