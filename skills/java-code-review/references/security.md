# Security

Sources: OWASP, Effective Java Item 88–90, SpotBugs/FindSecBugs. Flag these whenever the diff touches external input, persistence, files, crypto, or auth. A security finding usually rates Critical/High.

## Injection

- **SQL injection** — never build queries by string concatenation/`String.format` with user input. Use `PreparedStatement` with bind parameters, or a parameterized API (JPA criteria, jOOQ, named params). `"... WHERE id = '" + id + "'"` is Critical. FindSecBugs `SQL_INJECTION_*`.
- **Command injection** — `Runtime.exec("sh -c " + input)` / passing user input to a shell. Use `ProcessBuilder` with an explicit argument list, no shell. FindSecBugs `COMMAND_INJECTION`.
- **Path traversal** — user-controlled filenames joined to a base path without validation allow `../` escape. Canonicalize (`Path.normalize()` / `toRealPath()`) and verify the result is still under the intended base directory. FindSecBugs `PATH_TRAVERSAL_IN`.
- **LDAP / XPath / template / log injection** — same principle: never interpolate untrusted input into an interpreter's syntax.

## Deserialization (Effective Java Item 85)

- **Java native deserialization of untrusted data is dangerous** — `ObjectInputStream.readObject()` on attacker-controlled bytes enables remote code execution via gadget chains. Prefer a safe format (JSON via Jackson/Gson with types locked down). If native serialization is unavoidable, use object input filters (`ObjectInputFilter`). Critical when input is untrusted. FindSecBugs `OBJECT_DESERIALIZATION`.
- **XXE** — XML parsers (`DocumentBuilderFactory`, `SAXParserFactory`, `XMLInputFactory`, `TransformerFactory`) process external entities by default. Disable DTDs/external entities (`setFeature("http://apache.org/xml/features/disallow-doctype-decl", true)`). FindSecBugs `XXE_*`.

## Cryptography (Item 88-adjacent)

- **Weak algorithms** — MD5/SHA-1 for security, DES, ECB mode, RC4. Use SHA-256+, AES-GCM, etc. FindSecBugs `WEAK_MESSAGE_DIGEST_*`, `ECB_MODE`.
- **Insecure randomness** — `java.util.Random` / `Math.random()` for tokens, session IDs, keys, passwords, salts. Use `java.security.SecureRandom`. FindSecBugs `PREDICTABLE_RANDOM`.
- **Password hashing** — plain SHA for passwords is wrong; use bcrypt/scrypt/Argon2/PBKDF2 with a per-user salt.
- **Hardcoded crypto** — keys/IVs/passwords in source. See secrets below.
- **Constant-time comparison** — compare secrets/MACs with `MessageDigest.isEqual` / a constant-time routine, not `String.equals` (timing side channel). FindSecBugs `UNSAFE_HASH_EQUALS`.

## TLS / transport

- `TrustManager`/`HostnameVerifier` that accept everything (trust-all) disable certificate validation — Critical outside tests. FindSecBugs `WEAK_TRUST_MANAGER`, `WEAK_HOSTNAME_VERIFIER`.
- Plain `http://` for sensitive traffic; outdated protocols (SSLv3, TLS 1.0).

## Secrets

- **No hardcoded secrets** — API keys, passwords, tokens, connection strings with credentials in source/config committed to VCS. Inject via environment/secret manager. FindSecBugs `HARD_CODE_PASSWORD`.
- **Don't log secrets** — passwords, tokens, full card/PII in log statements or exception messages.

## Web-specific (if applicable)

- **SSRF** — fetching a user-supplied URL server-side without allowlisting lets an attacker hit internal services. Validate/allowlist the host.
- **Open redirect** — redirecting to a user-supplied URL without validation.
- **Mass assignment** — binding request bodies directly to entities exposes fields the user shouldn't set; use a DTO.
- **Missing output encoding** — reflecting user input into HTML without escaping (XSS).

## Quick scan

- String-concatenated SQL / shell command / file path with user input.
- `ObjectInputStream.readObject` on untrusted data; XML parser with DTDs enabled.
- MD5/SHA-1/DES/ECB for security; `java.util.Random` for tokens; plain-SHA passwords.
- Trust-all `TrustManager`/`HostnameVerifier`; `http://` for sensitive data.
- Hardcoded key/password/token; secrets in logs.
- Unvalidated server-side URL fetch / redirect; entity bound straight from request body.
