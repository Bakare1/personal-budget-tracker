package com.budgettracker.backend.service;

import com.budgettracker.backend.dto.TransactionRequest;
import com.budgettracker.backend.dto.TransactionResponse;
import com.budgettracker.backend.model.Account;
import com.budgettracker.backend.model.Category;
import com.budgettracker.backend.model.Transaction;
import com.budgettracker.backend.model.TransactionType;
import com.budgettracker.backend.repository.AccountRepository;
import com.budgettracker.backend.repository.CategoryRepository;
import com.budgettracker.backend.repository.TransactionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final AccountRepository accountRepository;
    private final CategoryRepository categoryRepository;

    public TransactionService(TransactionRepository transactionRepository,
                              AccountRepository accountRepository,
                              CategoryRepository categoryRepository) {
        this.transactionRepository = transactionRepository;
        this.accountRepository = accountRepository;
        this.categoryRepository = categoryRepository;
    }

    @Transactional
    public TransactionResponse createTransaction(Long userId, TransactionRequest request) {
        Account account = accountRepository.findByIdAndUserId(request.getAccountId(), userId)
                .orElseThrow(() -> new RuntimeException("Account not found or access denied"));

        Category category = null;
        if (request.getCategoryId() != null) {
            category = categoryRepository.findById(request.getCategoryId())
                    .orElseThrow(() -> new RuntimeException("Category not found"));
        }

        // Atomic Account Balance Update
        if (request.getType() == TransactionType.EXPENSE) {
            account.setBalance(account.getBalance().subtract(request.getAmount()));
        } else if (request.getType() == TransactionType.INCOME) {
            account.setBalance(account.getBalance().add(request.getAmount()));
        }

        accountRepository.save(account);

        Transaction transaction = new Transaction(
                account,
                category,
                request.getAmount(),
                request.getType(),
                request.getNote(),
                request.getTransactionDate()
        );

        Transaction saved = transactionRepository.save(transaction);
        return mapToResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<TransactionResponse> getUserTransactions(Long userId) {
        return transactionRepository.findAllByUserId(userId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    private TransactionResponse mapToResponse(Transaction t) {
        TransactionResponse res = new TransactionResponse();
        res.setId(t.getId());
        res.setAccountId(t.getAccount().getId());
        res.setAccountName(t.getAccount().getName());
        if (t.getCategory() != null) {
            res.setCategoryId(t.getCategory().getId());
            res.setCategoryName(t.getCategory().getName());
        }
        res.setAmount(t.getAmount());
        res.setType(t.getType());
        res.setNote(t.getNote());
        res.setTransactionDate(t.getTransactionDate());
        return res;
    }
}
