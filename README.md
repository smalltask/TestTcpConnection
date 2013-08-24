TestTcpConnection
=================

Tcp connection test. 

Use GCDAsyncSocket framework.

基于GCDAsyncSocket项目进行实现；

增加了一个用户测试界面，

实现了手工收发消息的功能，

便于测试时使用；

GCDAsyncSocket原先的Demo里，测试界面比较简单，用起来不方便。另外，如果测试过程中，忽然拔掉网线，socketConnection不能及时响应断网的状态，所以增加了Reachability类来判断网络状态的变更；

测试情况：
Wifi，2g/3g网络，手机在不同类型网络之间切换，客户端忽然拔掉网线，服务器端忽然中断，均可以正确响应；

