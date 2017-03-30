---
layout: post
title:  "两个 View 之间淡入淡出过渡动画的实现"
date:   2017-03-28
---

参考：[Crossfading Two Views](https://developer.android.com/training/animation/crossfade.html)

关键代码：对 alpha 属性进行变化。

### Android 版

```xml
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Hello!"
        android:id="@+id/hello"
        android:layout_gravity="center" />

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="World!"
        android:id="@+id/world"
        android:alpha="0"
        android:layout_gravity="center" />

</FrameLayout>
```

```java
@Override
public boolean onCreateOptionsMenu(Menu menu) {
    menu.add("Go").setShowAsActionFlags(MenuItem.SHOW_AS_ACTION_IF_ROOM).setOnMenuItemClickListener((MenuItem item) -> {
        item.setEnabled(false);

        View hello = findViewById(R.id.hello);
        View world = findViewById(R.id.world);

        hello.animate().alpha(1 - hello.getAlpha()).setDuration(2000);
        world.animate().alpha(1 - world.getAlpha()).setDuration(2000).setListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                item.setEnabled(true);
            }
        });

        return true;
    });
    return super.onCreateOptionsMenu(menu);
}
```

核心方法 `aView.animate() -> ViewPropertyAnimator`

### iOS 版

```objc
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    // UI Begin
    UILabel *hello = [[UILabel alloc] init];
    hello.text = @"Hello!";
    hello.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:hello];

    UILabel *world = [[UILabel alloc] init];
    world.text = @"World!";
    world.alpha = 0;
    world.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:world];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hello attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hello attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:world attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:world attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    // UI End

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(onItemSelected)];
    hello.tag = 100; // 在 demo 中较为简洁
    world.tag = 200;
}

- (void)onItemSelected {
    UIView *hello = [self.view viewWithTag:100];
    UIView *world = [self.view viewWithTag:200];

    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIView animateWithDuration:1 animations:^{
        hello.alpha = 1 - hello.alpha;
        world.alpha = 1 - world.alpha;
    } completion:^(BOOL finished) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}
```
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