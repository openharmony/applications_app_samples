/*
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import GoodsInfo from '../model/GoodsModel';

import { DatabaseUtil, EmitterUtil } from 'shoppingdata';
import { logger } from '../utils/Logger';

export class ShoppingDataUtil {
  private databaseUtil: DatabaseUtil;
  private emitterUtil: EmitterUtil;

  constructor(private context: Context) {
    this.context = context;
    this.databaseUtil = new DatabaseUtil(context);
    this.emitterUtil = new EmitterUtil();
  }

  public changeGoods(goodsId: string, count: number): void {
    this.emitterUtil.changeGoods(goodsId, count);
  }

  /**
   * 通过商品id查询商品信息
   */
  public async getGoodsInfo(goodsId: number): Promise<GoodsInfo> {
    let goodsInfo = await this.databaseUtil.queryGoodsInfo(this.context, goodsId);
    return goodsInfo;
  }

  public async getGoodsList(): Promise<Array<GoodsInfo>> {
    let goodsList = await this.databaseUtil.getGoodsList(this.context);
    if (goodsList.length === 0) {
      logger.error('goods list is empty !');
      return;
    }

    let result: Array<GoodsInfo> = [];
    for (let i = 0;i < goodsList.length - 1; i++) {
      if (goodsList[i].count > 0) {
        result.push(goodsList[i]);
      }
    }
    return result;
  }

  public async updateGoodsInfo(goodsInfo: GoodsInfo, count: number): Promise<void> {
    await this.databaseUtil.updateGoodsInfo(this.context, goodsInfo, count);
  }
}