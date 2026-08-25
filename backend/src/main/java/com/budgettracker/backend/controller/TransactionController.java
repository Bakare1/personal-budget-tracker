package com.budgettracker.backend.controller;

import com.budgettracker.backend.dto.TransactionRequest;
import com.budgettracker.backend.dto.TransactionResponse;
import com.budgettracker.backend.security.CustomUserDetails;
import com.budgettracker.backend.service.TransactionService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {

    private final TransactionService transactionService;

    public TransactionController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }

    @PostMapping
    public ResponseEntity<TransactionResponse> createTransaction(@AuthenticationPrincipal CustomUserDetails userDetails,
                                                                 @Valid @RequestBody TransactionRequest request) {
        return ResponseEntity.ok(transactionService.createTransaction(userDetails.getId(), request));
    }

    @GetMapping
    public ResponseEntity<List<TransactionResponse>> getTransactions(@AuthenticationPrincipal CustomUserDetails userDetails) {
        return ResponseEntity.ok(transactionService.getUserTransactions(userDetails.getId()));
    }
}
