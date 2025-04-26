## 接口介绍

```
BNCommonProgressBar.h

// 变更进度，animateWithDuration是传入动画时间
- (void)setValue:(CGFloat)value;
- (void)setValue:(CGFloat)value animateWithDuration:(NSTimeInterval)duration time:(NSTimeInterval)time;
- (void)setValue:(CGFloat)value animateWithDuration:(NSTimeInterval)duration completion:(void (^__nullable)(BOOL finished))completion;

// 重置所有状态，会将进度重置到0
- (void)reset;

// 暂停动画
- (void)pauseAnimation;
// 恢复动画
- (void)resumeAnimation;
// 清理动画状态，手动拖拽时先清理动画状态
- (void)removeProgressAnimation;
```

## 一、为什么 UISlider 不满足「高可用」的目标？

在阐述 UISlider 不满足「高可用」目标之前，我们先思考一下，满足什么样的条件的进度条，才可以算是「高可用」？

我想出四个目标：

- 1. UI可高度定制
- 2. 流畅的回调动画
- 3. 可定制的响应范围
- 4. 响应手势，且无卡顿问题

其中 UISlider 可满足其中 3 和 4，因为 UISlider 是系统提供的组件，「UI可高度定制」这条肯定不满足。

且 UISlider 对于动画的处理不够强大，在视频播放的场景下，视频播放器会定时高频的回调视频播放进度，更新进度的动画要足够流畅，但实际上使用 UISlider 的效果是下面这样的：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt310cq01ig30ay0munpd.gif)

所以 UISlider 不满足 第2点：「流畅的回调动画」，而业务场景下，视频进度回调更新进度条进度是高曝光的场景，一定要把这个动画做得足够流畅。

在这样的背景下，放弃 UISlider ，自定义进度条是唯一的选择。

## 二、定制一份「高可用」进度条 

Tips：`BNCommonProgressBar`是我们定制的进度条的类名，首先先看一下`BNCommonProgressBar`实现的效果：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt315ux1zjg30ay0munpd.gif)

`BNCommonProgressBar` 设计与需求相对应：

- 1. 目标：UI可高度定制  --> 方案：自定义UI
- 2. 目标：流畅的回调动画  --> 方案：动画处理
- 3. 目标：可定制的响应范围 --> 方案：手势范围处理
- 4. 目标：响应手势，且无卡顿问题 --> 方案：拖拽手势处理,卡顿问题处理

所以 `BNCommonProgressBar` 的设计也就分为 4个模块。

### （一）自定义UI

`BNCommonProgressBar`初始化方法为：

```
- (instancetype)initWithFrame:(CGRect)frame
                    barHeight:(CGFloat)progressBarHeight
                    dotHeight:(CGFloat)dotHeight
                 defaultColor:(UIColor *)defaultColor
              inProgressColor:(UIColor *)inProgressColor
                    dragColor:(UIColor *)dragColor
                 cornerRadius:(CGFloat)cornerRadius
         progressBarIconImage:(UIImage *)progressBarIconImage
         enablePanProgressIcon:(BOOL)enablePanProgressIcon;
```

允许业务层配置进度条高度、进度圆点高度、默认颜色、处于进度拖拽时的颜色、是否允许拖拽等，相比 UISlider 有更高的自定义程度。

且如果这些接口不够使用，你可以直接在`BNCommonProgressBar`初始化方法中添加相应控件和组件，实现定制化，绝对不会影响到 进度条动画/手势 等功能，实现功能隔离。

### （二）回调进度处理

#### 1. 问题分析

为何触发暂停后，进度条不能立即停止，而是滑动一段距离才能停下呢？

通过看进度条实现的代码，我发现了其中的端倪：

「进度条的位置」是通过「播放器的进度定时回调」来变更的

播放器大约每隔0.25秒会触发一次回调方法，告诉进度条下个0.25秒应该移动到哪个位置。

进度条为了实现进度变更的顺滑，采用了[UIView animationWithDuration:]动画。

那么问题就来了：

如果在第2秒时，播放器回调告诉了进度条下个0.25秒的位置，接着触发了[UIView animationWithDuration:0.25]的动画，

如果用户在2.01秒点击了暂停，如果这时不对动画做暂停的操作，进度条就会再移动完剩下的 (0.25 - 0.01)秒的动画，也就出现了暂停也滑动的表现。

解决这个问题最直观有两个方案：

#### 方案一：增加播放器回调的频率
当频率足够高时，[UIView animationWithDuration:]的duration间隔也会变小，那么暂停仍滑行的表现就会减弱

这个方案有两个问题:

1. 增加播放器回调频率，只是减弱滑行的表现，但并没有真正解决滑行的问题。当同样的进度条引用到iPad上后，进度条会变长，那么问题仍会暴露

2. 单纯增加播放器回调只是为了解决滑行问题，成本太高且没有必要。

#### 方案二：暂停CoreAnimation进行中的动画

下面我们就围绕着暂停CoreAnimation动画的方案，引入和补充一些关于Layer动画的知识点。

##### (1)实现过程

方案二有个直观的步骤：

- a. 当视频暂停时，记录暂停那一刻 进度条的位置

- b. 然后停止进度条的动画

- c. 等到恢复播放时，再从上次记录的位置重新恢复动画。

##### a. 当视频暂停时，记录暂停那一刻 进度条的位置

首先问题是：应该记录进度条view的哪个属性呢？

可以直接记录view.x吗？

实际上是不行的，如果我们将 [UIView animationWithDuration:]发生前 view.x 记录为 A，动画完成后 view.x 记录为 C，动画过程中记录为 B。

```
____I________I_______I___
  起点A     暂停B     终点C
```

你会发现，只要动画开始了，无论动画是否结束，你通过 view.x 访问到的总是 C，而非动画过程暂停那一刻的位置 B。

甚至如果你对view.layer.frame进行KVO的监测，你会发现在动画变更过程中，KVO并没有回调。

这是为什么呢？

#### CALayer图层树

我们都知道，UIView是对CALayer的一个封装，CALayer类在概念上和UIView类似，同样也是一些被层级关系树管理的矩形块，同样也可以包含一些内容（像图片，文本或者背景色），管理子图层的位置。它们有一些方法和属性用来做动画和变换。和UIView最大的不同是CALayer不处理用户的交互。

CALayer 和 UIView 一样存在着一个层级树状结构,称之为图层树(Layer Tree)，也可以叫 模型树（Model Tree）。

![](https://tva1.sinaimg.cn/large/008i3skNgy1gt30iuvsu2j30vt0rcwgg.jpg)

这三种图层树有什么作用呢？说到有啥作用，就不得不提Core Animation 核心动画了。因为这三个图层在核心动画中才能显示出它们的特点和用处。下面是官方文档的说明：

- **模型图层树** 中的对象是应用程序与之交互的对象。此树中的对象是存储任何动画的目标值的模型对象。每当更改图层的属性时，都使用其中一个对象。

- **表示图层树** 中的对象包含任何正在运行的动画的飞行中值。层树对象包含动画的目标值，而表示树中的对象反映屏幕上显示的当前值。您永远不应该修改此树中的对象。相反，您可以使用这些对象来读取当前动画值，也许是为了从这些值开始创建新动画。

- **渲染图层树** 中的对象执行实际动画，并且是Core Animation的私有动画。

也就是说，图层树中我们开发过程中可以实际用到的有两个属性：modelLayer （模型图层）、presentationLayer（表现图层）。

（渲染图层在CALayer没有提供直接的属性给我们使用，是core Animation私有的）

##### 什么是modelLayer？

modelLayer 实际上就是承载着layer终态的各种数据，我们开发过程中给layer的各种参数赋值，实际上也就是给layer.modelLayer赋值。

也即：view.layer == view.layer.modelLayer。

因为modelLayer是我们在进行动画时设定好的最终值，所以在动画执行过程中，对view.layer.frame进行KVO监测，是不会有值的变更的。

##### 什么是presentationLayer？

presentationLayer 是我们的主角，presentationLayer指的也就是 屏幕上实时展示的图层的layer ，在core animation 动画中，可以通过这个属性，获取动画过程中每个时刻动画图层的数据，这样如果在动画过程中需要做什么处理，就可以动态的获取layer上相关的数据了。

所以在执行core animation动画中，presentationLayer 是时刻变化的，但modelLayer是不会变的。

presentationLayer有诸多用途，比如视频中的滚动弹幕如果是使用layer做动画的，当弹幕正在滚动时，你需要点击它以处理需要做的事情，这时候你就会需要presentationLayer。再结合hintTest方法来做判断：
```
[self.layer.presentationLayer hitTest:point] //判断是不是你点击的哪个弹幕
```

##### b. 停止进度条的动画
停止core animation动画有很多种方式，layer.removeAllAnimations 就是其中一种。

但layer.removeAllAnimations并不能实现我们预期的效果，举例：

```
____I________I_______I___
  起点A     暂停B     终点C
```
  
在暂停B点，调用removeAllAnimations，动画是会停止，但进度会直接跳到最终态C，而非停在B，所以我们需要的是可以 pauseAnimation，而非removeAnimation的操作。

虽然CALayer没有提供pauseAnimation的接口，但我们可以通过CALayer的时间模型来实现pause的效果。

#### CAMediaTiming协议

CAMediaTiming协议的内容不多，头文件我罗列于此。

```
@protocol CAMediaTiming

@property CFTimeInterval beginTime;
@property CFTimeInterval duration;
@property float speed;
@property CFTimeInterval timeOffset;
@property float repeatCount;
@property CFTimeInterval repeatDuration;
@property BOOL autoreverses;
@property(copy) CAMediaTimingFillMode fillMode;

@end
```

CALayer实现了CAMediaTiming协议. CALayer通过CAMediaTiming协议实现了一个有层级关系的时间系统.
(除了CALayer,CAAnimation也采纳了此协议,用来实现动画的时间系统.)

##### beginTime
无论是图层还是动画,都有一个时间线Timeline的概念,他们的beginTime是相对于父级对象的开始时间. 虽然苹果的文档中没有指明,但是通过代码测试可以发现,默认情况下所有的CALayer图层的时间线都是一致的,他们的beginTime都是0,绝对时间转换到当前Layer中的时间大小就是绝对时间的大小.所以对于图层而言,虽然创建有先后,但是他们的时间线都是一致的(只要不主动去修改某个图层的beginTime),所以我们可以想象成所有的图层默认都是从系统重启后开始了他们的时间线的计时.

但是动画的时间线的情况就不同了,当一个动画创建好,被加入到某个Layer的时候,会先被拷贝一份出来用于加入当前的图层,在CA事务被提交的时候,如果图层中的动画的beginTime为0,则beginTime会被设定为当前图层的当前时间,使得动画立即开始.如果你想某个直接加入图层的动画稍后执行,可以通过手动设置这个动画的beginTime,但需要注意的是这个beginTime需要为 CACurrentMediaTime()+延迟的秒数,因为beginTime是指其父级对象的时间线上的某个时间,这个时候动画的父级对象为加入的这个图层,图层当前的时间其实为[layer convertTime:CACurrentMediaTime() fromLayer:nil],其实就等于CACurrentMediaTime(),那么再在这个layer的时间线上往后延迟一定的秒数便得到上面的那个结果.

##### timeOffset

这个timeOffset可能是这几个属性中比较难理解的一个,官方的文档也没有讲的很清楚. local time也分成两种：一种是active local time 一种是basic local time. timeOffset则是active local time的偏移量.
你将一个动画看作一个环,timeOffset改变的其实是动画在环内的起点,比如一个duration为5秒的动画,将timeOffset设置为2(或者7,模5为2),那么动画的运行则是从原来的2秒开始到5秒,接着再0秒到2秒,完成一次动画.

##### speed

speed属性用于设置当前对象的时间流相对于父级对象时间流的流逝速度,比如一个动画beginTime是0,但是speed是2,那么这个动画的1秒处相当于父级对象时间流中的2秒处. speed越大则说明时间流逝速度越快,那动画也就越快.比如一个speed为2的layer其所有的父辈的speed都是1,它有一个subLayer,speed也为2,那么一个8秒的动画在这个运行于这个subLayer只需2秒(8 / (2 * 2)).所以speed有叠加的效果.

有上面三个属性，我们就可以实现 pause 和 resume 的操作，相关代码如下：

```
#pragma mark 暂停和恢复CALayer的动画
- (void)pauseLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];

    // 让CALayer的时间停止走动
    layer.speed = 0.0;
    // 让CALayer的时间停留在pausedTime这个时刻
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = layer.timeOffset;
    // 1. 让CALayer的时间继续行走
    layer.speed = 1.0;
    // 2. 取消上次记录的停留时刻
    layer.timeOffset = 0.0;
    // 3. 取消上次设置的时间
    layer.beginTime = 0.0;
    // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
    layer.beginTime = timeSincePause;
}
```

上面方法中使用到的 CACurrentMediaTime()，也就是所谓的 马赫时间，它是CoreAnimation上的一个全局时间的概念。

马赫时间在设备上所有进程都是全局的--但是在不同设备上并不是全局的--不过这已经足够对动画的参考点提供便利了。

这个函数返回的值其实无关紧要（它返回了设备自从上次启动后的秒数，并不是你所关心的），它真实的作用在于对动画的时间测量提供了一个相对值。注意当设备休眠的时候马赫时间会暂停，也就是所有的CAAnimations（基于马赫时间）同样也会暂停。


### （三）手势范围处理

在`BNCommonProgressBar`中针对`hitTest:withEvent:`方法进行处理，可以将响应范围使用宏进行界定，也可由业务层传入，这里默认上下左右增加 `BNResponseWidHeight/2` 的响应范围。

```
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect respRect = CGRectMake(- BNResponseWidHeight/ 2, - BNResponseWidHeight / 2, self.width + BNResponseWidHeight, self.height + BNResponseWidHeight);
    if (CGRectContainsPoint(respRect, point)) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}
```

### （四）拖拽手势处理，卡顿问题处理

拖拽手势处理的代码在`onPanProgressIcon:`。
