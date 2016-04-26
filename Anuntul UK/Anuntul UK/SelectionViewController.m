//
//  SelectionViewController.m
//  Anuntul de UK
//
//  Created by Seby Feier on 25/03/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "SelectionViewController.h"

@interface SelectionViewController()<UITableViewDataSource, UITableViewDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
//    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionTableViewCellIdentifier"];
    }
    NSDictionary *selection = [self.allSelections objectAtIndex:indexPath.row];
    cell.textLabel.text = [selection objectForKey:@"titlu"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *selection = [self.allSelections objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectionDidSelect:)]) {
        [self.delegate selectionDidSelect:selection];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allSelections.count;
}


@end
