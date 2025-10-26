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
// [Start Internal_Attribute_Updater_V1]
// xxx.ets
import { AttributeUpdater } from '@kit.ArkUI';

class MyButtonModifier extends AttributeUpdater<ButtonAttribute> {
  public flag: boolean = false;

  initializeModifier(instance: ButtonAttribute): void {
    instance.backgroundColor('#ff2787d9')
      .width('50%')
      .height(30)
  }

  applyNormalAttribute(instance: ButtonAttribute): void {
    if (this.flag) {
      instance.borderWidth(2);
    } else {
      instance.borderWidth(10);
    }
  }
}

@Entry
@Component
struct Index {
  @State modifier: MyButtonModifier = new MyButtonModifier();

  build() {
    Row() {
      Column() {
        Button('Button')
          .attributeModifier(this.modifier)
        Button('Update')
          .onClick(() => {
            this.modifier.flag = !this.modifier.flag;
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Internal_Attribute_Updater_V1]
@Component
export struct InternalAttributeUpdaterV1 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {

    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_Attribute_Updater_V1'))
  }
}