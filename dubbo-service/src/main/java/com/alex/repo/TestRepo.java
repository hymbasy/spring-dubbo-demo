package com.alex.repo;

import com.alex.model.Users;

import java.util.List;

public interface TestRepo {
    List<Users> findAllUsers();
}
