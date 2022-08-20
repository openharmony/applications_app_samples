class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount() {
    return 0
  }

  public getData(index: number) {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload() {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  notifyDataMove(from: number, to: number) {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }
}

export class MyDataSource extends BasicDataSource {
  private dataArray: any[] = []

  constructor(data: any[]) {
    super()
    this.dataArray = data
  }

  public totalCount() {
    return this.dataArray.length
  }

  public getData(index: number) {
    return this.dataArray[index]
  }

  public deleteData(index: number) {
    this.dataArray.splice(index, 1)
    this.notifyDataAdd(index)
  }

  public pushData(index: any) {
    this.dataArray.push(index)
    this.notifyDataAdd(this.dataArray.length - 1)
  }

  public replaceData(result: any[]) {
    this.dataArray = result
    this.notifyDataReload()
  }
}