/*
 *
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

import emitter from '@ohos.events.emitter';
import relationalStore from '@ohos.data.relationalStore';

import GoodsInfo from '../model/GoodsModel';

import { EmitterUtil } from './EmitterUtil';
import { logger } from './Logger';

let TAG: string = 'DatabaseUtil';

export class DatabaseUtil {
  private context: Context = undefined;
  private store: relationalStore.RdbStore = undefined;
  private storeName: string = 'product_list_rdb';
  private splCreate: string = 'CREATE TABLE IF NOT EXISTS product_list_rdb (id INTEGER PRIMARY KEY, ' +
  'imageUrl TEXT, title TEXT, introduction TEXT, type TEXT, price TEXT, old_price TEXT, count INTEGER);';

  constructor(context: Context) {
    this.context = context;
  }

  public registerEmitter(): void {
    emitter.on({ eventId: EmitterUtil.GOODS_CHANGE_ID }, (eventData) => {
      let goodsId: number = parseInt(eventData.data['goodsId']);
      let count: number = eventData.data['count'];
      logger.info(`id: ${goodsId}, count: ${count}, data: ${JSON.stringify(eventData)}`);
      this.queryGoodsInfo(this.context, goodsId).then(goodsInfo => {
        this.updateGoodsInfo(this.context, goodsInfo, count);
      });
    });
  }

  public async initDataBase(context: Context): Promise<void> {
    this.context = context
    let storeConfig: relationalStore.StoreConfig = {
      name: this.storeName,
      securityLevel: relationalStore.SecurityLevel.S1,
      encrypt: false
    };
    try {
      this.store = await relationalStore.getRdbStore(this.context, storeConfig);
    } catch (err) {
      logger.error(TAG, `Get RdbStore failed, err: ${JSON.stringify(err)}`);
      return;
    }
    logger.info(TAG, 'Get RdbStore successfully.');
    this.store.executeSql(this.splCreate, null);
  }

  // 从数据库中查询所有的商品列表
  public async getGoodsList(context: Context): Promise<Array<GoodsInfo>> {
    if (this.store === undefined) {
      await this.initDataBase(context);
    }
    let goodsList: Array<GoodsInfo> = [];
    let resultSet: relationalStore.ResultSet;

    let predicates = new relationalStore.RdbPredicates(this.storeName);
    predicates.isNotNull('id');
    try {
      resultSet = await this.store.query(predicates, []);
    } catch (err) {
      if (err) {
        logger.info(TAG, `Get result set fail: ${JSON.stringify(err)}`);
        return;
      }
    }
    resultSet.goToFirstRow();
    for (let i = 0;i < resultSet.rowCount - 1; i++) {
      goodsList.push({
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        imageUrl: resultSet.getString(resultSet.getColumnIndex('imageUrl')),
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        introduction: resultSet.getString(resultSet.getColumnIndex('introduction')),
        type: resultSet.getString(resultSet.getColumnIndex('type')),
        price: resultSet.getString(resultSet.getColumnIndex('price')),
        old_price: resultSet.getString(resultSet.getColumnIndex('old_price')),
        count: resultSet.getLong(resultSet.getColumnIndex('count'))
      });
      resultSet.goToNextRow();
    }
    logger.info(TAG, `Goods list: ${goodsList.toString()}`);
    return goodsList;
  }

  // 更新库中商品数量信息
  public async updateGoodsInfo(context: Context, goodsInfo: GoodsInfo, count: number): Promise<number> {
    if (this.store === undefined) {
      await this.initDataBase(context);
    }
    let goodsBucket: relationalStore.ValuesBucket = {
      'id': goodsInfo.id,
      'imageUrl': goodsInfo.imageUrl,
      'title': goodsInfo.title,
      'introduction': goodsInfo.introduction,
      'type': goodsInfo.type,
      'price': goodsInfo.price,
      'old_price': goodsInfo.old_price,
      'count': count
    };
    let predicates = new relationalStore.RdbPredicates(this.storeName);
    predicates.equalTo('id', parseInt(goodsInfo.id))
      .or()
      .equalTo('title', goodsInfo.title);
    let rowId: number;
    try {
      rowId = await this.store.update(goodsBucket, predicates);
      this.store.commit();
    } catch (err) {
      if (err) {
        logger.error(TAG, 'update goods info fail!');
      }
    }
    // 同步组件刷新的状态
    AppStorage.SetOrCreate('goods_data_update', Date.now());
    logger.info(TAG, `Update goods info: ${JSON.stringify(goodsBucket)}, rowId: ${rowId}`);
    return rowId;
  }

  // 通过Id查找库中某一商品的信息
  public async queryGoodsInfo(context: Context, goodsId: number): Promise<GoodsInfo> {
    if (this.store === undefined) {
      await this.initDataBase(context);
    }
    let predicates = new relationalStore.RdbPredicates(this.storeName);
    predicates.equalTo('id', goodsId);
    let goodsInfo: GoodsInfo;
    let resultSet: relationalStore.ResultSet;
    try {
      resultSet = await this.store.query(predicates, []);
    } catch (err) {
      logger.info(TAG, `Get result set fail: ${JSON.stringify(err)}`);
      return;

    }
    resultSet.goToFirstRow();
    goodsInfo = {
      id: resultSet.getString(resultSet.getColumnIndex('id')),
      imageUrl: resultSet.getString(resultSet.getColumnIndex('imageUrl')),
      title: resultSet.getString(resultSet.getColumnIndex('title')),
      introduction: resultSet.getString(resultSet.getColumnIndex('introduction')),
      type: resultSet.getString(resultSet.getColumnIndex('type')),
      price: resultSet.getString(resultSet.getColumnIndex('price')),
      old_price: resultSet.getString(resultSet.getColumnIndex('old_price')),
      count: resultSet.getLong(resultSet.getColumnIndex('count'))
    };
    logger.info(TAG, `Goods info: ${JSON.stringify(goodsInfo)}`);
    return goodsInfo;
  }

  // 将所有的商品列表插入到数据库
  public async insertGoodsList(context: Context, goodsList: Array<GoodsInfo>): Promise<void> {
    if (this.store === undefined) {
      await this.initDataBase(context);
    }
    for (let i = 0; i < goodsList.length - 1; i++) {
      let goodsBucket: relationalStore.ValuesBucket = {
        'id': goodsList[i].id,
        'imageUrl': goodsList[i].imageUrl,
        'title': goodsList[i].title,
        'introduction': goodsList[i].introduction,
        'type': goodsList[i].type,
        'price': goodsList[i].price,
        'old_price': goodsList[i].old_price,
        'count': goodsList[i].count
      };
      logger.info(TAG, 'goods info: ' + JSON.stringify(goodsBucket));
      let rowId;
      try {
        rowId = await this.store.insert(this.storeName, goodsBucket);
      } catch (err) {
        logger.error(TAG, `Insert is failed, err: ${JSON.stringify(err)}`);
        return;
      }
    }
    logger.info(TAG, 'Insert is successful.');
  }
}