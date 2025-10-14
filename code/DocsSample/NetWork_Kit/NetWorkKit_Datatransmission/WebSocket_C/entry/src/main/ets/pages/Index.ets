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
// [Start WebSocket_C_full_example]
import testWebsocket from 'libentry.so';
// [StartExclude WebSocket_C_full_example_part_one]
import { promptAction } from '@kit.ArkUI';
// [EndExclude WebSocket_C_full_example_part_one]

@Entry
@Component
struct Index {
  @State wsUrl: string = '';
  @State content: string = '';
  @State connecting: boolean = false;

  build() {
    Navigation() {
      Column() {
        Column() {
          Text($r('app.string.WebSocket_address'))
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Start)
            .width('100%')
          TextInput()
            .width('100%')
            .id('textInput_address')
            .onChange((value) => {
              this.wsUrl = value;
            })
        }
        .margin({
          bottom: 16 // 与底间隔
        })
        .padding({
          left: 16, // 与左间隔
          right: 16 // 与右间隔
        })

        Column() {
          Text($r('app.string.Content'))
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Start)
            .width('100%')
          TextInput()
            .width('100%')
            .id('textInput_content')
            .enabled(this.connecting)
            .onChange((value) => {
              this.content = value;
            })
        }
        .margin({
          bottom: 16 // 与底间隔
        })
        .padding({
          left: 16, // 与左间隔
          right: 16 // 与右间隔
        })

        Blank()
        Column({
          space: 12 // 占位空间
        }) {
          Button($r('app.string.Connect'))
            .id('Connect')
            .enabled(!this.connecting)
            .onClick(() => {
              let connRet = testWebsocket.Connect(this.wsUrl);
              if (connRet) {
                this.connecting = true;
                // [StartExclude WebSocket_C_full_example_part_two]
                promptAction.showToast({
                  message: $r('app.string.Connect_successfully'),
                  duration: 4000, // 持续时间
                  bottom: 300 // 与底间隔
                });
                // [EndExclude WebSocket_C_full_example_part_two]
              } 
              // [StartExclude WebSocket_C_full_example_part_three]
              else {
                this.connecting = false;
                promptAction.showToast({
                  message: $r('app.string.Connect_failed'),
                  duration: 4000, // 持续时间
                  bottom: 300 // 与底间隔
                });
              }
              // [EndExclude WebSocket_C_full_example_part_three]
            })
          Button($r('app.string.Send'))
            .id('Send')
            .enabled(this.connecting)
            .onClick(() => {
              testWebsocket.Send(this.content);
              // [StartExclude WebSocket_C_full_example_part_four]
              promptAction.showToast({
                message: $r('app.string.Send_message_successfully'),
                duration: 4000, // 持续时间
                bottom: 300 // 与底间隔
              });
              // [EndExclude WebSocket_C_full_example_part_four]
            })
          Button($r('app.string.Close'))
            .id('Close')
            .enabled(this.connecting)
            .onClick(() => {
              let closeResult = testWebsocket.Close();
              if (closeResult != -1) {
                // [StartExclude WebSocket_C_full_example_part_five]
                this.connecting = false;
                promptAction.showToast({
                  message: $r('app.string.Close_connection'),
                  duration: 4000, // 持续时间
                  bottom: 300 // 与底间隔
                });
                this.wsUrl = '';
                this.content = '';
                // [EndExclude WebSocket_C_full_example_part_five]
              } 
              // [StartExclude WebSocket_C_full_example_part_six]
              else {
                promptAction.showToast({
                  message: $r('app.string.Close_connection_failed'),
                  duration: 4000, // 持续时间
                  bottom: 300 // 与底间隔
                });
              }
              // [EndExclude WebSocket_C_full_example_part_six]
            })
        }
      }
    }
  }
}
// [End WebSocket_C_full_example]