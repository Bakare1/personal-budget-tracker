package com.budgettracker.backend.repository;

import com.budgettracker.backend.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    // Retrieves system-default categories (user == null) + user-created categories
    List<Category> findByUserIdOrUserIsNull(Long userId);

    List<Category> findByUserId(Long userId);
}
