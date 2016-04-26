//
//  BlogTableViewCell.m
//  Anuntul de UK
//
//  Created by Seby Feier on 30/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "BlogTableViewCell.h"
#import "Haneke.h"

@interface BlogTableViewCell() {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleName;
@property (weak, nonatomic) IBOutlet UILabel *articleAuthor;

@end

@implementation BlogTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithInfo:(NSDictionary *)cellInfo {
    self.articleName.text = cellInfo[@"title"];
    self.articleAuthor.text = cellInfo[@"meta_description"];
    if ([cellInfo[@"image"] length]) {
        [self.articleImage hnk_setImageFromURL:[NSURL URLWithString:cellInfo[@"image"]]];
    } else {
        [self.articleImage setImage:[UIImage imageNamed:@"no-image"]];
    }
    
}

@end
