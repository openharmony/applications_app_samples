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
 

import { hiTraceMeter } from '@kit.PerformanceAnalysisKit';
import Log from './Log';

/**
 * Add method trace. Modify RECORD_TRACE before using.
 */
export default class Trace {
  public static readonly CORE_METHOD_START_DROPDOWNPANEL = 'startDropdownPanel';
  public static readonly CORE_METHOD_START_TOUCHEVENT = 'startTouchEvent';
  public static readonly CORE_METHOD_CLICK_CAPSULE = 'clickCapsuleEvent';
  public static readonly CORE_METHOD_CLICK_NOTIFICATION = 'clickNotificationEvent';
  public static readonly CORE_METHOD_START_VOLUMEPANEL = 'startVolumePanel';

  private static readonly TRACE_TAG = 'Systemui:Trace';
  private static readonly RECORD_TRACE = true;
  private static readonly TRACE_LIMIT = 2000;

  private static readonly TRACE_BASE_INDEX = 10000;
  private static taskIdMap: Map<string, number> = new Map();
  private static nextTraceIndex: number = Trace.TRACE_BASE_INDEX;

  /**
    * start trace method
    *
    * @param {string} methodName - methodName for tracing
    */
  static start(methodName: string): void {
    if (!Trace.RECORD_TRACE) {
      return;
    }
    let taskId: number | undefined = Trace.taskIdMap.get(methodName);
    if (taskId == undefined) {
      taskId = Trace.nextTraceIndex;
      Trace.nextTraceIndex++;
      Trace.taskIdMap.set(methodName, taskId);
    }
    Log.showInfo(Trace.TRACE_TAG, `start trace ${taskId}`);
    hiTraceMeter.startTrace(Trace.TRACE_TAG + methodName, taskId);
  }

  /**
    * stop trace method
    *
    * @param {string} methodName - methodName for tracing
    */
  static end(methodName: string): void {
    if (!Trace.RECORD_TRACE) {
      return;
    }
    const taskId: number | undefined = Trace.taskIdMap.get(methodName);
    if (taskId == undefined) {
      Log.showError(Trace.TRACE_TAG, `fail to end trace name ${methodName}`);
      return;
    }
    Log.showInfo(Trace.TRACE_TAG, `end trace ${taskId}`);
    hiTraceMeter.finishTrace(Trace.TRACE_TAG + methodName, taskId);
  }
}
