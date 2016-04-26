//
//  UIColor+CustomColor.h
//  Anuntul de UK
//
//  Created by Seby Feier on 14/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CustomColor)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end
