import { PhotoGroupModel, PhotoModel } from './PhotoModel';
import { DirectoryEntry } from 'smbProtocol'
// Basic implementation of IDataSource to handle data listener
class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}
export type PhotoDataModel = PhotoModel|DirectoryEntry

export class PhotoDataSource extends BasicDataSource<PhotoDataModel> {
  private dataArray: PhotoDataModel[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): PhotoDataModel {
    return this.dataArray[index];
  }

  public getAllData(): PhotoDataModel[] {
    return this.dataArray;
  }

  public addData(index: number, data: PhotoDataModel): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
    this.reverseData()
    this.notifyDataReload()
  }

  public setData(data: PhotoDataModel[]): void {
    this.dataArray = data
    this.notifyDataReload();
    this.reverseData()
    this.notifyDataReload()
  }

  public pushData(data: PhotoDataModel): void {
    this.dataArray.unshift(data);
    this.notifyDataAdd(this.dataArray.length - 1);
    this.reverseData()
    this.notifyDataReload()
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
    this.reverseData()
    this.notifyDataReload()
  }

  public clearData(): PhotoDataModel[] {
    this.dataArray.splice(0, this.totalCount());
    this.notifyDataReload();
    return [];
  }

  public reverseData(): void {
    this.dataArray.reverse()
    this.fixData()
  }

  public fixData(): void {
    let temporaryArray: PhotoModel[] = [];
    (this.dataArray as PhotoModel[]).forEach((item: PhotoModel, index: number) => {
      if (item.displayName.startsWith('PRESET_')) {
        temporaryArray.push(item);
        this.dataArray = this.dataArray.filter((res: PhotoDataModel) => {
          return (res as PhotoModel).displayName !== item.displayName;
        });
      }
    });
    this.dataArray.push(...temporaryArray);
  }
}

export class PhotoGroupDataSource extends BasicDataSource<PhotoGroupModel> {
  private dataArray: PhotoGroupModel[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): PhotoGroupModel {
    return this.dataArray[index];
  }

  public getAllData(): PhotoGroupModel[] {
    return this.dataArray;
  }

  public addData(index: number, data: PhotoGroupModel): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
    this.reverseData()
    this.notifyDataReload();
  }

  public setData(dataList: PhotoGroupModel[]) {
    this.dataArray = dataList;
    this.reverseData()
    this.notifyDataReload();
  }

  public pushData(data: PhotoGroupModel): void {
    this.dataArray.unshift(data);
    this.notifyDataAdd(this.dataArray.length - 1);
    this.reverseData()
    this.notifyDataReload();
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }

  public clearData(): PhotoGroupModel[] {
    this.dataArray.splice(0, this.totalCount());
    this.notifyDataReload();
    return [];
  }

  public reverseData(): PhotoGroupModel[] {
    this.dataArray.forEach((item)=>{
      item.photoList.reverse()
    })
    return [];
  }
}
