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
import { JsonArray, JsonObject, LayoutData } from './CommonType';
import { RESOLVER_REGISTRY as ResolverRegistry } from './ResolverRegistry';
import { fibonacciRecursive } from './Workload';

const TAG = 'DataParser';

console.log('---', TAG, 'import DataParser');

export interface IDataParser {
  parse(layoutData: LayoutData): Promise<DataSource>;
}

interface Evaluable {
  evaluate(): Object;
}

class WidthDynamicFormula implements Evaluable {
  static width: number = 100
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

function evalDynamicFormula(output: any, key: string, varResult: VarResult): void {
  Reflect.defineProperty(output, key, {
    get: function () {
      console.log('--- evalDynamicFormula get');
      return varResult.result;
    }
  })
}

export class DataParser implements IDataParser {
  static width = 100;
  parse(layoutData: LayoutData): Promise<DataSource> {
    const layoutDataObj: JsonObject | JsonArray = typeof layoutData === 'string' ? JSON.parse(layoutData) : layoutData;

    const rtn = new DataSource();
    console.time('--- fibonacciRecursive');
    fibonacciRecursive(31);
    console.timeEnd('--- fibonacciRecursive');

    if (Array.isArray(layoutDataObj)) {
      for (let i = 0; i < layoutDataObj.length; i++) {
        this.parseObject(layoutDataObj[i], rtn);
      }
    } else {
      this.parseObject(layoutData, rtn);
    }

    return Promise.resolve(rtn);
  }

  private parseObject(cardData: JsonObject, dataSource: DataSource): void {
    if (Array.isArray(cardData.data)) {
      for (let i = 0; i < cardData.data.length; i++) {
        this.createCardData(cardData.type, cardData.data[i], dataSource);
      }
    } else {
      this.createCardData(cardData.type, cardData.data, dataSource);
    }
  }

  private createCardData(type: string, payload: JsonObject, dataSource: DataSource): void {
    const cardResolver = ResolverRegistry.getCardResolver(type);
    if (!cardResolver) {
      console.error('---', TAG, 'Not found type: ' + type);
      return;
    }

    const data: CardData = cardResolver.createData({
      type: type,
      data: payload
    });
    dataSource.addData(data);
    evalDynamicFormula(payload.style, 'width', new VarResult(new WidthDynamicFormula())); // dynamic formula
    console.info('---', TAG, 'createCardData', data.type, data.opt('name'), data.opt('width'));
  }
}

