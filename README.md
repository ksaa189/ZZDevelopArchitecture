# ZZDevelopArchitecture
IOS开发框架
 本项目是一个为快速开发中小型APP所使用的开发框架。
 
 集成了一些常用的封装和功能。

 本框架集成了一些功能，需要引用LKDBHelper，Fmdb，MKNetworkKit这三个第三方库。

 Laroratory文件夹下主要是一个网络请求的封装，和一个队LKDBHelper的小扩展。
    
 UIModules文件夹下主要是一些基础ViewController的封装和修改，有的具有调试跟踪功能，有的是方便调用，还有一些常用封装。个人可以根据需要进行选择使用，不需要的仅仅是提供功能方便以后使用。

 Cache文件夹下主要包含文件缓存管理，内存缓存管理，自动Coding，和UserDefaults封装，使用时候需要看实现，规则可能和想象中不一样。

 CommonClass文件夹下面包含了很多东西，ZZRuntime类是根据runtime的的方法，来获取属性名函数名等。
     ZZMulticastDelegate类是管理多个delegate的回调。ZZAOP是给函数添加切面，在函数执行之前或者之后添加处理，可以用来测试或者调试。ZZReachability是网络监测类。ZZSandbox是获取程序的各种目录路径。ZZSystemInfo是获取版本号，越狱判断，屏幕大小比较等。ZZThread是GCD封装，内部使用较多。ZZTimer是一个比NSTimer优化一点的定时器。ZZCommon里面有一些函数，待分类。ZZFlyweightTransmit是解决a知道b,b不知道a, b传数据给a的情况传递数据之用。ZZJsonHelper是json转化model的类。



                                                                 联系QQ：395756553
                                                                 邮箱：ksaa189@163.com


