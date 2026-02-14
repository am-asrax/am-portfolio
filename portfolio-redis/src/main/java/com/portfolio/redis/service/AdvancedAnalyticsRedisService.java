package com.portfolio.redis.service;

import java.time.Duration;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.portfolio.model.analytics.request.AdvancedAnalyticsRequest;
import com.portfolio.model.analytics.response.AdvancedAnalyticsResponse;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class AdvancedAnalyticsRedisService {

    private final RedisTemplate<String, Object> redisTemplate;

    @Value("${spring.data.redis.portfolio-advanced-analytics.ttl:900}")
    private Integer ttlSeconds;

    @Value("${spring.data.redis.portfolio-advanced-analytics.key-prefix:portfolio:advanced-analytics:}")
    private String keyPrefix;

    public AdvancedAnalyticsRedisService(@Qualifier("redisTemplate") RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    @Async
    public CompletableFuture<Void> cacheAdvancedAnalytics(AdvancedAnalyticsResponse response,
            AdvancedAnalyticsRequest request) {
        return CompletableFuture.runAsync(() -> {
            try {
                String key = buildKey(request);
                log.debug("Caching advanced analytics with key: {}", key);

                // Use default TTL
                Duration ttl = Duration.ofSeconds(ttlSeconds);

                redisTemplate.opsForValue().set(key, response, ttl);
                log.info("Successfully cached advanced analytics for key: {}, TTL: {}s", key, ttlSeconds);
            } catch (Exception e) {
                log.error("Error caching advanced analytics: {}", e.getMessage(), e);
            }
        });
    }

    public Optional<AdvancedAnalyticsResponse> getAdvancedAnalytics(AdvancedAnalyticsRequest request) {
        try {
            String key = buildKey(request);
            log.debug("Fetching advanced analytics with key: {}", key);

            Object cached = redisTemplate.opsForValue().get(key);
            if (cached instanceof AdvancedAnalyticsResponse) {
                log.info("Found cached advanced analytics for key: {}", key);
                return Optional.of((AdvancedAnalyticsResponse) cached);
            }
        } catch (Exception e) {
            log.error("Error fetching advanced analytics: {}", e.getMessage(), e);
        }
        return Optional.empty();
    }

    private String buildKey(AdvancedAnalyticsRequest request) {
        StringBuilder sb = new StringBuilder(keyPrefix);
        sb.append(request.getCoreIdentifiers().getPortfolioId());

        // Add Date Range
        if (request.getFromDate() != null)
            sb.append(":from:").append(request.getFromDate());
        if (request.getToDate() != null)
            sb.append(":to:").append(request.getToDate());
        if (request.getTimeFrame() != null)
            sb.append(":tf:").append(request.getTimeFrame());

        // Add Feature Toggles to key to differentiate requests
        if (request.getFeatureToggles() != null) {
            sb.append(":hm:").append(request.getFeatureToggles().isIncludeHeatmap());
            sb.append(":mv:").append(request.getFeatureToggles().isIncludeMovers());
            sb.append(":sa:").append(request.getFeatureToggles().isIncludeSectorAllocation());
            sb.append(":ma:").append(request.getFeatureToggles().isIncludeMarketCapAllocation());
        }

        return sb.toString();
    }
}
