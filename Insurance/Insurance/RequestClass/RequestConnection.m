//
//  RequestConnection.m
//  RenewalReminder
//
//  Created by MonuRathor on 25/01/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import "RequestConnection.h"

//-- Local server
//#define SERVER @"http://localhost:8888/insurance/mobile.php"

//-- Live server
#define SERVER @"http://www.premiumsaver.co.uk/mobile/mobile.php"

@interface RequestConnection ()
{
    NSOperationQueue *queue;
}
@end

@implementation RequestConnection
@synthesize delegate;

/**
 *  Method to use login user
 */
- (void)loginUser:(NSString *)email
         Password:(NSString *)password{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"LOGIN" forKeyPath:@"action"];
    [param setValue:password forKeyPath:@"password"];
    [param setValue:email forKeyPath:@"email"];
    [self makePostRequestWithParam:param];
    
}

- (void)getRecordByDate:(NSString *)date{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GET_RECORD" forKeyPath:@"action"];
    [param setValue:date forKeyPath:@"str_date"];
    [self makePostRequestWithParam:param];
}

- (void)getRecordByDate:(NSString *)date Category:(NSString *)category andPage:(int)page{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"GET_RECORD_BY_PRODUCT" forKeyPath:@"action"];
    [param setValue:category forKey:@"product"];
    [param setValue:date forKeyPath:@"str_date"];
    [param setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [self makePostRequestWithParam:param];
}

- (void)makePostRequestWithParam:(NSDictionary *)param{
    NSString *parameterString = @"";
    for (NSString *aKey in [param allKeys]) {
        parameterString = [parameterString stringByAppendingFormat:@"&%@=%@",aKey,[param valueForKey:aKey]];
    }
    NSData *postData = [parameterString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:SERVER]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [self startConnection:request];
}

- (void)startConnection:(NSURLRequest *)request{
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if (!connectionError) {
            [self performSelectorOnMainThread:@selector(connectionSuccess:) withObject:data waitUntilDone:NO];
        }
        else{
            [self performSelectorOnMainThread:@selector(connectionError:) withObject:connectionError waitUntilDone:NO];
        }
    }];
}

- (void)connectionSuccess:(id)data{
    NSError *jsonError = nil;
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (!jsonError) {
        if ([[jsonResponse valueForKey:@"status"] boolValue] == YES) {
            if ([self.delegate respondsToSelector:@selector(requestResultSuccess:andError:)]) {
                [self.delegate requestResultSuccess:jsonResponse andError:nil];
            }
        }
        else{
            NSError *error = [[NSError alloc] initWithDomain:@"RESPONSE_ERROR" code:1001 userInfo:@{NSLocalizedDescriptionKey:[jsonResponse valueForKey:@"message"]}];
            if ([self.delegate respondsToSelector:@selector(requestResultSuccess:andError:)]) {
                [self.delegate requestResultSuccess:nil andError:error];
            }
        }
    }
    else{
        NSError *error = [[NSError alloc] initWithDomain:@"JSON_PARSING_ERROR" code:1002 userInfo:@{NSLocalizedDescriptionKey:@"Error to parsing response data."}];
        if ([self.delegate respondsToSelector:@selector(requestResultSuccess:andError:)]) {
            [self.delegate requestResultSuccess:nil andError:error];
        }
    }
}

- (void)connectionError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(requestResultSuccess:andError:)]) {
        [self.delegate requestResultSuccess:nil andError:error];
    }
}

@end
