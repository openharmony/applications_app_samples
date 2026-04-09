import bytrace from '@ohos.bytrace';

export class TraceControllerUtils {
  // Used to track the start of sequential tasks
  public static startTrace(name: string): void {
    bytrace.startTrace(name, 1);
  }

  // Used to track the end of sequential tasks. The name must be the same as that at start
  public static finishTrace(name: string): void {
    bytrace.finishTrace(name, 1);
  }

  // Used to track the start of cross tasks
  // (scenarios where the next task starts before the previous task is finished)
  public static startTraceWithTaskId(name: string, taskId: number): void {
    bytrace.startTrace(name, taskId);
  }

  // Used to track the end of cross tasks. The name and taskid must be the same as at start
  public static finishTraceWithTaskId(name: string, taskId: number): void {
    bytrace.finishTrace(name, taskId);
  }
}