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
import testNapi from 'libentry.so';
import { AppLog } from '../utils/Logger';
import { common } from '@kit.AbilityKit';
import { pushSourceToBox, getFileFd } from './FunctionUtility';

const TAG: string = 'HdrColorSpaceFunctions';

export class HdrColorSpaceFunctions {
  private logger = new AppLog(TAG);

  async createHdrImageSource(context: common.UIAbilityContext, fileName: string): Promise<string> {
    let filePath = context.filesDir + '/' + fileName;
    await pushSourceToBox(context, fileName);
    let errorCode = testNapi.createHdrImageSource(filePath);
    this.logger.check_result('CreateHdrImageSource', errorCode);
    if (errorCode === 0) {
      return 'CreateHdrImageSource success.';
    }
    this.logger.log(`CreateHdrImageSource failed with ${errorCode}.`);
    return `CreateHdrImageSource failed with ${errorCode}.`;
  }

  decodeHdrPixelMap(): string {
    let errorCode = testNapi.decodeHdrPixelMap();
    this.logger.check_result('DecodeHdrPixelMap', errorCode);
    return errorCode === 0 ? 'DecodeHdrPixelMap success.' : `DecodeHdrPixelMap failed with ${errorCode}.`;
  }

  checkHdrDynamicRange(): string {
    let errorCode = testNapi.checkHdrDynamicRange();
    this.logger.check_result('CheckHdrDynamicRange', errorCode);
    return errorCode === 0 ? 'CheckHdrDynamicRange success.' : `CheckHdrDynamicRange failed with ${errorCode}.`;
  }

  decodeSdrPixelMap(): string {
    let errorCode = testNapi.decodeSdrPixelMap();
    this.logger.check_result('DecodeSdrPixelMap', errorCode);
    return errorCode === 0 ? 'DecodeSdrPixelMap success.' : `DecodeSdrPixelMap failed with ${errorCode}.`;
  }

  decodeHdrPicture(): string {
    let errorCode = testNapi.decodeHdrPicture();
    this.logger.check_result('DecodeHdrPicture', errorCode);
    return errorCode === 0 ? 'DecodeHdrPicture success.' : `DecodeHdrPicture failed with ${errorCode}.`;
  }

  getMainPixelmapFromPicture(): string {
    let errorCode = testNapi.getMainPixelmapFromPicture();
    this.logger.check_result('GetMainPixelmapFromPicture', errorCode);
    return errorCode === 0 ? 'GetMainPixelmapFromPicture success.' : `GetMainPixelmapFromPicture failed with ${errorCode}.`;
  }

  getGainmapPixelmapFromPicture(): string {
    let errorCode = testNapi.getGainmapPixelmapFromPicture();
    this.logger.check_result('GetGainmapPixelmapFromPicture', errorCode);
    return errorCode === 0 ? 'GetGainmapPixelmapFromPicture success.' : `GetGainmapPixelmapFromPicture failed with ${errorCode}.`;
  }

  getHdrComposedPixelmapFromPicture(): string {
    let errorCode = testNapi.getHdrComposedPixelmapFromPicture();
    this.logger.check_result('GetHdrComposedPixelmapFromPicture', errorCode);
    return errorCode === 0 ? 'GetHdrComposedPixelmapFromPicture success.' :
      `GetHdrComposedPixelmapFromPicture failed with ${errorCode}.`;
  }

  packHdrPixelMap(context: common.UIAbilityContext, fileName: string): string {
    const fd = getFileFd(context, fileName);
    let errorCode = testNapi.packHdrPixelMap(fd as number);
    this.logger.check_result('PackHdrPixelMap', errorCode);
    return errorCode === 0 ? 'PackHdrPixelMap success.' : `PackHdrPixelMap failed with ${errorCode}.`;
  }

  releaseHdrColorSpaceSource(): string {
    let errorCode = testNapi.releaseHdrColorSpaceSource();
    this.logger.check_result('ReleaseHdrColorSpaceSource', errorCode);
    return errorCode === 0 ? 'ReleaseHdrColorSpaceSource success.' : `ReleaseHdrColorSpaceSource failed with ${errorCode}.`;
  }
}