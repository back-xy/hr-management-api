<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Support\Facades\Hash;

class AuthService
{
    /**
     * Register a new user and return user with token
     */
    public function register(array $data): array
    {
        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return [
            'user' => $user,
            'token' => $token
        ];
    }

    /**
     * Authenticate user and return user with token
     */
    public function login(array $credentials): array
    {
        if (!Auth::attempt($credentials)) {
            throw new AuthenticationException('Invalid credentials');
        }

        $user = User::where('email', $credentials['email'])->firstOrFail();
        $token = $user->createToken('auth_token')->plainTextToken;

        return [
            'user' => $user,
            'token' => $token
        ];
    }

    /**
     * Logout user by deleting current access token
     */
    public function logout(User $user): void
    {
        $user->currentAccessToken()->delete();
    }
}
