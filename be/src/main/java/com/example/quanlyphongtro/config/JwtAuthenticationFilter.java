package com.example.quanlyphongtro.config;

import com.example.quanlyphongtro.services.JwtService;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * Extracts and validates the JWT Bearer token from the Authorization header.
 * Sets the Spring Security authentication context if valid.
 */
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");
        String token = null;

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        } else if (request.getParameter("token") != null) {
            token = request.getParameter("token");
        }

        if (token != null) {
            try {
                Claims claims = jwtService.parseToken(token);

                if (claims != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    UUID userId = jwtService.getUserId(claims);
                    String role = jwtService.getRole(claims);

                    List<SimpleGrantedAuthority> authorities = List.of(
                            new SimpleGrantedAuthority("ROLE_" + (role != null ? role : "USER"))
                    );

                    UsernamePasswordAuthenticationToken authToken =
                            new UsernamePasswordAuthenticationToken(userId, null, authorities);
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            } catch (Exception e) {
                // Ignore invalid tokens, let security filter chain handle unauthorized access
            }
        }

        filterChain.doFilter(request, response);
    }
}
