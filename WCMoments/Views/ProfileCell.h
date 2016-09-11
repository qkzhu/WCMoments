//
//  ProfileCell.h
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface ProfileCell : UITableViewCell
- (void)setupWithData:(User *)user;
+ (CGFloat)getCellHeight;
@end