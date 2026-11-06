@extends('layouts.app')

@section('title', 'Dashboard')

@section('content')
    <h2>Dashboard</h2>
    <p class="text-muted">Sistem absensi berbasis CCTV.</p>

    {{-- LIVE CCTV --}}
    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <h5 class="mb-0">Live CCTV</h5>
        </div>

        <div class="card-body text-center">
            <img src="http://127.0.0.1:5000/video"
                class="img-fluid rounded"
                style="width: 100%; max-width: 600px; height: auto;"
                alt="Live CCTV">
        </div>
    </div>

    <div class="row g-3">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5>Training Data</h5>
                    <p>Kelola foto dan data wajah karyawan.</p>
                    <a href="{{ route('training') }}" class="btn btn-primary">
                        Buka Training
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5>Absensi</h5>
                    <p>Lihat catatan kehadiran dari CCTV.</p>
                    <a href="{{ route('absensi') }}" class="btn btn-primary">
                        Buka Absensi
                    </a>
                </div>
            </div>
        </div>
    </div>
@endsection