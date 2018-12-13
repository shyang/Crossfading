---
layout: post
title:  "两个 View 之间淡入淡出过渡动画的实现"
date:   2017-03-28
---

参考：[Crossfading Two Views](https://developer.android.com/training/animation/reveal-or-hide-view#Crossfade)

关键代码：对 alpha 属性进行变化。

-[Android 版](android/app/src/main/java/org/un/crossfading/MainActivity.java)


核心方法 `aView.animate() -> ViewPropertyAnimator`

-[iOS 版](ios/Crossfading/ViewController.m)

核心代码 `[UIView animateWithDuration:duration animations:^{}]`

#### P.S.
不使用 auto layout，采用 autoresizing mask 的方式如下：

```objc
// UI Begin
UILabel *hello = [[UILabel alloc] init];
hello.text = @"Hello!";
[hello sizeToFit];
hello.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
hello.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
[self.view addSubview:hello];

UILabel *world = [[UILabel alloc] init];
world.text = @"World!";
[world sizeToFit];
world.alpha = 0;
world.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
world.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
[self.view addSubview:world];
// UI End
```
Autoresizing mask 的能力弱于 auto layout，虽能解决大部分布局问题（特别是与 parentView 之间），但 subviews 之间的间隔也是等比例缩放的，不能保证初始的固定间隔。如果正好需要同比例缩放，可继续使用 autoresizingMask，否则就要 NSLayoutConstraint。