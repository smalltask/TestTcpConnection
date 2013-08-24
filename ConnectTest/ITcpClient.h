//
//  ITcpClient.h
//  ConnectTest
//
//  Created by  SmallTask on 13-8-22.
//
//

#import <Foundation/Foundation.h>

@protocol ITcpClient <NSObject>

#pragma mark ITcpClient

/**发送到服务器端的数据*/
-(void)OnSendDataSuccess:(NSString*)sendedTxt;

/**收到服务器端发送的数据*/
-(void)OnReciveData:(NSString*)recivedTxt;

/**socket连接出现错误*/
-(void)OnConnectionError:(NSError *)err;

@end
