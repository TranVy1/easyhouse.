package com.example.quanlyphongtro.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;

import java.util.concurrent.Executor;

@Configuration
@EnableAsync
public class AsyncConfig {

    @Bean(name = "taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("EasyHouseAsync-");
        executor.setWaitForTasksToCompleteOnShutdown(true);
        executor.setAwaitTerminationSeconds(30);
        executor.initialize();
        return executor;
    }

    /**
     * Scheduler danh rieng cho cac tac vu @Scheduled (SchedulerService).
     *
     * BAT BUOC phai co ke tu khi bat WebSocket. Ly do: @EnableWebSocketMessageBroker
     * dang ky mot bean TaskScheduler ten "messageBrokerTaskScheduler" dung de gui
     * heartbeat STOMP. Neu khong co bean nao ten "taskScheduler", @EnableScheduling
     * se lay bean TaskScheduler duy nhat tim duoc — tuc la scheduler cua broker.
     * Khi do mot job hang ngay chay lau se lam nghen heartbeat, Cloudflare thay
     * ket noi im lang qua 100 giay va dong WebSocket => chat chet ma khong bao loi.
     *
     * Dat ten "taskScheduler" de @EnableScheduling uu tien bean nay va hai ben tach
     * hoan toan khoi nhau.
     */
    @Bean(name = "taskScheduler")
    public TaskScheduler taskScheduler() {
        ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
        scheduler.setPoolSize(2);
        scheduler.setThreadNamePrefix("EasyHouseSched-");
        scheduler.setWaitForTasksToCompleteOnShutdown(true);
        scheduler.setAwaitTerminationSeconds(30);
        scheduler.initialize();
        return scheduler;
    }
}
