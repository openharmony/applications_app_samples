/*
* Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

// [Start model_image_classification]
import { mindSporeLite } from '@kit.MindSporeLiteKit'
import { hilog } from '@kit.PerformanceAnalysisKit';

export default async function modelPredict(
  modelBuffer: ArrayBuffer, inputsBuffer: ArrayBuffer[]): Promise<mindSporeLite.MSTensor[]> {

  // 1.创建上下文，设置线程数、设备类型等参数。本样例模型，不支持配置context.target = ["nnrt"]。
  let context: mindSporeLite.Context = {};
  context.target = ['cpu'];
  context.cpu = {}
  context.cpu.threadNum = 2;
  context.cpu.threadAffinityMode = 1;
  context.cpu.precisionMode = 'enforce_fp32';

  // 2.从内存加载模型。
  let msLiteModel: mindSporeLite.Model = await mindSporeLite.loadModelFromBuffer(modelBuffer, context);

  // 3.设置输入数据。
  let modelInputs: mindSporeLite.MSTensor[] = msLiteModel.getInputs();
  for (let i = 0; i < inputsBuffer.length; i++) {
    let inputBuffer = inputsBuffer[i];
    if (inputBuffer != null) {
      modelInputs[i].setData(inputBuffer as ArrayBuffer);
    }
  }

  // 4.执行推理。
  hilog.info(0xFF00, 'MindSporeLiteArkTSDemo', '%{public}s', `=========MS_LITE_LOG: MS_LITE predict start=====`);
  let modelOutputs: mindSporeLite.MSTensor[] = await msLiteModel.predict(modelInputs);
  return modelOutputs;
}
// [End model_image_classification]

