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

// [Start spring_curve]
import { curves } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

class Spring {
  public title: string;
  public subTitle: string;
  public iCurve: ICurve;

  constructor(title: string, subTitle: string, iCurve: ICurve) {
    this.title = title;
    this.iCurve = iCurve;
    this.subTitle = subTitle;
  }
}

// 弹簧组件
@Component
struct Motion {
  @Prop dRotate: number = 0;
  private title: string = '';
  private subTitle: string = '';
  private iCurve: ICurve | undefined = undefined;

  build() {
    Column() {
      Circle()
        .translate({ y: this.dRotate })
        .animation({ curve: this.iCurve, iterations: -1 })
        .foregroundColor('#317AF7')
        .width(30)
        .height(30)

      Column() {
        Text(this.title)
          .fontColor(Color.Black)
          .fontSize(10).height(30)
        Text(this.subTitle)
          .fontColor(0xcccccc)
          .fontSize(10).width(50)
      }
      .borderWidth({ top: 1 })
      .borderColor(0xf5f5f5)
      .width(80)
      .alignItems(HorizontalAlign.Center)
      .height(100)

    }
    .height(110)
    .margin({ bottom: 5 })
    .alignItems(HorizontalAlign.Center)
  }
}

@Entry
@Component
export struct SpringCurve {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State dRotate: number = 0;
  private springs: Spring[] = [
    // 请在resources\base\element\string.json文件中配置name为'springCurve_text1'，value为非空字符串的资源
    new Spring('springMotion', this.context.resourceManager.getStringByNameSync('springCurve_text1'),
      curves.springMotion(1, 0.25)),
    new Spring('responsive' + '\n' + 'SpringMotion',
      // 请在resources\base\element\string.json文件中配置name为'springCurve_text2'，value为非空字符串的资源
      this.context.resourceManager.getStringByNameSync('springCurve_text2'),
      curves.responsiveSpringMotion(1, 0.25)),
    new Spring('interpolating' + '\n' + 'Spring',
      // 请在resources\base\element\string.json文件中配置name为'springCurve_text3'，value为非空字符串的资源
      this.context.resourceManager.getStringByNameSync('springCurve_text3'),
      curves.interpolatingSpring(10, 1, 228, 30)),
    // 请在resources\base\element\string.json文件中配置name为'springCurve_text1'，value为非空字符串的资源
    new Spring('springCurve', this.context.resourceManager.getStringByNameSync('springCurve_text1'),
      curves.springCurve(10, 1, 228, 30))
  ];

  build() {
    Row() {
      ForEach(this.springs, (item: Spring) => {
        Motion({
          title: item.title,
          subTitle: item.subTitle,
          iCurve: item.iCurve,
          dRotate: this.dRotate
        })
      })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Bottom)
    .width('100%')
    .height(437)
    .margin({ top: 20 })
    .onClick(() => {
      this.dRotate = -50;
    })
  }
}

// [End spring_curve]