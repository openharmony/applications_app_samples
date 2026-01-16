/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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
// [Start sound_player]
// [Start sound_player_import]
// [Start sound_player_create]
// [Start sound_player_load]
// [Start sound_player_play]
// [Start sound_player_unload]
import { systemSoundManager } from '@kit.AudioKit';
// [End sound_player_import]
// [StartExclude sound_player_create]
// [StartExclude sound_player_load]
// [StartExclude sound_player_play]
// [StartExclude sound_player_unload]
import { SubHeader, TextModifier } from '@kit.ArkUI';
// [EndExclude sound_player_create]

// SystemSoundPlayer对象。
let systemSoundPlayer: systemSoundManager.SystemSoundPlayer | null = null;
// [EndExclude sound_player_load]
// [EndExclude sound_player_play]
// [EndExclude sound_player_unload]

// [StartExclude sound_player_create]
// 音效类型。
let systemSoundType: systemSoundManager.SystemSoundType = systemSoundManager.SystemSoundType.PHOTO_SHUTTER;

// [StartExclude sound_player_load]
// [StartExclude sound_player_play]
// [StartExclude sound_player_unload]
// 创建SystemSoundPlayer对象。
async function create() {
  // [EndExclude sound_player_create]
  systemSoundManager.createSystemSoundPlayer().then((systemSoundPlayerInstance) => {
    console.info('Succeeded in creating the system sound player.');
    systemSoundPlayer = systemSoundPlayerInstance;
  }).catch((err: BusinessError) => {
    console.error(`Failed to create the system sound player. Code: ${err.code}, message: ${err.message}`);
  });
  // [End sound_player_create]
}

// 加载系统音效资源。
async function load() {
  // [EndExclude sound_player_load]
  systemSoundPlayer?.load(systemSoundType).then(() => {
    console.info('Succeeded in calling the load method.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to call the load method. Code: ${err.code}, message: ${err.message}`);
  });
  // [End sound_player_load]
}

// 播放已加载的系统音效。
async function play() {
  // [EndExclude sound_player_play]
  systemSoundPlayer?.play(systemSoundType).then(() => {
    console.info('Succeeded in calling the play method.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to call the play method. Code: ${err.code}, message: ${err.message}`);
  });
  // [End sound_player_play]
}

// 卸载之前已加载的系统音效资源。
async function unload() {
  // [EndExclude sound_player_unload]
  systemSoundPlayer?.unload(systemSoundType).then(() => {
    console.info('Succeeded in calling the unload method.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to call the unload method. Code: ${err.code}, message: ${err.message}`);
  });
  // [End sound_player_unload]
}

// 释放SystemSoundPlayer对象。
async function release() {
  // [Start sound_player_release]
  systemSoundPlayer?.release().then(() => {
    console.info('Succeeded in calling the release method.');
  }).catch((err: BusinessError) => {
    console.error(`Failed to call the release method. Code: ${err.code}, message: ${err.message}`);
  });
  // [End sound_player_release]
}

// 播放系统音效。
async function playSystemSound() {
  console.info('Succeeded in calling the playSystemSound method.');

  // 创建SystemSoundPlayer对象。
  // await create();

  // 播放之前需要先加载音效资源。
  // await load();

  // 确保音效资源已经加载成功，再调用播放接口。
  await play();

  // 音效资源播放完毕后，应用可调用unload接口卸载之前已加载的系统音效资源。
  // await unload();

  // 不再使用时，调用release释放SystemSoundPlayer对象。
  //await release();
}

@Entry
@Component
struct Index {
  @State index: number = 0;
  @State arrowPosition: ArrowPosition = ArrowPosition.END
  @State primaryModifier: TextModifier = new TextModifier().fontSize(14).fontWeight(500).fontColor('#000000').opacity(0.6);
  selectArr:SelectOption[] = [{ value: $r('app.string.select_photo')},
    { value: $r('app.string.select_video_start') },
    { value: $r('app.string.select_video_end')}]

  async aboutToAppear(): Promise<void> {
    // 创建SystemSoundPlayer对象。
    await create();

    // 第一次进入默认加载拍照音效。
    await load();
  }

  async aboutToDisappear() {
    // 退出应用时卸载之前已加载的系统音效资源并释放SystemSoundPlayer对象。
    await unload();
    await release();
  }

  @Builder navTitle() {
    Column() {
      Row() {
        Text('SoundPlayer')
          .fontSize(26)
          .fontWeight(700)
          .fontColor('#182431')
          .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
      }
      .width('100%')
      .padding({ top: 10.5})
    }
    .width('100%')
    .height(56)
    .padding({
      left: 16,
      right: 16
    })
  }

  build() {
    Navigation() {
      Column() {
        Column() {
          SubHeader({
            primaryTitle: $r('app.string.primary_title'),
            primaryTitleModifier: this.primaryModifier
          })
            .width('100%')
          Select(this.selectArr)
            .value($r('app.string.select_value'))
            .font({size: 16, weight: 500})
            .onSelect((index: number) => {
              console.info('Select:' + index)
              switch (index) {
                case systemSoundManager.SystemSoundType.PHOTO_SHUTTER:
                  systemSoundType = systemSoundManager.SystemSoundType.PHOTO_SHUTTER;
                  break;
                case systemSoundManager.SystemSoundType.VIDEO_RECORDING_BEGIN:
                  systemSoundType = systemSoundManager.SystemSoundType.VIDEO_RECORDING_BEGIN;
                  break;
                case systemSoundManager.SystemSoundType.VIDEO_RECORDING_END:
                  systemSoundType = systemSoundManager.SystemSoundType.VIDEO_RECORDING_END;
                  break;
                default:
                  // 选择要播放的音效后加载对应的资源。
                  load();
                  break;
              }
            })
            .id('selectSystemSoundType')
            .height(56)
            .width('100%')
        }
        .width('100%')
        .height(56)
        .padding({
          left: 16,
          right: 16,
        })

        Column() {
          Button(($r('app.string.sound_player_button')), { type: ButtonType.Capsule })
            .backgroundColor('#0A59F7')
            .opacity(1)
            .fontColor(Color.White)
            .fontSize(16)
            .fontWeight(500)
            .width('100%')
            .height(40)
            .onClick(() => {
              playSystemSound();
            })
            .id('playSoundPoolButton')
        }
        .width('100%')
        .height(40)
        .padding({
          left: 16,
          right: 16
        })
        .margin({
          bottom: 16
        })
      }
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .title(this.navTitle())
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .navBarWidth('100%')
  }
}
// [End sound_player]