import worker, { MessageEvents, ThreadWorkerGlobalScope } from '@ohos.worker';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;
workerPort.onmessage = (e: MessageEvents): void => {
  if (typeof e.data === "string") {
    try {
      // 调用方法无入参
      let res: string = workerPort.callGlobalCallObjectMethod("picData", "setUp", 0) as string;
      console.error("worker: ", res);
    } catch (error) {
      // 异常处理
      console.error("worker: error code is " + error.code + " error message is " + error.message);
    }
  } else if (e.data instanceof Array) {
    workerPort.postMessage(e.data.slice(0, 4));
  }

}