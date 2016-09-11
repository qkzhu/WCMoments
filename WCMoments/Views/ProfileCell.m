//
//  ProfileCell.m
//  WCMoments
//
//  Created by QianKun on 10/9/16.
//  Copyright © 2016 QianKun. All rights reserved.
//

#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "UISettingUtility.h"
#import "User.h"
#import "Media.h"

#define DEFAULT_NICK @"Undefined"

#define PROFILE_IMAGE_HEIGHT 250

#define AVATAR_IMAGE_LENGTH 100
#define AVATAR_OFFSET_PROFILE_IMAGE 30
#define AVATAR_TRAILING 10

#define LABEL_NICK_HEIGHT 21
#define LABEL_TRAILING 8

#define SELF_PENDDING_BOTTOM 20


@interface ProfileCell ()

@property (nonatomic, strong) UIImageView *imgViewProfile;
@property (nonatomic, strong) UIImageView *imgViewAvatar;
@property (nonatomic, strong) UILabel *lblNick;

@end


@implementation ProfileCell

#pragma mark - Life Cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Public
- (void)setupWithData:(User *)user
{
    [self.imgViewProfile setImageWithURL:[NSURL URLWithString:user.profieImage.imageURL]];
    //    [self.imgViewProfile setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"testImg"]];
    [self.imgViewAvatar setImageWithURL:[NSURL URLWithString:user.avatar.imageURL]];
    self.lblNick.text = user.nick ? user.nick : DEFAULT_NICK;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateFramesWithCellFrame:self.contentView.frame];
}

+ (CGFloat)getCellHeight
{
    return PROFILE_IMAGE_HEIGHT + AVATAR_OFFSET_PROFILE_IMAGE + 20;
}

#pragma mark - Lazy
- (UIImageView *)imgViewProfile
{
    if (!_imgViewProfile)
    {
        _imgViewProfile = [[UIImageView alloc] init];
        _imgViewProfile.contentMode = UIViewContentModeScaleToFill;
        _imgViewProfile.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _imgViewProfile;
}

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
        _lblNick.numberOfLines = 1;
    }
    
    return _lblNick;
}

#pragma mark - Private
- (void)setupViews
{
    [self.contentView addSubview:self.imgViewProfile];
    [self.contentView addSubview:self.imgViewAvatar];
    [self.contentView addSubview:self.lblNick];
}

- (void)updateFramesWithCellFrame:(CGRect)cellFrame
{
    // set profile image
    CGRect profileImageFrame = cellFrame;
    profileImageFrame.size.height = PROFILE_IMAGE_HEIGHT;
    self.imgViewProfile.frame = profileImageFrame;
    
    // set avater image
    CGRect avatarImageFrame = CGRectMake(0, 0, AVATAR_IMAGE_LENGTH, AVATAR_IMAGE_LENGTH);
    avatarImageFrame.origin.x = cellFrame.size.width - AVATAR_TRAILING - AVATAR_IMAGE_LENGTH;
    avatarImageFrame.origin.y = profileImageFrame.size.height - AVATAR_IMAGE_LENGTH + AVATAR_OFFSET_PROFILE_IMAGE;
    self.imgViewAvatar.frame = avatarImageFrame;
    
    // set nick label
    CGSize textSize = [self.lblNick.text sizeWithAttributes:@{NSFontAttributeName:[self.lblNick font]}];
    CGFloat labelWidth = ceil(textSize.width);
    CGRect lblNickFrame = CGRectMake(0, 0, labelWidth, LABEL_NICK_HEIGHT);
    lblNickFrame.origin.x = avatarImageFrame.origin.x - LABEL_TRAILING - labelWidth;
    lblNickFrame.origin.y = avatarImageFrame.origin.y + AVATAR_IMAGE_LENGTH / 2 - LABEL_NICK_HEIGHT/2;
    self.lblNick.frame = lblNickFrame;
    
    // set content view frame
    cellFrame.size.height = profileImageFrame.size.height + AVATAR_OFFSET_PROFILE_IMAGE + SELF_PENDDING_BOTTOM;
    self.contentView.frame = cellFrame;
}

@end