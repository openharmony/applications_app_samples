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
// [Start TextComponent13_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[EvtryAblity]';

@Observed
class StyleList extends Array<TextStyles13> {
};

@Observed
class TextStyles13 {
  public fontSize: number;

  constructor(fontSize: number) {
    this.fontSize = fontSize;
  }
}

@Component
struct TextComponent13 {
  @ObjectLink textStyle13: TextStyles13;

  build() {
    Text('Hello World')
      .fontSize(this.textStyle13.fontSize)
  }
}

@Entry
@Component
struct Page13 {
  @State styleList: StyleList = new StyleList();

  aboutToAppear() {
    for (let i = 15; i < 50; i++) {
      this.styleList.push(new TextStyles13(i));
    }
  }

  build() {
    Column() {
      Text('Font Size List')
        .fontSize(50)
        .onClick(() => {
          for (let i = 0; i < this.styleList.length; i++) {
            this.styleList[i].fontSize++;
          }
          hilog.info(DOMAIN_NUMBER, TAG, 'change font size');
        })
      List() {
        ForEach(this.styleList, (item: TextStyles13) => {
          ListItem() {
            TextComponent13({ textStyle13: item })
          }
        })
      }
    }
  }
}
// [End TextComponent13_start]