<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});


Route::get('/login', function () {
    $prevUrl = url()->previous();

    if (! $prevUrl) {
        abort(404); // or redirect some where
    }

    $path = parse_url($prevUrl, PHP_URL_PATH);

    $panelId = explode('/', trim($path, '/'))[0];

    if (! in_array($panelId, array_keys(Filament::getPanels()))) {
        abort(404);
    }

    return redirect(route("filament.{$panelId}.auth.login"));
})->name('login');
