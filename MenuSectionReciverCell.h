//
//  MenuSectionReciverCell.h
//  kindergarten
//
//  Created by 颖炯 顾 on 12-9-28.
//  Copyright (c) 2012年 宁波爱班信息技术有限公司. All rights reserved.
//

#import "Three20/Three20.h"
#import "IcMenuTableSection.h"

@protocol MenuSectionReciverCellDelegate;
@class Reciver;

@interface MenuSectionReciverCell : TTTableViewCell{
    Reciver* _dataValue;
    id       _delegate;
}
@property(nonatomic, readonly) TTImageView *reciverAvatar;
@property(nonatomic, readonly) TTLabel     *reciverName;
@property(nonatomic, readonly) TTView      *groupLogoView;
@property(nonatomic, readonly) TTLabel     *reciverRole;

@property(nonatomic)MenuSectionRowType sectionTypeForRow;
@end

//@protocol MenuSectionReciverCellDelegate <NSObject>
//-(void)setCellBackground:(MenuSectionReciverCell*)cell delegate:(id)delegate;
//@end