//
//  CategoryTableViewCell.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/01/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "UILabel+Image.h"
#import "Haneke.h"
#import "NSString+RemovedCharacters.h"

@interface CategoryTableViewCell() {
}

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *adNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *adDateLabel;
@property (nonatomic, strong) NSDictionary *cellInfo;
@property (weak, nonatomic) IBOutlet UIImageView *optionsImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsWidthConstraint;
@property (nonatomic, strong) NSIndexPath *indexpath;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;
@end


@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [[self.optionsButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [self.optionsButton setImage:[UIImage imageNamed:@"dots"] forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithInfo:(NSDictionary *)cellInfo withMyProfile:(BOOL)isMyProfile andIndexpath:(NSIndexPath *)indexpath {
    self.cellInfo = cellInfo;
    self.indexpath = indexpath;
    self.userImageView.contentMode = UIViewContentModeScaleToFill;
    if (self.delegate) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
        [self.userImageView addGestureRecognizer:tapGesture];
        self.userImageView.userInteractionEnabled = YES;
    }
//    self.adImageView
    self.adNameLabel.numberOfLines = 0;
    self.adNameLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [self.adNameLabel sizeToFit];
    self.adNameLabel.text = [NSString removeCharacterFromString:cellInfo[@"titlu"]];
    self.adNameLabel.text = [self.adNameLabel.text stringByAppendingString:@"\n"];
//    self.adCategoryLabel.text = cellInfo[@"data"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    NSString *registeredDateString = [cellInfo objectForKey:@"data"];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *registeredDate = [dateFormatter2 dateFromString:registeredDateString];
    
    [dateFormatter2 setDateFormat:@"dd MMM yyyy"];
    NSString *newDateString = [dateFormatter2 stringFromDate:registeredDate];
    self.adCategoryLabel.text = newDateString;
//    self.adCategoryLabel.text = @"Date";
    if (cellInfo[@"location"]) {
        if ([cellInfo[@"location"] objectForKey:@"titlu"] && [[cellInfo[@"location"] objectForKey:@"titlu"] length]) {
            self.adDateLabel.text = [cellInfo[@"location"] objectForKey:@"titlu"];
        } else {
            self.adDateLabel.text = @"";
        }
    } else {
        self.adDateLabel.text = @"";
    }
    NSDictionary *imageInfo = [cellInfo[@"images"] firstObject];
    NSDictionary *img = [imageInfo objectForKey:@"img"];
    NSURL *url = [NSURL URLWithString:img[@"url"]];
    if (url) {
        [self.adImageView hnk_setImageFromURL:url];
    } else {
        [self.adImageView setImage:[UIImage imageNamed:@"no-image"]];
    }
    self.adImageView.contentMode = UIViewContentModeScaleToFill;
    if (!isMyProfile) {
        self.optionsWidthConstraint.constant = 0;
        [self.optionsImageView removeFromSuperview];
        [self.optionsButton removeFromSuperview];
    }
    if (self.optionsImageView) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionsButtonTapped:)];
        self.optionsImageView.userInteractionEnabled = YES;
        [self.optionsImageView addGestureRecognizer:tapGesture];
    }
    [self layoutIfNeeded];
}

//- (void)optionsButtonTapped:(UITapGestureRecognizer *)tapGesture {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(optionsButtonTapped:andIndexpath:)]) {
//        [self.delegate optionsButtonTapped:tapGesture andIndexpath:self.indexpath];
//    }
//}
- (IBAction)optionsButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(optionsButtonTapped:andIndexpath:)]) {
        [self.delegate optionsButtonTapped:nil andIndexpath:self.indexpath];
    }
}

- (void)userTapped:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(userTappedWithInfo:)]) {
        [self.delegate userTappedWithInfo:self.cellInfo];
    }
}

@end
