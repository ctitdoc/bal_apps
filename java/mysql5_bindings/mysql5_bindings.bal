import mysql5_bindings.cosmobilis.mysql5 as jmysql;

import ballerina/lang.'value as v;

// ---- Config commune réutilisable ----
public type Conf record {
    string host;
    int port = 3306;
    string user;
    string password;
    string database;
};

// ---- Client léger qui enveloppe la classe Java bindgen ----

public type Client record {|
    jmysql:DatabaseWrapper impl;
|};

// Construit l'URL JDBC
isolated function urlOf(Conf c) returns string =>
    string `jdbc:mysql://${c.host}:${c.port}/${c.database}`;

// Ouvre la connexion et retourne notre Client
public isolated function connect(Conf conf) returns Client|error {
        jmysql:DatabaseWrapper impl = check jmysql:newDatabaseWrapper1(urlOf(conf), conf.user, conf.password);
        return {impl};
}

// Ferme la connexion
public function close(Client c) returns error? {
    check c.impl.close();
}

// Exécute INSERT/UPDATE/DELETE et retourne le nombre de lignes affectées
public isolated function update(Client c, string sql) returns int|error {
    return check c.impl.executeUpdate(sql);
}

// Exécute SELECT et retourne directement un `json`
public isolated function query(Client c, string sql) returns json|error {
    string jsonText = check c.impl.executeQueryAsJson(sql);
    return check v:fromJsonString(jsonText);
}
