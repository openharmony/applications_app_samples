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

class GridMultiSelectData {
  public id: number;
  public name: string;
  public category: string;
  public count: string;
  public size: string;

  constructor(id: number, name: string, category: string, count: string, size: string) {
    this.id = id;
    this.name = name;
    this.category = category;
    this.count = count;
    this.size = size;
  }
}

class GridMultiSelectDataSource implements IDataSource {
  private dataArray: GridMultiSelectData[] = [];
  private listeners: DataChangeListener[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): GridMultiSelectData {
    return this.dataArray[index];
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
    const index: number = this.listeners.indexOf(listener);
    if (index >= 0) {
      this.listeners.splice(index, 1);
    }
  }

  public pushData(data: GridMultiSelectData): void {
    this.dataArray.push(data);
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(this.dataArray.length - 1);
    })
  }
}

@Entry
@Component
export struct GridSwipeSelect {
  private dataSource: GridMultiSelectDataSource = new GridMultiSelectDataSource();
  private colors: string[] = ['#E8F4FF', '#EAF7EE', '#FFF4D9', '#F6ECFF', '#EFFFFB', '#FFF0F0'];
  @State enableEditMode: boolean = false;
  @State selectedIds: number[] = [];

  aboutToAppear(): void {
    if (this.dataSource.totalCount() > 0) {
      return;
    }
    let names: string[] = ['Project Docs', 'Design Assets', 'Meeting Pack', 'Contracts', 'Test Reports', 'Image Library'];
    let categories: string[] = ['Docs', 'Assets', 'Meeting', 'Legal', 'Report', 'Image'];
    for (let index = 0; index < 96; index++) {
      let sourceIndex: number = index % names.length;
      this.dataSource.pushData(new GridMultiSelectData(index, names[sourceIndex] + ' ' + (index + 1).toString(),
        categories[sourceIndex], (12 + index % 36).toString() + ' files',
        (24 + index % 80).toString() + ' MB'));
    }
  }

  private isSelected(id: number): boolean {
    return this.selectedIds.indexOf(id) >= 0;
  }

  private updateSelected(id: number, selected: boolean): void {
    let nextSelectedIds: number[] = this.selectedIds.slice();
    let index: number = nextSelectedIds.indexOf(id);
    if (selected && index < 0) {
      nextSelectedIds.push(id);
    }
    if (!selected && index >= 0) {
      nextSelectedIds.splice(index, 1);
    }
    this.selectedIds = nextSelectedIds;
  }

  private setEditMode(enabled: boolean): void {
    this.enableEditMode = enabled;
    if (!enabled) {
      this.selectedIds = [];
    }
  }

  private itemColor(index: number): string {
    return this.colors[index % this.colors.length];
  }

  @Builder
  private OperationBar() {
    Row({ space: 12 }) {
      Column({ space: 2 }) {
        Text('Project Files')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#182431')
        Text(this.selectedIds.length.toString() + ' selected')
          .fontSize(13)
          .fontColor('#5B6470')
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      Button(this.enableEditMode ? 'Done' : 'Edit')
        .onClick(() => {
          this.setEditMode(!this.enableEditMode);
        })
    }
    .width('100%')
    .padding({ left: 4, right: 4 })
  }

  @Builder
  private GridCard(item: GridMultiSelectData, index: number) {
    Column({ space: 8 }) {
      Row() {
        SymbolGlyph($r('sys.symbol.folder_fill'))
          .fontSize(32)
          .fontColor(['#317AF7'])

        Blank()

        Text(item.category)
          .fontSize(11)
          .fontColor('#317AF7')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(8)
          .backgroundColor('#FFFFFF')
      }
      .width('100%')

      Text(item.name)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#182431')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(item.count)
        .fontSize(12)
        .fontColor('#5B6470')

      Text(item.size)
        .fontSize(12)
        .fontColor('#7A8491')
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(126)
    .padding(12)
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        this.OperationBar()

        // [Start Add_grid_select]
        Grid() {
          // [StartExclude Add_grid_select]
          LazyForEach(this.dataSource, (item: GridMultiSelectData, index: number) => {
            // [Start Add_grid_item_select]
            GridItem() {
              this.GridCard(item, index)
            }
            .selectable(true)
            .selected(this.isSelected(item.id))
            .onSelect((selected: boolean) => {
              this.updateSelected(item.id, selected);
            })
            // [End Add_grid_item_select]
            .borderRadius(12)
            .stateStyles({
              normal: {
                .backgroundColor(this.itemColor(index))
                .borderWidth(1)
                .borderColor('#E5E8EF')
              },
              selected: {
                .backgroundColor('#F0F7FF')
                .borderWidth(1)
                .borderColor('#317AF7')
              }
            })
          }, (item: GridMultiSelectData): string => item.id.toString())
          // [EndExclude Add_grid_select]
        }
        .enableEditMode(this.enableEditMode)
        .onEditModeChange((enabled: boolean) => {
          this.setEditMode(enabled);
        })
        .editModeOptions({ useDefaultMultiSelectStyle: true, enableTwoFingerMultiSelect: true })
        // [End Add_grid_select]
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .layoutWeight(1)
        .width('100%')
        .scrollBar(BarState.Auto)
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#F5F7FA')
    }
    .title($r('app.string.GridSwipeSelect_title'))
  }
}
