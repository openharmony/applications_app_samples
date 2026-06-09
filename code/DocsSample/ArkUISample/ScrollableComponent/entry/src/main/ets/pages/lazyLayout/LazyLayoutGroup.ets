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

// [Start lazy_layout_group]
import { LengthMetrics, LazyColumnLayout, LazyColumnLayoutAttribute } from '@kit.ArkUI';

class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  protected dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    return this.dataArray[index];
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

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

class MyDataSource<T> extends BasicDataSource<T> {
  public pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

class PhotoGroup {
  public title: string
  public photos: MyDataSource<number> = new MyDataSource<number>()

  constructor(title: string) {
    this.title = title
  }
}

@Entry
@Component
export struct LazyLayoutGroup {
  private groupData: MyDataSource<PhotoGroup> = new MyDataSource<PhotoGroup>();

  aboutToAppear(): void {
    // 初始化数据
    const months: string[] = ['2026年1月', '2026年2月', '2026年3月'];
    for (let m = 0; m < months.length; m++) {
      let group = new PhotoGroup(months[m]);
      let photoCount = 6 + m * 3;
      for (let i = 0; i < photoCount; i++) {
        group.photos.pushData(i);
      }
      this.groupData.pushData(group);
    }
  }

  // 外层 footer：底部工具栏，始终吸底
  @Builder
  BottomToolBarBuilder() {
    Row() {
      Column() {
        SymbolGlyph($r('sys.symbol.picture_fill'))
          .fontSize(24)
          .fontColor(['#FF007DFF'])
        // 请将$r('app.string.lazyLayout_photo')替换为实际资源文件，在本示例中该资源文件的value值为"照片"
        Text($r('app.string.lazyLayout_photo'))
          .fontSize(12)
          .fontColor('#FF007DFF')
          .margin({ top: 2 })
      }

      Column() {
        SymbolGlyph($r('sys.symbol.square_fill_grid_2x2'))
          .fontSize(24)
          .fontColor([Color.Gray])
        // 请将$r('app.string.lazyLayout_album')替换为实际资源文件，在本示例中该资源文件的value值为"相册"
        Text($r('app.string.lazyLayout_album'))
          .fontSize(12)
          .fontColor(Color.Gray)
          .margin({ top: 2 })
      }
      .margin({ left: 36 })

      Blank()
      // 请将$r('app.string.lazyLayout_select')替换为实际资源文件，在本示例中该资源文件的value值为"选择"
      Text($r('app.string.lazyLayout_select'))
        .fontSize(14)
        .fontColor('#FF007DFF')
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  // [Start lazy_layout_header]
  // 内层分组 header：月份标题，滚动时吸顶
  @Builder
  MonthHeaderBuilder(title: string, count: number) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
      Blank()
      // 请将$r('app.string.lazyLayout_photo_count')替换为实际资源文件，在本示例中该资源文件的value值为"%d张"
      Text($r('app.string.lazyLayout_photo_count', count))
        .fontSize(14)
        .fontColor(Color.Gray)
    }
    .width('100%')
    .height(48)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  // [StartExclude lazy_layout_header]
  // [Start lazy_layout_footer]
  // 分组 footer：仅最后一组底部显示"已经到底了"
  @Builder
  GroupFooterBuilder(index: number) {
    if (index === this.groupData.totalCount() - 1) {
      // 请将$r('app.string.lazyLayout_no_more_content')替换为实际资源文件，在本示例中该资源文件的value值为"—— 已经到底了 ——"
      Text($r('app.string.lazyLayout_no_more_content'))
        .fontSize(14)
        .fontColor(Color.Gray)
        .width('100%')
        .height(48)
        .textAlign(TextAlign.Center)
    }
  }
  // [EndExclude lazy_layout_header]

  build() {
    // [StartExclude lazy_layout_header]
    // [StartExclude lazy_layout_footer]
    NavDestination() {
      Scroll() {
        // 外层容器：footer吸底
        LazyColumnLayout() {
          // [EndExclude lazy_layout_footer]
          // [EndExclude lazy_layout_header]
          // 通过LazyForEach动态创建每个月份分组
          LazyForEach(this.groupData, (group: PhotoGroup, index: number) => {
            // 内层：每个分组为一个网格布局，header吸顶
            LazyVGridLayout() {
              // 子组件
              // [StartExclude lazy_layout_header]
              // [StartExclude lazy_layout_footer]
              LazyForEach(group.photos, (item: number) => {
                Column() {
                  SymbolGlyph($r('sys.symbol.picture'))
                    .fontSize(24)
                    .fontColor([Color.Gray])
                }
                .width('100%')
                .aspectRatio(1)
                .borderRadius(4)
                .backgroundColor('#e8e8e8')
                .justifyContent(FlexAlign.Center)
              }, (item: number) => `${index}_${item}`)
              // [EndExclude lazy_layout_footer]
              // [EndExclude lazy_layout_header]
            }
            // [StartExclude lazy_layout_header]
            // [StartExclude lazy_layout_footer]
            .columnsTemplate('1fr 1fr 1fr')
            .rowsGap(LengthMetrics.vp(2))
            .columnsGap(LengthMetrics.vp(2))
            // [EndExclude lazy_layout_header]
            .header(this.MonthHeaderBuilder(group.title, group.photos.totalCount()))
            // [EndExclude lazy_layout_footer]
            // [StartExclude lazy_layout_header]
            .footer(this.GroupFooterBuilder(index))
            // [StartExclude lazy_layout_footer]
            .sticky(StickyStyle.Header)
            // [EndExclude lazy_layout_footer]
            // [EndExclude lazy_layout_header]
          }, (group: PhotoGroup) => group.title)
          // [StartExclude lazy_layout_header]
          // [StartExclude lazy_layout_footer]
        }
        .space(LengthMetrics.vp(12))
        .footer(this.BottomToolBarBuilder())
        .sticky(StickyStyle.Footer)
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .layoutWeight(1)
      .backgroundColor(Color.White)
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.lazyLayout_group_title')替换为实际资源文件
    // 在本示例中该资源文件的value值为"分组展示与粘性标题"
    .title($r('app.string.lazyLayout_group_title'))
    // [EndExclude lazy_layout_footer]
    // [EndExclude lazy_layout_header]
  }
  // [End lazy_layout_footer]
  // [End lazy_layout_header]
}
// [End lazy_layout_group]
