package com.livraria.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class to hash and verify passwords using SHA-256.
 */
public class PasswordUtil {

    /**
     * Hashes a plaintext password using SHA-256.
     *
     * @param password the plaintext password
     * @return hexadecimal string of the hash
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedHash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Could not hash password", e);
        }
    }

    /**
     * Verifies a plaintext password against a previously hashed password.
     *
     * @param password the plaintext password
     * @param hashedPassword the hashed password stored in the database
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        return hashPassword(password).equals(hashedPassword);
    }
}
