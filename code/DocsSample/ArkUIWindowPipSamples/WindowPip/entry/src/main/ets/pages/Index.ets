/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// Index.ets
// 应用首页
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack) {
      Scroll() {
        Flex({ direction: FlexDirection.Column }) {
          this.featureButton('使用XComponent实现画中画', this.xComponent);
          this.featureButton('使用TypeNode自由节点实现画中画', this.typeNodeFree);
          this.featureButton('使用Router导航时通过TypeNode实现画中画', this.routerImplement);
          this.featureButton('使用Navigation导航时通过TypeNode实现画中画', this.navImplement);
          this.featureButton('使用单页面Ability时通过TypeNode实现画中画', this.abilityImplement);
          this.featureButton('使用NDK接口实现画中画（C++）', this.ndkImplement);
        }
      }
    }
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor('#FFF1F3F5')
    .mode(NavigationMode.Stack)
    .title('画中画SampleCode')
  }

  @Builder
  featureButton(buttonText: string, callbackOnClick: () => void) {
    Button({ type: ButtonType.Normal }) {
      Row() {
        Column() {
          Text(buttonText)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#000000')
          Rect()
            .radius(1)
            .fill('#0A59F7')
            .height(2)
            .width(30)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
    }
    .width('90%')
    .padding('5%')
    .margin({ top: '3%', bottom: '2%', right: '3%' })
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .onClick(callbackOnClick)
  }

  private xComponent = () => {
    this.getUIContext().getRouter().pushUrl({ url: 'pages/XComponentImplementPage' }, router.RouterMode.Standard)
  }
  private typeNodeFree = () => {
    this.getUIContext().getRouter().pushUrl({ url: 'pages/TypeNodeFreePage' }, router.RouterMode.Standard)
  }
  private routerImplement = () => {
    this.getUIContext().getRouter().pushUrl({ url: 'pages/RouterImplementPage' }, router.RouterMode.Standard)
  }
  private navImplement = () => {
    this.getUIContext().getRouter().pushUrl({ url: 'pages/NavigationImplementPage' }, router.RouterMode.Standard)
  }
  private abilityImplement = () => {
    this.getUIContext().getRouter().pushUrl({ url: 'pages/AbilityImplementPage' }, router.RouterMode.Standard)
  }
  private ndkImplement = () => {
    this.getUIContext().getRouter().pushUrl({ url: 'pages/NDKImplementPage' }, router.RouterMode.Standard)
  }
}