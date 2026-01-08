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

// [Start list_scrolling_with_for_each]
// xxx.ets
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_ReusableComponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'ReusableComponent_';

class MyDataSource implements IDataSource {
  private dataArray: string[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string {
    return this.dataArray[index];
  }

  public pushData(data: string): void {
    this.dataArray.push(data);
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

@Entry
@Component
struct Index {
  private data: MyDataSource = new MyDataSource();
  private data02: MyDataSource = new MyDataSource();
  @State isShow: boolean = true;
  @State dataSource: ListItemObject[] = [];

  aboutToAppear() {
    for (let i = 0; i < 100; i++) { // 循环100次
      this.data.pushData(i.toString());
    }

    for (let i = 30; i <= 80; i++) { // 循环50次
      this.data02.pushData(i.toString());
    }
  }

  build() {
    Column() {
      Row() {
        Button('clear').onClick(() => {
          for (let i = 1; i <= 50; i++) { // 循环50次
            this.dataSource.pop();
          }
        }).height(40)

        Button('update').onClick(() => {
          for (let i = 1; i <= 50; i++) { // 循环50次
            let obj = new ListItemObject();
            obj.id = i;
            obj.uuid = Math.random().toString();
            obj.isExpand = false;
            this.dataSource.push(obj);
          }
        }).height(40)
      }

      List({ space: 10 }) {
        ForEach(this.dataSource, (item: ListItemObject) => {
          ListItem() {
            ListItemView({
              obj: item
            })
          }
        }, (item: ListItemObject) => {
          return item.uuid.toString();
        })

      }.cachedCount(0)
      .width('100%')
      .height('100%')
    }
  }
}

@Reusable
@Component
struct ListItemView {
  @ObjectLink obj: ListItemObject;
  @State item: string = '';

  aboutToAppear(): void {
    // 点击 update，首次进入，上下滑动，由于Foreach折叠展开属性，无法复用。
    hilog.info(DOMAIN, TAG, BUNDLE + '=====aboutToAppear=====ListItemView==创建了==' + this.item);
  }

  aboutToReuse(params: ESObject) {
    this.item = params.item;
    // 点击clear，再次update，复用成功。
    // 符合一帧内重复创建多个已被销毁的自定义组件。
    hilog.info(DOMAIN, TAG, BUNDLE + '=====aboutToReuse====ListItemView==复用了==' + this.item);
  }

  build() {
    Column({ space: 10 }) {
      Text(`${this.obj.id}.标题`)
        .fontSize(16)
        .fontColor('#000000')
        .padding({
          top: 20,
          bottom: 20,
        })

      if (this.obj.isExpand) {
        Text('')
          .fontSize(14)
          .fontColor('#999999')
      }
    }
    .width('100%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .padding(15)
    .onClick(() => {
      this.obj.isExpand = !this.obj.isExpand;
    })
  }
}

@Observed
class ListItemObject {
  public uuid: string = '';
  public id: number = 0;
  public isExpand: boolean = false;
}
// [End list_scrolling_with_for_each]
