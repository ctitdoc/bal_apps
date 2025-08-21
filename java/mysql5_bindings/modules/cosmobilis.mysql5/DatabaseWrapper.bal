import mysql5_bindings.java.lang as javalang;
import mysql5_bindings.java.sql as javasql;

import ballerina/jballerina.java;

# Ballerina class mapping for the Java `cosmobilis.mysql5.DatabaseWrapper` class.
@java:Binding {'class: "cosmobilis.mysql5.DatabaseWrapper"}
public distinct class DatabaseWrapper {

    *java:JObject;
    *javalang:Object;

    # The `handle` field that stores the reference to the `cosmobilis.mysql5.DatabaseWrapper` object.
    public handle jObj;

    # The init function of the Ballerina class mapping the `cosmobilis.mysql5.DatabaseWrapper` Java class.
    #
    # + obj - The `handle` value containing the Java reference of the object.
    public isolated function init(handle obj) {
        self.jObj = obj;
    }

    # The function to retrieve the string representation of the Ballerina class mapping the `cosmobilis.mysql5.DatabaseWrapper` Java class.
    #
    # + return - The `string` form of the Java object instance.
    public function toString() returns string {
        return java:toString(self.jObj) ?: "";
    }

    # The function that maps to the `close` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + return - The `javasql:SQLException` value returning from the Java mapping.
    public function close() returns javasql:SQLException? {
        error|() externalObj = cosmobilis_mysql5_DatabaseWrapper_close(self.jObj);
        if (externalObj is error) {
            javasql:SQLException e = error javasql:SQLException(javasql:SQLEXCEPTION, externalObj, message = externalObj.message());
            return e;
        }
    }

    # The function that maps to the `equals` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + arg0 - The `javalang:Object` value required to map with the Java method parameter.
    # + return - The `boolean` value returning from the Java mapping.
    public function 'equals(javalang:Object arg0) returns boolean {
        return cosmobilis_mysql5_DatabaseWrapper_equals(self.jObj, arg0.jObj);
    }

    # The function that maps to the `executeQueryAsJson` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + arg0 - The `string` value required to map with the Java method parameter.
    # + return - The `string` or the `javasql:SQLException` value returning from the Java mapping.
    public isolated function executeQueryAsJson(string arg0) returns string|javasql:SQLException {
        handle|error externalObj = cosmobilis_mysql5_DatabaseWrapper_executeQueryAsJson(self.jObj, java:fromString(arg0));
        if (externalObj is error) {
            javasql:SQLException e = error javasql:SQLException(javasql:SQLEXCEPTION, externalObj, message = externalObj.message());
            return e;
        } else {
            return java:toString(externalObj) ?: "";
        }
    }

    # The function that maps to the `executeUpdate` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + arg0 - The `string` value required to map with the Java method parameter.
    # + return - The `int` or the `javasql:SQLException` value returning from the Java mapping.
    public isolated function executeUpdate(string arg0) returns int|javasql:SQLException {
        int|error externalObj = cosmobilis_mysql5_DatabaseWrapper_executeUpdate(self.jObj, java:fromString(arg0));
        if (externalObj is error) {
            javasql:SQLException e = error javasql:SQLException(javasql:SQLEXCEPTION, externalObj, message = externalObj.message());
            return e;
        } else {
            return externalObj;
        }
    }

    # The function that maps to the `getClass` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + return - The `javalang:Class` value returning from the Java mapping.
    public function getClass() returns javalang:Class {
        handle externalObj = cosmobilis_mysql5_DatabaseWrapper_getClass(self.jObj);
        javalang:Class newObj = new (externalObj);
        return newObj;
    }

    # The function that maps to the `hashCode` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + return - The `int` value returning from the Java mapping.
    public function hashCode() returns int {
        return cosmobilis_mysql5_DatabaseWrapper_hashCode(self.jObj);
    }

    # The function that maps to the `notify` method of `cosmobilis.mysql5.DatabaseWrapper`.
    public function notify() {
        cosmobilis_mysql5_DatabaseWrapper_notify(self.jObj);
    }

    # The function that maps to the `notifyAll` method of `cosmobilis.mysql5.DatabaseWrapper`.
    public function notifyAll() {
        cosmobilis_mysql5_DatabaseWrapper_notifyAll(self.jObj);
    }

    # The function that maps to the `wait` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + return - The `javalang:InterruptedException` value returning from the Java mapping.
    public function 'wait() returns javalang:InterruptedException? {
        error|() externalObj = cosmobilis_mysql5_DatabaseWrapper_wait(self.jObj);
        if (externalObj is error) {
            javalang:InterruptedException e = error javalang:InterruptedException(javalang:INTERRUPTEDEXCEPTION, externalObj, message = externalObj.message());
            return e;
        }
    }

    # The function that maps to the `wait` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + arg0 - The `int` value required to map with the Java method parameter.
    # + return - The `javalang:InterruptedException` value returning from the Java mapping.
    public function wait2(int arg0) returns javalang:InterruptedException? {
        error|() externalObj = cosmobilis_mysql5_DatabaseWrapper_wait2(self.jObj, arg0);
        if (externalObj is error) {
            javalang:InterruptedException e = error javalang:InterruptedException(javalang:INTERRUPTEDEXCEPTION, externalObj, message = externalObj.message());
            return e;
        }
    }

    # The function that maps to the `wait` method of `cosmobilis.mysql5.DatabaseWrapper`.
    #
    # + arg0 - The `int` value required to map with the Java method parameter.
    # + arg1 - The `int` value required to map with the Java method parameter.
    # + return - The `javalang:InterruptedException` value returning from the Java mapping.
    public function wait3(int arg0, int arg1) returns javalang:InterruptedException? {
        error|() externalObj = cosmobilis_mysql5_DatabaseWrapper_wait3(self.jObj, arg0, arg1);
        if (externalObj is error) {
            javalang:InterruptedException e = error javalang:InterruptedException(javalang:INTERRUPTEDEXCEPTION, externalObj, message = externalObj.message());
            return e;
        }
    }

}

# The constructor function to generate an object of `cosmobilis.mysql5.DatabaseWrapper`.
#
# + arg0 - The `string` value required to map with the Java constructor parameter.
# + arg1 - The `string` value required to map with the Java constructor parameter.
# + arg2 - The `string` value required to map with the Java constructor parameter.
# + return - The new `DatabaseWrapper` class or `javasql:SQLException` error generated.
public isolated function newDatabaseWrapper1(string arg0, string arg1, string arg2) returns DatabaseWrapper|javasql:SQLException {
    handle|error externalObj = cosmobilis_mysql5_DatabaseWrapper_newDatabaseWrapper1(java:fromString(arg0), java:fromString(arg1), java:fromString(arg2));
    if (externalObj is error) {
        javasql:SQLException e = error javasql:SQLException(javasql:SQLEXCEPTION, externalObj, message = externalObj.message());
        return e;
    } else {
        DatabaseWrapper newObj = new (externalObj);
        return newObj;
    }
}

# The function that maps to the `closePool` method of `cosmobilis.mysql5.DatabaseWrapper`.
#
# + return - The `javasql:SQLException` value returning from the Java mapping.
public function DatabaseWrapper_closePool() returns javasql:SQLException? {
    error|() externalObj = cosmobilis_mysql5_DatabaseWrapper_closePool();
    if (externalObj is error) {
        javasql:SQLException e = error javasql:SQLException(javasql:SQLEXCEPTION, externalObj, message = externalObj.message());
        return e;
    }
}

function cosmobilis_mysql5_DatabaseWrapper_close(handle receiver) returns error? = @java:Method {
    name: "close",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: []
} external;

function cosmobilis_mysql5_DatabaseWrapper_closePool() returns error? = @java:Method {
    name: "closePool",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: []
} external;

function cosmobilis_mysql5_DatabaseWrapper_equals(handle receiver, handle arg0) returns boolean = @java:Method {
    name: "equals",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: ["java.lang.Object"]
} external;

isolated function cosmobilis_mysql5_DatabaseWrapper_executeQueryAsJson(handle receiver, handle arg0) returns handle|error = @java:Method {
    name: "executeQueryAsJson",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: ["java.lang.String"]
} external;

isolated function cosmobilis_mysql5_DatabaseWrapper_executeUpdate(handle receiver, handle arg0) returns int|error = @java:Method {
    name: "executeUpdate",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: ["java.lang.String"]
} external;

function cosmobilis_mysql5_DatabaseWrapper_getClass(handle receiver) returns handle = @java:Method {
    name: "getClass",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: []
} external;

function cosmobilis_mysql5_DatabaseWrapper_hashCode(handle receiver) returns int = @java:Method {
    name: "hashCode",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: []
} external;

function cosmobilis_mysql5_DatabaseWrapper_notify(handle receiver) = @java:Method {
    name: "notify",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: []
} external;

function cosmobilis_mysql5_DatabaseWrapper_notifyAll(handle receiver) = @java:Method {
    name: "notifyAll",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: []
} external;

function cosmobilis_mysql5_DatabaseWrapper_wait(handle receiver) returns error? = @java:Method {
    name: "wait",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: []
} external;

function cosmobilis_mysql5_DatabaseWrapper_wait2(handle receiver, int arg0) returns error? = @java:Method {
    name: "wait",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: ["long"]
} external;

function cosmobilis_mysql5_DatabaseWrapper_wait3(handle receiver, int arg0, int arg1) returns error? = @java:Method {
    name: "wait",
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: ["long", "int"]
} external;

isolated function cosmobilis_mysql5_DatabaseWrapper_newDatabaseWrapper1(handle arg0, handle arg1, handle arg2) returns handle|error = @java:Constructor {
    'class: "cosmobilis.mysql5.DatabaseWrapper",
    paramTypes: ["java.lang.String", "java.lang.String", "java.lang.String"]
} external;

