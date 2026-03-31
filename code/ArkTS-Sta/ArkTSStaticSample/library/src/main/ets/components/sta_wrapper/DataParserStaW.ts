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

import { LayoutData } from '../dyn/CommonType';
import { DataSource, CardData, RESOLVER_REGISTRY as ResolverRegistry, IDataParser } from '../dyn/IndexDyn';
import { EtsFactory } from '../sta_bridge/EtsFactory';

const TAG = 'DataParserStaW';

console.log('---', TAG, 'import DataParserStaW');

export class DataParserStaW implements IDataParser {
  private dataParserSta: IDataParser;

  constructor() {
    this.dataParserSta = EtsFactory.get().newDataParser();
  }

  parse(layoutData: LayoutData): Promise<DataSource> {
    const layoutDataStr = (typeof layoutData === 'string') ? layoutData : JSON.stringify(layoutData);

    return this.dataParserSta.parse(layoutDataStr).then((dataSourceSta: DataSource) => {
      const dataSource: DataSource = new DataSource();
      const len = dataSourceSta.totalCount();

      for (let i = 0; i < len; i++) {
        const dataSta = dataSourceSta.getData(i);
        const data = this.convertCardDataToDyn(dataSta);
        if (data) {
          dataSource.addData(data);
        }
      }

      return dataSource;
    });
  }

  private convertCardDataToDyn(dataSta: CardData): CardData | undefined {
    const cardResolver = ResolverRegistry.getCardResolver(dataSta.type);
    if (!cardResolver) {
      console.error('---', TAG, 'Not found type: ' + dataSta.type);
      return undefined;
    }
    const data: CardData = cardResolver.createData({
      type: dataSta.type,
      data: dataSta.data
    });
    console.info('---', TAG, '** convertCardDataToDyn 00000', dataSta.type);
    return data;
  }
}
