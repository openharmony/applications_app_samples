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

import { describe, it, expect } from '@ohos/hypium';

class WorkerDataHolder {
  key: string = '';
  num: number = 0;

  constructor(key: string = '', num: number = 0) {
    this.key = key;
    this.num = num;
  }
}

class WorkerPortHolder {
  postMessage(_message: string): void {
  }
}

class Worker {
  data: string | number | boolean | Array<number> | WorkerDataHolder | null | undefined = null;
  dataLen: number = 0;
  worker: WorkerPortHolder | null = null;
  url: string = '';
  srcPath: string = '';
}


export default function WorkerFullContract001Test() {
  const casePrefix = 'DemandPlayer_WorkerFullContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('WorkerFullContract001TestSuite', () => {
    it(addCase(casePrefix + 'Worker_InitialData_Null_001'), 0, () => {
      const worker = new Worker();
      expect(worker.data === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'Worker_InitialData_Len_Zero_002'), 0, () => {
      const worker = new Worker();
      expect(worker.dataLen).assertEqual(0);
    });

    it(addCase(casePrefix + 'Worker_InitialWorker_Null_003'), 0, () => {
      const worker = new Worker();
      expect(worker.worker === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'Worker_InitialUrl_EmptyString_004'), 0, () => {
      const worker = new Worker();
      expect(worker.url).assertEqual('');
    });

    it(addCase(casePrefix + 'Worker_InitialSrcPath_EmptyString_005'), 0, () => {
      const worker = new Worker();
      expect(worker.srcPath).assertEqual('');
    });

    it(addCase(casePrefix + 'Worker_InitialData_SetNull_006'), 0, () => {
      const worker = new Worker();
      worker.data = null;
      expect(worker.data === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'Worker_InitialData_SetObject_007'), 0, () => {
      const worker = new Worker();
      worker.data = new WorkerDataHolder('value', 0);
      expect((worker.data as WorkerDataHolder).key).assertEqual('value');
    });

    it(addCase(casePrefix + 'Worker_DataLen_SetValue_008'), 0, () => {
      const worker = new Worker();
      worker.dataLen = 1024;
      expect(worker.dataLen).assertEqual(1024);
    });

    it(addCase(casePrefix + 'Worker_Worker_SetInstance_009'), 0, () => {
      const worker = new Worker();
      const fakeW = new WorkerPortHolder();
      worker.worker = fakeW;
      expect(worker.worker !== null).assertEqual(true);
    });

    it(addCase(casePrefix + 'Worker_Url_SetPath_010'), 0, () => {
      const worker = new Worker();
      worker.url = '/data/workers/my.worker.js';
      expect(worker.url).assertEqual('/data/workers/my.worker.js');
    });

    it(addCase(casePrefix + 'Worker_SrcPath_SetPath_011'), 0, () => {
      const worker = new Worker();
      worker.srcPath = 'entry/workers/PlayerWorker.ts';
      expect(worker.srcPath).assertEqual('entry/workers/PlayerWorker.ts');
    });

    it(addCase(casePrefix + 'Worker_MultipleFieldUpdates_012'), 0, () => {
      const worker = new Worker();
      worker.data = new WorkerDataHolder('', 42);
      worker.dataLen = 256;
      worker.url = '/path/worker.js';
      worker.srcPath = 'workers/Player.ts';
      expect((worker.data as WorkerDataHolder).num).assertEqual(42);
      expect(worker.dataLen).assertEqual(256);
      expect(worker.url).assertEqual('/path/worker.js');
      expect(worker.srcPath).assertEqual('workers/Player.ts');
    });

    it(addCase(casePrefix + 'Worker_DataLen_NegativeValue_013'), 0, () => {
      const worker = new Worker();
      worker.dataLen = -1;
      expect(worker.dataLen).assertEqual(-1);
    });

    it(addCase(casePrefix + 'Worker_DataLen_LargeValue_014'), 0, () => {
      const worker = new Worker();
      worker.dataLen = 1000000000;
      expect(worker.dataLen).assertEqual(1000000000);
    });

    it(addCase(casePrefix + 'Worker_Worker_ReplaceInstance_015'), 0, () => {
      const worker = new Worker();
      const fakeW1 = new WorkerPortHolder();
      const fakeW2 = new WorkerPortHolder();
      worker.worker = fakeW1;
      worker.worker = fakeW2;
      expect(worker.worker !== null).assertEqual(true);
    });

    it(addCase(casePrefix + 'Worker_Data_ClearAndSet_016'), 0, () => {
      const worker = new Worker();
      worker.data = new WorkerDataHolder('a', 1);
      worker.data = new WorkerDataHolder('b', 2);
      expect((worker.data as WorkerDataHolder).key).assertEqual('b');
      expect((worker.data as WorkerDataHolder).num).assertEqual(2);
    });

    it(addCase(casePrefix + 'Worker_Url_EmptyAfterSet_017'), 0, () => {
      const worker = new Worker();
      worker.url = '';
      expect(worker.url).assertEqual('');
    });

    it(addCase(casePrefix + 'Worker_SrcPath_EmptyAfterSet_018'), 0, () => {
      const worker = new Worker();
      worker.srcPath = '';
      expect(worker.srcPath).assertEqual('');
    });

    it(addCase(casePrefix + 'Worker_Data_ArrayValue_019'), 0, () => {
      const worker = new Worker();
      worker.data = [1, 2, 3, 4, 5];
      expect((worker.data as number[]).length).assertEqual(5);
    });

    it(addCase(casePrefix + 'Worker_Data_NumberValue_020'), 0, () => {
      const worker = new Worker();
      worker.data = 42;
      expect(worker.data).assertEqual(42);
    });

    it(addCase(casePrefix + 'Worker_Data_StringValue_021'), 0, () => {
      const worker = new Worker();
      worker.data = 'worker-data-string';
      expect(worker.data).assertEqual('worker-data-string');
    });

    it(addCase(casePrefix + 'Worker_Data_BooleanValue_022'), 0, () => {
      const worker = new Worker();
      worker.data = true;
      expect(worker.data).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_023'), 0, () => {
      expect(allCaseNames.length).assertEqual(23);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_WorkerFullContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
