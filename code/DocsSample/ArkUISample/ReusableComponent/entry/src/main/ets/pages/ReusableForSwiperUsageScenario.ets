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

// [Start reusable_for_swiper_usage_scenario]
@Entry
@Component
struct Index {
  private dataSource = new MyDataSource<Question>();

  aboutToAppear(): void {
    for (let i = 0; i < 1000; i++) { // 循环1000次
      let title = i + 1 + 'test_swiper';
      let answers = ['test1', 'test2', 'test3', 'test4'];
      // 请开发者自行在src/main/resources/base/media路径下添加app.media.app_icon图片，否则运行时会因资源缺失而报错。
      this.dataSource.pushData(new Question(i.toString(), title, $r('app.media.app_icon'), answers));
    }
  }

  build() {
    Column({ space: 5 }) {
      Swiper() {
        LazyForEach(this.dataSource, (item: Question) => {
          QuestionSwiperItem({ itemData: item });
        }, (item: Question) => item.id)
      }
    }
    .width('100%')
    .margin({ top: 5 })
  }
}

class Question {
  public id: string = '';
  public title: ResourceStr = '';
  public image: ResourceStr = '';
  public answers: Array<ResourceStr> = [];

  constructor(id: string, title: ResourceStr, image: ResourceStr, answers: Array<ResourceStr>) {
    this.id = id;
    this.title = title;
    this.image = image;
    this.answers = answers;
  }
}

@Reusable
@Component
struct QuestionSwiperItem {
  @State itemData: Question | null = null;

  aboutToReuse(params: Record<string, Object>): void {
    this.itemData = params.itemData as Question;
  }

  build() {
    Column() {
      Text(this.itemData?.title)
        .fontSize(18)
        .fontColor($r('sys.color.ohos_id_color_primary'))
        .alignSelf(ItemAlign.Start)
        .margin({
          top: 10,
          bottom: 16
        })
        
      Image(this.itemData?.image)
        .width('100%')
        .borderRadius(12)
        .objectFit(ImageFit.Contain)
        .margin({
          bottom: 16
        })
        .height(80)
        .width(80)

      Column({ space: 16 }) {
        ForEach(this.itemData?.answers, (item: Resource) => {
          Text(item)
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_primary'))
        }, (item: ResourceStr) => JSON.stringify(item))
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({
      left: 16,
      right: 16
    })
  }
}

class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }
}

export class MyDataSource<T> extends BasicDataSource<T> {
  private dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    return this.dataArray[index];
  }

  public pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
// [End reusable_for_swiper_usage_scenario]
