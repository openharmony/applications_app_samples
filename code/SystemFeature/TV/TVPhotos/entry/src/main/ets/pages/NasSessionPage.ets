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
 
import { image } from '@kit.ImageKit'
import { AlbumType } from '../models/PhotoModel'
import { NasImage } from './components/NasImage'
import { inputConsumer, KeyCode } from '@kit.InputKit'
import Logger from '../common/Logger'
import { router } from '@kit.ArkUI'
import nasSessionManager, { SessionModel } from '../smaba/NasSessionManager'
import { smbUtil } from 'smbProtocol'
import { NasDisconnectDialog } from './components/NasDisconnectDialog'
import { Constants } from '../common/Constants'

const TAG = 'NAS_sessionPage'

const SESSION_PREFIX = 'session_'

const FOCUS_RETRY_NUM = 7;
const RETRY_INTERVAL = 100;

@Entry
@Component
struct NasSessionPage {
  @State pixelMap?: image.PixelMap = undefined
  @State sessionModels: SessionModel[] = []
  private albumGridRowCount: number = 5;
  @State focusStr: string = SESSION_PREFIX + '0'
  private focusIndex = 0
  private dialogFlag = false
  @State dialogFocusStr: string = ''
  private scroller: Scroller = new Scroller();
  private keyOptionsMenu: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: Constants.MENU_KEY,
    isFinalKeyDown: false,
    finalKeyDownDuration: Constants.KEY_DOWN_DURATION
  };
  private keyCallback = (keyOptions: inputConsumer.KeyOptions) => {
    if (!this.dialogFlag && !this.sessionModels[this.focusIndex].isPlaceHolder) {
      this.disconnectDialogController.open()
    }
  }
  private disconnectDialogController: CustomDialogController = new CustomDialogController({
    builder: NasDisconnectDialog({
      onCancel: () => {
        console.info(TAG, `on cancel`)
        this.disconnectDialogController.close()
      },
      onConfirm: () => {
        console.info(TAG, `on confirm disconnect`)
        this.disconnectDialogController.close()
        this.disconnect()
      }
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: '36lpx',
    width: '640lpx',
    height: '260lpx',
    backgroundColor: $r('app.color.dialog_background_color')
  })
  private nasSessionObserver = (models: SessionModel[]) => {
    console.info(TAG, `nasSessionObserver sessions change ` + JSON.stringify(models, smbUtil.bigIntReplacer))
    this.sessionModels = [...models, {
      host: '',
      fileSize: 0,
      isPlaceHolder: true
    }]
  }

  disconnect() {
    nasSessionManager.disconnectSession(this.sessionModels[this.focusIndex].host)
  }

  onPageShow(): void {
    nasSessionManager.registerSessionCallback(this.nasSessionObserver)
    this.clickFocusBtn(this.focusStr, this.focusIndex)
    try {
      inputConsumer.on('key', this.keyOptionsMenu, this.keyCallback);
    } catch (error) {
      Logger.error(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }

  onPageHide(): void {
    nasSessionManager.unRegisterSessionCallback(this.nasSessionObserver)
    clearTimeout(this.focusIntval)
    this.focusRetryNum = 0;
    try {
      inputConsumer.off('key', this.keyOptionsMenu, this.keyCallback);
    } catch (error) {
      Logger.error(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text($r('app.string.album_name_more'))
            .fontFamily('HarmonyOS Sans')
            .fontColor(Color.White)
            .fontSize('64lpx')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: '33lpx',
          right: '33lpx',
          top: '48lpx',
          bottom: '56lpx'
        })

        Grid(this.scroller) {
          ForEach(this.sessionModels, (item: SessionModel, index: number) => {
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.Bottom }) {
                  if (item.isPlaceHolder) {
                    Image($r('app.media.cover_add'))
                      .borderRadius('18lpx')
                      .id(SESSION_PREFIX + index)
                      .focusable(true)
                      .width('100%')
                      .aspectRatio(1)
                      .shadow({ radius: 1, color: Color.Gray })
                      .defaultFocus(index === 0)
                      .autoResize(false)
                      .interpolation(ImageInterpolation.Medium)
                      .onKeyEvent(event => {
                        this.onEvent(index, item, event)
                      })
                      .onClick(()=>{
                        const targetSession = this.sessionModels[index];
                        if (targetSession.isPlaceHolder) {
                          router.pushUrl({
                            url: 'pages/NasClientPage'
                          });
                        } else {
                          router.pushUrl({
                            url: 'pages/PhotoList',
                            params: {
                              photoTitle: targetSession.host,
                              photoType: AlbumType.NAS_SESSION,
                            },
                          });
                        }
                      })
                      .onFocus(() => {
                        console.log(TAG, `cover_add Focused`)
                      })
                      .width('100%')
                      .height('100%')

                    Column() {
                      Text($r('app.string.add_nas_servers'))
                        .fontFamily('HarmonyOS Sans')
                        .width('100%')
                        .height('32lpx')
                        .fontWeight(500)
                        .fontColor('#DBFFFFFF')
                        .fontSize('32lpx')
                        .margin({ bottom: '12lpx' })
                    }
                    .backgroundImage($r('app.media.mask'))
                    .width('100%')
                    .align(Alignment.Bottom)
                    .padding({ top: '46lpx', left: '10%' })
                  } else {
                    NasImage({
                      host: item.host,
                      imageFile: item.thumbFile,
                      focusId: SESSION_PREFIX + index,
                      eventCallback: (e) => {
                        this.onEvent(index, item, e)
                      },
                      defaultInFocus: index === 0
                    })

                    Column() {
                      Text(item.host)
                        .fontFamily('HarmonyOS Sans')
                        .width('100%')
                        .height('32lpx')
                        .fontWeight(500)
                        .fontColor('#DBFFFFFF')
                        .fontSize('32lpx')
                        .margin({ bottom: '12lpx' })
                      Text(`${item.fileSize}`)
                        .fontFamily('HarmonyOS Sans')
                        .width('100%')
                        .height('32lpx')
                        .fontWeight(500)
                        .fontColor('#DBFFFFFF')
                        .fontSize('32lpx')
                        .margin({ bottom: '10%' })
                    }
                    .backgroundImage($r('app.media.mask'))
                    .width('100%')
                    .align(Alignment.Bottom)
                    .padding({ top: '46lpx', left: '10%' })
                  }
                }
                .width('100%')
                .borderRadius('18lpx')
                .aspectRatio(1)
              }
              .borderRadius('22lpx')
              .margin('24lpx')
              .padding('6lpx')
              .border({
                width: 2,
                color: this.focusStr == (SESSION_PREFIX + index) ? '#fff' : Color.Transparent, // 边框颜色
                style: BorderStyle.Solid
              })
            }
            .backgroundImageSize({ width: '100%', height: '100%' })
          }, (item: SessionModel) => item.host + item.fileSize)
        }
        .columnsTemplate('1fr '.repeat(this.albumGridRowCount))
        .padding({ left: '4lpx', right: '4lpx' })
        .height('80%')
        .width('100%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.main_color'))
  }

  onEvent(index: number, session: SessionModel, e: KeyEvent) {
    // 只在按键按下时处理
    if (e.type !== KeyType.Down) {
      return;
    }
    Logger.info(TAG, `onEvent = ${e.keyCode}`);
    switch (e.keyCode) {
      case KeyCode.KEYCODE_DPAD_LEFT:
        this.nextAlbumClick(index, 'left');
        break;
      case KeyCode.KEYCODE_DPAD_RIGHT:
        this.nextAlbumClick(index, 'right');
        break;
      case KeyCode.KEYCODE_DPAD_DOWN:
        this.nextAlbumClick(index, 'down');
        break;
      case KeyCode.KEYCODE_DPAD_UP:
        this.nextAlbumClick(index, 'up');
        break;
      case KeyCode.KEYCODE_DPAD_CENTER:
      case KeyCode.KEYCODE_ENTER:
        const targetSession = this.sessionModels[index];
        if (targetSession.isPlaceHolder) {
          router.pushUrl({
            url: 'pages/NasClientPage'
          });
        } else {
          router.pushUrl({
            url: 'pages/PhotoList',
            params: {
              photoTitle: targetSession.host,
              photoType: AlbumType.NAS_SESSION,
            },
          });
        }
        break;
    }
  }


  nextAlbumClick(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down') {
    const index = this.getNextAlbum(currentIndex, direction)
    if (index !== -1) {
      this.clickFocusBtn(SESSION_PREFIX + index, index)
    }
  }

  getNextAlbum(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down'): number {
    const indexs: number[] = []
    let trueIndex = 0
    this.sessionModels.forEach((value, index) => {
      indexs.push(index)
      if (index === currentIndex) {
        trueIndex = indexs.length - 1
      }
    })

    let newIndex = -1
    if (direction === 'left' && trueIndex > 0) {
      newIndex = indexs[trueIndex - 1]
    }
    if (direction === 'right' && trueIndex < indexs.length - 1) {
      newIndex = indexs[trueIndex + 1]
    }
    if (direction === 'up' && trueIndex > this.albumGridRowCount) {
      newIndex = indexs[trueIndex - this.albumGridRowCount]
    }
    if (direction === 'down' && trueIndex < indexs.length - this.albumGridRowCount) {
      newIndex = indexs[trueIndex + this.albumGridRowCount]
    }
    return newIndex
  }

  focusRetryNum: number = 0;
  focusIntval: number | null = null;

  clickFocusBtn(str: string, index: number): boolean {
    let isSuccess = focusControl.requestFocus(str);
    Logger.info(TAG, `this.sessionModels.length = ${this.sessionModels.length}`);
    if (isSuccess) {
      this.focusStr = str;
      this.focusIndex = index
      this.scroller.scrollToIndex(index, true)
      this.focusRetryNum = 0;
    } else {
      this.focusRetryNum++;
      Logger.error(TAG, `requestFocus is failed , focusStr = ${str}, focusRetryNum = ${this.focusRetryNum}`);
      if (this.focusRetryNum > FOCUS_RETRY_NUM) {
        return false
      }
      this.focusIntval = setTimeout(() => {
        this.clickFocusBtn(str, index);
      }, RETRY_INTERVAL)
    }
    return isSuccess;
  }
}
