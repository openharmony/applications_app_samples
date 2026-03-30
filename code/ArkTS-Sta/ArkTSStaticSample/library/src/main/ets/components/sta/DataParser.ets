/**
 *
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

'use static'

import { DataSource } from './DataSource';
import { CardData } from './CardData';
import { RESOLVER_REGISTRY as ResolverRegistry } from './ResolverRegistry';
import hiTraceMeter from '@kit.PerformanceAnalysisKit';
import { fibonacciRecursive } from './Workload';
import { jsonToArray, jsonObjectToRecord, JsonArray, JsonObject } from './CommonType'

const TAG = 'DataParser';

export interface IDataParser {
  parse(layoutDataStr: string): Promise<DataSource>;
}

interface Evaluable {
  evaluate(): Object;
}

class WidthDynamicFormula implements Evaluable {
  static width = 100
  evaluate(): Object {
    WidthDynamicFormula.width = WidthDynamicFormula.width - 10;
    return WidthDynamicFormula.width.toString() + '%';
  }
}

class VarResult {
  private _result: Object | undefined;
  private formula: Evaluable;
  constructor(e: Evaluable) {
    this.formula = e;
  }

  get result(): Object {
    this._result = this.formula.evaluate();
    return this._result!;
  }
}

class MyRecord extends Record<string, Object> {
  private key: string;
  private varResult: VarResult;
  constructor(k: string, r: VarResult) {
    this.key = k;
    this.varResult = r;
  }

  override $_get(k : String) : Object | undefined {
    if (k === this.key) {
      return this.varResult.result;
    }
    return undefined;
  }
}


export class DataParser implements IDataParser {
  parse(layoutDataStr: string): Promise<DataSource> {
    hiTraceMeter.startTrace('new-task', 50002);
    let task: taskpool.Task = new taskpool.Task(this.parseFunction, layoutDataStr);
    hiTraceMeter.finishTrace('new-task', 50002);
    hiTraceMeter.startTrace('task-execute', 50003);
    return taskpool.execute(task, taskpool.Priority.HIGH) as Promise<DataSource>;
  }

  parseFunction(layoutDataStr: string): DataSource {
    hiTraceMeter.startTrace('parse-concurrent', 50004);
    const layoutData: jsonx.JsonElement = JSON.parseJsonElement(layoutDataStr);
    console.time('--- fibonacciRecursive');
    fibonacciRecursive(31);
    console.timeEnd('--- fibonacciRecursive');
    const rtn = new DataSource();

    if (layoutData.jsonType === jsonx.JsonType.JsonArray) {
      let layoutDataArray: JsonArray = jsonToArray(layoutData.asArray());
      for (let i = 0; i < layoutDataArray.length; i++) {
        this.parseObject(layoutDataArray[i] as JsonObject, rtn);
      }
    } else if (layoutData.jsonType === jsonx.JsonType.JsonObject) {
      let layoutDataObject: JsonObject = jsonObjectToRecord(layoutData);
      this.parseObject(layoutDataObject, rtn);
    }
    hiTraceMeter.finishTrace('parse-concurrent', 50004);
    hiTraceMeter.finishTrace('task-execute', 50003);
    return rtn;
  }

  private parseObject(cardData: JsonObject, dataSource: DataSource): void {
    const payload = cardData.get('data');
    try {
      if (payload) {
        if (Array.isArray(payload!)) {
          (payload! as JsonArray).forEach((_payload: Object) => {
            this.createCardData(cardData.get('type')!.toString(), _payload, dataSource);
          })
        } else {
          this.createCardData(cardData.get('type')!.toString(), payload!, dataSource);
        }
      }
    } catch (e: Error) {
      console.error('--- parseObject exception, message', e.toString());
    }

  }

  private createCardData(type: string, payload: Object, dataSource: DataSource): void {
    const cardResolver = ResolverRegistry.getCardResolver(type);
    if (!cardResolver) {
      console.error('---', TAG, 'Not found type: ' + type);
      return;
    }

    const data: CardData = cardResolver.createData({
      type: type,
      data: payload as JsonObject
    });
    // let widthRecord: MyRecord = new MyRecord();
    (payload as JsonObject).set('style', new MyRecord('width', new VarResult(new WidthDynamicFormula())));
    dataSource.addData(data);
    console.info('---', TAG, 'createCardData', data.type);
  }
}

