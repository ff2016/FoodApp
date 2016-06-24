//
//  SignatrueEncryption.h
//  Tuantuangou
//


#import <Foundation/Foundation.h>

@interface SignatrueEncryption : NSObject

//通过SHA-1加密算法，得到用户的合法签名
+ (NSMutableDictionary *)encryptedParamsWithBaseParams:(NSMutableDictionary *)paramsDictionary;

@end
