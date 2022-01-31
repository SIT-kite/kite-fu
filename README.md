# 2022 虎年 "五福" 活动

该活动借鉴支付宝 “扫福赢福卡” 活动, 通过 "扫校徽赢福卡" 的方式展开, 当用户集齐全套福卡后, 可以前往易班工作站领取奖品. 项目于 2021
年底由上海应用技术大学易班工作站发起，技术部分由技术部负责.

技术上, 后端部分由 rust 和 python 语言混合编写，见 [kite-badge](https://github.com/SIT-kite/kite-badge). 当前仓库为前仓库, 使用
dart 语言和 flutter 框架构建 (Dart 2.15.1, flutter 2.8.1).

## 文档

文档参见 [kite-server/docs/APIv2/集五福.md](https://github.com/SIT-kite/kite-server/blob/v2/docs/APIv2/%E9%9B%86%E4%BA%94%E7%A6%8F.md)
.

## 使用

```shell
git clone https://github.com/SIT-kite/kite-fu.git
cd kite-fu

flutter pub get
flutter pub run flutter_native_splash:create
flutter build web
```

生产环境的代码在编译时的完整命令如下：

```shell
flutter build web --web-renderer=html --base-href=/fu/ --no-source-maps --no-null-assertions --no-native-null-assertions --release
```

## 版权

项目中用到的背景图片，除 `2.png` 外，均来源于小米主题商店. 福字图片, 由上海应用技术大学易班工作站制作.

本项目使用 GPLv3 协议授权.