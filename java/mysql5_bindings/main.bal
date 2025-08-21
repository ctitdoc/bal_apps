import ballerina/log;

configurable Conf conf = ?;

public function main() returns error? {
    final Client 'client = check connect(conf);
    log:printInfo("✅ Connexion établie");

    // Table de test
    _ = check update('client,
        "CREATE TABLE IF NOT EXISTS test_mysql5_bindings (" +
        "id INT AUTO_INCREMENT PRIMARY KEY, " +
        "name VARCHAR(50), " +
        "age INT, " +
        "data JSON)"
    );
    log:printInfo("✅ Table test_mysql5_bindings créée");

    // INSERT
    int rows = check update('client,
        "INSERT INTO test_mysql5_bindings (name, age, data) " +
        "VALUES ('Alice', 30, '{\"city\":\"Paris\",\"active\":true}')"
    );
    log:printInfo(string `INSERT -> ${rows} ligne(s) affectée(s)`);

    // SELECT (retourne un json typé)
    json res = check query('client,
        "SELECT id, name, age, data FROM test_mysql5_bindings"
    );
    log:printInfo("SELECT (json) -> " + res.toJsonString());

    // UPDATE
    rows = check update('client,
        "UPDATE test_mysql5_bindings SET age = 31 WHERE name = 'Alice'"
    );
    log:printInfo(string `UPDATE -> ${rows} ligne(s) affectée(s)`);

    // DELETE
    rows = check update('client,
        "DELETE FROM test_mysql5_bindings WHERE name = 'Alice'"
    );
    log:printInfo(string `DELETE -> ${rows} ligne(s) affectée(s)`);

    // DROP
    _ = check update('client, "DROP TABLE IF EXISTS test_mysql5_bindings");
    log:printInfo("✅ Table test_mysql5_bindings supprimée");

    // Close
    check close('client);
    log:printInfo("✅ Connexion fermée");
}
