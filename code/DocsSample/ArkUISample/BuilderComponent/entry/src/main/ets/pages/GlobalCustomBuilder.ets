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
// [Start global_custom_builder_function]
class ChildTmp {
  public val: number = 1;
}

class ParamTmp {
  public strValue: string = 'Hello';
  public numValue: number = 0;
  public tmpValue: ChildTmp = new ChildTmp();
  public arrayTmpValue: Array<ChildTmp> = [];
}

@Builder
function overBuilder(param: ParamTmp) {
  Column() {
    Text(`strValue: ${param.strValue}`)
      .width(230)
      .height(40)
      .margin(12)
      .backgroundColor('#0d000000')
      .fontColor('#e6000000')
      .borderRadius(20)
      .textAlign(TextAlign.Center)
    Text(`numValue: ${param.numValue}`)
      .width(230)
      .height(40)
      .margin(12)
      .backgroundColor('#0d000000')
      .fontColor('#e6000000')
      .borderRadius(20)
      .textAlign(TextAlign.Center)
    Text(`tmpValue: ${param.tmpValue.val}`)
      .width(230)
      .height(40)
      .margin(12)
      .backgroundColor('#0d000000')
      .fontColor('#e6000000')
      .borderRadius(20)
      .textAlign(TextAlign.Center)
    ForEach(param.arrayTmpValue, (item: ChildTmp) => {
      ListItem() {
        Text(`arrayTmpValue: ${item.val}`)
          .width(230)
          .height(40)
          .margin(12)
          .backgroundColor('#0d000000')
          .fontColor('#e6000000')
          .borderRadius(20)
          .textAlign(TextAlign.Center)
      }
    }, (item: ChildTmp) => JSON.stringify(item))
  }
}

@Entry
@Component
struct ParentDemo {
  @State objParam: ParamTmp = new ParamTmp();

  build() {
    Column() {
      Text('UI Rendered via @Builder')
        .fontSize(20)
        .margin(12)
      // 调用全局@Builder函数overBuilder
      overBuilder({
        strValue: this.objParam.strValue,
        numValue: this.objParam.numValue,
        tmpValue: this.objParam.tmpValue,
        arrayTmpValue: this.objParam.arrayTmpValue
      })
      Button('Update Values').onClick(() => {
        this.objParam.strValue = 'Hello World';
        this.objParam.numValue = 1;
        this.objParam.tmpValue.val = 8;
        const childValue: ChildTmp = {
          val: 2
        }
        this.objParam.arrayTmpValue.push(childValue);
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End global_custom_builder_function]