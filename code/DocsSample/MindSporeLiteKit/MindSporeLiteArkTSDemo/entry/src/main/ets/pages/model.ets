// [Start model_ImageClassification]
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

  // 本模型不支持其他shape resize
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
// [End model_ImageClassification]

