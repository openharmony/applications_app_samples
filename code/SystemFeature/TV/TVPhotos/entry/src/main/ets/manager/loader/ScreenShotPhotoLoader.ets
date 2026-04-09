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
import { AlbumModel, AlbumType } from "../../models/PhotoModel";
import { SubTypeLoader } from "./SubTypeLoader";
import { photoAccessHelper } from "@kit.MediaLibraryKit";

const TAG = 'PHOTOM_ScreenShotPhotoLoader'

export class ScreenShotPhotoLoader extends SubTypeLoader {
  getTag(): string {
    return TAG
  }

  getAlbumModel(): AlbumModel {
    return new AlbumModel(AlbumType.SCREENSHOT, $r('app.string.album_name_screenshot'))
  }

  getSubType(): photoAccessHelper.AlbumSubtype {
    return photoAccessHelper.AlbumSubtype.SCREENSHOT
  }
}