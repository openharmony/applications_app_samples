/*
 * Copyright (c) 2025-2026 Huawei Device Co., Ltd.
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
// [StartExclude richEditor_eventPaste]
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

  build() {
    Column() {
      // [StartExclude richEditor_eventSelectChange]
      Text($r('app.string.Add_Event_title_2'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_eventSelectChange
      Column({ space: 3 }) {
        // 请将$r('app.string.xxx')替换为实际资源文件
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
      }
      // [StartExclude richEditor_eventSelectChange]
      Text($r('app.string.Add_Event_title_2_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_eventSelectChange]
    }
  }
  // [End richEditor_eventSelectChange]
}

@Component
struct event3 {
  // [Start richEditor_eventChange]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };

  build() {
    Column() {
      // [StartExclude richEditor_eventChange]
      Text($r('app.string.Add_Event_title_3'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_eventChange
      Column({ space: 3 }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.AddEvent_Text_5')替换为实际资源文件，在本示例中该资源文件的value值为"组件内图文变化前，触发回调。\n图文变化后，触发回调。"
            this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_5')), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
          .onWillChange((value: RichEditorChangeValue) => {
            // 请将$r('app.string.AddEvent_Text_6')替换为实际资源文件，在本示例中该资源文件的value值为"组件内图文变化前，触发回调：\"
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
            // 请将$r('app.string.AddEvent_Text_7')替换为实际资源文件，在本示例中该资源文件的value值为"\n图文变化后，触发回调：\n rangeBefore"
            this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_7')) +
            JSON.stringify(rangeBefore) + '\nrangeAfter: ' + JSON.stringify(rangeBefore), {
              style: {
                fontColor: Color.Gray,
                fontSize: 10
              }
            })
          })
          .width(300)
          .height(50);
        // 请将$r('app.string.AddEvent_Text_4')替换为实际资源文件，在本示例中该资源文件的value值为"查看回调内容："
        Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300);
        RichEditor(this.infoShowOptions)
          .width(300)
          .height(70);
      }
      // [StartExclude richEditor_eventChange]
      Text($r('app.string.Add_Event_title_3_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_eventChange]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_eventChange]
}

@Component
struct event4 {
  // [Start richEditor_eventInput]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };

  build() {
    Column() {
      // [StartExclude richEditor_eventInput]
      Text($r('app.string.Add_Event_title_4'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_eventInput
      Column({ space: 3 }) {
        // 请将$r('app.string.xxx')替换为开发者所需的资源文件
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

      }
      // [StartExclude richEditor_eventInput]
      Text($r('app.string.Add_Event_title_4_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_eventInput]
    }
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_eventInput]
}

// [EndExclude richEditor_eventPaste]
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
      // [StartExclude richEditor_eventPaste]
      // 请将$r('app.string.Add_Event_title_5')替换为实际资源文件，在本示例中该资源文件的value值为"添加完成粘贴前可触发的回调"
      Text($r('app.string.Add_Event_title_5'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_eventPaste
      Column({ space: 3 }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.AddEvent_Text_11')替换为实际资源文件，在本示例中该资源文件的value值为"对此处文本进行复制粘贴操作可触发对应回调。"
            this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_11')),
              { style: { fontColor: Color.Black, fontSize: 15 } })
          })
          .onPaste((event) => {
            // 请将$r('app.string.AddEvent_Text_12')替换为实际资源文件，在本示例中该资源文件的value值为"触发onPaste回调\n"
            this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_12')),
              { style: { fontColor: Color.Gray, fontSize: 10 } })
            if (event != undefined && event.preventDefault) {
              event.preventDefault();
            }
            this.PopDataFromPasteboard()
          })
          .width(300)
          .height(50);
        // 请将$r('app.string.AddEvent_Text_4')替换为实际资源文件，在本示例中该资源文件的value值为"查看回调内容："
        Text(resource.resourceToString($r('app.string.AddEvent_Text_4'))).fontSize(10).fontColor(Color.Gray).width(300);
        RichEditor(this.infoShowOptions)
          .width(300)
          .height(70);
      }.width('100%').alignItems(HorizontalAlign.Start);
      // [StartExclude richEditor_eventPaste]
      // 请将$r('app.string.Add_Event_title_5_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过onPaste回调，来添加粘贴前要处理的流程"
      Text($r('app.string.Add_Event_title_5_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_eventPaste]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
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

  build() {
    Column() {
      // [StartExclude richEditor_eventCut]
      Text($r('app.string.Add_Event_title_6'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_eventCut
      Column({ space: 3 }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.AddEvent_Text_13')替换为实际资源文件，在本示例中该资源文件的value值为"对此处文本进行复制粘贴操作可触发对应回调。"
            this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_13')), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
          .onCut(() => {
            // 请将$r('app.string.AddEvent_Text_14')替换为实际资源文件，在本示例中该资源文件的value值为"触发onCut回调\n"
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
      }
      // [StartExclude richEditor_eventCut]
      Text($r('app.string.Add_Event_title_6_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_eventCut]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_eventCut]
}

@Component
struct event7 {
  // [Start richEditor_eventCopy]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };

  build() {
    Column() {
      // [StartExclude richEditor_eventCopy]
      // 请将$r('app.string.Add_Event_title_7')替换为实际资源文件，在本示例中该资源文件的value值为"添加完成复制前可触发的回调"
      Text($r('app.string.Add_Event_title_7'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_eventCopy
      Column({ space: 3 }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.AddEvent_Text_15')替换为实际资源文件，在本示例中该资源文件的value值为"对此处文本进行复制粘贴操作可触发对应回调。"
            this.controller.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_15')), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
          .onCopy(() => {
            // 请将$r('app.string.AddEvent_Text_16')替换为实际资源文件，在本示例中该资源文件的value值为"触发onCopy回调\n"
            this.infoShowController.addTextSpan(resource.resourceToString($r('app.string.AddEvent_Text_16')), {
              style: {
                fontColor: Color.Gray,
                fontSize: 10
              }
            })
          })
          .width(300)
          .height(50)
        RichEditor(this.infoShowOptions)
          .width(300)
          .height(70)
      }
      // [StartExclude richEditor_eventCopy]
      Text($r('app.string.Add_Event_title_7_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_eventCopy]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_eventCopy]
}

@Entry
@Component
export struct AddEvent {
  scroller: Scroller = new Scroller();

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          event1()
          event2()
          event3()
          event4()
          on_cut_copy_paste()
          event6()
          event7()
          // tmp();

        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Add_Event_title')替换为实际资源文件，在本示例中该资源文件的value值为"添加事件"
    .title($r('app.string.Add_Event_title'))
  }
}