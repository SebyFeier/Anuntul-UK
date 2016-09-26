//
//  CategoryTableViewCell.h
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AdsDelegate <NSObject>

- (void)userTappedWithInfo:(NSDictionary *)userInfo;
- (void)optionsButtonTapped:(UITapGestureRecognizer *)tapGesture andIndexpath:(NSIndexPath *)indexpath;

@end

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AdsDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *featuredImageView;
- (void)updateCellWithInfo:(NSDictionary *)cellInfo withMyProfile:(BOOL)isMyProfile andIndexpath:(NSIndexPath *)indexpath;

@end
