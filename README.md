截屏并分享功能，实现快速分享指定widget

## Features
截屏并分享功能

![](./assets/res.gif)

功能不全，后面有时间优化

### 引用的三方库
   + [permission_handler](https://pub.dev/packages/permission_handler)
       - 需要跟进readme 进行配置
   + [path_provider](https://pub.dev/packages/path_provider)




## Getting started
start


## Usage


```dart
 final ShotController shotController = ShotController();

 ScreenShotShare(
        shotController: shotController,
        actionHeight: 100,
        actions: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _item('QQ', 'assets/images/ic/ic_news_family_apply.png'),
            _item('微信', 'assets/images/ic/ic_news_feedback.png'),
            _item('小红书', 'assets/images/ic/default_song_cover.png'),
          ],
        ),
        child: SizeBox(),
        )
        
          Widget _item(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 50,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
```

## Additional information
no