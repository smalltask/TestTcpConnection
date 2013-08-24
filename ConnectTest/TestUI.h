//
//  TestUI.h
//  ConnectTest
//
//  Created by  SmallTask on 13-8-15.
//
//

#import <UIKit/UIKit.h>
#import "TcpClient.h"
#import "ITcpClient.h"
#import "Reachability.h"


@interface TestUI : UIViewController
<ITcpClient,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfPort;
@property (weak, nonatomic) IBOutlet UIButton *btConnect;
@property (weak, nonatomic) IBOutlet UILabel *lbConnectionResult;

@property (weak, nonatomic) IBOutlet UITextField *tftxt;
@property (weak, nonatomic) IBOutlet UIButton *btSend;

@property (weak, nonatomic) IBOutlet UITextView *tfRecived;


- (IBAction)onBtConnection:(id)sender;

- (IBAction)onbtClicked:(id)sender;


@end
