package com.budgettracker.backend.service;

import com.budgettracker.backend.dto.AccountDto;
import com.budgettracker.backend.model.Account;
import com.budgettracker.backend.model.User;
import com.budgettracker.backend.repository.AccountRepository;
import com.budgettracker.backend.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AccountService {

    private final AccountRepository accountRepository;
    private final UserRepository userRepository;

    public AccountService(AccountRepository accountRepository, UserRepository userRepository) {
        this.accountRepository = accountRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public AccountDto createAccount(Long userId, AccountDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        BigDecimal initialBalance = dto.getBalance() != null ? dto.getBalance() : BigDecimal.ZERO;

        Account account = new Account(
                user,
                dto.getName(),
                dto.getType(),
                initialBalance,
                user.getDefaultCurrency()
        );

        Account saved = accountRepository.save(account);
        return mapToDto(saved);
    }

    @Transactional(readOnly = true)
    public List<AccountDto> getUserAccounts(Long userId) {
        return accountRepository.findByUserId(userId)
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    private AccountDto mapToDto(Account account) {
        AccountDto dto = new AccountDto();
        dto.setId(account.getId());
        dto.setName(account.getName());
        dto.setType(account.getType());
        dto.setBalance(account.getBalance());
        dto.setCurrency(account.getCurrency());
        return dto;
    }
}
