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
// [Start Information_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[EvtryAblity]';

@Observed
class InfoList extends Array<Info> {
};

@Observed
class Info {
  public ids: number;
  public age: number;
  public gender: string;

  constructor() {
    this.ids = Math.floor(Math.random() * 1000);
    this.age = Math.floor(Math.random() * 100 % 40);
    this.gender = Math.floor(Math.random() * 100) % 2 == 0 ? 'Male' : 'Female';
  }
}

@Component
struct Information {
  @ObjectLink info: Info;
  @State index: number = 0;

  isRenderText(index: number): number {
    hilog.info(DOMAIN_NUMBER, TAG, `index ${index} is rendered`);
    return 1;
  }

  build() {
    Row() {
      Text('id: ' + this.info.ids)
        .fontSize(20)
        .margin({
          left: 30,
          right: 5
        })
      Text('age: ' + this.info.age)
        .fontSize(20)
        .margin({
          left: 5,
          right: 5
        })
        .position({ x: 100 })
        .opacity(this.isRenderText(this.index))
        .onClick(() => {
          this.info.age++;
        })
      Text('gender: ' + this.info.gender)
        .margin({
          left: 5,
          right: 5
        })
        .position({ x: 180 })
        .fontSize(20)
    }
  }
}

@Entry
@Component
struct Page2 {
  @State infoList: InfoList = new InfoList();
  @State items: string[] = [];

  aboutToAppear() {
    this.items.push('Head');
    this.items.push('List');
    for (let i = 0; i < 20; i++) {
      this.infoList.push(new Info());
    }
  }

  build() {
    Row() {
      Column() {
        ForEach(this.items, (item: string) => {
          if (item == 'Head') {
            Text('Personal Info')
              .fontSize(40)
          } else if (item == 'List') {
            List() {
              ForEach(this.infoList, (info: Info, index) => {
                ListItem() {
                  Information({
                    info: info,
                    index: index
                  })
                }
                .margin({
                  top: 5,
                  bottom: 5
                })
              })
            }
          }
        })
      }
    }
  }
}
// [End Information_start]