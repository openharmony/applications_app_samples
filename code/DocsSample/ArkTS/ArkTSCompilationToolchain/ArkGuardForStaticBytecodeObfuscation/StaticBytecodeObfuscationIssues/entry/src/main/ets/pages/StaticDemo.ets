'use static'

 import {BaseClass} from './BaseClass'
 import {testAnnoClass, testAnnotation} from './Annotations'

// [Start staticArkGuardExample_className]
interface interfaceTest {
    // name05: string;
    // age05: string;
}

@testAnnoClass({prop1 : 123 , prop2 : "testAnno"})
class ClassName implements interfaceTest {
    public static ClassMember : number = 3;
}
// [End staticArkGuardExample_className]

// namespace ClassTestConfig{
//
// }
//
// interface ClassTestConfig {
//
// }

class ClassTestConfig{
    private static alias: string = 'test';
    foo(param: string): void {
        console.log('hello')
    }
}

export function testStatic() {
    // let test = ClassTest();
    // test.getPersonName();
}

// [Start staticArkGuardExample_keep]
type type01 = number;
let message01: type01 = 1;
// [End staticArkGuardExample_keep]

// [Start staticArkGuardExample_keepType]
//常规类型
let number1: number = 2;
let str: string = 'This is test';
//联合类型
let value: int|number|float = 3

//元组
// [Start staticArkGuardExample_tuple]
type UserTuple1 = [string, number, boolean];
let uType1: UserTuple1 = ["Tom", 18, true];
// [End staticArkGuardExample_tuple]
// [End staticArkGuardExample_keepType]

// [Start staticArkGuardExample_function]
function getDemoName() {
}
// [End staticArkGuardExample_function]

console.log('log1');

// [Start staticArkGuardExample_classMethod]
class ClassMethod {
    public final method1(name:string,age:int): int{
        return 1 ;
    }
    public static method2(){
    }
}
// [End staticArkGuardExample_classMethod]

class ClassNumber1 {
    @testAnnoClass({prop1 : 123 , prop2 : "testAnno"})
    public static id1 : number = 111;
}

class A {
    static f1:number;
    f1:number;
}

// [Start staticArkGuardExample_classTest]
class ClassTest{
    // public static age: number = 10;
    age: int = 5;
    name: string = "test";
    sex: number = 0;

    // set name(stringVar:string){
    //     this._name = stringVar;
    // }
    // get name(){
    //     return this._name;
    // }
}
// [End staticArkGuardExample_classTest]

// [Start staticArkGuardExample_classExtendsBaseClass_2]
class ClassName02 extends BaseClass {
    public static ClassMember02 : number = 2;
}
// [End staticArkGuardExample_classExtendsBaseClass_2]

// [Start staticArkGuardExample_color]
export enum Color {
    RED,
    BLUE
}
// [End staticArkGuardExample_color]

// [Start staticArkGuardExample_classWithAnnotation_2]
@testAnnoClass({prop1 : 123 , prop2 : "testAnno"})
class ClassName03 {
    public static ClassMember03 : number = 3;
}
// [End staticArkGuardExample_classWithAnnotation_2]

type UserTuple = [string, number, boolean];
let uType: UserTuple = ["Tom", 18, true];

// [Start staticArkGuardExample_lambda]
function fooTest1(func1:(a:number, ...args:number[])=>number):(a:number)=>number  {
    return (a:number)=>func1(a, 3);
}

function fooTest2(func1:(a:number, b:number, ...args:number[])=>number):(a:number)=>number  {
    return (a:number)=>func1(a, 3);
}

function fooTest3(func1:(a:number, ...args:number[])=>number):(a:number, ...args:number[])=>number  {
    return (a:number, ...args:number[])=>func1(a, 3);
}
// [End staticArkGuardExample_lambda]

// [Start staticArkGuardExample_anno]
@interface Anno1 {
    f1: number = 123;
}

@Anno1({f1: 123})
class ClassTest1 {
    public Class1_Field: number = 123;
}

@interface Anno2 {
    f2: number = 123;
}

@Anno2({f2: 123})
class ClassTest2 extends ClassTest1 {
    public Class2_Field: number = 123;
}
// [End staticArkGuardExample_anno]

// [Start staticArkGuardExample_Abstract]
abstract class AbstractClass {
    public abstract PUBLIC_ABSTRACT_METHOD():void;
    protected abstract PROTECTED_ABSTRACT_METHOD():void;
}

class ExampleClass extends AbstractClass {
    public override PUBLIC_ABSTRACT_METHOD():void{};
    protected override PROTECTED_ABSTRACT_METHOD():void{};
}
// [End staticArkGuardExample_Abstract]

class A1{

}

class A2{

}

// class A11 {
//
//     foo(a: String, b: A1, c: A2): void {
//
//     }
// }