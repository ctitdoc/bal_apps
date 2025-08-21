// Ballerina error type for `java.sql.SQLException`.

public const SQLEXCEPTION = "SQLException";

type SQLExceptionData record {
    string message;
};

public type SQLException distinct error<SQLExceptionData>;

