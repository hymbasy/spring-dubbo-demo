package com.alex;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

@RunWith(value = SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring.xml"})
public class RedisTest {

    @Autowired
    private JedisPool jedisPool;

    @Test
    public void test(){
        Jedis jedis = jedisPool.getResource();
        jedis.set("name","测试的名字");
        jedis.close();
    }
}
