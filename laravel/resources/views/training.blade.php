@extends('layouts.app')
@section('content')
<div class="container py-4">

    {{-- Header --}}
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1">Training Data Wajah</h2>
        </div>
    </div>

    {{-- Notifikasi --}}
    @if (session('success'))
        <div class="alert alert-success alert-dismissible fade show">
            <strong>Berhasil!</strong> {{ session('success') }}
            <button type="button" class="btn-close"
                    data-bs-dismiss="alert"></button>
        </div>
    @endif

    @if (session('error'))
        <div class="alert alert-danger alert-dismissible fade show">
            <strong>Gagal memproses training.</strong>
            <pre class="mb-0 mt-2 text-wrap">{{ session('error') }}</pre>
            <button type="button" class="btn-close"
                    data-bs-dismiss="alert"></button>
        </div>
    @endif

    @if ($errors->any())
        <div class="alert alert-warning">
            <strong>Periksa kembali input kamu:</strong>
            <ul class="mb-0 mt-2">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <div class="row g-4">

        {{-- Form Training --}}
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-white py-3">
                    <h5 class="fw-bold mb-0">Tambah Data Wajah</h5>
                </div>

                <div class="card-body">
                    <form action="{{ route('training.simpan') }}"
                          method="POST"
                          enctype="multipart/form-data">
                        @csrf

                        <div class="mb-3">
                            <label for="name" class="form-label fw-semibold">
                                Nama
                            </label>
                            <input type="text"
                                   id="name"
                                   name="name"
                                   class="form-control"
                                   placeholder="Masukkan nama"
                                   value="{{ old('name') }}"
                                   maxlength="255"
                                   required>
                        </div>

                        <div class="mb-3">
                            <label for="foto" class="form-label fw-semibold">
                                Foto Wajah
                            </label>
                            <input type="file"
                                   id="foto"
                                   name="foto"
                                   class="form-control"
                                   accept=".jpg,.jpeg,.png"
                                   required>
                            <small class="text-muted">
                                Format JPG, JPEG, atau PNG. Maksimal 5 MB.
                            </small>
                        </div>

                        {{-- Preview foto --}}
                        <div id="preview-container" class="mb-3 d-none">
                            <p class="small fw-semibold mb-2">Preview foto</p>
                            <img id="preview"
                                 src=""
                                 alt="Preview foto wajah"
                                 class="img-fluid rounded border"
                                 style="max-height: 220px; object-fit: contain;">
                        </div>

                        <div class="alert alert-light border small">
                            <strong>Catatan:</strong>
                            Gunakan foto dengan wajah yang jelas dan tidak
                            tertutup agar proses encoding lebih optimal.
                        </div>

                        <button type="submit"
                                class="btn btn-primary w-100">
                            Simpan Data Wajah
                        </button>
                    </form>
                </div>
            </div>
        </div>

        {{-- Tabel Data --}}
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <div class="d-flex justify-content-between
                                align-items-center gap-2">
                        <h5 class="fw-bold mb-0">Data Wajah Tersimpan</h5>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0"
                               id="tabelTraining">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">No.</th>
                                    <th>Nama</th>
                                    <th>Data Wajah
                                </tr>
                            </thead>

                            <tbody>
                                @forelse ($data_wajah as $data)
                                    <tr>
                                        <td class="ps-3">
                                            {{ $loop->iteration }}
                                        </td>
                                        <td class="fw-semibold">
                                            {{ $data->name }}
                                        </td>
                                        <td>
                                            <span class="badge bg-success">
                                                Tersimpan
                                            </span>
                                        </td>
                                    </tr>
                                @empty
                                    <tr id="dataKosong">
                                        <td colspan="3"
                                            class="text-center py-5">
                                            <div class="text-muted">
                                                <h6>Belum ada data wajah</h6>
                                                <p class="mb-0 small">
                                                    Tambahkan foto karyawan
                                                    melalui form di samping.
                                                </p>
                                            </div>
                                        </td>
                                    </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card-footer bg-white text-muted small">
                    Data ditampilkan berdasarkan isi tabel
                    <code>encoding_data</code>.
                </div>
            </div>
        </div>

    </div>
</div>

<!-- {{-- Preview dan pencarian tabel --}}
<script>
document.getElementById('foto').addEventListener('change', function () {
    const file = this.files[0];
    const preview = document.getElementById('preview');
    const container = document.getElementById('preview-container');

    if (file) {
        preview.src = URL.createObjectURL(file);
        container.classList.remove('d-none');
    } else {
        preview.src = '';
        container.classList.add('d-none');
    }
});

document.getElementById('searchData').addEventListener('input', function () {
    const keyword = this.value.toLowerCase();

    document.querySelectorAll('#tabelTraining tbody tr').forEach(row => {
        const nama = row.cells[1]?.textContent.toLowerCase() || '';
        row.style.display = nama.includes(keyword) ? '' : 'none';
    });
});
</script> -->
@endsection