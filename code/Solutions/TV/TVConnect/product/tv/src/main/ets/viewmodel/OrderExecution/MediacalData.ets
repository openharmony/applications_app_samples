export interface DrugData {
  field1: string;
  field8: string;
  field9: string;
  field10: string;
  field20: string;
}

export interface DrugDataList {
  list: DrugData[];
}

export interface DrugObject {
  status: number;
  desc: string;
  data: DrugDataList;
  traceId: string | null;
  transparent: number;
  success: boolean;
}

export class DrugClass {
  constructor(field1: string, field8: string, field9: string, field10: string, field20: string) {
    this.field1 = field1;
    this.field8 = field8;
    this.field9 = field9;
    this.field10 = field10;

    //0：未执行     1：已执行
    if (field20 == '0') {
      this.field20 = '未执行';
    } else if (field20 == '1') {
      this.field20 = '已执行';
    }
  }

  public field1: string = '';
  public field8: string = '';
  public field9: string = '';
  public field10: string = '';
  public field20: string = '';

  public static fromJSON(json: DrugData): DrugClass {
    return new DrugClass(
      json.field1,
      json.field8,
      json.field9,
      json.field10,
      json.field20,
    );
  }
}