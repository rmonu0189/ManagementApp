//
//  RequestConnection.h
//  RenewalReminder
//
//  Created by MonuRathor on 25/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestConnectionDelegate <NSObject>

- (void)requestResultSuccess:(id)response andError:(NSError *)error;

@end

@interface RequestConnection : NSObject
{
    __weak id<RequestConnectionDelegate> delegate;
}
@property (nonatomic, weak) id<RequestConnectionDelegate> delegate;

/**
 *  Method to use login user
 */
- (void)loginUser:(NSString *)email
         Password:(NSString *)password;
- (void)getRecordByDate:(NSString *)date;
- (void)getRecordByDate:(NSString *)date Category:(NSString *)category andPage:(int)page;

@end
