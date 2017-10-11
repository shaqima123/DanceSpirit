//
//  DSPMainPageCollectionViewCell.m
//  DanceSpirit
//
//  Created by zj－db0737 on 2017/10/10.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

#import "DSPMainPageCollectionViewCell.h"

@interface DSPMainPageCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation DSPMainPageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
}
@end
