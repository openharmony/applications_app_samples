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
import { PhotoModel } from '../../models/PhotoModel'
import { getThumbByUri } from '../../manager/loader/LoadUtil'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { EventUtil } from '../../common/EventUtil'
import { IntentionCode, KeyCode } from '@kit.InputKit'
import { Constants } from '../../common/Constants'

const TAG = 'VideoImage'

@Component
export struct VideoImage {
  @Prop isDistributed: boolean = false
  @Require
  photoModel: PhotoModel | undefined = undefined
  @Require
  focusId: string = ''
  @Require
  eventCallback?: (event: KeyEvent) => void
  private defaultInFocus: boolean = false
  @State album: string | undefined = undefined

  aboutToAppear(): void {
    if (this.photoModel) {
      if (this.isDistributed) {
        if (this.photoModel.photoType == photoAccessHelper.PhotoType.VIDEO) {
          getThumbByUri(getContext(), this.photoModel, 'videoImage' + this.focusId, this.isDistributed).then((thumbUri) => {
            this.album = thumbUri
          })
        } else {
          this.album = this.photoModel.remoteUri
        }
      } else {
        getThumbByUri(getContext(), this.photoModel, 'videoImage' + this.focusId).then((thumbUri) => {
          this.album = thumbUri
        })
      }
    }
  }

  build() {
    Image(this.album)
      .borderRadius("18lpx")
      .id(this.focusId)
      .focusable(true)
      .width('100%')
      .aspectRatio(1)
      .shadow({ radius: 1, color: Color.Gray })
      .defaultFocus(this.defaultInFocus)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
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
      })
      .width('100%')
      .height('100%')
  }
}

