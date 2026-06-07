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

class ListMultiSelectData {
  public id: number;
  public sender: string;
  public title: string;
  public summary: string;
  public avatar: string;

  constructor(id: number, sender: string, title: string, summary: string, avatar: string) {
    this.id = id;
    this.sender = sender;
    this.title = title;
    this.summary = summary;
    this.avatar = avatar;
  }
}

class ListMultiSelectDataSource implements IDataSource {
  private dataArray: ListMultiSelectData[] = [];
  private listeners: DataChangeListener[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): ListMultiSelectData {
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

  public pushData(data: ListMultiSelectData): void {
    this.dataArray.push(data);
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(this.dataArray.length - 1);
    })
  }
}

@Entry
@Component
export struct ListFingerSwipeMultiSelectDyn {
  private dataSource: ListMultiSelectDataSource = new ListMultiSelectDataSource();
  private avatarColors: string[] = ['#317AF7', '#00A878', '#F7A531', '#8A5CF6', '#D94854', '#2A8C9C'];
  @State enableEditMode: boolean = false;
  @State selectedIds: number[] = [];
  @State useDefaultMultiSelectStyle: boolean = true;

  aboutToAppear(): void {
    if (this.dataSource.totalCount() > 0) {
      return;
    }
    let senders: string[] = ['Operations', 'Design Team', 'Project Bot', 'Support Center', 'Meeting Bot', 'Cloud Drive'];
    let titles: string[] = [
      'Weekly report approval',
      'Design review reminder',
      'Release plan update',
      'Customer feedback queue',
      'Meeting notes generated',
      'Storage cleanup suggestion'
    ];
    let summaries: string[] = [
      'Use stable ids with dynamic data to keep selection state correct after refresh.',
      'Enter edit mode with two-finger swipe and select continuous review messages.',
      'LazyForEach creates nearby list items on demand while release messages keep growing.',
      'Feedback messages can be selected in batches and archived after processing.',
      'Meeting notifications are easier to manage when selected continuously in edit mode.',
      'Drive reminders are loaded on demand, which fits long message list scenarios.'
    ];
    let avatars: string[] = ['O', 'D', 'P', 'S', 'M', 'C'];
    for (let index = 0; index < 72; index++) {
      let sourceIndex: number = index % senders.length;
      this.dataSource.pushData(new ListMultiSelectData(index, senders[sourceIndex],
        titles[sourceIndex] + ' ' + (index + 1).toString(), summaries[sourceIndex],
        avatars[sourceIndex]));
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

  private avatarColor(index: number): string {
    return this.avatarColors[index % this.avatarColors.length];
  }

  @Builder
  private OperationBar() {
    Row({ space: 12 }) {
      Column({ space: 2 }) {
        Text('Inbox')
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
  private ItemContent(item: ListMultiSelectData, index: number) {
    Row({ space: 12 }) {
      Text(item.avatar)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)
        .width(42)
        .height(42)
        .borderRadius(21)
        .backgroundColor(this.avatarColor(index))

      Column({ space: 6 }) {
        Row({ space: 8 }) {
          Text(item.title)
            .fontSize(15)
            .fontColor('#182431')
            .layoutWeight(1)
        }
        .width('100%')

        Text(item.summary)
          .fontSize(13)
          .fontColor('#5B6470')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(14)
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        this.OperationBar()

        // [Start Add_list_select]
        List({ space: 10 }) {
          // [StartExclude Add_list_select]
          LazyForEach(this.dataSource, (item: ListMultiSelectData, index: number) => {
            // [Start Add_list_item_select]
            ListItem() {
              this.ItemContent(item, index)
            }
            .selectable(true)
            .selected(this.isSelected(item.id))
            .onSelect((selected: boolean) => {
              this.updateSelected(item.id, selected);
            })
            // [End Add_list_item_select]
            .borderRadius(10)
            .stateStyles({
              normal: {
                .backgroundColor('#FFFFFF')
                .borderWidth(1)
                .borderColor('#E5E8EF')
              },
              selected: {
                .backgroundColor('#F0F7FF')
                .borderWidth(1)
                .borderColor('#317AF7')
              }
            })
          }, (item: ListMultiSelectData): string => item.id.toString())
          // [EndExclude Add_list_select]
        }
        .enableEditMode(this.enableEditMode)
        .onEditModeChange((enabled: boolean) => {
          this.setEditMode(enabled);
        })
        .editModeOptions({ useDefaultMultiSelectStyle: true, enableTwoFingerMultiSelect: true })
        // [End Add_list_select]
        // [Start Add_list_GestureRecognizerJudgeBegin]
        .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
          recognizers: Array<GestureRecognizer>) => {
          // [StartExclude Add_list_GestureRecognizerJudgeBegin]
          if (this.useDefaultMultiSelectStyle) {
            return GestureJudgeResult.CONTINUE;
          }
          // [EndExclude Add_list_GestureRecognizerJudgeBegin]
          // 以滑动多选的判定热区在列表左边，且宽度为48vp为例
          if (current.getTag() !== 'SWIPESELECT' && this.enableEditMode && event.fingerList[0].localX < 48) {
            return GestureJudgeResult.REJECT;
          }
          return GestureJudgeResult.CONTINUE;
        })
        // [End Add_list_GestureRecognizerJudgeBegin]
        .layoutWeight(1)
        .width('100%')
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#F5F7FA')
    }
    .title($r('app.string.ListSwipeSelect_title'))
  }
}
