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
 
import { PhotoModel } from '../../models/PhotoModel'
import { getThumbByUri } from '../../manager/loader/LoadUtil'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { EventUtil } from '../../common/EventUtil'
import { IntentionCode, KeyCode } from '@kit.InputKit'

@Component
export struct PickImageVideo {
  @ObjectLink
  photoModel: PhotoModel | undefined;
  @Require
  focusId: string = ''
  @Require
  eventClickBack?: () => void
  private defaultInFocus: boolean = true
  @State album: string | undefined = undefined

  aboutToAppear(): void {
    if (this.photoModel) {
      if (this.photoModel.photoType == photoAccessHelper.PhotoType.VIDEO) {
        getThumbByUri(getContext(), this.photoModel, 'videoImage' + this.focusId)
          .then((thumbUri) => {
            this.album = thumbUri;
            this.photoModel!.pickVideoPreview = thumbUri;
          })
      } else {
        this.album = this.photoModel.uri
      }
    }
  }

  build() {
    Image(this.album)
      .borderRadius('18lpx')
      .id(this.focusId)
      .focusable(true)
      .width('100%')
      .stateStyles({
        focused: {
          .border({
            color: Color.Transparent
          })
        }
      })
      .aspectRatio(1)
      .shadow({ radius: 1, color: Color.Gray })
      .defaultFocus(this.defaultInFocus)
      .autoResize(true)
      .onClick(() => {
        this.eventClickBack && this.eventClickBack();
      })
      .width('100%')
      .height('100%')
  }
}
