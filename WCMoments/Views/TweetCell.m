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

#define IMAGE_PENDING 4

#define MAX_IMAGE_PER_ROW 3


@interface TweetCell ()

@property (nonatomic, strong) UIImageView *imgViewAvatar;
@property (nonatomic, strong) UILabel *lblNick;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imageViewsList;

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
    self.images = [tweet.images allObjects];
    
    // first: clean all imageViews
    [self cleanAllImageViews];
    if (tweet.images.count > 0 )
    {
        // add
        NSMutableArray *newImageViewList = [NSMutableArray array];
        for (Media *meida in [tweet.images allObjects])
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:imageView];
            [newImageViewList addObject:imageView];
            [imageView setImageWithURL:[NSURL URLWithString:meida.imageURL]];
        }
        
        self.imageViewsList = newImageViewList;
    }
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
    if (tweet.images.count == 1)
    {
        CGFloat imageLength = ceil(contentWidth / 2);
        totalHeight += (PENDING + imageLength);
        
    }
    else if (tweet.images.count > 1 && tweet.images.count <= 9)
    {
        CGFloat imageLength = floor((contentWidth - PENDING * (MAX_IMAGE_PER_ROW - 1)) / MAX_IMAGE_PER_ROW);
        NSInteger totalImages = tweet.images.count;
        CGFloat totalLineOfImage = totalImages / MAX_IMAGE_PER_ROW + (totalImages % 3 == 0 ? 0 :1);
        totalHeight += totalLineOfImage * imageLength + (totalLineOfImage - 1) * PENDING;
    }
    
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
    CGFloat totalHeight = 0;
    
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
    totalHeight += LABEL_NICK_HEIGHT;
    
    // set content label
    CGRect lblContentFrame = CGRectZero;
    lblContentFrame.origin.x = contentOrigin.x;
    lblContentFrame.origin.y = lblNickFrame.origin.y + PENDING + lblNickFrame.size.height;
    lblContentFrame.size.width = contentWidth;
    lblContentFrame.size.height = [UISettingUtility getLabelHeightWithLabel:self.lblContent];
    self.lblContent.frame = lblContentFrame;
    totalHeight += (PENDING + lblContentFrame.size.height);
    
    // set images
    if (self.imageViewsList.count == 1)
    {
        UIImageView *imageView = [self.imageViewsList firstObject];
        
        CGRect imageFrame = CGRectZero;
        imageFrame.origin.x = contentOrigin.x;
        imageFrame.origin.y = lblContentFrame.origin.y + lblContentFrame.size.height + PENDING;
        CGFloat imageLength = ceil(contentWidth / 2);
        imageFrame.size.width = imageLength;
        imageFrame.size.height = imageLength;
        imageView.frame = imageFrame;
        
        totalHeight += (PENDING + imageLength);
        
    }
    else if (self.imageViewsList.count > 1 && self.imageViewsList.count <= 9)
    {
        CGFloat imageLength = floor((contentWidth - PENDING * (MAX_IMAGE_PER_ROW - 1)) / MAX_IMAGE_PER_ROW);
        CGFloat imagesStartingY = lblContentFrame.origin.y + lblContentFrame.size.height + PENDING;
        NSInteger totalImages = self.imageViewsList.count;
        for (int i = 0; i < totalImages; i++)
        {
            CGRect imageFrame = CGRectZero;
            imageFrame.origin.x = contentOrigin.x + (i % MAX_IMAGE_PER_ROW) * (imageLength + PENDING);
            imageFrame.origin.y = imagesStartingY + (i / MAX_IMAGE_PER_ROW) * (imageLength + PENDING);
            imageFrame.size.width = imageLength;
            imageFrame.size.height = imageLength;
            UIImageView *imageView = [self.imageViewsList objectAtIndex:i];
            imageView.frame = imageFrame;
        }
        
        CGFloat totalLineOfImage = totalImages / MAX_IMAGE_PER_ROW + (totalImages % 3 == 0 ? 0 :1);
        totalHeight += totalLineOfImage * imageLength + (totalLineOfImage - 1) * PENDING;
    }
    else
    {
        [self cleanAllImageViews];
    }
    
    // set comments
    
    // set content view frame
    cellFrame.size.height = totalHeight < AVATAR_IMAGE_LENGTH ? AVATAR_IMAGE_LENGTH : totalHeight;
    cellFrame.size.height += TWEEET_TOP_BOTTOM_PENDING * 2;
    self.contentView.frame = cellFrame;
}

- (void)cleanAllImageViews
{
    for (UIImageView *imageView in self.imageViewsList) {
        [imageView removeFromSuperview];
    }
    self.imageViewsList = nil;
}

@end