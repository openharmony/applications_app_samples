import { mindSporeLite } from '@kit.MindSporeLiteKit'

export default async function modelPredict(
  modelBuffer: ArrayBuffer, inputsBuffer: ArrayBuffer[]): Promise<mindSporeLite.MSTensor[]> {

  //1.创建上下文
  let context: mindSporeLite.Context = {};
  context.target = ['cpu'];
  context.cpu = {}
  context.cpu.threadNum = 2;
  context.cpu.threadAffinityMode = 1;
  context.cpu.precisionMode = 'enforce_fp32';

  //2.加载模型
  let msLiteModel: mindSporeLite.Model = await mindSporeLite.loadModelFromBuffer(modelBuffer, context);

  //3.设置输入数据
  let modelInputs: mindSporeLite.MSTensor[] = msLiteModel.getInputs();

  // 本模型不支持其他shape resize
  for (let i = 0; i < inputsBuffer.length; i++) {
    let inputBuffer = inputsBuffer[i];
    if (inputBuffer != null) {
      modelInputs[i].setData(inputBuffer as ArrayBuffer);
    }
  }

  //4.执行推理
  console.info('=========MS_LITE_LOG: MS_LITE predict start=====');
  let modelOutputs: mindSporeLite.MSTensor[] = await msLiteModel.predict(modelInputs);
  return modelOutputs;
}


