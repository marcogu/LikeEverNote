//
//  MenuSectionReciverCell.m
//  kindergarten
//
//  Created by 颖炯 顾 on 12-9-28.
//  Copyright (c) 2012年 宁波爱班信息技术有限公司. All rights reserved.
//

#import "MenuSectionReciverCell.h"
//#import "Reciver.h"
#import "ReciverVo.h"

@implementation MenuSectionReciverCell

@synthesize reciverAvatar, reciverName, groupLogoView, reciverRole;

-(void)dealloc{
    [_dataValue release];
    [super dealloc];
}

#pragma mark - private

-(TTStyle*)createGroupLogoStyle:(UIColor*)color
{
    TTStyle* newStyle = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:11] next:

                          [TTSolidFillStyle styleWithColor:color next:nil]];
    return newStyle;
}

-(TTStyle*)recviverCellStyle:(UIColor*)clr{
    TTTextStyle* tstyle = [TTTextStyle styleWithFont:[UIFont systemFontOfSize:14] next:nil];
    tstyle.numberOfLines = 1;
    tstyle.lineBreakMode = UILineBreakModeTailTruncation;
    tstyle.textAlignment = UITextAlignmentLeft;
    if (clr!=nil) {
        tstyle.color = clr;
    }
    return tstyle;
}

#pragma mark - public

-(TTView*)groupLogoView
{
    if(!groupLogoView)
    {
        groupLogoView = [[TTView alloc] init];
        groupLogoView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:groupLogoView];
        [groupLogoView release];
    }
    return groupLogoView;
}

-(TTImageView*)reciverAvatar
{
    if (!reciverAvatar)
    {
        reciverAvatar = [[TTImageView alloc] init];
        reciverAvatar.style = TTSTYLE(roundAvatar);
        reciverAvatar.backgroundColor = [UIColor clearColor];
        reciverAvatar.defaultImage = TTIMAGE(@"bundle://defaultAvatar.png");
        [self.contentView addSubview:reciverAvatar];
        [reciverAvatar release];
    }
    return reciverAvatar;
}

-(TTLabel*)reciverName
{
    if (!reciverName)
    {
        reciverName = [[TTLabel alloc] init];
        reciverName.style = [self recviverCellStyle:nil];//TTSTYLE(recviverCellStyle);
        reciverName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:reciverName];
        [reciverName release];
    }
    return reciverName;
}

-(TTLabel*)reciverRole{
    if (!reciverRole) {
        reciverRole = [[TTLabel alloc] init];
        reciverRole.style = [self recviverCellStyle:[UIColor grayColor]];
        reciverRole.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:reciverRole];
        [reciverRole release];
    }
    return reciverRole;
}

#pragma mark - override tttablecell method

-(void)setObject:(id)valueObj{
    if (_dataValue!= valueObj)
    {
        [_dataValue release];
        _dataValue = (Reciver*)[valueObj retain];
        
        [self.groupLogoView setHidden:(!_dataValue.isGroup)];
        [self.reciverAvatar setHidden:_dataValue.isGroup];
        
        self.reciverName.text = _dataValue.reciverName;
        self.reciverAvatar.urlPath = _dataValue.avatar;
        if (_dataValue.isGroup)
        {
            UIColor* newColr = RGBCOLOR([_dataValue.r floatValue], [_dataValue.g floatValue], [_dataValue.b floatValue]);
            self.groupLogoView.style = [self createGroupLogoStyle:newColr];
            self.reciverRole.text = @"群组";
        }else{
            self.reciverRole.text = @"用户";
        }
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(id)object
{
    return _dataValue;
}

-(void)layoutSubviews
{
    [super layoutSubviews];  
    [reciverName sizeToFit];
        if (self.sectionTypeForRow == MenuSectionRowTypeContent)
        {
            groupLogoView.frame = reciverAvatar.frame = CGRectMake(40, 5, 30, 30);
            reciverName.frame = CGRectMake(80, 4, 200, 20);
            reciverRole.frame = CGRectMake(80, 24, 200, 15);
        }
        else
        {
            groupLogoView.frame = reciverAvatar.frame = CGRectMake(20, 5, 30, 30);
            reciverName.frame = CGRectMake(60, 4, 200, 20);
            reciverRole.frame = CGRectMake(60, 24, 200, 15);
        }
}
@end
