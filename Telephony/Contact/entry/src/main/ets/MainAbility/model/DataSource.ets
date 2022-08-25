import contact from '@ohos.contact'

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

export class ItemContainerSource extends BasicDataSource {
  public contactData: contact.Contact[]

  constructor(contactData: contact.Contact[]) {
    super()
    this.contactData = contactData
  }

  public totalCount(): number {
    return this.contactData.length
  }

  public getData(index: number): any {
    return this.contactData[index]
  }

  public addData(index: number, data: any): void {
    this.contactData.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: any): void {
    this.contactData.push(data)
    this.notifyDataAdd(this.contactData.length - 1)
  }
}