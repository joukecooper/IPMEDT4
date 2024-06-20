<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::prefix('api')->group(function () {
    require __DIR__.'/api.php';
});

Route::get('/test', function () {
    return 'Test Route Works!';
});
