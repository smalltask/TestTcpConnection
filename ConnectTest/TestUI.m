//
//  TestUI.m
//  ConnectTest
//
//  Created by  SmallTask on 13-8-15.
//
//

#import "TestUI.h"

@interface TestUI ()

@end

@implementation TestUI

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tfRecived.text = @"";
    
    [self netstate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)netstate;
{
    NSLog(@"开启 www.apple.com 的网络检测");
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    NSLog(@"-- current status: %@", reach.currentReachabilityString);
    
    // start the notifier which will cause the reachability object to retain itself!
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    /*
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.blockLabel.text = @"网络可用";
//            self.blockLabel.backgroundColor = [UIColor greenColor];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tfRecived.text = @"网络不可用";
            self.tfRecived.backgroundColor = [UIColor redColor];
        });
    };
    
    */
    [reach startNotifier];
      
}

- (void) reachabilityChanged: (NSNotification*)note {
    Reachability * reach = [note object];
    
    if(![reach isReachable])
    {
        self.tfRecived.text = @"网络不可用";
        self.tfRecived.backgroundColor = [UIColor redColor];
        
//        self.wifiOnlyLabel.backgroundColor = [UIColor redColor];
//        self.wwanOnlyLabel.backgroundColor = [UIColor redColor];
        
        TcpClient *tcp = [TcpClient sharedInstance];
        [tcp setDelegate_ITcpClient:self];
        
        [tcp.asyncSocket disconnect];
        
        return;
    }
    
    self.tfRecived.text = @"网络可用";
    self.tfRecived.backgroundColor = [UIColor greenColor];
    
    if (reach.isReachableViaWiFi) {
        self.tfRecived.backgroundColor = [UIColor greenColor];
        self.tfRecived.text = @"当前通过wifi连接";
    } else {
        self.tfRecived.backgroundColor = [UIColor redColor];
        self.tfRecived.text = @"wifi未开启，不能用";
    }
    
    if (reach.isReachableViaWWAN) {
        self.tfRecived.backgroundColor = [UIColor greenColor];
        self.tfRecived.text = @"当前通过2g or 3g连接";
    } else {
        self.tfRecived.backgroundColor = [UIColor redColor];
        self.tfRecived.text = @"2g or 3g网络未使用";
    }
}


- (IBAction)onBtConnection:(id)sender {
    TcpClient *tcp = [TcpClient sharedInstance];
    [tcp setDelegate_ITcpClient:self];
    if(tcp.asyncSocket.isConnected)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络已经连接好啦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else
    {
        NSString *HOST = self.tfAddress.text;
        NSString *port = self.tfPort.text;
        [tcp openTcpConnection:HOST port:[port intValue]];
    }
    
    [self resignKeyboard];
    
}

//发送消息
- (IBAction)onbtClicked:(id)sender {
    
//    NSString *txt = self.tftxt.text;
//    NSData *data = [txt dataUsingEncoding:NSUTF8StringEncoding];
    TcpClient *tcp = [TcpClient sharedInstance];
    if(tcp.asyncSocket.isDisconnected)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络不通" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }else if(tcp.asyncSocket.isConnected)
    {

        NSString *requestStr = [NSString stringWithFormat:@"%@\r\n",self.tftxt.text];
        [tcp writeString:requestStr];
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"TCP链接没有建立" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    [self resignKeyboard];
}

-(void)resignKeyboard;
{
    [self.tfAddress resignFirstResponder];
    [self.tfPort resignFirstResponder];
    [self.tftxt resignFirstResponder];
}

#pragma mark -
#pragma mark ITcpClient

/**发送到服务器端的数据*/
-(void)OnSendDataSuccess:(NSString*)sendedTxt;
{
    self.tfRecived.text = [NSString stringWithFormat:@"%@\r\nsended-->:%@\r\n",self.tfRecived.text,sendedTxt];
}

/**收到服务器端发送的数据*/
-(void)OnReciveData:(NSString*)recivedTxt;
{
    self.tfRecived.text = [NSString stringWithFormat:@"%@\r\n-->recived:%@\r\n",self.tfRecived.text,recivedTxt];
}

/**socket连接出现错误*/
-(void)OnConnectionError:(NSError *)err;
{
    self.tfRecived.text = [NSString stringWithFormat:@"%@\r\n\r\n**** network error! ****\r\n",self.tfRecived.text];
}

#pragma mark -
#pragma mark UIScrollerView
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resignKeyboard];
}


@end
