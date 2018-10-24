package com.alex.service;

import com.alex.model.Users;
import com.alex.repo.TestRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class TestServiceImpl implements TestService {
    @Autowired
    private TestRepo testRepo;

    @Override
    public List<Users> hello() {
        List<Users> usersList = testRepo.findAllUsers();
        return usersList;
    }
}
