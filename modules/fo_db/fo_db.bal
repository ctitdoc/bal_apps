import ballerina/log;

import cosmobilis/mysql5_bindings as j_mysql5;

configurable j_mysql5:Conf conf = ?;

public type Quotation record {
    int id;
    string content;
};

public record {
    0 TODO;
    1 DONE;
    2 ERROR;
} SYNC_STATE = {TODO: 0, DONE: 1, ERROR: 2};

isolated function getQuotationSelect(string etat) returns string {
    return string `SELECT CONCAT('<itn_bo_message><id>',id,'</id><message><![CDATA[', message,']]></message></itn_bo_message>') as quotationMessage FROM itn_bo_message WHERE etat = ${etat} AND created_at >= '2025-07-10' limit 1`;
}

public isolated function getQuotationMsgsInError() returns xml|error {
    return execQuotationSelect(getQuotationSelect("2"));
}

public isolated function getQuotationMsgs() returns xml|error {
    return execQuotationSelect(getQuotationSelect("0"));
}

isolated function execQuotationSelect(string query) returns xml|error {
    json result = check j_mysql5:query(check j_mysql5:connect(conf), query);
    map<string>[] typedResult = check result.cloneWithType();
    string content = (typedResult.length() == 0) ? "" : check (typedResult[0]["quotationMessage"]).cloneWithType();
    string xmlDocStr = "<itn_bo_messages>" + content + "</itn_bo_messages>";
    string:RegExp r = re `\\\\u`;
    xmlDocStr = r.replaceAll(xmlDocStr, "\\u");
    string:RegExp r1 = re `\\\\"`;
    xmlDocStr = r1.replaceAll(xmlDocStr, "\\\"");
    log:printDebug(xmlDocStr);
    xml quotationMsgs = check xml:fromString(xmlDocStr);
    return quotationMsgs;
}

public isolated function setQuotationMsgState(string quotationMsgId, int state, string response) returns error? {
    string query = string `UPDATE itn_bo_message SET etat = ${state}, response = '${escapeForSql(response)}' WHERE id = ${quotationMsgId}`;
    log:printDebug(query);
    int rows = check j_mysql5:update(check j_mysql5:connect(conf), query);
}

isolated function escapeForSql(string input) returns string {
    string escaped = input;

    // Remplacer les backslashes par \\ 
    string:RegExp rBackslash = re `\\`;
    escaped = rBackslash.replaceAll(escaped, "\\\\");

    // Remplacer les quotes simples par deux quotes simples
    string:RegExp rSingleQuote = re `'`;
    escaped = rSingleQuote.replaceAll(escaped, "''");

    // Remplacer les quotes doubles par \"
    string:RegExp rDoubleQuote = re `"`;
    escaped = rDoubleQuote.replaceAll(escaped, "\\\"");

    // Remplacer retour chariot par \r
    string:RegExp rCR = re `\r`;
    escaped = rCR.replaceAll(escaped, "\\r");

    // Remplacer saut de ligne par \n
    string:RegExp rLF = re `\n`;
    escaped = rLF.replaceAll(escaped, "\\n");

    // Remplacer tabulation par \t
    string:RegExp rTab = re `\t`;
    escaped = rTab.replaceAll(escaped, "\\t");

    return escaped;
}
