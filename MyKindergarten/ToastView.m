//
//  ToastView.m
//  Mtec
//
//  Created by ChangJiang on 12-10-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ToastView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ToastView

static ToastView *toastView;
static UILabel *label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        toastView = self;   
        toastView.alpha = 0;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 1;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//-(void)dealloc
//{
//    [label release];
//    [super dealloc];
//}

-(void)timerCalled:(NSTimer*)timer
{
    [timer invalidate];
        
    [UIView animateWithDuration:0.3 animations:^{
        toastView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+(void)showInView:(UIView *)superView withText:(NSString*)text duration:(int)duration
{
    if( toastView == nil )
    {   
        toastView = [[ToastView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    }
    
    label.text = text;
    [label sizeToFit];
    
    int addedValue = 30;
    CGSize toastViewSize = CGSizeMake(label.frame.size.width + addedValue, label.frame.size.height + addedValue);
    
    toastView.frame = CGRectMake((CGRectGetWidth(superView.bounds) - toastViewSize.width)/2, (CGRectGetHeight(superView.bounds) - toastViewSize.height)/2, toastViewSize.width, toastViewSize.height);
    label.center = CGPointMake(toastViewSize.width/2, toastViewSize.height/2);
        
    [UIView animateWithDuration:0.3 animations:^{
        [superView addSubview:toastView];
        toastView.alpha = 1.0;
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:duration target:toastView selector:@selector(timerCalled:) userInfo:nil repeats:NO];
};




@end
