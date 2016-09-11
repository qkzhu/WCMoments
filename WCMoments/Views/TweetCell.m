//
//  TweetCell.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "UISettingUtility.h"
#import "Tweet.h"
#import "User.h"
#import "Media.h"
#import "TweetComment.h"

// constant and configuration
#define TWEEET_TOP_BOTTOM_PENDING 20
#define AVATAR_IMAGE_LENGTH 50
#define PENDING 8

#define LABEL_NICK_HEIGHT 21
#define LABEL_TRAILING 8


@interface TweetCell ()

@property (nonatomic, strong) UIImageView *imgViewAvatar;
@property (nonatomic, strong) UILabel *lblNick;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) NSArray *images;

@end


@implementation TweetCell

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupViews];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateFramesWithCellFrame:self.contentView.frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public
- (void)setupWithData:(Tweet *)tweet
{
    [self.imgViewAvatar setImageWithURL:[NSURL URLWithString:tweet.sender.avatar.imageURL]];
    self.lblNick.text = tweet.sender.nick ? tweet.sender.nick : tweet.sender.username;
    self.lblContent.text = tweet.content;
}

+ (CGFloat)getCellHeightWithData:(Tweet *)tweet withContentWidth:(CGFloat)ctWidth
{
    CGFloat totalHeight = 0;
    CGFloat contentWidth = ctWidth - PENDING * 2 - AVATAR_IMAGE_LENGTH - PENDING;
    
    // add height for nick name
    totalHeight += LABEL_NICK_HEIGHT;
    
    // add height for content
    CGFloat contentLabelHeight = [UISettingUtility getLabelHeightWithLabelWidth:contentWidth
                                                                     contentStr:tweet.content
                                                                      labelFont:[UISettingUtility contentFont]];
    
    totalHeight += (PENDING + contentLabelHeight);
    
    // set images
    
    // set comments
    
    if (totalHeight < AVATAR_IMAGE_LENGTH)
        totalHeight = AVATAR_IMAGE_LENGTH;
    
    totalHeight += TWEEET_TOP_BOTTOM_PENDING * 2;
    
    return totalHeight;
}

#pragma mark - Lazy
- (UIImageView *)imgViewAvatar
{
    if (!_imgViewAvatar)
    {
        _imgViewAvatar = [[UIImageView alloc] init];
        _imgViewAvatar.contentMode = UIViewContentModeScaleToFill;
        _imgViewAvatar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _imgViewAvatar;
}

- (UILabel *)lblNick
{
    if (!_lblNick)
    {
        _lblNick = [[UILabel alloc] init];
        _lblNick.textColor = [UISettingUtility profileNickNameColor];
        _lblNick.font = [UISettingUtility profileNickNameFont];
        _lblNick.numberOfLines = 1;
    }
    
    return _lblNick;
}

- (UILabel *)lblContent
{
    if (!_lblContent)
    {
        _lblContent = [[UILabel alloc] init];
        _lblContent.font = [UISettingUtility contentFont];
        _lblContent.textColor = [UISettingUtility contentColor];
        _lblContent.numberOfLines = 0;
    }
    
    return _lblContent;
}

#pragma mark - Private
- (void)setupViews
{
    [self.contentView addSubview:self.imgViewAvatar];
    [self.contentView addSubview:self.lblNick];
    [self.contentView addSubview:self.lblContent];
}

- (void)updateFramesWithCellFrame:(CGRect)cellFrame
{
    // setup avatar
    CGRect avatarImageFrame = CGRectMake(PENDING, TWEEET_TOP_BOTTOM_PENDING, AVATAR_IMAGE_LENGTH, AVATAR_IMAGE_LENGTH);
    self.imgViewAvatar.frame = avatarImageFrame;
    
    // content part
    CGFloat contentWidth = cellFrame.size.width - PENDING * 2 - AVATAR_IMAGE_LENGTH - PENDING;
    CGPoint contentOrigin = CGPointMake(PENDING + AVATAR_IMAGE_LENGTH + PENDING, TWEEET_TOP_BOTTOM_PENDING);
    
    // set nick label
    CGRect lblNickFrame = CGRectMake(0, 0, contentWidth, LABEL_NICK_HEIGHT);
    lblNickFrame.origin = contentOrigin;
    self.lblNick.frame = lblNickFrame;
    
    // set content label
    CGRect lblContentFrame = CGRectZero;
    lblContentFrame.origin.x = contentOrigin.x;
    lblContentFrame.origin.y = lblNickFrame.origin.y + PENDING + lblNickFrame.size.height;
    lblContentFrame.size.width = contentWidth;
    lblContentFrame.size.height = [UISettingUtility getLabelHeightWithLabel:self.lblContent];
    self.lblContent.frame = lblContentFrame;
    
    // set images
    
    // set comments
    
    // set content view frame
    CGFloat totalHeight = LABEL_NICK_HEIGHT + PENDING + lblContentFrame.size.height;
    cellFrame.size.height = totalHeight < AVATAR_IMAGE_LENGTH ? AVATAR_IMAGE_LENGTH : totalHeight;
    cellFrame.size.height += TWEEET_TOP_BOTTOM_PENDING * 2;
    self.contentView.frame = cellFrame;
}

@end