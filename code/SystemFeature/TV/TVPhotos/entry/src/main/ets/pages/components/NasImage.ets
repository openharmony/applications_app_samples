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
import { DirectoryEntry, smbUtil } from 'smbProtocol'
import nasSessionManager from '../../smaba/NasSessionManager'
import { BusinessError } from '@kit.BasicServicesKit'
import Logger from '../../common/Logger'
import { EventUtil } from '../../common/EventUtil'
import { IntentionCode, KeyCode } from '@kit.InputKit'
import { Constants } from '../../common/Constants'

const TAG = 'NAS_image'

@Component
export struct NasImage {
  @Require
  host?: string
  @Require
  imageFile?: DirectoryEntry
  @Require
  focusId: string = ''
  @Require
  eventCallback?: (event: KeyEvent) => void
  private defaultInFocus: boolean = false
  @State album: string | undefined = undefined

  aboutToAppear(): void {
    console.info(TAG,
      'aboutToAppear host = ' + this.host + '  imageFile = ' + JSON.stringify(this.imageFile, smbUtil.bigIntReplacer))
    if (this.host && this.imageFile) {
      nasSessionManager.readThumb(this.host, this.imageFile, 0).then((albumPath) => {
        Logger.error(TAG, 'readThumb success ' + albumPath)
        this.album = albumPath.localPath
      }).catch((err: BusinessError) => {
        Logger.error(TAG, 'readThumb fail ' + JSON.stringify(err))
      })
    }
  }

  build() {
    Image(this.album)
      .borderRadius('18lpx')
      .id(this.focusId)
      .focusable(true)
      .width('100%')
      .aspectRatio(1)
      .shadow({ radius: 1, color: Color.Gray })
      .defaultFocus(this.defaultInFocus)
      .autoResize(true)
      .onKeyEvent(event => {
        this.eventCallback && this.eventCallback(event)
      })
      .onClick(()=>{
        if (this.eventCallback) {
          this.eventCallback({
            keyCode: KeyCode.KEYCODE_ENTER,
            type: KeyType.Down,
            keyText: '',
            keySource: KeySource.Unknown,
            deviceId: 0,
            metaKey: 0,
            timestamp: 0,
            stopPropagation: (): void => {
              return
            },
            intentionCode: IntentionCode.INTENTION_UNKNOWN
          })
        }
      })
      .onTouch((event) => {
        if (!EventUtil.isTouchEvent(event)) {
          return;
        }
        if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
          return;
        }
        if (this.eventCallback) {
          this.eventCallback({
            keyCode: KeyCode.KEYCODE_ENTER,
            type: KeyType.Down,
            keyText: '',
            keySource: KeySource.Unknown,
            deviceId: 0,
            metaKey: 0,
            timestamp: 0,
            stopPropagation: (): void => {
              return
            },
            intentionCode: IntentionCode.INTENTION_UNKNOWN
          })
        }
      })
      .width('100%')
      .height('100%')
  }
}
