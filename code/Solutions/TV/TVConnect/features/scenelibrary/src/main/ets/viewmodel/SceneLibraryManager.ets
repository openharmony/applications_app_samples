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
import {
  SceneLibraryDao, ConnectDatabaseHelperImpl, Logger, Scene
} from '@ohos/common/index';
import { SceneBean } from '../common/bean/SceneBean';
import { BasicDataSource } from './BasicDataSource';
import { InternationalManager, LibraryManagerFactory, LibraryManagerType } from '@ohos/mine';
import sceneLibraryModel from './SceneLibraryModel';
import I18n from '@ohos.i18n';

const TAG = 'SceneLibraryManager';

/**
 * 场景管理类
 */
@Observed
export class SceneLibraryManager {
  private static instance: SceneLibraryManager;
  /**
   * 当前场景信息列表
   */
  public sceneList: Scene[] = [];
  public tabContentData: Map<Scene, Map<string, Scene>> = new Map();
  public currentContentData: SceneLibraryDataSource = new SceneLibraryDataSource();
  public myContentData: MySceneLibraryDataSource = new MySceneLibraryDataSource();

  private constructor() {
  }

  public static getInstance() {
    if (SceneLibraryManager.instance == undefined) { //第一次获取单例对象
      SceneLibraryManager.instance = new SceneLibraryManager(); //创建对象
      SceneLibraryManager.instance.updateData();
      SceneLibraryManager.getInstance();
      SceneLibraryManager.instance.registerListener(); // 注册监听
    }
    return SceneLibraryManager.instance;
  }

  public static dataChangeCallback() {
    SceneLibraryManager.getInstance().updateData();
  }

  /**
   * 语言变更回调
   */
  public static async onLanguageChange() {
    SceneLibraryManager.instance.updateData(); // 重新从数据库读数据，获取响应语言的数据源，渲染页面
  }

  /**
   * 数据库导入回调
   */
  public static onFileImport() {
    SceneLibraryManager.instance.updateData(); // 重新从数据库读数据，获取响应语言的数据源，渲染页面
  }

  //注册监听
  registerListener() {
    InternationalManager.registerLanguageChangeListener(SceneLibraryManager.onLanguageChange);
    LibraryManagerFactory.getInstance()
      .getManager(LibraryManagerType.DEVICE)
      .registerUpdateLibraryListener(SceneLibraryManager.onFileImport);
  }

  /**
   * 初始化场景库管理类，从数据库中查询所有场景
   */
  async updateData() {
    this.tabContentData.clear(); // 在数据源发生变化时，防止页面保留旧数据
    let databaseHelper = await ConnectDatabaseHelperImpl.getInstance();
    let dao = new SceneLibraryDao(databaseHelper);
    let sceneList: Scene[] = await dao.queryAllScene();
    this.sceneList = await sceneLibraryModel.getSceneList();
    this.sceneList = this.sceneList.concat(sceneList);
    this.currentContentData.initData(this.sceneList);
  }

  /**
   * 刷新页面数据源，重新渲染页面
   */
  refreshCurrentData() {
    this.currentContentData.reloadData();
  }

  /**
   * 根据ID查询场景
   */
  async getSceneInfo(id: string): Promise<Scene | null> {
    let databaseHelper = await ConnectDatabaseHelperImpl.getInstance();
    let dao = new SceneLibraryDao(databaseHelper);
    let sceneInfo = await dao.querySceneById(id);
    Logger.info(TAG, 'sceneInfo:' + JSON.stringify(sceneInfo));
    if (sceneInfo == null) {
      return null;
    } else {
      return sceneInfo;
    }
  }
}

/**
 * 用于懒加载的设备库数据源
 */
export class SceneLibraryDataSource extends BasicDataSource {
  private dataArray: (Scene | SceneBean)[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  /**
   * 初始化数据，并重新加载所有数据
   * @param data
   */
  public initData(data: Array<Scene | SceneBean>) {
    this.dataArray = [];
    this.dataArray = data;
    this.notifyDataReload();
  }

  public getData(index: number): Scene | SceneBean {
    return this.dataArray[index];
  }

  public getAllData(): Array<Scene | SceneBean> {
    return this.dataArray;
  }

  public addData(index: number, data: Scene | SceneBean): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Scene | SceneBean): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }

  public changeData(index: number): void {
    this.notifyDataChange(index);
  }

  public reloadData(): void {
    this.notifyDataReload();
  }
}

/**
 * 用于懒加载的设备库数据源
 */
export class MySceneLibraryDataSource extends BasicDataSource {
  private dataArray: (Scene | SceneBean)[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  /**
   * 初始化数据，并重新加载所有数据
   * @param data
   */
  public initData(data: Array<Scene | SceneBean>) {
    this.dataArray = [];
    this.dataArray = data;
    this.notifyDataReload();
  }

  public getData(index: number): Scene | SceneBean {
    return this.dataArray[index];
  }

  public getAllData(): Array<Scene | SceneBean> {
    return this.dataArray;
  }

  public addData(index: number, data: Scene | SceneBean): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Scene | SceneBean): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }

  public changeData(index: number): void {
    this.notifyDataChange(index);
  }

  public reloadData(): void {
    this.notifyDataReload();
  }
}
