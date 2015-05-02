//
//  MasterCell.h
//  Google News RSS
//
//  Created by Yecheng Li on 02/11/15.
//  Copyright (c) 2015 Yecheng Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemDate;
@property (weak, nonatomic) IBOutlet UILabel *itemSnippet;

@end
