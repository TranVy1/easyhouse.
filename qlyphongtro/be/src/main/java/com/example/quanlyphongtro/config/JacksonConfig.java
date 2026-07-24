package com.example.quanlyphongtro.config;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Configuration
public class JacksonConfig {

    private static final DateTimeFormatter ISO_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter VN_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @Bean
    @Primary
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();

        // Đăng ký module cho Java 8 Date/Time API
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        // Module tùy chỉnh hỗ trợ nhiều định dạng ngày
        SimpleModule multiFormatModule = new SimpleModule("LocalDateMultiFormat");

        // Serializer: luôn trả về yyyy-MM-dd
        multiFormatModule.addSerializer(LocalDate.class, new LocalDateSerializer(ISO_FORMAT));

        // Deserializer: nhận cả yyyy-MM-dd và dd/MM/yyyy
        multiFormatModule.addDeserializer(LocalDate.class, new JsonDeserializer<LocalDate>() {
            @Override
            public LocalDate deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
                String text = p.getText();
                if (text == null || text.isBlank()) {
                    return null;
                }
                text = text.trim();

                try {
                    // yyyy-MM-dd
                    if (text.contains("-")) {
                        return LocalDate.parse(text, ISO_FORMAT);
                    }
                    // dd/MM/yyyy
                    if (text.contains("/")) {
                        return LocalDate.parse(text, VN_FORMAT);
                    }
                    // Fallback ISO default
                    return LocalDate.parse(text);
                } catch (Exception e) {
                    throw new IOException(
                        "Không thể parse ngày: '" + text + "'. Hỗ trợ: yyyy-MM-dd hoặc dd/MM/yyyy", e);
                }
            }
        });

        mapper.registerModule(multiFormatModule);
        return mapper;
    }
}
