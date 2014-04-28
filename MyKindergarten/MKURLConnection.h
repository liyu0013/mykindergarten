//
//  YOZURLConnection.h
//  OneDict
//
//  Created by XXX on 22/04/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability;

@protocol MKURLConnectionDelegate<NSObject>

- (void)noConnection;
- (void)suggestionsReturned:(NSMutableArray *)data;
- (void)detailsReturned:(NSMutableData *)data;

@end

@interface MKURLConnection : NSObject<NSXMLParserDelegate>

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (strong, nonatomic) NSMutableData *buffer;
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *suggestions;
@property (nonatomic, weak)id<MKURLConnectionDelegate> delegate;

- (void)parseData;
- (void)search:(NSString *)keyword;
- (void)printMessage:(NSString *) message;
- (void)initReachability;
- (void)reachabilityChanged:(NSNotification *) note;

@end
