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

import { ComponentCard } from '../../common/Card';
// [Start richEditor_eventPaste]
import { pasteboard } from '@kit.BasicServicesKit';
// [End richEditor_eventPaste]
import resource from '../../common/resource';

@Component
struct event1 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  controller1: RichEditorController = new RichEditorController();
  options1: RichEditorOptions = { controller: this.controller1 };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_1'),
        description: $r('app.string.Add_Event_title_1_desc')
      }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_1')), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
      }
    }
  }
}

@Component
struct event2 {
  // [Start richEditor_eventSelectChange]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };
  // [End richEditor_eventSelectChange]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_2'),
        description: $r('app.string.Add_Event_title_2_desc'),
      }) {
        Column({ space: 3 }) {
          // [Start richEditor_eventSelectChange]
          // $r('app.string.xxx')需要替换为开发者所需的字符串
          RichEditor(this.options)
            .onReady(() => {
              this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_2')), {
                style: {
                  fontColor: Color.Black,
                  fontSize: 15
                }
              })
            })
            .onSelectionChange((value: RichEditorRange) => {
              this.infoShowController.addTextSpan('\n' + resource.resourceToString($r('app.string.AddEvent_Text_3')) +
              value.start + ',' + value.end + ')', {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
            .width(300)
            .height(50)
          Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300)
          RichEditor(this.infoShowOptions)
            .width(300)
            .height(70)
          // [End richEditor_eventSelectChange]
        }
      }
    }
  }
}

@Component
struct event3 {
  // [Start richEditor_eventChange]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };
  // [StartExclude richEditor_eventChange]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_3'),
        description: $r('app.string.Add_Event_title_3_desc')
      }) {
        Column({ space: 3 }) {
          // [EndExclude richEditor_eventChange]
          RichEditor(this.options)
            .onReady(() => {
              // $r('app.string.AddEvent_Text_5')需要替换为开发者所需的资源文件
              this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_5')), {
                style: {
                  fontColor: Color.Black,
                  fontSize: 15
                }
              })
            })
            .onWillChange((value: RichEditorChangeValue) => {
              // $r('app.string.AddEvent_Text_6')需要替换为开发者所需的资源文件
              this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_6')) +
              JSON.stringify(value), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
              return true;
            })
            .onDidChange((rangeBefore: TextRange, rangeAfter: TextRange) => {
              // $r('app.string.AddEvent_Text_7')需要替换为开发者所需的资源文件
              this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_7')) +
              JSON.stringify(rangeBefore) + '\nrangeAfter：' + JSON.stringify(rangeBefore), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
            .width(300)
            .height(50);
          // $r('app.string.AddEvent_Text_4')需要替换为开发者所需的资源文件
          Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300);
          RichEditor(this.infoShowOptions)
            .width(300)
            .height(70);
            // [End richEditor_eventChange]
        }
      }
    }
  }
}

@Component
struct event4 {
  // [Start richEditor_eventInput]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };
  // [StartExclude richEditor_eventInput]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_4'),
        description: $r('app.string.Add_Event_title_4_desc'),
      }) {
        Column({ space: 3 }) {
          // [EndExclude richEditor_eventInput]
          // $r('app.string.xxx')需要替换为开发者所需的资源文件
          RichEditor(this.options)
            .onReady(() => {
              this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_8')), {
                style: {
                  fontColor: Color.Black,
                  fontSize: 15
                }
              })
            })
            .aboutToIMEInput((value: RichEditorInsertValue) => {
              this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_9')) +
              JSON.stringify(value), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
              return true;
            })
            .onDidIMEInput((value: TextRange) => {
              this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_10')) +
              JSON.stringify(value), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
            .width(300)
            .height(50)
          Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300)
          RichEditor(this.infoShowOptions)
            .width(300)
            .height(70)
            // [End richEditor_eventInput]
        }
      }
    }
  }
}

// [Start richEditor_eventPaste]
@Component
struct on_cut_copy_paste {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };

  PopDataFromPasteboard() {
    let selection = this.controller.getSelection();
    let start = selection.selection[0];
    let end = selection.selection[1];
    if (start == end) {
      start = this.controller.getCaretOffset();
      end = this.controller.getCaretOffset();
    }
    let moveOffset = 0;
    let sysBoard = pasteboard.getSystemPasteboard();
    sysBoard.getData((err, data) => {
      if (err) {
        return;
      }
      if (start != end) {
        this.controller.deleteSpans({ start: start, end: end });
      }
      let count = data.getRecordCount();
      for (let i = 0; i < count; i++) {
        const element = data.getRecord(i);
        if (element && element.plainText && element.mimeType === pasteboard.MIMETYPE_TEXT_PLAIN) {
          this.controller.addTextSpan(element.plainText,
            {
              style: { fontSize: 26, fontColor: Color.Red },
              offset: start + moveOffset
            }
          )
          moveOffset += element.plainText.length;
        }
      }
      this.controller.setCaretOffset(start + moveOffset);
    });
  }

  build() {
    Column() {
      // $r('app.string.xxx')需要替换为开发者所需的资源文件
      ComponentCard({
        title: $r('app.string.Add_Event_title_5'),
        description: $r('app.string.Add_Event_title_5_desc')
      }) {
        Column({ space: 3 }) {
          RichEditor(this.options)
            .onReady(() => {
              this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_11')),
                { style: { fontColor: Color.Black, fontSize: 15 } })
            })
            .onPaste((event) => {
              this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_12')),
                { style: { fontColor: Color.Gray, fontSize: 10 } })
              if (event != undefined && event.preventDefault) {
                event.preventDefault();
              }
              this.PopDataFromPasteboard()
            })
            .width(300)
            .height(50);
          Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300);
          RichEditor(this.infoShowOptions)
            .width(300)
            .height(70);
        }.width('100%').alignItems(HorizontalAlign.Start);
      }
    }
  }
}
// [End richEditor_eventPaste]

@Component
struct event6 {
  // [Start richEditor_eventCut]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };
  // [StartExclude richEditor_eventCut]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_6'),
        description: $r('app.string.Add_Event_title_6_desc')
      }) {
        Column({ space: 3 }) {
          // [EndExclude richEditor_eventCut]
          // $r('app.string.xxx')需要替换为开发者所需的资源文件
          RichEditor(this.options)
            .onReady(() => {
              this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_13')), {
                style: {
                  fontColor: Color.Black,
                  fontSize: 15
                }
              })
            })
            .onCut(() => {
              this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_14')), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
            .width(300)
            .height(70)
          RichEditor(this.infoShowOptions)
            .width(300)
            .height(70)
            // [End richEditor_eventCut]
        }
      }
    }
  }
}

@Component
struct event7 {
  // [Start richEditor_eventCopy]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };
  // [End richEditor_eventCopy]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_7'),
        description: $r('app.string.Add_Event_title_7')
      }) {
        Column({ space: 3 }) {
          // [Start richEditor_eventCopy]
          // $r('app.string.xxx')需要替换为开发者所需的资源文件
          RichEditor(this.options)
            .onReady(() => {
              this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_15')), {
                style: {
                  fontColor: Color.Black,
                  fontSize: 15
                }
              })
            })
            .onCopy(() => {
              this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_16')), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
            .width(300)
            .height(50);
          RichEditor(this.infoShowOptions)
            .width(300)
            .height(70);
            // [End richEditor_eventCopy]
        }
      }
    }
  }
}

@Entry
@Component
export struct AddEvent {
  scroller: Scroller = new Scroller();

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          event1();
          event2();
          event3();
          event4();
          on_cut_copy_paste();
          event6();
          event7();
          // tmp();

        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Add_Event_title'))
  }
}