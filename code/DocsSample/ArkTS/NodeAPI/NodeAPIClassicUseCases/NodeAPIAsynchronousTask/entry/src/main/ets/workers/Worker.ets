// [Start napi_create_async_work_worker]
// entry/src/main/ets/workers/Worker.ets

import nativeModule from 'libentry1.so';
import { worker, MessageEvents } from '@kit.ArkTS';

const port = worker.workerPort;

port.onmessage = (e : MessageEvents) => {
    console.info('Worker thread received data:', e.data.num1 + '、' + e.data.num2);
    nativeModule.asyncWork(e.data.num1, e.data.num2, (result) => {
        port.postMessage(result);
    });
}
// [End napi_create_async_work_worker]