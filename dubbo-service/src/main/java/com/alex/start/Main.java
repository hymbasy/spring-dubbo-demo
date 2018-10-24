package com.alex.start;

import com.alibaba.dubbo.common.logger.Logger;
import com.alibaba.dubbo.common.logger.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Main {

    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    private static final String CONFIG_FILE_SPRING = "spring.xml";
    private static volatile boolean running = true;
    private static ClassPathXmlApplicationContext context = null;

    public static void main(String[] args) {
        try {
            start();
            String logLine = new SimpleDateFormat("[yyyy-MM-dd HH:mm:ss]").format(new Date()) + " dubbox server started!";
            System.out.println(logLine);
            logger.info(logLine);
        } catch (RuntimeException e) {
            e.printStackTrace();
            logger.error(e.getMessage(), e);
            System.exit(1);
        }

        if (!"false".equals(System.getProperty("dubbo.shutdown.hook"))) {
            Runtime.getRuntime().addShutdownHook(new Thread() {
                public void run() {
                    context.stop();
                    Class t = Main.class;
                    synchronized (Main.class) {
                        running = false;
                        Main.class.notify();
                    }
                }
            });
        }

        synchronized (Main.class) {
            while (true) {
                try {
                    Main.class.wait();
                } catch (Throwable e) {
                }
            }
        }
    }

    private static void start() {
        context = new ClassPathXmlApplicationContext(new String[]{CONFIG_FILE_SPRING});
        context.start();
    }
}
