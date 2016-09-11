//
//  TweetCell.h
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface TweetCell : UITableViewCell

- (void)setupWithData:(Tweet *)tweet;
+ (CGFloat)getCellHeightWithData:(Tweet *)tweet withContentWidth:(CGFloat)ctWidth;
@end