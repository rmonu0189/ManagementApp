//
//  DashboardTableViewCell.h
//  Insurance
//
//  Created by MonuRathor on 18/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgTypeLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblQuetsFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblValueFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblQuotesSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblValueSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblQoutesThird;
@property (weak, nonatomic) IBOutlet UILabel *lblValueThird;
@property (weak, nonatomic) IBOutlet UILabel *lblQoutesFourth;
@property (weak, nonatomic) IBOutlet UILabel *lblValueFourth;

@end
