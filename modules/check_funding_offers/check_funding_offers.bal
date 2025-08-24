import ballerina/data.jsondata;
import ballerina/log;
import ballerina/task;
import cosmobilis/teams;

import cosmobilis/bo_db as bodb;


// === SCHEDULER INITIALISATION ===
public function createCheckFundingOffersJob() returns task:JobId|error {
    CheckFundingOffersJob myJob = new;
    return task:scheduleJobRecurByFrequency(myJob, 60*60*24);
}

//TODO: refactor logging and teams notif code in this class: 
// - externalize teams code in a dedicated package
// - externalize logging code in a dedicated pkg integrating teams pkg.
class CheckFundingOffersJob {
    *task:Job;

    // === SCHEDULED EXECUTION FUNCTIONS ===
    public function execute() {
        lock {
            do {
                log:printInfo("⏱️ Job planifié : exécution de scheduledRun()");
                var result = self.scheduledRun();
                if result is error {
                    string msg = "❌ scheduledRun() a échoué : " + result.message();
                    log:printError(msg, result);
                    // Envoi d'une notification Teams en cas d'erreur
                    var notif = teams:sendTeamsNotification("Erreur exécution job check_funding_offers", msg, [{"Type d'exécution": "Tâche planifiée"}]);
                    if notif is error {
                        log:printError("Échec d'envoi Teams", notif);
                    }
                }
            } on fail var failure {
                log:printError("Unmanaged error", failure);
            }
        }
    }

    function scheduledRun() returns error? {
        json[] offers = check bodb:getPendingFundingOffers();

        if offers.length() == 0 {
            log:printInfo("Aucune offre bloquée à signaler.");
            return;
        }

        string title = "🚨 Offres en attente de financement détectées";
        string description = string `${offers.length()} offre(s) bloquée(s) nécessitent une attention`;
        
        // Construction du message formaté avec toutes les offres
        string detailsMessage = "📋 **DÉTAILS DES OFFRES BLOQUÉES**\n\n";
        
        foreach var offer in offers {
            string idOffre = (check jsondata:read(offer, `$.id_offre`)).toString();
            string idCarshop = (check jsondata:read(offer, `$.id_carshop`)).toString();
            string nom = (check jsondata:read(offer, `$.nom`)).toString();
            string typee = (check jsondata:read(offer, `$.type`)).toString();
            string publiee = (check jsondata:read(offer, `$.publiee`)).toString();
            string dateCreation = (check jsondata:read(offer, `$.date_creation`)).toString();
            string dateMaj = (check jsondata:read(offer, `$.date_derniere_mise_a_jour`)).toString();
            string natureId = (check jsondata:read(offer, `$.id_nature`)).toString();
            string libelleNature = (check jsondata:read(offer, `$.libelle_nature`)).toString();
            string urlCarshop = (check jsondata:read(offer, `$.url_carshop`)).toString();
            string urlSite = (check jsondata:read(offer, `$.url_site`)).toString();
            string nbJoursAttente = (check jsondata:read(offer, `$.nb_jours_attente`)).toString();

            detailsMessage += string `
            **🔸 OFFRE #${idOffre}
            • ID Carshop: ${idCarshop}
            • Nom: ${nom}
            • Type: ${typee}
            • Publiée: ${publiee}
            • Date création: ${dateCreation}
            • Dernière MAJ: ${dateMaj}
            • Nature: ${natureId} (${libelleNature})
            • Jours d'attente: ${nbJoursAttente}
            • URL Carshop: ${urlCarshop}
            • URL Site: ${urlSite}

            -------------------------
            `;
        }

        check teams:sendTeamsNotification(title, description, detailsMessage);
    }

}