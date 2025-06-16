package com.livraria.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class to hash and verify passwords using jBCrypt.
 */
public class PasswordUtil {

    /**
     * Hashes a plaintext password using bcrypt.
     *
     * @param password the plaintext password
     * @return bcrypt hash
     */
    public static String hashPassword(String password) {
        if (password == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    /**
     * Verifies a plaintext password against a bcrypt hash.
     *
     * @param password       the plaintext password
     * @param hashedPassword the bcrypt hash stored in the database
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        return BCrypt.checkpw(password, hashedPassword);
    }
}
