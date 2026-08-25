package com.budgettracker.backend.dto;

import com.budgettracker.backend.model.AccountType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class AccountDto {
    private Long id;

    @NotBlank(message = "Account name is required")
    private String name;

    @NotNull(message = "Account type is required")
    private AccountType type;

    private BigDecimal balance;
    private String currency;

    public AccountDto() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public AccountType getType() { return type; }
    public void setType(AccountType type) { this.type = type; }

    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }
}
