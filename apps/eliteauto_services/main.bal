import ballerina/task;
import cosmobilis/job_patch;
import cosmobilis/update_customer_dispo as ucd;
// zero km job is not requested in prod yet: uncomment it to test it
//import cosmobilis/zero_km as zk;
import cosmobilis/sync_fo_quotations as sfq;
import cosmobilis/check_disk_space as cds;
import cosmobilis/check_funding_offers as cfo;

public function main() returns error? {
    job_patch:runJobPatch();
    map<task:JobId> _ = {
        // zero km job is not requested in prod yet: uncomment it to test it
        //"ZeroKmJob": check zk:createZeroKmJob(),
        "CustomerDispoJob": check ucd:createCustomerDispoJob(),
        "SyncFoQuotationJob": check sfq:createSyncFoQuotationJob(),
        "CheckDiskSpaceJob": check cds:createCheckDiskSpaceJob(),
        "CheckFundingOffersJob": check cfo:createCheckFundingOffersJob()
    };
}
