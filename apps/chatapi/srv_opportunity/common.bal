import ballerina/http;
import ballerina/io;
import ballerina/lang.regexp;
import ballerina/sql;
import ballerina/url;
import ballerinax/mysql;

//see https://ballerina.io/learn/by-example/http-client-send-request-receive-response/

// public function OFPost(http:Client apiClient, string apiUrl, string route, anydata body, map<string>? headers) returns json|error {
//     io:println("call POST " + apiUrl + route);
//     io:println("with body:");
//     io:println(body);
//     json response = ();
//     if (headers != ()) {
//     response = check apiClient->post(route, body, headers);
//     } else {
//         response = check apiClient->post(route, body, headers);
//     }
//     io:println("receive response:");
//     io:println(response);
//     io:println();
//     return response;
// }

public function OFUpdate(string updateMethod, http:Client apiClient, string apiUrl, string route, anydata body, map<string>? headers, boolean urlEncodeBody = false) returns json|error {
    io:println("call " + updateMethod + " " + apiUrl + route);
    io:println("with body:");
    io:println(body);
    string urlEncodedBody = "";
    if (urlEncodeBody) {
        urlEncodedBody = encodeParams(<map<string>>body);
        io:println("body urlencoded version:");
        io:println(urlEncodedBody);
    }
    anydata processedBody = urlEncodeBody ? urlEncodedBody : body;
    json response = ();
    if (headers != ()) {
        if (updateMethod == "POST") {
            response = check apiClient->post(route, processedBody, headers);
        } else if (updateMethod == "PATCH") {
            response = check apiClient->patch(route, processedBody, headers);
        } else if (updateMethod == "PUT") {
            response = check apiClient->put(route, processedBody, headers);
        }
    } else {
        if (updateMethod == "POST") {
            response = check apiClient->post(route, processedBody);
        } else if (updateMethod == "PATCH") {
            response = check apiClient->patch(route, processedBody);
        } else if (updateMethod == "PUT") {
            response = check apiClient->put(route, processedBody);
        }
    }
    io:println("receive response:");
    io:println(response);
    io:println();
    return response;
}

function resolveExpressions(string jsonString, json response, map<json> memory = {}) returns SchemedTalk|error {

    string:RegExp regex = re `"?<\?([:\w]+)\?>"?`;

    //see https://github.com/ballerina-platform/ballerina-lang/issues/42331
    // about isolation, readonlyness and finalness...
    final map<json> & readonly work;
    if !(response is map<json>) {
        work = {};
    } else {
        work = response.cloneReadOnly();
    }
    final map<json> & readonly mem = memory.cloneReadOnly();

    regexp:Replacement replaceFunction = isolated function(regexp:Groups groups) returns string {
        regexp:Span? span = groups[1];
        if (span == ()) {
            return "";
        }
        string key = span.substring();
        string:RegExp memoryPattern = re `memory:(\w+)`;
        json? value = ();
        if memoryPattern.matchAt(key, 0) is regexp:Span {
            regexp:Groups? memoryGroup = memoryPattern.findGroups(key);
            if memoryGroup is () {
                return "<?" + key + "?>";
            }
            regexp:Span? memorySpan = memoryGroup[1];
            if memorySpan is () {
                return "<?" + key + "?>";
            }
            key = memorySpan.substring();
            value = mem[key];
            if value is string {
                value = value.toJsonString();
                if value is string && value.startsWith("\"") && value.endsWith("\"") {
                    return value.substring(1, value.length() - 1);
                } else {
                    return <string> value;
                }
            } else {
                return value.toJsonString();
            }
        } else {
            value = work[key];
            if value is string {
                value = value.toJsonString();
                if value is string && value.startsWith("\"") && value.endsWith("\"") {
                    return value.substring(1, value.length() - 1);
                } else {
                    return <string> value;
                }
            } else {
                return value.toJsonString();
            }
        }
    };

    string result = regex.replaceAll(jsonString, replaceFunction);
    SchemedTalk resolvedSchemedTalk = check (<anydata>(check result.fromJsonString())).cloneWithType();
    return resolvedSchemedTalk;
}

function encodeParams(map<string> params) returns string {
    string encodedParams = "";
    foreach var [key, value] in params.entries() {
        string encodedKey = checkpanic url:encode(key, "UTF-8");
        string encodedValue = checkpanic url:encode(value, "UTF-8");
        encodedParams += encodedKey + "=" + encodedValue + "&";
    }
    return encodedParams;
}

public function OFPatch(http:Client apiClient, string apiUrl, string route, anydata body, map<string>? headers, boolean urlEncodeBody = false) returns json|error {
    return OFUpdate("PATCH", apiClient, apiUrl, route, body, headers, urlEncodeBody);
}

public function OFPut(http:Client apiClient, string apiUrl, string route, anydata body, map<string>? headers, boolean urlEncodeBody = false) returns json|error {
    return OFUpdate("PUT", apiClient, apiUrl, route, body, headers, urlEncodeBody);
}

public function OFPost(http:Client apiClient, string apiUrl, string route, anydata body, map<string>? headers, boolean urlEncodeBody = false) returns json|error {
    return OFUpdate("POST", apiClient, apiUrl, route, body, headers, urlEncodeBody);
}

public function prGet(string url, anydata response) {
    io:println("call GET " + url);
    io:println("receive response:");
    io:println(response);
    io:println();
}

public function getDbClient() returns mysql:Client|sql:Error {
    final mysql:Client|sql:Error dbClient = new ("localhost", "root", "root", "srv_opportunity", 3310);
    return dbClient;
}

isolated function getOpportunities(mysql:Client dbClient) returns SOOpp[] {
    SOOpp[] opportunities = [];
    stream<SOOpp, error?> resultStream = dbClient->query(
        `SELECT openflex_opportunity_id, status FROM opportunity`
    );
    error? status = from SOOpp opportunity in resultStream
        do {
            opportunities.push(opportunity);
        };
    status = resultStream.close();
    return opportunities;
}

public function play(string|SchemedTalk scenarioId, typedesc<anydata> typeDesc = never) returns boolean {
    if (scenarioId is string) {
        return scenarios.indexOf(<string>scenarioId) != () || scenarios.indexOf("all") != ();
    }
    var value = scenarioId.cloneWithType(typeDesc);
    match (value) {
        var x if x is error => {
            return false;
        }
        _ => {
            return true;
        }
    }
    return false;
}

public function hasPlayed((SchemedTalk|map<json>)[] schemedTalks, typedesc<anydata> typeDesc = never) returns boolean {
    (SchemedTalk|map<json>)[] result = from (SchemedTalk|map<json>) schemedTalk in schemedTalks
        where typeof schemedTalk === typeDesc
        select schemedTalk;
    return (result.length() > 0);
}

public function buildRoute(GET|POST|PATCH|PUT request) returns string|error {
    string route = <string>request.route;
    if (request?.parameters != ()) {
        route += "?";
        map<string|int|float|boolean|(string|int|float|boolean)[]> params = check request?.parameters.cloneWithType();
        foreach string key in params.keys() {
            if (params[key] is (string|int|float|boolean)[]) {
                (string|int|float)[] values = check params[key].cloneWithType();
                foreach var value in values {
                    route += string `${key}[]=${value}&`;
                }
            } else {
                (string|int|float|boolean) value = <(string|int|float|boolean)>params[key];
                route += string `${key}=${value}&`;
            }
        }
    }
    return route;
}

function extractIP(string headerValue, string fallbackValue) returns string {
    regexp:RegExp ipPattern = re `\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b`;
    regexp:Span? span = ipPattern.find(headerValue);
    return span is () ? fallbackValue : span.substring();
}

function getRequestEmitterIP(http:Request request) returns string {
    string requestEmitterIP = "localhost";
    string|error headerValue = "";
    if (request.hasHeader("Forwarded")) {
        headerValue = request.getHeader("X-Forwarded");
    } else if (request.hasHeader("X-Forwarded-For")) {
        headerValue = request.getHeader("X-Forwarded-For");
    } else if (request.hasHeader("X-Real-IP")) {
        headerValue = request.getHeader("X-Real-IP");
    }
    match headerValue {
        var e if e is error => {
        }
        _ => {
            requestEmitterIP = extractIP(<string>headerValue, "localhost");
        }
    }
    return requestEmitterIP;
}

// Fonction récursive pour vérifier si v2 est un sous-ensemble de v1
function isSubset(json v1, json v2) returns boolean {
    if v2 is map<anydata> {
        if v1 is map<anydata> {
            foreach var key in v2.keys() {
                if !v1.hasKey(key) { // Clé absente dans v1
                    return false;
                }
                if !isSubset(v1[key], v2[key]) { // Vérification récursive ou valeur simple
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    else if v2 is int|float|boolean|string {
        return v1 is int|float|boolean|string && v1 == v2;
    }
    else if v2 is json[] { // Cas où v2 est un array
        if v1 is json[] {
            foreach json itemV2 in v2 {
                boolean found = false;
                foreach json itemV1 in v1 {
                    if isSubset(itemV1, itemV2) { // Vérification récursive pour chaque élément
                        found = true;
                        break;
                    }
                }
                if !found {
                    return false; // Si un élément de v2 n'est pas trouvé dans v1, ce n'est pas un sous-ensemble
                }
            }
            return true;
        }
        return false; // Si v1 n'est pas un array mais v2 en est un
    }
    return false; // Types incompatibles
}

function substringBefore(json result, string needle) returns string?|error {
    string value;
    if (result is json[]) {
        value = <string>result[0];
    } else {
        value = <string>result;
    }
    int? index = value.indexOf(needle);
    return index > 0 ? value.substring(0, <int>index) : value;
}

function decodeFunctionCall(string input) returns map<string|string[]>|error {
    // Extraire le nom de la fonction (la partie avant la parenthèse ouvrante)
    string fnName = input.substring(0, <int>input.indexOf("(")).trim();

    // Extraire la chaîne située entre la première '(' et la dernière ')'
    int startParams = <int>input.indexOf("(") + 1;
    int endParams = <int>input.lastIndexOf(")");
    string paramsSubstring = input.substring(startParams, endParams).trim();

    // Séparer les paramètres sur la virgule.
    // (On suppose ici que les paramètres sont des chaînes simples sans virgule interne)
    string:RegExp r = re `,`;
    string[] rawParams = r.split(paramsSubstring);

    string[] parameters = [];

    // Parcourir chaque paramètre, supprimer les espaces et les guillemets
    foreach string p in rawParams {
        string trimmed = p.trim();
        if (trimmed.startsWith("\"") && trimmed.endsWith("\"")) {
            trimmed = trimmed.substring(1, trimmed.length() - 1);
        }
        parameters.push(trimmed);
    }

    return {
        "functionName": fnName,
        "parameters": parameters
    };
}
