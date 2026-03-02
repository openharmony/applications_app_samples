/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State logMessages: string = '';
  @State currentState: string = '';

  aboutToAppear() {
    this.logMessages = this.getStringResource('log_initial');
    this.currentState = this.getStringResource('state_ready');
  }

  getStringResource(key: string): string {
    const stringMap: Record<string, string> = {
      'log_initial': '等待操作...',
      'state_ready': '准备就绪',
      'log_prefix_error': '[错误]',
      'log_prefix_info': '[信息]',
      'state_metadata_set': '元数据已设置',
      'state_failed': '设置失败',
      'state_playback_set': '播放状态已设置',
      'state_callback_registered': '播放回调已注册',
      'state_register_failed': '注册失败',
      'error_set_metadata': '设置元数据失败',
      'error_set_playback_state': '设置播放状态失败',
      'error_register_callback': '注册播放回调失败'
    };
    return stringMap[key] || '';
  }

  updateLogInfo(msg: string, isError: boolean = false) {
    const prefix = isError ? this.getStringResource('log_prefix_error') : this.getStringResource('log_prefix_info');
    const timestamp = new Date().toLocaleTimeString();
    this.logMessages = `${prefix} ${timestamp}: ${msg}\n${this.logMessages}`;
  }

  build() {
    Column() {
      Scroll() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
          this.textComponent($r('app.string.index_title'));

          this.buttonComponent($r('app.string.btn_set_metadata'), () => {
            try {
              hilog.info(DOMAIN, 'AVSession', 'SetMetadata clicked');
              const result = testNapi.SetMetadata();
              this.currentState = this.getStringResource('state_metadata_set');
              this.updateLogInfo(result as string);
            } catch (err) {
              hilog.error(DOMAIN, 'AVSession', 'SetMetadata failed: %{public}s', JSON.stringify(err));
              this.currentState = this.getStringResource('state_failed');
              this.updateLogInfo(`${this.getStringResource('error_set_metadata')}: ${JSON.stringify(err)}`, true);
            }
          });

          this.buttonComponent($r('app.string.btn_set_playback_state'), () => {
            try {
              hilog.info(DOMAIN, 'AVSession', 'SetPlaybackState clicked');
              const result = testNapi.SetPlaybackState();
              this.currentState = this.getStringResource('state_playback_set');
              this.updateLogInfo(result as string);
            } catch (err) {
              hilog.error(DOMAIN, 'AVSession', 'SetPlaybackState failed: %{public}s', JSON.stringify(err));
              this.currentState = this.getStringResource('state_failed');
              this.updateLogInfo(`${this.getStringResource('error_set_playback_state')}: ${JSON.stringify(err)}`, true);
            }
          });

          this.buttonComponent($r('app.string.btn_register_play'), () => {
            try {
              hilog.info(DOMAIN, 'AVSession', 'RegisterPlayCallback clicked');
              const result = testNapi.RegisterPlayCallback();
              this.currentState = this.getStringResource('state_callback_registered');
              this.updateLogInfo(result as string);
            } catch (err) {
              hilog.error(DOMAIN, 'AVSession', 'RegisterPlayCallback failed: %{public}s', JSON.stringify(err));
              this.currentState = this.getStringResource('state_register_failed');
              this.updateLogInfo(`${this.getStringResource('error_register_callback')}: ${JSON.stringify(err)}`, true);
            }
          });
        }
        .width('100%')
        .padding(20)
      }
      .width('100%')
      .height('40%')

      Divider().margin({ top: 10, bottom: 10 })

      // 状态和日志显示区域
      Column() {
        Text($r('app.string.realtime_status'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 10 })

        Text() {
          Span($r('app.string.current_state'))
          Span(this.currentState)
        }
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 20 })

        Text($r('app.string.log_info'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 10 })

        Scroll() {
          Text(this.logMessages)
            .fontSize(14)
            .fontFamily('monospace')
            .width('90%')
        }
        .width('100%')
        .height(120)
        .backgroundColor('#F5F5F5')
        .padding(10)
        .borderRadius(8)
      }
      .width('100%')
      .height('60%')
      .padding(20)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  textComponent(name: string | ResourceStr) {
    Text(name)
      .textAlign(TextAlign.Center)
      .margin({ bottom: 20 })
      .fontSize(24)
      .fontWeight(FontWeight.Bold)
  }

  @Builder
  buttonComponent(name: string | ResourceStr, clickHandler: () => void) {
    Button(name)
      .width('80%')
      .height('auto')
      .padding({ top: 12, bottom: 12, left: 20, right: 20 })
      .margin({ bottom: 12 })
      .fontSize(14)
      .onClick(() => {
        clickHandler();
      })
  }
}
