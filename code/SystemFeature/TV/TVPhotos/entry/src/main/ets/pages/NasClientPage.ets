/**
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
import { KeyCode } from '@kit.InputKit'
import Logger from '../common/Logger'
import Client from '../smaba/client/Client'
import { NasLoginDialog } from './components/NasLoginDialog'
import { NasLoginProgress } from './components/NasLoginProgress'
import { BusinessError } from '@kit.BasicServicesKit'
import { promptAction, router } from '@kit.ArkUI'
import nasSessionManager from '../smaba/NasSessionManager'

const TAG = 'NAS_clientPage'
const CLIENT_PREFIX = 'client_'

@Entry
@Component
struct NasClientPage {
  @State isNasFindFailed: boolean = false;
  @State clients: Client[] = []
  private albumGridRowCount: number = 5;
  @State focusStr: string = CLIENT_PREFIX + '0'
  @State loading: boolean = true;
  private selectClient?: Client
  private scroller: Scroller = new Scroller();
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: NasLoginDialog({
      onCancel: () => {
        console.info(TAG, `on cancel`)
        this.dialogController.close()
      },
      onConfirm: (userName: string, password: string) => {
        this.dialogController.close()
        console.info(TAG, `on confirm ${userName} ${password}`)
        this.authClient(userName, password)
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: '36lpx',
    width: '700lpx',
    height: '514lpx',
    backgroundColor: $r('app.color.dialog_background_color')
  })
  private progressController: CustomDialogController = new CustomDialogController({
    builder: NasLoginProgress(),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: '36lpx',
    width: '1045lpx',
    height: '230lpx',
    backgroundColor: $r('app.color.dialog_background_color')
  })

  authClient(userName: string, password: string) {
    if (this.selectClient) {
      this.progressController.open()
      nasSessionManager.authNasSession({
        host: this.selectClient.host,
        userName: userName,
        password: password
      }).then((isAuthSuccess: boolean) => {
        if (!isAuthSuccess) {
          this.progressController.close()
          promptAction.showToast({
            message: $r('app.string.dfs_connect_failed')
          })
          return
        }
        let index = this.clients.findIndex((client) => {
          return client.host === this.selectClient!!.host
        })
        this.clients.splice(index, 1)
        this.progressController.close()
        promptAction.showToast({
          message: $r('app.string.dfs_connect_success')
        })
        if (this.clients.length === 0) {
          router.back()
        }
      }).catch((err: BusinessError) => {
        console.error(TAG, 'auth fail err = ' + JSON.stringify(err))
        this.progressController.close()
        promptAction.showToast({
          message: $r('app.string.dfs_connect_failed')
        })
      })
    }
  }

  onPageShow(): void {
    nasSessionManager.findNas()
      .then((clients) => {
        this.clients = clients
        this.loading = false
        console.error(TAG, `getclient size=` + this.clients.length)
        if (this.clients.length > 0) {
          setTimeout(() => {
            console.error(TAG, `clickFocusBtn=` + CLIENT_PREFIX + '0')
            this.clickFocusBtn(CLIENT_PREFIX + '0', 0)
          }, 200)
        }
      })
      .catch((e:BusinessError)=>{
        this.loading = false;
        this.isNasFindFailed = true;
        console.error(TAG, `FindNas failed : ${JSON.stringify(e)}`)
      })
  }

  onPageHide(): void {
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text($r('app.string.nas_servers'))
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

        if (this.loading) {
          Stack() {
            LoadingProgress()
              .color(Color.White)
              .width('160lpx')
              .height('160lpx')
          }.width('100%')
          .height('80%')
        } else if (this.clients.length === 0) {
          Stack() {
            Text(this.isNasFindFailed?$r('app.string.nas_find_failed'):$r('app.string.no_nas_servers'))
              .fontFamily('HarmonyOS Sans')
              .fontColor(Color.White)
              .fontSize('48lpx')
          }.width('100%')
          .height('80%')
        } else {
          Grid(this.scroller) {
            ForEach(this.clients, (item: Client, index: number) => {
              GridItem() {
                Column() {
                  Stack({ alignContent: Alignment.Bottom }) {
                    Image($r('app.media.cover_nas_server'))
                      .borderRadius('18lpx')
                      .id(CLIENT_PREFIX + index)
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
                        this.selectClient = item
                        this.dialogController.open()
                      })
                      .width('100%')
                      .height('100%')

                    Column() {
                      Text(item.host)
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
                  color: this.focusStr === (CLIENT_PREFIX + index) ? Color.White : Color.Transparent, // 边框颜色
                  style: BorderStyle.Solid
                })
              }
              .backgroundImageSize({ width: '100%', height: '100%' })
            }, (item: Client, index: number) => item.host + index)
          }
          .columnsTemplate('1fr '.repeat(this.albumGridRowCount))
          .padding({ left: '4lpx', right: '4lpx' })
          .width('100%')
          .height('80%')
        }
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.main_color'))
  }

  onEvent(index: number, client: Client, e: KeyEvent) {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
      this.nextAlbumClick(index, 'left')
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
      this.nextAlbumClick(index, 'right')
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
      this.nextAlbumClick(index, 'down')
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
      this.nextAlbumClick(index, 'up')
    }
    if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) &&
      e.type == KeyType.Down) {
      //toto show dialog
      this.selectClient = client
      this.dialogController.open()
    }
  }

  nextAlbumClick(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down') {
    const index = this.getNextAlbum(currentIndex, direction)
    if (index !== -1) {
      this.clickFocusBtn(CLIENT_PREFIX + index, index)
    }
  }

  getNextAlbum(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down'): number {
    const indexs: number[] = []
    let trueIndex = 0
    this.clients.forEach((value, index) => {
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

  clickFocusBtn(str: string, index: number): boolean {
    let isSuccess = focusControl.requestFocus(str);
    if (isSuccess) {
      this.focusStr = str;
      this.scroller.scrollToIndex(index, true)
    } else {
      Logger.error(TAG, `requestFocus is failed , focusStr = ${str}`);
    }
    return isSuccess;
  }
}
