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
@property (nonatomic, strong) UILabel *lblComments;
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
    
    // images
    [self cleanAllImageViews];
    if (tweet.images.count > 0 )
    {
        NSMutableArray *newImageViewList = [NSMutableArray array];
        for (Media *meida in [tweet.images allObjects])
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:imageView];
            [newImageViewList addObject:imageView];
            [imageView setImageWithURL:[NSURL URLWithString:meida.imageURL] placeholderImage:[UIImage imageNamed:@"place_holder"]];
        }
        
        self.imageViewsList = newImageViewList;
    }
    
    // comments
    [self cleanAllComments];
    if (tweet.comments.count > 0)
    {
        self.lblComments.text = [TweetCell mergeAllComments:tweet];
        [self.contentView addSubview:self.lblComments];
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
        totalHeight += (totalLineOfImage * imageLength + (totalLineOfImage - 1) * IMAGE_PENDING + PENDING);
    }
    
    // set comments
    if (tweet.comments.count > 0)
    {
        NSString *allComments = [self mergeAllComments:tweet];
        CGFloat contentLabelHeight = [UISettingUtility getLabelHeightWithLabelWidth:contentWidth
                                                                         contentStr:allComments
                                                                          labelFont:[UISettingUtility contentFont]];
        totalHeight += (PENDING + contentLabelHeight);
    }
    
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

- (UILabel *)lblComments
{
    if (!_lblComments)
    {
        _lblComments = [[UILabel alloc] init];
        _lblComments.font = [UISettingUtility contentFont];
        _lblComments.textColor = [UISettingUtility contentColor];
        _lblComments.numberOfLines = 0;
    }
    
    return _lblComments;
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
    lblContentFrame.origin.y = lblNickFrame.origin.y + totalHeight + PENDING;
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
        imageFrame.origin.y = contentOrigin.y + totalHeight + PENDING;
        CGFloat imageLength = ceil(contentWidth / 2);
        imageFrame.size.width = imageLength;
        imageFrame.size.height = imageLength;
        imageView.frame = imageFrame;
        
        totalHeight += (PENDING + imageLength);
    }
    else if (self.imageViewsList.count > 1 && self.imageViewsList.count <= 9)
    {
        CGFloat imageLength = floor((contentWidth - IMAGE_PENDING * (MAX_IMAGE_PER_ROW - 1)) / MAX_IMAGE_PER_ROW);
        CGFloat imagesStartingY = contentOrigin.y + totalHeight + PENDING;
        NSInteger totalImages = self.imageViewsList.count;
        for (int i = 0; i < totalImages; i++)
        {
            CGRect imageFrame = CGRectZero;
            imageFrame.origin.x = contentOrigin.x + (i % MAX_IMAGE_PER_ROW) * (imageLength + IMAGE_PENDING);
            imageFrame.origin.y = imagesStartingY + (i / MAX_IMAGE_PER_ROW) * (imageLength + IMAGE_PENDING);
            imageFrame.size.width = imageLength;
            imageFrame.size.height = imageLength;
            UIImageView *imageView = [self.imageViewsList objectAtIndex:i];
            imageView.frame = imageFrame;
        }
        
        CGFloat totalLineOfImage = totalImages / MAX_IMAGE_PER_ROW + (totalImages % 3 == 0 ? 0 :1);
        totalHeight += (totalLineOfImage * imageLength + (totalLineOfImage - 1) * IMAGE_PENDING + PENDING);
    }
    else
    {
        [self cleanAllImageViews];
    }
    
    // set comments
    if (self.lblComments.text.length > 0)
    {
        if (!self.lblComments.superview)
        {
            [self.contentView addSubview:self.lblComments];
        }
        else if (![self.lblComments.superview isKindOfClass:[self class]])
        {
            [self.lblComments removeFromSuperview];
            [self.contentView addSubview:self.lblComments];
        }
        
        CGRect commentLabelFrame = CGRectZero;
        commentLabelFrame.origin.x = contentOrigin.x;
        commentLabelFrame.origin.y = contentOrigin.y + totalHeight + PENDING;
        commentLabelFrame.size.width = contentWidth;
        commentLabelFrame.size.height = [UISettingUtility getLabelHeightWithLabel:self.lblComments];
        self.lblComments.frame = commentLabelFrame;
        totalHeight += (PENDING + commentLabelFrame.size.height);
    }
    else
    {
        [self cleanAllComments];
    }
    
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

- (void)cleanAllComments
{
    self.lblComments.text = nil;
    [self.lblComments removeFromSuperview];
}

+ (NSString *)mergeAllComments:(Tweet *)tweet
{
    //TODO: to add different color for sender name
    /*
    NSDictionary *senderNameAttribute = [NSDictionary dictionaryWithObject:[UISettingUtility profileNickNameColor]
                                                                    forKey:NSForegroundColorAttributeName];
    NSDictionary *contentAttribute = [NSDictionary dictionaryWithObject:[UISettingUtility contentColor]
                                                                 forKey:NSForegroundColorAttributeName];

    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:@""];
     */
    
    NSMutableString *labelText = [NSMutableString stringWithString:@""];
    NSString *senderName;
    for (TweetComment *comment in tweet.comments)
    {
        senderName = comment.sender.nick ? comment.sender.nick : comment.sender.username;
        if (labelText.length > 0)
        {
            [labelText appendFormat:@"\n%@: %@", senderName, comment.content];
        }
        else
        {
            [labelText appendFormat:@"%@: %@", senderName, comment.content];
        }
    }
    
    return labelText;
}

@end