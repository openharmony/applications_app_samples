export interface loginData {
  orgId: string;
  deptId: string;
}

export interface loginDataList {
  dataDeptInfoList: loginData[];
}

export interface loginObject {
  status: number;
  desc: string;
  data: loginDataList;
  traceId: string | null;
  transparent: number;
  success: boolean;
}

export class LoginData {
  constructor(orgId: string, deptId: string) {
    this.orgId = orgId;
    this.deptId = deptId;
  }

  public orgId: string;
  public deptId: string;

  static fromJSON(json: loginData): LoginData {
    return new LoginData(
      json.orgId,
      json.deptId,
    );
  }
}