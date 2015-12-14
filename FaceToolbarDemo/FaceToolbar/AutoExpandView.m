//
//  AutoExpandView.m
//  BaseProject
//
//  Created by andy on 15/12/8.
//  Copyright © 2015年 andy. All rights reserved.
//


#import "AutoExpandView.h"

@implementation AutoExpandView
- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if ( self )
    {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    if ( NO == _inited )
    {
        self.backgroundColor = [UIColor clearColor];
                
        _inited = YES;
        
        [self load];
    }
}

-(void)load{
    self.ktype = KBType_Keyboard;
    
}


-(void)layoutSubviews{
    
    self.textView.frame = CGRectMake(KSP , KSP , ScreenWidth - KBTN_WIDTH - KSP * 2, self.frame.size.height - KSP * 2);
    
    self.keyBoardTypeBtn.frame = CGRectMake(ScreenWidth - KBTN_WIDTH - KSP / 2.0 , KSP , KBTN_WIDTH, KBTN_WIDTH);
    
    
}

-(void)setKBtype:(KBType)ktype{
    self.ktype = ktype;
    
    if (ktype == KBType_Face) {//表情
        self.keyBoardTypeBtn.selected = YES;
    }else{//键盘
        self.keyBoardTypeBtn.selected = NO;
    }
}





-(FTTextView *)textView{
    if (_textView == nil) {
        _textView = [[FTTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:FFONT_SIZE];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderColor = [UIColor colorWithString:@"#CBCBCB"].CGColor;
        _textView.layer.borderWidth = 0.5 * ScaleX_IP5;
        _textView.layer.cornerRadius = 4.0 * ScaleX_IP5;
        _textView.layer.masksToBounds = YES;
//        _textView.tintColor =[UIColor redColor];//光标颜色

        if (IOS7_OR_LATER) {//光标高度自动
            _textView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        }
        
        
        _textView.clipsToBounds = YES;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度

        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.layoutManager.allowsNonContiguousLayout = NO;//解决界面闪的问题
        _textView.contentInset = UIEdgeInsetsMake(2, 0, 2, 0);
//        _textView.textContainerInset = UIEdgeInsetsMake(2, 0, 2, 0);

        [self addSubview:_textView];
    }
    return _textView;
}


-(UIButton *)keyBoardTypeBtn{
    if (_keyBoardTypeBtn == nil) {
        _keyBoardTypeBtn = [[UIButton alloc] init];
        [_keyBoardTypeBtn setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];//键盘
        [_keyBoardTypeBtn setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];//表情
        
        [self addSubview:_keyBoardTypeBtn];
    }
    return _keyBoardTypeBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
