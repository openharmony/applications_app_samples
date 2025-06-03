/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import process from '@ohos.process';
import { ColumnOperation } from '../components/ColumnOperation';
import { getString } from '@ohos/common/src/main/ets/util/ResourceUtil';
import { logger } from '@ohos/common/src/main/ets/util/Logger';

let child: process.ChildProcess | undefined = undefined;
const TAG: string = 'Process';

@Component
export struct Process {
  @State result: string = '';

  build() {
    Scroll() {
      Column() {
        Text(this.result)
          .width('100%')
          .height(100)
          .backgroundColor('#DFDFDF')
          .fontSize(20)
          .margin({ top: 20 })
          .textAlign(TextAlign.Start)
          .padding(10)
        ColumnOperation({ operationRes: $r('app.strarray.process_operations'), doOperation: this.doOperation })
      }
      .width('100%')
      .padding(16)
    }
    .scrollBar(BarState.Off)
    .align(Alignment.Start)
  }

  doOperation = (index: number) => {
    let proManager = new process.ProcessManager();
    switch (index) {
      case 0:
        this.result = process.uptime().toString() + 's';
        logger.info(TAG, 'uptime=' + this.result);
        break;
      case 1:
        logger.info(TAG, 'process cwd');
        this.result = process.cwd().toString();
        break;
      case 2:
        logger.info(TAG, 'process change dir');
        process.chdir('/system');
        this.result = process.cwd().toString();
        break;
      case 3:
        child = process.runCmd('sleep 2;ls');
        this.result = child == null ? 'failed' : 'succeed';
        logger.info(TAG, 'runCmd=' + this.result);
        let childResult = child.wait();
        childResult.then(val => {
          this.result = 'child process run finish' + JSON.stringify(val);
          logger.info(TAG, 'runCmd result =' + val);
        })
        break;
      case 4:
        if (child != null) {
          this.result = getString($r('app.string.close_success'));
          child.close();
        } else {
          this.result = getString($r('app.string.child_null'));
        }
        logger.info(TAG, this.result);
        break;
      case 5:
        let pres = process.pid;
        let result = proManager.kill(28, pres);
        if (result === true) {
          this.result = getString($r('app.string.success'));
        } else {
          this.result = getString($r('app.string.failed'));
        }
        break;
      case 6:
        proManager.exit(0);
        break;
      default:
        break;
    }
  }
}