import dataPreferences from '@ohos.data.preferences'; // 假设 HarmonyOS 提供的存储模块

export default class Net {
  public context: Context = getContext();
  private static instance: Net;
  public ip: string = '';
  public typeId: string = '5';
  public orgId: string = '';
  public deptId: string = '';

  private constructor() {
    this.loadProperties();
  }

  public static getInstance(): Net {
    if (!Net.instance) {
      Net.instance = new Net();
    }
    return Net.instance;
  }

  private saveProperties() {
    dataPreferences.getPreferences(this.context, 'netConfig', (err, preferences) => {
      if (err) {
        console.error('Failed to get preferences:', err);
        return;
      }
      console.info(`Saving properties: Ip=${this.ip}, typeId=${this.typeId}, orgId=${this.orgId}, deptId=${this.deptId}`);
      preferences.putSync('Ip', this.ip);
      preferences.putSync('typeId', this.typeId);
      preferences.putSync('orgId', this.orgId);
      preferences.putSync('deptId', this.deptId);
      preferences.flush();
    });
  }

  private loadProperties() {
    dataPreferences.getPreferences(this.context, 'netConfig', (err, preferences) => {
      if (err) {
        console.error('Failed to get preferences:', err);
        return;
      }
      this.ip = preferences.getSync('Ip', '222.173.253.70:18080') as string;
      this.typeId = preferences.getSync('typeId', '5') as string;
      this.orgId = preferences.getSync('orgId', '') as string;
      this.deptId = preferences.getSync('deptId', '') as string;
    });
  }

  // Example setters that save properties after setting them
  public setIp(ip: string) {
    this.ip = ip;
    this.saveProperties();
  }

  public setTypeId(typeId: string) {
    this.typeId = typeId;
    this.saveProperties();
  }

  public setOrgId(orgId: string) {
    this.orgId = orgId;
    this.saveProperties();
  }

  public setDeptId(deptId: string) {
    this.deptId = deptId;
    this.saveProperties();
  }
};
