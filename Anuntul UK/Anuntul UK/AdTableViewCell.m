//
//  AdTableViewCell.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "AdTableViewCell.h"

@interface AdTableViewCell() {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@end

@implementation AdTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithInfo:(NSDictionary *)cellInfo {
//    self.categoryImageView
    self.categoryName.text = cellInfo[@"categoryName"];
}

@end
