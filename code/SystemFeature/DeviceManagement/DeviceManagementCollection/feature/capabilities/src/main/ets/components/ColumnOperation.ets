/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { getStringArray } from '@ohos/common/src/main/ets/util/ResourceUtil';

@Component
export struct ColumnOperation {
  private operationRes: Resource | undefined = undefined;
  @State operationSource: string[] = [];
  private doOperation: (index: number) => void = () => {
  };

  build() {
    Column() {
      ForEach(this.operationSource, (item: string, index: number) => {
        Row() {
          Button() {
            Text(item)
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor($r("app.color.list_title"))
              .width('100%')
              .padding({
                left: 16
              })
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .height(68)
          .borderRadius(20)
          .type(ButtonType.Normal)
          .backgroundColor($r("app.color.white"))
          .margin({ top: 16 })
          .onClick(() => {
            this.doOperation(index)
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }, (index: string) => index)
    }
    .width('100%')
  }

  async aboutToAppear() {
    if (this.operationRes !== undefined) {
      let menuList: Array<string> = await getStringArray(this.operationRes);
      this.operationSource = menuList;
    }
  }
}