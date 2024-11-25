<?php

namespace App\Helpers;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class JWTHandler
{
    private static $secret;

    public static function init()
    {
        /* self::$secret = getenv('JWT_SECRET'); */
        self::$secret = 'mysecretkey';
    }

    public static function createToken($payload)
    {
        self::init();
        $issuedAt = time();
        $expire = $issuedAt + (60 * 60); // 1 hora de expiración
        $payload['iat'] = $issuedAt;
        $payload['exp'] = $expire;

        return JWT::encode($payload, self::$secret, 'HS256');
    }

    public static function validateToken($token)
    {
        self::init();
        try {
            return JWT::decode($token, new Key(self::$secret, 'HS256'));
        } catch (\Exception $e) {
            return null; // Token inválido
        }
    }
}
