# PLShortVideoKit

PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、回删、本地存储，云端存储在内的多种功能，还可以支持高度定制以及二次开发。

**声明：**
**本短视频 SDK 可免费使用，更多高级功能和定制需求请联系：pili@qiniu.com**

## 功能特性

- [x] 视频采集
- [x] 音频采集
- [x] 视频 H.264 硬编码
- [x] 音频 AAC 硬编码
- [x] 实时美颜
- [x] 实时滤镜
- [x] 支持第三方美颜
- [x] 支持第三方滤镜
- [x] 自定义时长
- [x] 自定义码率
- [x] 自定义分辨率 
- [x] 支持 1:1 录制 
- [x] 断点拍摄
- [x] 回删视频
- [x] 视频水印  
- [x] 视频存为 .mp4 格式
- [x] 支持 armv7, arm64, i386, x86_64 体系架构

## 设备以及系统要求

- 设备要求：搭载 iOS 系统的设备
- 系统要求：iOS 8.0 及其以上

## 安装方法

[CocoaPods](https://cocoapods.org/) 是针对 Objective-C 的依赖管理工具，它能够将使用类似 PLShortVideoKit 的第三方库的安装过程变得非常简单和自动化，你能够用下面的命令来安装它：

```bash
$ sudo gem install cocoapods
```

### Podfile

为了使用 CoacoaPods 集成 PLShortVideoKit 到你的 Xcode 工程当中，你需要编写你的 `Podfile`

```ruby
source 'https://github.com/CocoaPods/Specs.git'
target 'TargetName' do
pod 'PLShortVideoKit'
end
```

然后，运行如下的命令：

```bash
$ pod install
```

## PLShortVideoKit 文档

请参考开发者中心文档：[PLShortVideoKit 文档](https://developer.qiniu.com/pili/sdk/3669/PLShortVideoKit)

## 反馈及意见
当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 issues 来反馈问题，请尽可能的描述清楚遇到的问题，如果有错误信息也一同附带，并且在 Labels 中指明类型为 bug 或者其他。

[通过这里查看已有的 issues 和提交 Bug。](https://github.com/pili-engineering/PLShortVideoKit/issues)









