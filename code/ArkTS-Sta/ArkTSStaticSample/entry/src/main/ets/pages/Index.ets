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

import { DataParser, DataSource, CardData, RESOLVER_REGISTRY as ResolverRegistry, JsonArray } from 'library';
import { CardResolver } from './CardResolver';
import jsonData from './jsonData.json';
import { hiTraceMeter } from '@kit.PerformanceAnalysisKit';
import { fibonacciRecursive } from './Workload';

const asyncFunction1 = async (): Promise<number> => {
  return new Promise((resolve) => {
    setTimeout(() => {
      hiTraceMeter.startTrace('main-workload-28', 50010);
      fibonacciRecursive(28);
      hiTraceMeter.finishTrace('main-workload-28', 50010);
    }, 0);
  });
};
const asyncFunction2 = async (): Promise<number> => {
  return new Promise((resolve) => {
    setTimeout(() => {
      hiTraceMeter.startTrace('main-workload-25', 50011);
      fibonacciRecursive(25);
      hiTraceMeter.finishTrace('main-workload-25', 50011);
    }, 0
    );
  });
};
const asyncFunction3 = async (): Promise<number> => {
  return new Promise((resolve) => {
    setTimeout(() => {
      hiTraceMeter.startTrace('main-workload-15', 50012);
      fibonacciRecursive(15);
      hiTraceMeter.finishTrace('main-workload-15', 50012);
    }, 0);
  });
};

@Entry
@Component
export struct Index {
  @State data: DataSource | undefined = undefined;
  @State message0: string = 'Hello 0';

  aboutToAppear(): void {
    ResolverRegistry.registerCard('text', new CardResolver());

    try {
      let layoutData: JsonArray = jsonData.layoutData;
      let dataParser: DataParser = new DataParser();
      Promise.all([
        asyncFunction1(),
        asyncFunction2(),
        asyncFunction3(),
      ]);
      hiTraceMeter.startTrace('dataParser', 50001);
      dataParser.parse(layoutData).then((dataSource: DataSource) => {
        hiTraceMeter.finishTrace('dataParser', 50001);
        console.log('---', dataSource.totalCount());
        this.data = dataSource;
      });

    } catch (e) {
      let msg = 'error:\n' + e?.message + '\n' + e?.stack;
      console.error(msg);
      this.message0 = msg;
    }
  }

  build() {
    Column() {
      Text(this.message0)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      if (this.data) {
        List({ space: 16 }) {
          LazyForEach(this.data, (data: CardData) => {
            ListItem() {
              Text(data.opt('item').title.name)
                .fontSize(36)
                .width(data.opt('style').width)
                .height(100)
                .backgroundColor(Color.Green)
                .textAlign(TextAlign.Center)
            }
            .padding({
              left: 8,
              top: 8,
              right: 8,
              bottom: 8
            })
          }, (data: CardData) => data.getObjectId())
        }
      }
    }
  }
}

