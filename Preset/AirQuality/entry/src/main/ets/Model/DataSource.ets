import { AirQualityModel } from '../Model/AirQualityModel'
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): any {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener')
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener')
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }
}

export class AirSource extends BasicDataSource {
  public AirHistoryData: Array<AirQualityModel>

  constructor(AirHistoryData: Array<AirQualityModel>) {
    super()
    this.AirHistoryData = AirHistoryData
  }

  public totalCount(): number {
    return this.AirHistoryData.length
  }

  public getData(index: number): any {
    return this.AirHistoryData[index]
  }

  public addData(index: number, data: any): void {
    this.AirHistoryData.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: any): void {
    this.AirHistoryData.push(data)
    this.notifyDataAdd(this.AirHistoryData.length - 1)
  }
}