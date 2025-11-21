# ArkUI使用makeObserved接口：将非观察数据变为可观察数据指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

### 1.[线性容器(Column)](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-container-column.md)

### 2.[文本显示器(Text)](https://docs.openharmony.cn/pages/v6.0/en/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-text.md)

### 3.[Button](https://docs.openharmony.cn/pages/v6.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-basic-components-button.md)

### 4.[makeObserved接口：将非观察数据变为可观察数据](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-new-makeObserved.md)

## 预览效果
```
import { UIUtils } from '@kit.ArkUI';
class Person {
  age: number = 10;
}
class Info {
  id: number = 0;
  person: Person = new Person();
}
@Entry
@Component
struct Index {
  @State message: Info = new Info();
  @State message2: Info = UIUtils.makeObserved(this.message); // 不会抛异常
  build() {
    Column() {
      Text(`${this.message2.person.age}`)
        .onClick(() => {
          // UI不会刷新，因为State只能观察到第一层的变化
          this.message2.person.age++;
        })
    }
  }
}
```
![image1](![](screenshots/device/image1.jpeg)
makeObserved仅对入参生效，不会改变接受返回值的观察能力
message被@Local装饰，本身具有观察自身赋值的能力。其初始值为makeObserved的返回值，具有深度观察能力。
点击change id可以触发UI刷新。
点击change Info将this.message重新赋值为不可观察数据后，再次点击change id无法触发UI刷新。
再次点击change Info1将this.message重新赋值为可观察数据后，点击change id可以触发UI刷新。
![image1](![](screenshots/device/image2.jpeg)
makeObserved在传入@Sendable类型的数据后有观察能力，且其变化可以触发UI刷新。
从子线程中获取一个整体数据，然后对UI线程的可观察数据做整体替换。
从子线程获取的数据重新执行makeObserved，将数据变为可观察数据。
将数据从主线程传递回子线程时，仅传递不可观察的数据。makeObserved的返回值不可直接传给子线程。
![image1](![](screenshots/device/image3.jpeg)
makeObserved和collections.Array/Set/Map配合使用
collections提供ArkTS容器集，可用于并发场景下的高性能数据传递。详情见@arkts.collections文档。

makeObserved可以在ArkUI中导入可观察的collections容器，但makeObserved不能和状态管理V1的状态变量装饰器如@State和@Prop等配合使用，否则会抛出运行时异常。

collections.Array

collections.Array可以触发UI刷新的API有：

改变数组长度：push、pop、shift、unshift、splice、shrinkTo、extendTo
改变数组项本身：sort、fill
其他API不会改变原始数组，所以不会触发UI刷新。
![image1](![](screenshots/device/image4.jpeg)
collections.Map

collections.Map可以触发UI刷新的API有：set、clear、delete。
![image1](![](screenshots/device/image5.jpeg)
collections.Set

collections.Set可以触发UI刷新的API有：add、clear、delete。
![image1](![](screenshots/device/image6.jpeg)
makeObserved的入参为JSON.parse的返回值
JSON.parse返回Object，无法使用@Trace装饰其属性，可以使用makeObserved使其变为可观察数据。
![image1](![](screenshots/device/image7.jpeg)
makeObserved和V2装饰器配合使用
makeObserved可以和V2的装饰器一起使用。对于@Monitor和@Computed，因为makeObserved传入@Observed或ObservedV2装饰的类实例会返回其自身，所以@Monitor或者@Computed不能定义在class中，只能定义在自定义组件里。
![image1](![](screenshots/device/image8.jpeg)
makeObserved在@Component内使用
makeObserved不能和V1的状态变量装饰器一起使用，但可以在@Component装饰的自定义组件里使用。
![image1](![](screenshots/device/image9.jpeg)getTarget后的数据可以正常赋值，但是无法触发UI刷新
getTarget可以获取状态管理框架代理前的原始对象。

makeObserved封装的观察对象，可以通过getTarget获取到其原始对象，对原始对象的赋值不会触发UI刷新。

![image1](![](screenshots/device/image10.jpeg)
![image1](![](screenshots/device/image11.jpeg)



## 使用说明
### 1.在进入主页面后，点击页面按钮进行查看

## 工程目录结构
```
MakeObserved
├─ AppScope
│  ├─ app.json5
│  └─ resources
│     └─ base
│        ├─ element
│        │  └─ string.json
│        └─ media
│           ├─ background.png
│           ├─ foreground.png
│           └─ layered_image.json
├─ code-linter.json5
├─ entry
│  ├─ hvigorfile.ts
│  ├─ obfuscation-rules.txt
│  ├─ oh-package.json5
│  └─ src
│     ├─ main
│     │  ├─ ets
│     │  │  ├─ common
│     │  │  │  └─ MyComponent.ets
│     │  │  ├─ entryability
│     │  │  │  └─ EntryAbility.ets
│     │  │  ├─ entrybackupability
│     │  │  │  └─ EntryBackupAbility.ets
│     │  │  ├─ Model
│     │  │  │  └─ modelView.ets
│     │  │  ├─ pages
│     │  │  │  └─ Index.ets
│     │  │  └─ View
│     │  │     ├─ Page1.ets
│     │  │     ├─ Page10.ets
│     │  │     ├─ Page2.ets
│     │  │     ├─ Page3.ets
│     │  │     ├─ Page4.ets
│     │  │     ├─ Page5.ets
│     │  │     ├─ Page6.ets
│     │  │     ├─ Page7.ets
│     │  │     ├─ Page8.ets
│     │  │     └─ Page9.ets
│     │  ├─ module.json5
│     │  └─ resources
│     │     ├─ base
│     │     │  ├─ element
│     │     │  │  ├─ color.json
│     │     │  │  ├─ float.json
│     │     │  │  └─ string.json
│     │     │  ├─ media
│     │     │  │  ├─ background.png
│     │     │  │  ├─ foreground.png
│     │     │  │  ├─ layered_image.json
│     │     │  │  └─ startIcon.png
│     │     │  └─ profile
│     │     │     ├─ backup_config.json
│     │     │     └─ main_pages.json
│     │     ├─ dark
│     │     │  └─ element
│     │     │     └─ color.json
│     │     └─ rawfile
│     ├─ mock
│     │  └─ mock-config.json5
│     ├─ ohosTest
│     │  ├─ ets
│     │  │  └─ test
│     │  │     ├─ Ability.test.ets
│     │  │     ├─ index.test.ets
│     │  │     └─ List.test.ets
│     │  └─ module.json5
│     └─ test
│        ├─ List.test.ets
│        └─ LocalUnit.test.ets
├─ hvigor
│  └─ hvigor-config.json5
├─ hvigorfile.ts
├─ index.test.ets
├─ oh-package-lock.json5
├─ oh-package.json5
├─ ohoTest.md
└─ README_zh.md

```
## 具体实现
1. 导入UIUtils模块并使用makeObserved接口
2. 处理不同类型数据的可观察转换
3. 与状态管理装饰器(@Local等)配合使用
4. 支持集合类型(collections.Array/Map/Set)的可观察转换
5. 为了将普通不可观察数据变为可观察数据，开发者可以使用makeObserved接口，makeObserved可以在@Trace无法标记的情况下使用。

亮点功能：
- 与@Sendable装饰类配合使用，支持跨线程数据传递后的可观察转换
- 处理JSON.parse返回的匿名对象的可观察转换

### 相关权限
不涉及。

### 依赖
不涉及。

### 约束与限制
.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API22版本SDK，版本号：6.0.0.33，镜像版本号：OpenHarmony_6.0.0.33。

3.本示例需要使用DevEco Studio 6.0.0 Canary1 (Build Version: 6.0.0.270， built on May 9, 2025)及以上版本才可编译运行。

### 下载
如需单独下载本工程，执行如下命令：

`````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/MakeObserved > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
`````