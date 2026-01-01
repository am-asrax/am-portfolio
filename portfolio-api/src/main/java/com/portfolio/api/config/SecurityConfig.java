package com.portfolio.api.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

/**
 * Spring Security Configuration for Portfolio Service
 * 
 * Security Model: Zero Trust Aji
 * - Validates JWT signature using INTERNAL_JWT_SECRET
 * - Trusts API Gateway ONLY if it presents a valid, signed Service Token
 * - Protected endpoints require valid JWT with correct signature
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

        @Value("${app.jwt.secret}")
        private String jwtSecret;

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                // Enable CORS
                                .cors(Customizer.withDefaults())
                                // Disable CSRF (stateless REST API with JWT)
                                .csrf(csrf -> csrf.disable())

                                // Debug Filter
                                .addFilterBefore((request, response, chain) -> {
                                        org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder
                                                        .getContext().getAuthentication();
                                        if (auth != null) {
                                                System.out.println("DEBUG AUTH: User=" + auth.getName()
                                                                + " Authorities=" + auth.getAuthorities());
                                        } else {
                                                System.out.println(
                                                                "DEBUG AUTH: No Authentication config found in context (yet)");
                                        }
                                        chain.doFilter(request, response);
                                }, org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter.class)

                                // Stateless session management (no cookies, JWT-based)
                                .sessionManagement(session -> session
                                                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                                // Configure authorization rules
                                .authorizeHttpRequests(auth -> auth
                                                // ✅ PUBLIC ENDPOINTS - No authentication required
                                                .requestMatchers(
                                                                "/actuator/**", // All Actuator endpoints for debugging
                                                                "/swagger-ui/**", // Swagger API documentation
                                                                "/v3/api-docs/**", // OpenAPI specification
                                                                "/v3/api-docs.yaml", // OpenAPI YAML
                                                                "/error" // Error page
                                                ).permitAll()

                                                // ✅ PROTECTED ENDPOINTS - Require valid JWT
                                                .requestMatchers(
                                                                "/v1/portfolios/**", // All portfolio operations
                                                                "/v1/analytics/**", // Analytics endpoints
                                                                "/v1/market-data/**", // Market data endpoints
                                                                "/v1/market-index/**", // Market index endpoints
                                                                "/v1/index-analytics/**" // Index analytics
                                                                                         // endpoints
                                                ).authenticated()

                                                // ❌ Deny all other endpoints (fail secure)
                                                .anyRequest().denyAll())

                                // ✅ ZERO TRUST: Enforce JWT Validation
                                .oauth2ResourceServer(oauth2 -> oauth2
                                                .jwt(jwt -> jwt
                                                                .decoder(jwtDecoder())
                                                                .jwtAuthenticationConverter(
                                                                                new com.portfolio.api.security.CustomJwtConverter())))

                                // Disable HTTP Basic authentication (not needed, using JWT)
                                .httpBasic(basic -> basic.disable())

                                // Disable form login (API Gateway handles authentication)
                                .formLogin(form -> form.disable());

                return http.build();
        }

        @Bean
        public JwtDecoder jwtDecoder() {
                // Use HS256 (Symmetric Key) to match Auth Service
                SecretKey key = new SecretKeySpec(jwtSecret.getBytes(), "HmacSHA256");
                return NimbusJwtDecoder.withSecretKey(key).build();
        }

        // Custom converter is now used directly in filterChain

        @Bean
        public org.springframework.web.cors.CorsConfigurationSource corsConfigurationSource() {
                org.springframework.web.cors.CorsConfiguration configuration = new org.springframework.web.cors.CorsConfiguration();
                configuration.setAllowedOriginPatterns(java.util.Collections.singletonList("*"));
                configuration.setAllowedMethods(
                                java.util.Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
                configuration.setAllowedHeaders(java.util.Collections.singletonList("*"));
                configuration.setAllowCredentials(true);

                org.springframework.web.cors.UrlBasedCorsConfigurationSource source = new org.springframework.web.cors.UrlBasedCorsConfigurationSource();
                source.registerCorsConfiguration("/**", configuration);
                return source;
        }

}
