<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserDataController;
use App\Http\Controllers\PresetRouteController;


Route::post('/user', [UserDataController::class, 'createUser']);

Route::get('/user/{userId}/username', [UserDataController::class, 'getUsername']);
Route::put('/user/{userId}/username', [UserDataController::class, 'setUsername']);

Route::get('/user/{userId}/coins', [UserDataController::class, 'getCoins']);
Route::put('/user/{userId}/coins', [UserDataController::class, 'addCoins']);
Route::delete('/user/{userId}/coins', [UserDataController::class, 'removeCoins']);

Route::get('/user/{userId}/streak_count', [UserDataController::class, 'getStreakCount']);
Route::put('/user/{userId}/streak_count', [UserDataController::class, 'addStreakCount']);
Route::delete('/user/{userId}/streak_count', [UserDataController::class, 'resetStreakCount']);

Route::get('/user/{userId}/total_distance_walked', [UserDataController::class, 'getTotalDistanceWalked']);
Route::put('/user/{userId}/total_distance_walked', [UserDataController::class, 'addTotalDistanceWalked']);
Route::delete('/user/{userId}/total_distance_walked', [UserDataController::class, 'resetTotalDistanceWalked']);

Route::get('/user/{userId}/friends', [UserDataController::class, 'getFriendsById']);
Route::post('/user/{userId}/friends', [UserDataController::class, 'addFriendsById']);
Route::delete('/user/{userId}/friends', [UserDataController::class, 'removeFriendById']);
Route::get('/user/{userId}/friends/count', [UserDataController::class, 'countTotalFriends']);

Route::get('top-users', [UserDataController::class, 'getTopUsersByCoins']);
Route::get('user/{userId}/coins-and-neighbors', [UserDataController::class, 'getUserCoinsAndNeighbors']);
Route::get('user/{userId}/top-friends', [UserDataController::class, 'getTopFriendsWithUser']);

Route::get('/routes/{id}/gpx', [PresetRouteController::class, 'downloadGpx']);
Route::get('/routes/{id}/coins', [PresetRouteController::class, 'getCoins']);
Route::get('/routes', [PresetRouteController::class, 'getRoutes']);

Route::get('/test', function () {
    return 'Test Route Works!';
});
