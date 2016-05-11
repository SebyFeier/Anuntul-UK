//
//  NSString+RemovedCharacters.m
//  Anuntul de UK
//
//  Created by Seby Feier on 29/03/16.
//  Copyright © 2016 Seby Feier. All rights reserved.
//

#import "NSString+RemovedCharacters.h"

@implementation NSString (RemovedCharacters)

+ (NSString *)removeCharacterFromString:(NSString *)descriptionText {
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"</br>" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&amp;amp;" withString:@"&"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&atilde;" withString:@"ă"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&acirc;" withString:@"â"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&icirc;" withString:@"î"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&Icirc;" withString:@"Î"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&Acirc;" withString:@"Â"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&#039" withString:@"'"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&trade;" withString:@"s"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&shy;" withString:@"-"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&bull;" withString:@"•"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<a href=\"http://www.anuntul.co.uk/termeni.php\">" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<a href=\"http://www.anuntul.co.uk/termeni.php\">" withString:@""];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"<a href=\"http://www.anuntul.co.uk/termeni.php\">" withString:@""];
    char cString[] = "\u00c8\u2122";
    NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"result string: %@", string);
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:string withString:@"ş"];
    
    
    char cString2[] = "\u00c4\u0192";
    data = [NSData dataWithBytes:cString2 length:strlen(cString2)];
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"result string: %@", string);
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:string withString:@"ă"];
    
    char cString3[] = "\u00c8\u203a";
    data = [NSData dataWithBytes:cString3 length:strlen(cString3)];
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"result string: %@", string);
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:string withString:@"ț"];
    
    char cString4[] = "\u00e2\u20ac";
    data = [NSData dataWithBytes:cString4 length:strlen(cString4)];
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"result string: %@", string);
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:string withString:@"'"];
    
    char cString5[] = "\u00c3\u00a2";
    data = [NSData dataWithBytes:cString5 length:strlen(cString5)];
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"result string: %@", string);
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:string withString:@"â"];
    
    char cString6[] = "\u00c2\u00a3";
    data = [NSData dataWithBytes:cString6 length:strlen(cString6)];
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"result string: %@", string);
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:string withString:@"£"];
    
    return descriptionText;

}

@end
