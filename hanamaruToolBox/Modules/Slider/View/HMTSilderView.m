//
//  HMTSilderView.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/3.
//

#import "HMTSilderView.h"
#import "HMTSilderViewCell.h"

@interface HMTSilderView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HMTSilderView


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMTSilderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HMTSliderItem *item = self.items[indexPath.row];
    cell.nameLabel.text = item.name;
    cell.cellSelected = indexPath.row == [self.items indexOfObject:self.selectedItem];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:didSelectedItem:)]) {
        [self.delegate sliderView:self didSelectedItem:self.items[indexPath.item]];
    }
}

#pragma mark - Setter

- (void)setItems:(NSArray<HMTSliderItem *> *)items {
    _items = items;
    [self.tableView reloadData];
}

- (void)setSelectedItem:(HMTSliderItem *)selectedItem {
    _selectedItem = selectedItem;
    [self.tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
