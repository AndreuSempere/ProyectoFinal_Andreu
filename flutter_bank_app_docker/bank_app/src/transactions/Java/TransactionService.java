@Service
public class TransactionService {

    private final AccountRepository accountRepository;

    public TransactionService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    public synchronized void processTransaction(TransactionRequest request) {
        Account account = accountRepository.findById(request.getAccountId())
                .orElseThrow(() -> new RuntimeException("Account not found"));

        double newBalance = account.getBalance();
        if (request.getType().equals("ingreso")) {
            newBalance += request.getAmount();
        } else if (request.getType().equals("gasto")) {
            if (account.getBalance() < request.getAmount()) {
                throw new RuntimeException("Insufficient funds");
            }
            newBalance -= request.getAmount();
        }

        account.setBalance(newBalance);
        accountRepository.save(account);

        // Optionally log the transaction
    }
}
