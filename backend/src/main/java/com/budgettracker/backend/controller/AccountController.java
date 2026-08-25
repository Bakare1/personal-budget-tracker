package com.budgettracker.backend.controller;

import com.budgettracker.backend.dto.AccountDto;
import com.budgettracker.backend.security.CustomUserDetails;
import com.budgettracker.backend.service.AccountService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/accounts")
public class AccountController {

    private final AccountService accountService;

    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }

    @PostMapping
    public ResponseEntity<AccountDto> createAccount(@AuthenticationPrincipal CustomUserDetails userDetails,
                                                    @Valid @RequestBody AccountDto dto) {
        return ResponseEntity.ok(accountService.createAccount(userDetails.getId(), dto));
    }

    @GetMapping
    public ResponseEntity<List<AccountDto>> getAccounts(@AuthenticationPrincipal CustomUserDetails userDetails) {
        return ResponseEntity.ok(accountService.getUserAccounts(userDetails.getId()));
    }
}
