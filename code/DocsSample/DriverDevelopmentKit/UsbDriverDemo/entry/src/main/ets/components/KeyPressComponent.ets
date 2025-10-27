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

import { KeyCode } from '@kit.InputKit';
import { preferences } from '@kit.ArkData';
import RpcTool from '../tool/RpcTool';
import { hilog } from '@kit.PerformanceAnalysisKit';

class StorageKey {
  public key?: string
  public default?: number
}
const STORAGE_KEY: StorageKey[] = [
  { key: 'key1', default: KeyCode.KEYCODE_SPACE },
  { key: 'key2', default: KeyCode.KEYCODE_ENTER },
  { key: 'key3', default: KeyCode.KEYCODE_BACK },
  { key: 'key4', default: KeyCode.KEYCODE_1 }];
class MenuKey {
  public code?: number
  public value?: string
  public note?: string
}
const MENU_KEY_LIST: MenuKey[] = [
  { code: KeyCode.KEYCODE_SPACE, value: 'Space', note: '空格' },
  { code: KeyCode.KEYCODE_ENTER, value: 'Enter', note: '换行' },
  { code: KeyCode.KEYCODE_BACK, value: 'Backspace', note: '回退' },
  { code: KeyCode.KEYCODE_DEL, value: 'Delete', note: '删除' },
  { code: KeyCode.KEYCODE_ESCAPE, value: 'Esc', note: '退出' },
  { code: KeyCode.KEYCODE_SYSRQ, value: 'PrtSc', note: '截屏' },
  { code: KeyCode.KEYCODE_SHIFT_LEFT, value: 'Left Shift', note: '左Shift' },
  { code: KeyCode.KEYCODE_SHIFT_RIGHT, value: 'Right Shift', note: '右Shift' },
  // { code: KeyCode.KEYCODE_BRIGHTNESS_DOWN, value: 'Bright Down', note: '亮度-' },
  // { code: KeyCode.KEYCODE_BRIGHTNESS_UP, value: 'Bright Up', note: '亮度+' },
  // { code: KeyCode.KEYCODE_MUTE, value: 'Mute', note: '静音' },
  { code: KeyCode.KEYCODE_VOLUME_DOWN, value: 'Vol Down', note: '音量-' },
  { code: KeyCode.KEYCODE_VOLUME_UP, value: 'Vol Up', note: '音量+' },
  { code: KeyCode.KEYCODE_0, value: '0', note: '数字' },
  { code: KeyCode.KEYCODE_1, value: '1', note: '数字' },
  { code: KeyCode.KEYCODE_2, value: '2', note: '数字' },
  { code: KeyCode.KEYCODE_3, value: '3', note: '数字' },
  { code: KeyCode.KEYCODE_4, value: '4', note: '数字' },
  { code: KeyCode.KEYCODE_5, value: '5', note: '数字' },
  { code: KeyCode.KEYCODE_6, value: '6', note: '数字' },
  { code: KeyCode.KEYCODE_7, value: '7', note: '数字' },
  { code: KeyCode.KEYCODE_8, value: '8', note: '数字' },
  { code: KeyCode.KEYCODE_9, value: '9', note: '数字' },
  { code: KeyCode.KEYCODE_A, value: 'A', note: '字母' },
  { code: KeyCode.KEYCODE_B, value: 'B', note: '字母' },
  { code: KeyCode.KEYCODE_C, value: 'C', note: '字母' },
  { code: KeyCode.KEYCODE_D, value: 'D', note: '字母' },
  { code: KeyCode.KEYCODE_E, value: 'E', note: '字母' },
  { code: KeyCode.KEYCODE_F, value: 'F', note: '字母' },
  { code: KeyCode.KEYCODE_G, value: 'G', note: '字母' },
  { code: KeyCode.KEYCODE_H, value: 'H', note: '字母' },
  { code: KeyCode.KEYCODE_I, value: 'I', note: '字母' },
  { code: KeyCode.KEYCODE_J, value: 'J', note: '字母' },
  { code: KeyCode.KEYCODE_K, value: 'K', note: '字母' },
  { code: KeyCode.KEYCODE_L, value: 'L', note: '字母' },
  { code: KeyCode.KEYCODE_M, value: 'M', note: '字母' },
  { code: KeyCode.KEYCODE_N, value: 'N', note: '字母' },
  { code: KeyCode.KEYCODE_O, value: 'O', note: '字母' },
  { code: KeyCode.KEYCODE_P, value: 'P', note: '字母' },
  { code: KeyCode.KEYCODE_Q, value: 'Q', note: '字母' },
  { code: KeyCode.KEYCODE_R, value: 'R', note: '字母' },
  { code: KeyCode.KEYCODE_S, value: 'S', note: '字母' },
  { code: KeyCode.KEYCODE_T, value: 'T', note: '字母' },
  { code: KeyCode.KEYCODE_U, value: 'U', note: '字母' },
  { code: KeyCode.KEYCODE_V, value: 'V', note: '字母' },
  { code: KeyCode.KEYCODE_W, value: 'W', note: '字母' },
  { code: KeyCode.KEYCODE_X, value: 'X', note: '字母' },
  { code: KeyCode.KEYCODE_Y, value: 'Y', note: '字母' },
  { code: KeyCode.KEYCODE_Z, value: 'Z', note: '字母' },];

@Component
@Preview
export struct KeyPressComponent {
  @State private keyInfo: string[] = ['开启手写应用', '关闭手写应用', '上翻', '下翻'];
  private keyPreference: preferences.Preferences | null = null;

  aboutToAppear() {
    let filePath = getContext().filesDir;
    hilog.info(0, 'testTag', `keyPressComponent aboutToAppear, filePath: ${filePath}`);
    this.keyPreference = preferences.getPreferencesSync(getContext(this), {name: 'keyInfo'});
    STORAGE_KEY.forEach((value, index) => {
      if(this.keyPreference) {
        let storageKeyCode = this.keyPreference.getSync(value.key, value.default);
        let searchInfo = MENU_KEY_LIST.filter(key => (key.code == storageKeyCode));
        if (searchInfo.length != 0) {
          this.keyInfo[index] = `${searchInfo[0].note}: ${searchInfo[0].value}`;
        }
      }
    })
  }

  @Builder
  MyMenu(keyIndex: number) {
    Menu() {
      ForEach(MENU_KEY_LIST, (item: MenuKey) => {
        MenuItem({ content: `${item.note}:${item.value}` })
          .onClick(() => {
            hilog.info(0, 'testTag', `set key btn ${item.note}: ${item.value}`);
            this.keyInfo[keyIndex] = `${item.note}: ${item.value}`;
            if(this.keyPreference) {
              this.keyPreference.putSync(STORAGE_KEY[keyIndex].key, item.code);
              this.keyPreference.flushSync();
              if(item.code) {
                RpcTool.getInstance().setKeyValue(keyIndex, item.code);
              }
            }
          })
      })
    }
    .borderStyle(BorderStyle.Dotted)
  }

  build() {
    Column() {
      Stack() {
        // 底层外边框
        Row() {
          Blank()
            .width(230)
          Row() {
            // 底层内边框
            Row()
              .border({ width: 4, color: '#E1E1E1', radius: 10 })
              .layoutWeight(1)
              .height(400)
              .margin({ left: 80, right: 20, top: 20, bottom: 20 })
          }
          .height(500)
          .width(750)
          .padding(10)
          .borderRadius(40)
          .border({ width: 12, color: '#E1E1E1' })
          .margin({ right: 30 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)

        Row() {
          //左边导引区
          Column() {
            ForEach(this.keyInfo, (item: string, index) => {
              Row() {
                Text(item)
                  .margin({ right: 10 })
                  .width(140)
                  .textAlign(TextAlign.End)
                Column()
                  .width(10)
                  .height(10)
                  .borderRadius(10)
                  .backgroundColor('#0A59F7')
                Column()
                  .border({ width: 1, color: '#0A59F7' })
                  .width(80)
                  .height(2)
                Text()
                  .border({ width: 2, color: '#E1E1E1' })
                  .height(85)
                  .aspectRatio(0.6)
                  .bindMenu(this.MyMenu(index))
              }.height(85)
              .margin({ top: 5, bottom: 5 })
            })
          }
          .justifyContent(FlexAlign.Center)
        }
        .height('100%')
        .margin({ left: 20 })
      }
      .width(1000)
      .height(500)
      .alignContent(Alignment.Start)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}