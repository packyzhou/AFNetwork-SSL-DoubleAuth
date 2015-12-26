//
//  PKHTTPSRequest.m
//  HTTPSDemo
//
//  Created by 周经伟 on 15/12/26.
//  Copyright © 2015年 excellence. All rights reserved.
//

#import "PKHTTPSRequest.h"
#import "AFNetworking/AFNetworking.h"
@implementation PKHTTPSRequest
    
-(void) requestHttps{
    NSString *url = @"https://192.168.3.2:8444/SSH/test!getTestMsg.do?msg=ios";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
         NSLog(@"成功:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"失败:%@",error);
    }];
}
    
-(AFSecurityPolicy*)customSecurityPolicy
    {
        /**** SSL Pinning ****/
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"root" ofType:@"p12"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setValidatesDomainName:NO];
        [securityPolicy setValidatesCertificateChain:NO];
        
        /**** SSL Pinning ****/
        
        return securityPolicy;
    }
    

- (void)startConnection{
    NSString *url = @"https://192.168.3.2:8444/SSH/test!getTestMsg.do?msg=ios";
    
        NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *connection = nil;
        connection = [[NSURLConnection alloc] initWithRequest:connectionRequest delegate:self startImmediately:YES];
    }
    
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // gets a certificate from local resources
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"root" ofType:@"p12"];
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    
    SecIdentityRef identity;
    // extract the ideneity from the certificate
    [self extractIdentity :inPKCS12Data :&identity];
    
    SecCertificateRef certificate = NULL;
    SecIdentityCopyCertificate (identity, &certificate);
    
    const void *certs[] = {certificate};
    CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
    // create a credential from the certificate and ideneity, then reply to the challenge with the credential
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
    
    [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    
}
    
- (OSStatus)extractIdentity:(CFDataRef)inP12Data :(SecIdentityRef*)identity {
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("Zhoupinwen");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12Data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
#pragma unused(theConnection)
    NSHTTPURLResponse * httpResponse;
    NSString *          contentTypeHeader;
    httpResponse = (NSHTTPURLResponse *) response;
    // 返回的元数据类型
    NSString *returnMIMEType= [httpResponse MIMEType];
    // 请求的URL地址
    NSURL *returnURL= [httpResponse URL];
    // 要返回的数据长度（指总共长度）
    long long returnContentLength= [httpResponse expectedContentLength];
    // 状态代码，一般根据状态代码。返回来的数据是否正常。
    NSInteger returnInteger= [httpResponse statusCode];
    // 编码名称-字符串表示；如果元数据不提供，则返回nil
    NSString *returnEncodingName=[httpResponse textEncodingName];
    // 文件名称
    NSString *returnFilename=[httpResponse suggestedFilename];
    // 返回的头文件信息
    NSDictionary *returnHeaderFields= [httpResponse allHeaderFields];
    
    
}



- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
    // 当请求失败时的相关操作；
    NSLog(@"错误:%@",error);
}


- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
    
    // 接收到的数据长度
    dataLength = [data length];
    dataBytes  = [data bytes];
    bytesWrittenSoFar = 0;
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"服务器返回:%@",result);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
}

@end
