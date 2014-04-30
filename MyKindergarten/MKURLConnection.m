//
//  YOZURLConnection.m
//  OneDict
//
//  Created by XXX on 22/04/14.
//  Copyright (c) 2014 XXX. All rights reserved.
//

#import "MKURLConnection.h"
#import "Reachability.h"

@interface MKURLConnection (){
    bool isSuggestion; // for xml parsing only
    bool isSuggestionsReturned;
    bool isDetailsReturned;
}
@end

@implementation MKURLConnection

@synthesize hostReachability, internetReachability, wifiReachability, buffer, parser, suggestions, delegate;

- (id)init {
    self = [super init];
    [self initReachability];
    return self;
}

-(void)searchWithURL :(NSURL *)url{
    if ([self.internetReachability currentReachabilityStatus] == NotReachable) {
        NSLog(@"Network not available!");
        [self printMessage:@"Network not available!"];
        if ([delegate respondsToSelector:@selector(noConnection)]) {
            [delegate noConnection];
        }
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (conn) {
            self.buffer = [NSMutableData data];
        }
    }
}

- (void)search:(NSString *)keyword {
    NSString *remoteHostName =
    //    [NSString stringWithFormat:@"http://dict-co.iciba.com/api/dictionary.php?key=583E68BDE90D1A1A0D393078483CA251&w=%@", keyword];
    [NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/collegiate/xml/%@?key=5625418a-8099-4ee4-af44-771a648ecb36", keyword];
    
    if ([self.wifiReachability currentReachabilityStatus] == NotReachable) {
        NSLog(@"Network not available!");
        [self printMessage:@"Network not available!"];
        if ([delegate respondsToSelector:@selector(noConnection)]) {
            [delegate noConnection];
        }
    } else {
        NSURL *url = [NSURL URLWithString:remoteHostName];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (conn) {
            self.buffer = [NSMutableData data];
        }
    }
}
- (void)initReachability{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
	self.hostReachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
//	[self.hostReachability startNotifier];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
//	[self.internetReachability startNotifier];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
//	[self.wifiReachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note{
	Reachability* reachability = [note object];
	NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
//    NSLog(@"reachabilityChanged - %d", [reachability currentReachabilityStatus]);
}

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response {
	[buffer setLength:0];
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data {
	[buffer appendData:data];
}

- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error {
    if ([delegate respondsToSelector:@selector(detailsReturned:)]) {
        [delegate detailsReturned:nil];
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
    
//    NSMutableString *theXML = [[NSMutableString alloc] initWithBytes:[buffer mutableBytes] length:[buffer length] encoding:NSUTF8StringEncoding];
//    [theXML replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [theXML length])];
//    [theXML replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [theXML length])];
    
    NSError *e = nil;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&e];


    [self parseJSON:results];
}

-(void)parseJSON:(NSDictionary *)results{

    NSDictionary *lev1 = [results objectForKey:@"response"];
        NSArray *items = [lev1 objectForKey:@"kindergartenList"];
    NSMutableArray * dataArray = [[NSMutableArray alloc]init];
    for (NSDictionary *item in items) {
        NSString *latitude = [item objectForKey:@"latitude"];
        NSString *longitude = [item objectForKey:@"longitude"];
        NSString *kindergartenID = [item objectForKey:@"id"];
        NSString *name = [item objectForKey:@"name"];
        NSString *street = [item objectForKey:@"street"];
        NSString *block = [item objectForKey:@"block"];
        NSString *building = [item objectForKey:@"building"];
        NSString *floor = [item objectForKey:@"floor"];
        NSString *postalCode = [item objectForKey:@"postalCode"];
        NSString *x_addr = [item objectForKey:@"x_addr"];
        NSString *y_addr = [item objectForKey:@"y_addr"];
        
        
        MKKindergarten *garten = [[MKKindergarten alloc]initWithCoordiniate:(CLLocationCoordinate2D){.latitude =[latitude doubleValue], .longitude = [longitude doubleValue]} name:name street:street postalCode:postalCode block:block building:building floor:floor x_addr:x_addr y_addr:y_addr longitude:longitude latitude:latitude kindergartenID:kindergartenID];
        [dataArray addObject:garten];
    }
    if ([self.delegate respondsToSelector:@selector(suggestionsReturned:)]) {
        [delegate suggestionsReturned:dataArray];
    }
}
- (void) parseData{
    isSuggestionsReturned = NO;
    isDetailsReturned = NO;
    if (suggestions) {
        suggestions = nil;
    }
    
    self.parser = [[NSXMLParser alloc] initWithData:buffer];
    [parser setDelegate:self];
    [parser parse];
    
    if (isSuggestionsReturned && [self.delegate respondsToSelector:@selector(suggestionsReturned:)]) {
        [delegate suggestionsReturned:suggestions];
    } else if ([self.delegate respondsToSelector:@selector(detailsReturned:)]) {
        [delegate detailsReturned:isDetailsReturned ? buffer : nil];
    }
}

- (void) parser:(NSXMLParser *) xmlparser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    NSLog(@"elementName - %@", elementName);
    if ([elementName isEqualToString:@"entry"]) {
        isDetailsReturned = YES;
        [xmlparser abortParsing]; //cease parsing and segue to YOZDetailViewController
    } else if ([elementName isEqualToString:@"suggestion"]) {
        isSuggestion = YES;
        isSuggestionsReturned = YES;
        if (!suggestions){
            suggestions = [[NSMutableArray alloc] init];
        }
    }
}

- (void) parser:(NSXMLParser *) parser foundCharacters:(NSString *) string {
    if (isSuggestion) {
        isSuggestion = NO;
        [suggestions addObject:string];
    }
}

- (void) parser:(NSXMLParser *) parser didEndElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName{
}

- (void)printMessage:(NSString *) message{
    UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [popup show];
}

@end
