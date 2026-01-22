/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[Sample_StateManagement]';

@Observed
class StyleList extends Array<TextStyles> {
}

@Observed
class TextStyles {
  public fontSize: number;

  constructor(fontSize: number) {
    this.fontSize = fontSize;
  }
}

@Entry
@Component
struct Page {
  @State styleList: StyleList = new StyleList();

  aboutToAppear() {
    for (let i = 15; i < 50; i++) {
      this.styleList.push(new TextStyles(i));
    }
  }

  build() {
    Column() {
      // [Start array_foreach_error]
      Text('Font Size List')
        .fontSize(50)
        .onClick(() => {
          for (let i = 0; i < this.styleList.length; i++) {
            // 此处想要修改的是this.styleList[i]对象的fontSize属性
            // 修改之前调用canBeObserved接口获取this.styleList[i]对象关联的组件信息
            hilog.info(DOMAIN_NUMBER, TAG, `res: ${JSON.stringify(UIUtils.canBeObserved(this.styleList[i]))}`);
            this.styleList[i].fontSize++;
          }
          hilog.info(DOMAIN_NUMBER, TAG, 'change font size');
        })
      // [End array_foreach_error]
      List() {
        ForEach(this.styleList, (item: TextStyles) => {
          ListItem() {
            Text('Hello World')
              .fontSize(item.fontSize)
          }
        })
      }
    }
  }
}

const stateArrayForeachPage = Page;
export default stateArrayForeachPage;