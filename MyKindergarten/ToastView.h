//
//  ToastView.h
//  Mtec
//
//  Created by ChangJiang on 12-10-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView
{
    
}

+(void)showInView:(UIView *)superView withText:(NSString*)text duration:(int)duration;

@end
