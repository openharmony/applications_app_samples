'use static'

// [Start staticArkGuardExample_classWithInterface]
// [Start staticArkGuardExample_classWithAnnotation_1]
export @interface testAnnoClass {
    prop1: number = 123;
    prop2: string = "testAnno" ;
}
// [End staticArkGuardExample_classWithAnnotation_1]
// [End staticArkGuardExample_classWithInterface]

export declare @interface testAnnotation {
    name : string = "test";
    age : number = 123;
}


