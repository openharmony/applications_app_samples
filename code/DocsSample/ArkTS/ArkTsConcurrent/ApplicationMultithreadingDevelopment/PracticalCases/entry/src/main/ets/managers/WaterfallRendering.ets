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

// [Start receive_child_thread_data_render_waterfall_component]
import { WaterFlowDataSource } from './WaterFlowDataSource';
import { getImgFromDB } from './Mock';
import resource from '../util/resource';

// 模拟图片数组
let img = new Array<string>(33);

export function fillImg(imgArr: Array<string>) {
  img = imgArr;
}

@Entry
@Component
struct WaterFlowDemo {
  @State minSize: number = 80;
  @State maxSize: number = 180;
  @State fontSize: number = 24;
  @State colors: number[] = [0xFFC0CB, 0xDA70D6, 0x6B8E23, 0x6A5ACD, 0x00FFFF, 0x00FF7F];
  scroller: Scroller = new Scroller();
  dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  private itemWidthArray: number[] = [];
  private itemHeightArray: number[] = [];

  // 计算FlowItem宽/高
  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize);
    return (ret > this.minSize ? ret : this.minSize);
  }

  // 设置FlowItem的宽/高数组
  setItemSizeArray() {
    for (let i = 0; i < 100; i++) {
      this.itemWidthArray.push(this.getSize());
      this.itemHeightArray.push(this.getSize());
    }
  }

  aboutToAppear() {
    this.setItemSizeArray();
  }

  @Builder
  itemFoot() {
    Column() {
      Text(`Footer`)
        .fontSize(10)
        .backgroundColor(Color.Red)
        .width(50)
        .height(50)
        .align(Alignment.Center)
        .margin({ top: 2 });
    }
  }

  build() {
    Column({ space: 2 }) {
      Text('ArkUI WaterFlow Demo')
        .onAppear(() => {
          getImgFromDB();
        })
      WaterFlow() {
        LazyForEach(this.dataSource, (item: number) => {
          FlowItem() {
            Column() {
              Text('N' + item)
                .fontSize(12)
                .height('16')
                .onClick(() => {
                });
              // 为了模拟图片加载，使用Text组件显示，正常加载jpg文件时，可以直接使用Image组件
              // 参考 Image(this.img[item % 33]).objectFit(ImageFit.Contain).width('100%').layoutWeight(1)
              if (img[item % 33] == null) {
                Text(resource.resourceToString($r('app.string.Image_loading')))
                  .width('100%')
                  .layoutWeight(1);
              }
              Text(img[item % 33])
                .width('100%')
                .layoutWeight(1);
            }
          }
          .onAppear(() => {
            // 即将触底时提前增加数据
            if (item + 20 == this.dataSource.totalCount()) {
              for (let i = 0; i < 100; i++) {
                this.dataSource.addLastItem();
              }
            }
          })
          .width('100%')
          .height(this.itemHeightArray[item % 100])
          .backgroundColor(this.colors[item % 5])
        }, (item: string) => item)
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(10)
      .rowsGap(5)
      .backgroundColor(0xFAEEE0)
      .width('100%')
      .height('100%')
      .onReachStart(() => {
        console.info('TaskPoolTest-waterFlow reach start');
      })
      .onScrollStart(() => {
        console.info('TaskPoolTest-waterFlow scroll start');
      })
      .onScrollStop(() => {
        console.info('TaskPoolTest-waterFlow scroll stop');
      })
      .onScrollFrameBegin((offset: number, state: ScrollState) => {
        console.info('TaskPoolTest-waterFlow scrollFrameBegin offset: ' + offset + ' state: ' + state.toString());
        return { offsetRemain: offset };
      })
    }
  }
}
// [End receive_child_thread_data_render_waterfall_component]