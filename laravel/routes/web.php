<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AttendanceController;

Route::get('/', [AttendanceController::class, 'dashboard'])->name('dashboard');
Route::get('/training', [AttendanceController::class, 'training'])->name('training');
Route::get('/absensi', [AttendanceController::class, 'absensi'])->name('absensi');
Route::get('/absensi/gambar/{id}/{jenis}', [AttendanceController::class, 'gambar'])->name('absensi.gambar');
Route::post('/training/simpan', [AttendanceController::class, 'simpan'])->name('training.simpan');