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
// [Start Internal_Common_Modifier_V2]
import { UIUtils } from '@kit.ArkUI';
import { CommonModifier } from '@ohos.arkui.modifier';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

class MyModifier extends CommonModifier {
  applyNormalAttribute(instance: CommonAttribute): void {
    super.applyNormalAttribute?.(instance);
  }

  public setGroup1(): void {
    this.borderStyle(BorderStyle.Dotted);
    this.borderWidth(8);
  }

  public setGroup2(): void {
    this.borderStyle(BorderStyle.Dashed);
    this.borderWidth(8);
  }
}

@ComponentV2
struct MyImage1 {
  @Param @Require modifier: CommonModifier;

  build() {
    // 此处'app.media.app_icon'仅作示例，请开发者自行替换，否则imageSource创建失败会导致后续无法正常执行。
    Image($r('app.media.app_icon'))
      .attributeModifier(this.modifier as MyModifier)
  }
}

@Entry
@ComponentV2
struct Index {
  // 使用makeObserved的能力来观测CommonModifier
  @Local myModifier: CommonModifier = UIUtils.makeObserved(new MyModifier().width(100).height(100).margin(10));
  index: number = 0;

  build() {
    Column() {
      Button($r('app.string.EntryAbility_label'))
        .margin(10)
        .onClick(() => {
          hilog.info(DOMAIN, 'testTag', 'Modifier', 'onClick');
          this.index++;
          if (this.index % 2 === 1) {
            (this.myModifier as MyModifier).setGroup1();
            hilog.info(DOMAIN, 'testTag', 'Modifier', 'setGroup1');
          } else {
            (this.myModifier as MyModifier).setGroup2();
            hilog.info(DOMAIN, 'testTag', 'Modifier', 'setGroup2');
          }
        })

      MyImage1({ modifier: this.myModifier })
    }
    .width('100%')
  }
}
// [End Internal_Common_Modifier_V2]
@Component
export struct InternalCommonModifierV2 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {

    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_Common_Modifier_V2'))
  }
}