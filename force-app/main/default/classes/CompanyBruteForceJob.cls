public class CompanyBruteForceJob implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext context) {
        StockCompanyService.bruteForceImportAllCompanies();
    }
}