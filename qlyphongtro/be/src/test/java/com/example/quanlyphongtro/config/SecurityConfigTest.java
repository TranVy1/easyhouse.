package com.example.quanlyphongtro.config;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import jakarta.servlet.Filter;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.http.HttpHeaders;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

@SpringBootTest
class SecurityConfigTest {

    @Autowired
    private WebApplicationContext context;

    @Autowired
    private Filter springSecurityFilterChain;

    @Autowired
    private com.example.quanlyphongtro.services.JwtService jwtService;

    private MockMvc mockMvc;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context)
                .addFilters(springSecurityFilterChain)
                .build();
    }

    @Test
    void dashboardApiRequiresAuthentication() throws Exception {
        mockMvc.perform(get("/api/dashboard/stats"))
                .andExpect(status().isForbidden());
    }

    @Test
    void adminApiRequiresAuthentication() throws Exception {
        mockMvc.perform(get("/api/admin/users"))
                .andExpect(status().isForbidden()); // or isUnauthorized depending on entry point
    }

    @Test
    void lichHenPostIsPublic() throws Exception {
        mockMvc.perform(post("/api/lich-hen")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest()); // Missing body results in 400, not 401/403
    }

    @Test
    void publicInvoiceUuidRequiresAuthentication() throws Exception {
        mockMvc.perform(get("/api/hoa-don-public/" + UUID.randomUUID()))
                .andExpect(status().isForbidden());
    }

    @Test
    void landlordCannotAccessAdminUserApi() throws Exception {
        String token = jwtService.generateAccessToken(UUID.randomUUID(), "landlord@example.com", "LANDLORD");

        mockMvc.perform(get("/api/admin/users")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + token))
                .andExpect(status().isForbidden());
    }

    @Test
    void adminCanAccessAdminUserApi() throws Exception {
        String token = jwtService.generateAccessToken(UUID.randomUUID(), "admin@example.com", "ADMIN");

        mockMvc.perform(get("/api/admin/users")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + token))
                .andExpect(status().isOk());
    }
}
