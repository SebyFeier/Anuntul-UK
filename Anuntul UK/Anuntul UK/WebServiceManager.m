//
//  WebServiceManager.m
//  Anuntul de UK
//
//  Created by Seby Feier on 06/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "WebServiceManager.h"
#import <AFHTTPClient.h>
#import "AFNetworking.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

#define kTWebServiceForEndpoint(endpoint) [WebServiceUrl stringByAppendingPathComponent:endpoint]

NSString *const WebServiceUrl = @"http://anuntul.boxnets.com";

@implementation WebServiceManager

+ (WebServiceManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static WebServiceManager *_sharedClient = nil;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WebServiceManager alloc] init];
        
    });
    return _sharedClient;
}

- (void)getAdsWithParameter:(NSString *)parameter withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"parameter=%@",parameter];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
        [self.adsValues setObject:JSON[@"result"] forKey:parameter];
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)getAllCategoriesWithCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"categories"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getSearchResultsWithKeyWord:(NSString *)keyWord andLocation:(NSString *)locationId andCategory:(NSString *)categoryId andPageNumber:(NSNumber *)pageNumber withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    if (!locationId) {
        locationId = @"";
    }
    if (!categoryId) {
        categoryId = @"";
    }
    if ([categoryId rangeOfString:@"null"].location != NSNotFound) {
        categoryId = @"";
    }
    if ([locationId rangeOfString:@"null"].location != NSNotFound) {
        locationId = @"";
    }
    NSString *urlString = [NSString stringWithFormat:@"search?name=%@&location=%@&category_id=%@&page=%@",[keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], locationId, categoryId, pageNumber];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
        NSString *headerTitle = @"";
        if ([locationId length] && [categoryId length]) {
//            headerTitle = [NSString stringWithFormat:@"%@, %@",locationId, categoryId];
            headerTitle = @"Rezultate";
        } else if ([locationId length] && ![categoryId length]) {
            headerTitle = locationId;
        } else if (![locationId length] && [categoryId length]) {
            headerTitle = categoryId;
        }
        [self.adsValues setObject:JSON forKey:headerTitle];
        self.categoryId = headerTitle;
//        self.categoryId = categoryId;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getAdsFromCategory:(NSString *)categoryId andPage:(NSNumber *)pageNumber withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"categories/%@?page=%@",categoryId, pageNumber];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
        [self.adsValues setObject:JSON forKey:categoryId];
        self.categoryId = categoryId;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getPremiumAnnouncementWithPageNumber:(NSNumber *)pageNumber withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"premium_announcements?page=%@", pageNumber];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
        [self.adsValues setObject:JSON forKey:@"Premium"];
        self.categoryId = @"Premium";
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getAdsDetailsForAdId:(NSString *)adId withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"announcements/%@",adId];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
//        [self.adsValues setObject:JSON[@"result"] forKey:parameter];
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getAdsForUser:(NSString *)userId withPageNumber:(NSNumber *)pageNumber withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"users/%@/announcements?page=%@",userId, pageNumber];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
//        [self.adsValues setObject:JSON[@"result"] forKey:parameter];
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getWaitingAnnouncementsForUser:(NSString *)userId andPageNumber:(NSNumber *)pageNumber withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"users/%@/waiting_announcements?page=%@",userId, pageNumber];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
        //        [self.adsValues setObject:JSON[@"result"] forKey:parameter];
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)showExpiredAnnouncements:(NSString *)userId andPageNumber:(NSNumber *)pageNumber withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"users/%@/expired_announcements?page=%@",userId, pageNumber];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
        //        [self.adsValues setObject:JSON[@"result"] forKey:parameter];
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
    

}

- (void)createAnnouncementWithCategoryId:(NSString *)categoryId userId:(NSString *)userId locationId:(NSString *)locationId announcementType:(NSString *)announcementType title:(NSString *)title description:(NSString *)description phoneNumber:(NSString *)phoneNumber images:(NSArray *)images oldAnnouncementId:(NSString *)oldAnnouncementId isRepublished:(NSNumber *)isRepublished withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"announcement/create";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSString *ipAddress = [self getIPAddress];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:categoryId,@"id_categ",userId,@"id_user",locationId,@"id_locatie",announcementType,@"setari_anunturi_id",title,@"titlu",description,@"descriere",phoneNumber,@"telefon1", images,@"images",ipAddress,@"ip",oldAnnouncementId,@"old_announcement_id",isRepublished,@"is_republished", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getAllLocationWithCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"locations"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        if (!self.adsValues) {
//            self.adsValues = [[NSMutableDictionary alloc] init];
//        }
        if (!self.listOfLocations) {
            self.listOfLocations = [[NSMutableArray alloc] init];
        }
        self.listOfLocations = JSON;
//        [self.adsValues setObject:JSON[@"result"] forKey:parameter];
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getAllAdsFromLocation:(NSString *)locationId withPageNumber:(NSNumber *)pageNumber withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock{
    NSString *urlString = [NSString stringWithFormat:@"locations/%@?page=%@",locationId, pageNumber];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.adsValues) {
            self.adsValues = [[NSMutableDictionary alloc] init];
        }
//        [self.adsValues setObject:JSON[@"result"] forKey:parameter];
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"login?email=%@&password=%@",email, password];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        self.userInfo = JSON;
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)loginWithFacebookId:(NSString *)facebookId email:(NSString *)email name:(NSString *)name image:(NSString *)image withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"facebook";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:facebookId,@"fb_id",name,@"nume",email,@"email",image,@"avatar", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password andUsername:(NSString *)username withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"register?email=%@&parola=%@&nume=%@",email, password, username];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getBlogArticlesWithPageNumber:(NSNumber *)pageNumber WithCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"articles?page=%@", pageNumber];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (!self.listOfArticles) {
            self.listOfArticles = [[NSMutableArray alloc] init];
        }
        self.listOfArticles = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getBlogArticleDetails:(NSString *)articleId withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"articles/%@",articleId];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)getAnnouncementsTypeWithCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"announcements_type"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)destroyAnnouncementForAnnouncementId:(NSString *)announcementId withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"announcement/destroy?id=%@",announcementId];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)republishAnnouncementForAnnouncementId:(NSString *)announcementId withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"announcement/republish?id=%@",announcementId];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)getClientTokenwithCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"client_token"];
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)editUserWithId:(NSString *)userId username:(NSString *)name andPassword:(NSString *)password withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"user/edit";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"id",name,@"nume",password,@"parola", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)sendEmailFrom:(NSString *)email name:(NSString *)name announcement_id:(NSString *)announcementId body:(NSString *)body withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"user/send_email";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email",announcementId,@"announcement_id",body,@"body", name, @"nume", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)reportAnnouncementWithId:(NSString *)announcementId withMessage:(NSString *)message withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"user/report";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSString *ipAddress = [self getIPAddress];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:announcementId,@"announcement_id",message,@"mesaj",ipAddress,@"ip", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)contactOwnerWithEmail:(NSString *)email phoneNumber:(NSString *)phoneNumber body:(NSString *)body withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"user/contact_owner";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSString *ipAddress = [self getIPAddress];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email",phoneNumber,@"telefon",body,@"body",ipAddress,@"ip", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)resetPasswordForEmail:(NSString *)email withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"user/reset_password";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (void)paymentPerformedByUserId:(NSString *)userId announcementId:(NSString *)announcementId typeId:(NSString *)typeId ammount:(NSString *)ammount currency:(NSString *)currency email:(NSString *)email details:(NSString *)details orderNumber:(NSString *)orderNumber withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"announcement/payment";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",userId],@"id_user",[NSString stringWithFormat:@"%@",announcementId],@"id_anunt",[NSString stringWithFormat:@"%@",typeId],@"id_type",ammount, @"amount", currency, @"currency",email, @"payer_email", details, @"details", orderNumber, @"order_number", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];

}

- (void)sendPaymentInformationToServer:(NSString *)nonce type:(NSString *)type announcementId:(NSString *)announcementId announcementType:(NSString *)announcementType withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock {
    NSString *urlString = @"announcement/processing_braintree";
    NSURL *url = [NSURL URLWithString:WebServiceUrl];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:nonce,@"payment_method_nonce",type,@"payment_type",announcementId,@"id_anunt", announcementType, @"setari_anunturi_id", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setStringEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:urlString
                                                      parameters:parameters];
    NSLog(@"URL %@",request.URL);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/octet-stream", nil]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.userInfo = JSON;
        completionBlock(JSON, nil);
        NSLog(@"%@",JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionBlock(JSON, error);
    }];
    [operation start];
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

@end
