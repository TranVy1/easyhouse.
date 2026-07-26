import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.util.Date;
import java.util.UUID;
import java.nio.charset.StandardCharsets;

public class TestJwtLength {
    public static void main(String[] args) {
        String secret = "abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890";
        var key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        String token = Jwts.builder()
                .subject(UUID.randomUUID().toString())
                .id(UUID.randomUUID().toString())
                .claim("tokenType", "refresh")
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + 100000000))
                .signWith(key)
                .compact();
        System.out.println("Token length: " + token.length());
        System.out.println("Token: " + token);
    }
}
