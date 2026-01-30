/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { camera } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'commons';
import OutputManager, { CreateOutputConfig, OutputType } from './OutputManager';
import CameraConstant from '../constants/CameraConstants';

const TAG_LOG = 'PreviewManager'

export class PreviewManager implements OutputManager {
  public type: OutputType = OutputType.PREVIEW;
  public output?: camera.PreviewOutput;
  public isActive: boolean = true;
  public onPreviewStart: () => void = () => {};

  constructor(onPreviewStart: () => void) {
    this.onPreviewStart = onPreviewStart;
  }

  // [Start createOutput]
  async createOutput(config: CreateOutputConfig) {
    const cameraOutputCap = config.cameraManager.getSupportedOutputCapability(config.device, config.sceneMode);
    const displayRatio = config.profile.size.width / config.profile.size.height;
    const profileWidth = config.profile.size.width;
    const previewProfile = cameraOutputCap.previewProfiles
      .sort((a, b) => Math.abs(a.size.width - profileWidth) - Math.abs(b.size.width - profileWidth))
      .find(pf => {
        const pfDisplayRatio = pf.size.width / pf.size.height;
        return pf.format === config.profile.format &&
          Math.abs(pfDisplayRatio - displayRatio) <= CameraConstant.PROFILE_DIFFERENCE;
      });
    if (!previewProfile) {
      Logger.error(TAG_LOG, 'Failed to get preview profile');
      return;
    }
    this.output = config.cameraManager.createPreviewOutput(previewProfile, config.surfaceId);
    this.addOutputListener(this.output);
    return this.output;
  }
  // [End createOutput]

  addOutputListener(output: camera.PreviewOutput) {
    this.addFrameStartEventListener(output);
    this.addFrameEndEventListener(output);
  }

  // [Start onFrame]
  addFrameStartEventListener(output: camera.PreviewOutput) {
    output.on('frameStart', (err: BusinessError) => {
      if (err !== undefined && err.code !== 0) {
        Logger.error(TAG_LOG, `FrameStart callback Error, errorMessage: ${err.message}`);
        return;
      }
      Logger.info(TAG_LOG, 'Preview frame started');
      this.onPreviewStart();
    });
  }

  addFrameEndEventListener(output: camera.PreviewOutput) {
    output.on('frameEnd', (err: BusinessError) => {
      if (err !== undefined && err.code !== 0) {
        Logger.error(TAG_LOG, `FrameStart callback Error, errorMessage: ${err.message}`);
        return;
      }
      Logger.info(TAG_LOG, 'Preview frame end');
    });
  }
  // [End onFrame]

  // [Start release]
  async release() {
    await this.output?.release();
    this.output = undefined;
  }
  // [End release]

  // [Start getSupportedFrameRates]
  getSupportedFrameRates() {
    return this.output?.getSupportedFrameRates();
  }
  // [End getSupportedFrameRates]

  // [Start setFrameRate]
  setFrameRate(minFps: number, maxFps: number) {
    try {
      this.output?.setFrameRate(minFps, maxFps);
    } catch(e) {
      Logger.error(TAG_LOG, 'setFrameRate error ' + JSON.stringify(e));
    }
  }
  // [End setFrameRate]
}
