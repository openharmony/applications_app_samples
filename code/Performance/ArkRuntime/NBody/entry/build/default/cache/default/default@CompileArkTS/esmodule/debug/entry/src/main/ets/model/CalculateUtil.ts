import taskpool from "@ohos:taskpool";
import type { BusinessError } from "@ohos:base";
import worker from "@ohos:worker";
import type { MessageEvents } from "@ohos:worker";
import util from "@ohos:util";
import { offsetMomentum, energy, advance } from "@bundle:com.example.nbody/entry/ets/model/NBody_ETS_6";
import Logger from "@bundle:com.example.nbody/entry/ets/utils/Logger";
const TAG: string = 'CalculateUtil';
let calculateResult: string = "Total time costed = %s ms.";
class WorkerMessage {
    timeSteps: number;
    constructor(timeSteps: number) {
        this.timeSteps = timeSteps;
    }
}
/**
 * 运行天体轨道计算程序
 * @param totalTimeSteps 时间推移量
 * @returns 计算时间
 */
export function computeTask(totalTimeSteps: number): number {
    "use concurrent";
    const tagInTask: string = 'computeTask';
    const timeStep: number = 0.01; // 单位:hour
    const fractionDigits: number = 9; // 机械能数值小数位
    let start: number = new Date().getTime();
    // 建立孤立系统的动量守恒
    offsetMomentum();
    Logger.info(tagInTask, energy().toFixed(fractionDigits));
    // 更新天体在按指定的时间变化后的位置信息
    for (let i: number = 0; i < totalTimeSteps; i++) {
        advance(timeStep);
    }
    // 判断系统计算前后机械能守恒
    Logger.info(tagInTask, energy().toFixed(fractionDigits));
    let end: number = new Date().getTime();
    return end - start;
}
/**
 * 使用TaskPool开启子线程，执行轨道计算任务
 * @param totalTimeSteps 时间推移量
 */
export function computeNBodyByTaskPool(totalTimeSteps: number): void {
    Logger.info(TAG, "computeNBodyByTaskPool: start executing");
    let task: taskpool.Task = new taskpool.Task(computeTask, totalTimeSteps);
    try {
        Logger.info(TAG, 'computeNBodyByTaskPool: start calculating...');
        // 向taskpool线程池派发子线程任务
        taskpool.execute(task, taskpool.Priority.HIGH).then((res: number) => {
            Logger.info(TAG, 'computeNBodyByTaskPool: executed successfully, total time costed = ' + res + ' ms.');
            AppStorage.set<String>('timeCost', util.format(calculateResult, res.toString()));
        });
    }
    catch (err) {
        Logger.error(TAG, "computeNBodyByTaskPool: execute failed, " + (err as BusinessError).toString());
    }
    Logger.info(TAG, "computeNBodyByTaskPool: finish executing");
}
/**
 * 使用Worker开启子线程，执行轨道计算任务
 * @param totalTimeSteps 时间推移量
 */
export function computeNBodyByWorker(totalTimeSteps: number): void {
    Logger.info(TAG, "computeNBodyByWorker: start executing");
    let workerInstance = new worker.ThreadWorker("entry/ets/workers/CalculateWorker.ts");
    // 设置如何处理，来自worker线程的消息
    workerInstance.onmessage = (e: MessageEvents): void => {
        let data = e.data;
        Logger.info(TAG, 'computeNBodyByWorker: executed successfully, total time costed = ' + data.result + ' ms.');
        AppStorage.set<String>('timeCost', util.format(calculateResult, data.result));
    };
    // 设置由主线程向worker线程发送什么消息
    workerInstance.postMessage(new WorkerMessage(totalTimeSteps));
}