// [Start napi_call_threadsafe_function_worker]
// entry/src/main/ets/worker/worker.ets

import nativeModule from 'libentry1.so';
import { worker, MessageEvents } from '@kit.ArkTS';

const port = worker.workerPort;

port.onmessage = (e: MessageEvents) => {
  console.info('Worker thread received:' + e.data);
  nativeModule.startWithCallback('Hello', (result: string) => {
    console.info('[Worker] Got from native:', result);
    port.postMessage(result);
  });
}
// [End napi_call_threadsafe_function_worker]
