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
 
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';


let context: Context = getContext(this) as common.UIAbilityContext

export async function createRegister(onRefresh: () => void) {
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  let onCallback = (changeData: photoAccessHelper.ChangeData) => {
    console.info('onCallback successfully, changData: ' + JSON.stringify(changeData));
    onRefresh()
  }
  phAccessHelper.registerChange(photoAccessHelper.DefaultChangeUri.DEFAULT_PHOTO_URI, true, onCallback);
}