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
import { pasteboard } from '@kit.BasicServicesKit';
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
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  controller1: RichEditorController = new RichEditorController();
  options1: RichEditorOptions = { controller: this.controller1 };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_2'),
        description: $r('app.string.Add_Event_title_2_desc'),
      }) {
        Column({ space: 3 }) {
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
              this.controller1.addTextSpan('\n' + resource.resourceToString($r('app.string.AddEvent_Text_3')) +
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
          RichEditor(this.options1)
            .width(300)
            .height(70)
        }
      }
    }
  }
}

@Component
struct event3 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  controller1: RichEditorController = new RichEditorController();
  options1: RichEditorOptions = { controller: this.controller1 };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_3'),
        description: $r('app.string.Add_Event_title_3_desc')
      }) {
        Column({ space: 3 }) {
          RichEditor(this.options)
            .onReady(() => {
              this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_5')), {
                style: {
                  fontColor: Color.Black,
                  fontSize: 15
                }
              })
            })
            .onWillChange((value: RichEditorChangeValue) => {
              this.controller1.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_6')) +
              JSON.stringify(value), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
              return true;
            })
            .onDidChange((rangeBefore: TextRange, rangeAfter: TextRange) => {
              this.controller1.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_7')) +
              JSON.stringify(rangeBefore) + '\nrangeAfter：' + JSON.stringify(rangeBefore), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
            .width(300)
            .height(50)
          Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300)
          RichEditor(this.options1)
            .width(300)
            .height(70)
        }
      }
    }
  }
}

@Component
struct event4 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  controller1: RichEditorController = new RichEditorController();
  options1: RichEditorOptions = { controller: this.controller1 };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_4'),
        description: $r('app.string.Add_Event_title_4_desc'),
      }) {
        Column({ space: 3 }) {
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
              this.controller1.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_9')) +
              JSON.stringify(value), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
              return true;
            })
            .onDidIMEInput((value: TextRange) => {
              this.controller1.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_10')) +
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
          RichEditor(this.options1)
            .width(300)
            .height(70)
        }
      }
    }
  }
}

@Component
struct event5 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  controller1: RichEditorController = new RichEditorController();
  options1: RichEditorOptions = { controller: this.controller1 };

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
        this.controller.deleteSpans({ start: start, end: end })
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
      this.controller.setCaretOffset(start + moveOffset)
    })
  }

  build() {
    Column() {
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
              this.controller1.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_12')),
                { style: { fontColor: Color.Gray, fontSize: 10 } })
              if (event != undefined && event.preventDefault) {
                event.preventDefault();
              }
              console.info('RichEditor onPaste')
              this.PopDataFromPasteboard()
            })
            .width(300)
            .height(50)
          Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300)
          RichEditor(this.options1)
            .width(300)
            .height(70)
        }.width('100%').alignItems(HorizontalAlign.Start)
      }
    }
  }
}

@Component
struct event6 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  controller1: RichEditorController = new RichEditorController();
  options1: RichEditorOptions = { controller: this.controller1 };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_6'),
        description: $r('app.string.Add_Event_title_6_desc')
      }) {
        Column({ space: 3 }) {
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
              this.controller1.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_14')), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
            .width(300)
            .height(50)
          Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300)
          RichEditor(this.options1)
            .width(300)
            .height(70)
        }
      }
    }
  }
}

@Component
struct event7 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  controller1: RichEditorController = new RichEditorController();
  options1: RichEditorOptions = { controller: this.controller1 };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Add_Event_title_7'),
        description: $r('app.string.Add_Event_title_7')
      }) {
        Column({ space: 3 }) {
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
              this.controller1.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_16')), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
            .width(300)
            .height(50)
          Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300)
          RichEditor(this.options1)
            .width(300)
            .height(70)
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
          event5();
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