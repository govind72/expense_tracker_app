<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use GuzzleHttp\Psr7\Response;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(Request $request){
        $request->validate(
            [
                'name'=>'required|max:30',
                'email'=>'required|email|unique:users',
                'password'=>'required|min:6|confirmed'
            ]
            );
        $user = User::create(
            [
                'name'=>$request->name,
                'email'=>$request->email,
                'password'=>Hash::make($request->password)
            ]
        );

        $token = $user->createToken('auth_token')->accessToken;
        return response(
            [
                'token'=>$token,
                'message'=>"User Created Sucessfully"
            ],200
        );
    }
    public function login(Request $request){
        $request->validate(
            [
                'email'=>'required',
                'password'=>'required'
            ]
            );
        $user = User::where('email',$request->email)->first();

        if(!$user || !Hash::check($request->password , $user->password)){
            return response(
                [
                    "message"=>"Invalid Credentials"
                ],401
            );
        }
        $token = $user->createToken('auth_token')->accessToken;
        return response(
            [
                'token'=>$token,
                'message'=>"Logged in Sucessfully"
            ],200
        );
        
    }
    public function logout(Request $request){

        $request->user()->token()->revoke();

        return response(
            [
                "message"=>"Logged out Sucessfully"
            ],
            200
        );
    }
}
