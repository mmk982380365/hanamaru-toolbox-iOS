//
//  HMTSingleSongLayout.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/4.
//

#import "HMTSingleSongLayout.h"

@interface HMTSingleSongLayout ()

@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *cellAttributes;

@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *headerAttributes;

@property (assign, nonatomic) CGFloat totalHeight;

@end

@implementation HMTSingleSongLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _column = 3;
        self.sectionInset = UIEdgeInsetsMake(8, 0, 8, 0);
        self.minimumLineSpacing = 8;
        self.minimumInteritemSpacing = 8;
    }
    return self;
}

- (void)prepareLayout {
    [self.cellAttributes removeAllObjects];
    [self.headerAttributes removeAllObjects];
    
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    
    CGFloat totalHeight = 0;
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        
        CGFloat height = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(layout:heightForHeaderWithIndexPath:)]) {
            height = [self.delegate layout:self heightForHeaderWithIndexPath:headerIndexPath];
        }
        
        if (height > 0) {
            UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
            headerAttributes.frame = CGRectMake(0, totalHeight, self.collectionView.frame.size.width, height);
            self.headerAttributes[headerIndexPath] = headerAttributes;
            
            totalHeight += CGRectGetMaxY(headerAttributes.frame);
        }
        
        CGFloat *heights = calloc(1, sizeof(CGFloat) * self.column);
//        memset(heights, totalHeight, sizeof(CGFloat) * self.column);
        for (int i = 0; i < self.column; i++) {
            heights[i] = totalHeight + self.sectionInset.top;
        }
        
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < numberOfItemsInSection; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            
            CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * (self.column - 1)) / self.column;
            
            CGFloat height = 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(layout:heightForCellWithIndexPath:width:)]) {
                height = [self.delegate layout:self heightForCellWithIndexPath:indexPath width:width];
            }
            
            // min
            
            int minIndex = 0;
            CGFloat minValue = heights[0];
            
            for (int i = 1; i < self.column; i++) {
                if (heights[i] < minValue) {
                    minValue = heights[i];
                    minIndex = i;
                }
            }
            
            CGRect frame = CGRectZero;
            frame.size.width = width;
            frame.size.height = height;
            frame.origin.x = self.sectionInset.left + (width + self.minimumInteritemSpacing) * minIndex;
            frame.origin.y = minValue;
            
            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            layoutAttributes.frame = frame;
            
            self.cellAttributes[indexPath] = layoutAttributes;
            
            
            heights[minIndex] = CGRectGetMaxY(frame) + self.minimumLineSpacing;
        }
        
        CGFloat maxValue = heights[0];
        for (int i = 1; i < self.column; i++) {
            if (heights[i] > maxValue) {
                maxValue = heights[i];
            }
        }
        
        maxValue -= self.minimumLineSpacing;
        
        totalHeight = maxValue + self.sectionInset.bottom;
        
        free(heights);
    }
    self.totalHeight = totalHeight;
    
}

- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    size.height = self.totalHeight;
    return size;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:0];
    [self.headerAttributes enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UICollectionViewLayoutAttributes * _Nonnull obj, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [attributes addObject:obj];
        }
    }];
    [self.cellAttributes enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UICollectionViewLayoutAttributes * _Nonnull obj, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [attributes addObject:obj];
        }
    }];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellAttributes[indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return self.headerAttributes[indexPath];
}

- (NSMutableDictionary<NSIndexPath *,UICollectionViewLayoutAttributes *> *)cellAttributes {
    if (!_cellAttributes) {
        _cellAttributes = [NSMutableDictionary dictionary];
    }
    return _cellAttributes;
}

- (NSMutableDictionary<NSIndexPath *,UICollectionViewLayoutAttributes *> *)headerAttributes {
    if (!_headerAttributes) {
        _headerAttributes = [NSMutableDictionary dictionary];
    }
    return _headerAttributes;
}

@end
