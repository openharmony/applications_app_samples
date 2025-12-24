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

import { expect } from '@ohos/hypium';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';

export async function sleep(time: number): Promise<void> {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export async function saveMediaToGallery(ctx: Context, rawfileName: string, isImage: boolean = true): Promise<void> {
  try {
    let resourceManager = ctx.resourceManager;
    let imageData = await resourceManager.getRawFileContent(rawfileName);

    let file = fileIo.openSync(ctx.filesDir + `/${rawfileName}`,
      fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
    fileIo.writeSync(file.fd, imageData.buffer);
    fileIo.closeSync(file);

    let fileUri = 'file://' + ctx.filesDir + `/${rawfileName}`;

    if (isImage) {
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(ctx, fileUri);

      let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(ctx);
      await phAccessHelper.applyChanges(assetChangeRequest);
    } else {
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        photoAccessHelper.MediaAssetChangeRequest.createVideoAssetRequest(ctx, fileUri);

      let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(ctx);
      await phAccessHelper.applyChanges(assetChangeRequest);
    }
  } catch (err) {
    expect(true).assertFalse();
  }
}