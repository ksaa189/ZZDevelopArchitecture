//
//  NSData+ZZ.m
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/7/2.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "NSData+ZZ.h"
#import <CommonCrypto/CommonCrypto.h>
#import "ZZDevelopPreDefine.h"


@implementation NSData (ZZ)

@dynamic SHA1String;
@dynamic SHA1Data;
- (NSString *)MD5String
{
    uint8_t	digest[CC_MD5_DIGEST_LENGTH + 1] = { 0 };
    
    CC_MD5( [self bytes], (CC_LONG)[self length], digest );
    
    char tmp[16] = { 0 };
    char hex[256] = { 0 };
    
    for ( CC_LONG i = 0; i < CC_MD5_DIGEST_LENGTH; ++i )
    {
        sprintf( tmp, "%02X", digest[i] );
        strcat( (char *)hex, tmp );
    }
    
    return [NSString stringWithUTF8String:(const char *)hex];
}

- (NSData *)MD5Data
{
    uint8_t	digest[CC_MD5_DIGEST_LENGTH + 1] = { 0 };
    
    CC_MD5( [self bytes], (CC_LONG)[self length], digest );
    
    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

@dynamic MD5String;
@dynamic MD5Data;
- (NSString *)SHA1String
{
    uint8_t	digest[CC_SHA1_DIGEST_LENGTH + 1] = { 0 };
    
    CC_SHA1( self.bytes, (CC_LONG)self.length, digest );
    
    char tmp[16] = { 0 };
    char hex[256] = { 0 };
    
    for ( CC_LONG i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i )
    {
        sprintf( tmp, "%02X", digest[i] );
        strcat( (char *)hex, tmp );
    }
    
    return [NSString stringWithUTF8String:(const char *)hex];
}

- (NSData *)SHA1Data
{
    uint8_t	digest[CC_SHA1_DIGEST_LENGTH + 1] = { 0 };
    
    CC_SHA1( self.bytes, (CC_LONG)self.length, digest );
    
    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

@dynamic BASE64Encrypted;
- (NSString *)BASE64Encrypted
{
    static char * __base64EncodingTable = (char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    // copy from THREE20
    
    if ( 0 == [self length] )
    {
        return @"";
    }
    
    char * characters = (char *)malloc((([self length] + 2) / 3) * 4);
    if ( NULL == characters )
    {
        return nil;
    }
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while ( i < [self length] )
    {
        char	buffer[3] = { 0 };
        short	bufferLength = 0;
        
        while ( bufferLength < 3 && i < [self length] )
        {
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        }
        
        // Encode the bytes in the buffer to four characters,
        // including padding "=" characters if necessary.
        characters[length++] = __base64EncodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = __base64EncodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        
        if ( bufferLength > 1 )
        {
            characters[length++] = __base64EncodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        }
        else
        {
            characters[length++] = '=';
        }
        
        if ( bufferLength > 2 )
        {
            characters[length++] = __base64EncodingTable[buffer[2] & 0x3F];
        }
        else
        {
            characters[length++] = '=';
        }
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end