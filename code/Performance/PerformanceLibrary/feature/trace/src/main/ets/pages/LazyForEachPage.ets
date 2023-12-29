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

import { IconItem } from '../view/IconView';
import { BasicDataSource } from '../viewmodel/BasicDataSource';

// List子组件主轴方向的间隔
const LIST_SPACE: number = 20;
// List分割线的宽度
const STROKE_WIDTH: number = 2;
// List分割线的起始位置
const START_MARGIN: number = 20;
// List分割线的结束位置
const END_MARGIN: number = 20;
// 设置子组件和兄弟元素在主轴上的权重
const LAYOUT_WEIGHT: number = 1;

// IconItem相关数据
class IconItemModel {
  image: string | Resource = '';
  text: string | Resource = '';

  constructor(image: string | Resource = '', text: string | Resource = '') {
    this.image = image;
    this.text = text;
  }
}

@Component
export struct LazyForEachPage {
  private iconItemSourceList = new ListData();

  aboutToAppear() {
    // 遍历添加120个IconItem的数据
    for (let index = 0; index < 20; index++) {
      const numStart: number = index * 6;
      // 此处循环使用三张图片资源
      this.iconItemSourceList.pushData(new IconItemModel($r('app.media.nearby'), `item${numStart + 1}`));
      this.iconItemSourceList.pushData(new IconItemModel($r('app.media.scan'), `item${numStart + 2}`));
      this.iconItemSourceList.pushData(new IconItemModel($r('app.media.shop'), `item${numStart + 3}`));
      this.iconItemSourceList.pushData(new IconItemModel($r('app.media.cards'), `item${numStart + 4}`));
      this.iconItemSourceList.pushData(new IconItemModel($r('app.media.album'), `item${numStart + 5}`));
      this.iconItemSourceList.pushData(new IconItemModel($r('app.media.applet'), `item${numStart + 6}`));
    }
  }

  build() {
    Column() {
      Text('懒加载示例')
        .fontSize($r('app.integer.LazyForEachPage_title_font'))
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .width($r('app.string.layout_90_percent'))
        .height($r('app.integer.LazyForEachPage_title_height'))
      List({ space:LIST_SPACE }) {
        LazyForEach(this.iconItemSourceList, (item: IconItemModel) => {
          ListItem() {
            IconItem({ image: item.image, text: item.text })
          }
        }, (item: IconItemModel, index) => index.toString())
      }
      .divider({ strokeWidth: STROKE_WIDTH, startMargin: START_MARGIN, endMargin: END_MARGIN }) // 每行之间的分界线
      .width($r('app.string.layout_100_percent'))
      .height($r('app.string.layout_100_percent'))
      .layoutWeight(LAYOUT_WEIGHT)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}

export class ListData extends BasicDataSource<IconItemModel> {
  private menuList: Array<IconItemModel> = [];

  public totalCount(): number {
    return this.menuList.length;
  }

  public getData(index: number): IconItemModel {
    return this.menuList[index];
  }

  public pushData(data: IconItemModel): void {
    this.menuList.push(data);
    this.notifyDataAdd(this.menuList.length - 1);
  }
}