//
//  UILabel+Image.m
//  Anuntul de UK
//
//  Created by Seby Feier on 15/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "UILabel+Image.h"

@implementation UILabel (Image)

- (UILabel *)createLabelWithImage:(NSString *)imageName andTitle:(NSString *)title {
    NSTextAttachment *attachmentImage = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attachmentImage.image = [UIImage imageNamed:imageName];
    attachmentImage.bounds = CGRectMake(0, -3, 10, 16);
    
//    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachmentImage];
//    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:title];
//    [titleString appendAttributedString:attachmentString];
//    self.attributedText = titleString;
//    
//    return self;
    NSAttributedString *attachmentString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title ]];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachmentImage]];
    [titleString appendAttributedString:attachmentString];
    self.attributedText = titleString;
    
    return self;

}

@end
