import ballerina/log;
import ballerina/sql;
import ballerinax/mysql;

public type Conf record {
    string host;
    int port = 3306;
    string user;
    string password;
    string database;
};

public type QuotationCriterias record {
    string numero?;
};

type VehJsonPartenaireRow record {
        int id?;
        int offre?;
        int etat?;
};

public configurable Conf conf = ?;

final mysql:Client dbClient = check new (conf.host, conf.user, conf.password, conf.database, conf.port);

public isolated function getCountQuotations(QuotationCriterias criterias) returns int|error {
    sql:ParameterizedQuery queryTemplate = `SELECT count(1) FROM devis `;
    if criterias.numero != "" {
            queryTemplate = sql:queryConcat(queryTemplate, `WHERE numero = ${criterias.numero} `);
    }

    log:printDebug(queryTemplate.strings.toString());
    log:printDebug(queryTemplate.insertions.toString());

    return check dbClient->queryRow(queryTemplate);
}

public isolated function existQuotations(QuotationCriterias criterias) returns boolean|error {
    return check getCountQuotations(criterias) > 0 ? true : false;
}

public isolated function getPendingFundingOffers() returns json[]|error {

    sql:ParameterizedQuery query = `
    SELECT
        sq.id_offre,
        sq.id_carshop,
        sq.url_carshop,
        sq.url_site,
        sq.nom,
        sq.type,
        IF (
                sq.etat = 'active' AND (NOT sq.c_est_du_stock OR sq.etape_vente = 'dispo'),
                'oui',
                'non'
        ) AS publiee,
        sq.date_creation,
        sq.date_derniere_mise_a_jour,
        sq.id_nature,
        sq.libelle_nature,
        sq.nb_jours_attente
    FROM (
            SELECT
                v.offre AS id_offre,
                o.nom,
                o.is_stock AS c_est_du_stock,
                o.nature AS id_nature,
                IF (
                        o.etat = 1, 'active', 'inactive'
                )  AS etat,

                CASE o.etat_vente
                    WHEN 0 THEN 'dispo'
                    WHEN 1 THEN 'reservée'
                    WHEN 2 THEN 'validation financement'
                    WHEN 3 THEN 'vendue'
                    WHEN 4 THEN 'reservée client'
                    WHEN 5 THEN 'dossier vente incomplet'
                    ELSE o.etat_vente
                    END AS etape_vente,

                CASE o.nature
                    WHEN 0 THEN 'EUROTAX'
                    WHEN 1 THEN 'ELITE'
                    WHEN 2 THEN 'ELITE_VO'
                    WHEN 3 THEN 'BMC'
                    WHEN 4 THEN 'BMC_VO'
                    WHEN 5 THEN 'PROXAUTO_VO'
                    WHEN 6 THEN 'STARTERRE_VN'
                    WHEN 7 THEN 'STARTERRE_VO'
                    WHEN 8 THEN 'OKAZIUM_VO'
                    WHEN 9 THEN 'IMEXSO_VN'
                    WHEN 10 THEN 'IMEXSO_VO'
                    WHEN 11 THEN 'EDPAUTO_VN'
                    WHEN 12 THEN 'EDPAUTO_VO'
                    WHEN 99 THEN 'QUARANTAINE'
                    ELSE CAST(o.nature AS CHAR)
                    END AS libelle_nature,

                CASE o.nature
                    WHEN 0 THEN 'VN'
                    WHEN 1 THEN 'VN'
                    WHEN 3 THEN 'VN'
                    WHEN 6 THEN 'VN'
                    WHEN 9 THEN 'VN'
                    WHEN 11 THEN 'VN'
                    WHEN 2 THEN 'VO'
                    WHEN 4 THEN 'VO'
                    WHEN 5 THEN 'VO'
                    WHEN 7 THEN 'VO'
                    WHEN 8 THEN 'VO'
                    WHEN 10 THEN 'VO'
                    WHEN 12 THEN 'VO'
                    ELSE 'AUTRE'
                    END AS type,

                v.created_at AS date_creation,
                v.update_at AS date_derniere_mise_a_jour,
                JSON_UNQUOTE(JSON_EXTRACT(v.json, '$.sIDCrypte')) AS id_carshop,
                CONCAT('https://car-shop.webapp4you.eu/service/vo/visualisation?i_veh_id=',
                        JSON_UNQUOTE(JSON_EXTRACT(v.json, '$.sIDCrypte'))) AS url_carshop,
                CONCAT('https://www.elite-auto.fr/devis/',offre) as url_site,
                DATEDIFF(NOW(), v.update_at) AS nb_jours_attente

            FROM veh_json_partenaire v
                    JOIN offre o ON o.id = v.offre
            WHERE v.etat = 12
        ) AS sq;
    `;

    stream<VehJsonPartenaireRow, error?> resultStream = dbClient->query(query);
    json[] results = [];
    int count = 0;
    check from VehJsonPartenaireRow row in resultStream
        do {
            count += 1;
            results.push(row.toJson());
        };
    log:printInfo("Nombre total de lignes : " + count.toString());
    return results;
}