//
//  WebServiceManager.h
//  Anuntul de UK
//
//  Created by Seby Feier on 06/02/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef void(^DictionaryAndErrorCompletionBlock)(NSDictionary *dictionary, NSError *error);
typedef void(^ArrayAndErrorCompletionBlock)(NSArray *array, NSError *error);


@interface WebServiceManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *adsValues;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSArray *listOfCategories;
@property (nonatomic, strong) NSArray *listOfLocations;
@property (nonatomic, strong) NSArray *listOfArticles;
@property (nonatomic, assign) NSInteger bottomConstraint;
@property (nonatomic, assign) NSInteger topConstraint;
@property (nonatomic, assign) NSString *fileLocation;

@property (nonatomic, strong) NSDictionary *userInfo;

+ (WebServiceManager *)sharedInstance;

- (void)getAdsWithParameter:(NSString *)parameter
        withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getAllCategoriesWithCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)getAdsFromCategory:(NSString *)categoryId
                   andPage:(NSNumber *)pageNumber
       withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)getAdsDetailsForAdId:(NSString *)adId
         withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getAdsForUser:(NSString *)userId
       withPageNumber:(NSNumber *)pageNumber
  withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)getAllLocationWithCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)getAllAdsFromLocation:(NSString *)locationId
               withPageNumber:(NSNumber *)pageNumber
          withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)getPremiumAnnouncementWithPageNumber:(NSNumber *)pageNumber withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)getSearchResultsWithKeyWord:(NSString *)keyWord
                        andLocation:(NSString *)locationId
                        andCategory:(NSString *)categoryId
                      andPageNumber:(NSNumber *)pageNumber
                withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)loginWithEmail:(NSString *)email
           andPassword:(NSString *)password
   withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)registerWithEmail:(NSString *)email
              andPassword:(NSString *)password
              andUsername:(NSString *)username
      withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getBlogArticlesWithPageNumber:(NSNumber *)pageNumber WithCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)getBlogArticleDetails:(NSString *)articleId
          withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getAnnouncementsTypeWithCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)createAnnouncementWithCategoryId:(NSString *)categoryId
                                  userId:(NSString *)userId
                              locationId:(NSString *)locationId
                        announcementType:(NSString *)announcementType
                                   title:(NSString *)title
                             description:(NSString *)description
                             phoneNumber:(NSString *)phoneNumber
                                  images:(NSArray *)images
                       oldAnnouncementId:(NSString *)oldAnnouncementId
                           isRepublished:(NSNumber *)isRepublished
                     withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getWaitingAnnouncementsForUser:(NSString *)userId
                         andPageNumber:(NSNumber *)pageNumber
                   withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)showExpiredAnnouncements:(NSString *)userId
                         andPageNumber:(NSNumber *)pageNumber
                   withCompletionBlock:(ArrayAndErrorCompletionBlock)completionBlock;

- (void)destroyAnnouncementForAnnouncementId:(NSString *)announcementId
                         withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)republishAnnouncementForAnnouncementId:(NSString *)announcementId
                           withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)loginWithFacebookId:(NSString *)facebookId
                      email:(NSString *)email
                       name:(NSString *)name
                      image:(NSString *)image
        withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)editUserWithId:(NSString *)userId
              username:(NSString *)name
           andPassword:(NSString *)password
   withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)sendEmailFrom:(NSString *)email
                 name:(NSString *)name
      announcement_id:(NSString *)announcementId
                 body:(NSString *)body
  withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)reportAnnouncementWithId:(NSString *)announcementId
                     withMessage:(NSString *)message
             withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)contactOwnerWithEmail:(NSString *)email
                  phoneNumber:(NSString *)phoneNumber
                         body:(NSString *)body
          withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)paymentPerformedByUserId:(NSString *)userId
                  announcementId:(NSString *)announcementId
                          typeId:(NSString *)typeId
                         ammount:(NSString *)ammount
                        currency:(NSString *)currency
                           email:(NSString *)email
                         details:(NSString *)details
                     orderNumber:(NSString *)orderNumber
             withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)resetPasswordForEmail:(NSString *)email
          withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)sendPaymentInformationToServer:(NSString *)nonce
                               type:(NSString *)type
                        announcementId:(NSString *)announcementId
                      announcementType:(NSString *)announcementType
                   withCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

- (void)getClientTokenwithCompletionBlock:(DictionaryAndErrorCompletionBlock)completionBlock;

@end
